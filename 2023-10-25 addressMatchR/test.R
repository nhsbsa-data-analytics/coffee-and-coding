
# Libraries
library(dplyr)
library(dbplyr)

# Set up connection to DALP
con <- nhsbsaR::con_nhsbsa(database = "DALP")

# Create a lazy table from the item level FACT table
pcd <- con %>%
  tbl(from = in_schema("ADNSH", "POSTCODE_LATLONG_DECILES")) %>%
  filter(WARD_NAME == "Bywell") %>%
  select(POSTCODE = PCD_NO_SPACES) %>%
  distinct()

x = con %>%
  tbl(from = in_schema("ADNSH", "INT646_ABP_20230331"))

# Get AddressBase info
ab = con %>%
  tbl(from = in_schema("ADNSH", "INT646_ABP_20230331")) %>%
  inner_join(pcd) %>% 
  select(AB_POSTCODE = POSTCODE, AB_ADDRESS = CORE_SINGLE_LINE_ADDRESS) %>% 
  distinct() %>% 
  nhsbsaR::collect_with_parallelism(., 16)


df

# Generate primary df ID
primary_df = df %>%
  tidy_postcode_df(., POSTCODE) %>% 
  tidy_single_line_address_df(., ADDRESS) %>% 
  dplyr::mutate(ID = dplyr::row_number())

# Generate lookup df ID
lookup_df = ab %>%
  tidy_postcode_df(., AB_POSTCODE) %>% 
  tidy_single_line_address_df(., AB_ADDRESS) %>% 
  dplyr::mutate(ID_LOOKUP = dplyr::row_number()) %>% 
  rename(
    ADDRESS = AB_ADDRESS,
    POSTCODE = AB_POSTCODE
  )

# Find exact matches
exact_match_df = dplyr::inner_join(
  x = primary_df,
  y = lookup_df,
  by = c("POSTCODE", "ADDRESS"),
  suffix = c("", "_LOOKUP")
) %>%
  dplyr::select(ID, ID_LOOKUP) %>%
  dplyr::mutate(
    SCORE = 1,
    MATCH_TYPE = "EXACT"
  )

# Identify then tokenise non exact matches
non_exact_match_df <- primary_df %>% 
  dplyr::anti_join(
    y = exact_match_df,
    na_matches = "na",
    by = "ID"
  ) %>%
  tidytext::unnest_tokens(
    output = "TOKEN",
    input = "ADDRESS",
    to_lower = FALSE,
    drop = FALSE
  ) %>%
  dplyr::group_by(ID) %>%
  dplyr::mutate(
    TOKEN_WEIGHT = dplyr::if_else(grepl("[0-9]", TOKEN) == TRUE, 4, 1),
    TOKEN_NUMBER = row_number(),
    # Add the theoretical max score for each non exact match address
    MAX_SCORE = sum(TOKEN_WEIGHT, na.rm = TRUE)
  ) %>%
  dplyr::ungroup()

# Tokenise lookup addresses
lookup_tokens_df <- lookup_df %>%
  tidytext::unnest_tokens(
    output = "TOKEN",
    input = "ADDRESS",
    to_lower = FALSE,
    drop = FALSE
  ) %>%
  # Only need 1 instance of token per lookup ID
  dplyr::distinct() %>%
  dplyr::mutate(
    TOKEN_WEIGHT = dplyr::if_else(grepl("[0-9]", TOKEN) == TRUE, 4, 1)
  )

# Score remaining matches
non_exact_match_df2 = dplyr::full_join(
  x = non_exact_match_df,
  y = lookup_tokens_df,
  by = c("POSTCODE", "TOKEN_WEIGHT"),
  suffix = c("", "_LOOKUP"),
  relationship = "many-to-many"
) %>%
  # Remove unwanted token pairs (with jw score < 0.8)
dplyr::filter(
  # Remove NA tokens
  !is.na(TOKEN),
  !is.na(TOKEN_LOOKUP),
  TOKEN != "",
  TOKEN_LOOKUP != "",
  # Tokens share same first letter
  substr(TOKEN_LOOKUP, 1, 1) == substr(TOKEN, 1, 1) |
    # Tokens share same second letter
    substr(TOKEN_LOOKUP, 2, 2) == substr(TOKEN, 2, 2) |
    # Tokens share same last letter
    (substr(TOKEN_LOOKUP, nchar(TOKEN_LOOKUP), nchar(TOKEN_LOOKUP)) == substr(TOKEN, nchar(TOKEN_LOOKUP), nchar(TOKEN_LOOKUP))) |
    # One token is a substring of the other
    stringr::str_detect(TOKEN, TOKEN_LOOKUP) |
    stringr::str_detect(TOKEN_LOOKUP, TOKEN)
  ) %>%
# Score remaining token pairs
dplyr::mutate(
  SCORE = dplyr::case_when(
    # Exact matches
    TOKEN == TOKEN_LOOKUP ~ 1,
    (TOKEN != TOKEN_LOOKUP) & (TOKEN_WEIGHT == 4) ~ 0,
    TOKEN != TOKEN_LOOKUP ~ stringdist::stringsim(
      a = TOKEN,
      b = TOKEN_LOOKUP,
      method = "jw",
      p = 0.1
    )
  )
) %>% 
  # Remove tokens with score less than 0.8 then multiple by weight
  dplyr::mutate(SCORE  = ifelse(SCORE <= 0.8, 0, SCORE)) %>%
  dplyr::mutate(SCORE = SCORE * TOKEN_WEIGHT) %>% 
  # Max score per token
  dplyr::group_by(ID, ID_LOOKUP, MAX_SCORE, TOKEN_NUMBER) %>%
  dplyr::summarise(SCORE = max(SCORE, na.rm = TRUE)) %>%
  dplyr::ungroup() %>% 
  # Sum scores per ID pair & generate score out of maximum score
  dplyr::group_by(ID, ID_LOOKUP, MAX_SCORE) %>%
  dplyr::summarise(SCORE = sum(SCORE, na.rm = TRUE)) %>%
  dplyr::mutate(SCORE = SCORE / MAX_SCORE) %>%
  dplyr::ungroup() %>%
  dplyr::select(-MAX_SCORE) %>%
  # Slice top score with ties per primary df ID
  dplyr::group_by(ID) %>%
  dplyr::slice_max(order_by = SCORE, with_ties = TRUE) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(MATCH_TYPE = "NON-EXACT")


y# Max score per token
non_exact_match_df3 = non_exact_match_df2 %>% 
  dplyr::group_by(ID, ID_LOOKUP, MAX_SCORE, TOKEN, TOKEN_NUMBER) %>%
  dplyr::mutate(SCORE = max(SCORE, na.rm = TRUE)) %>% 
  dplyr::ungroup() %>% 
  # Sum scores per ID pair & generate score out of maximum score
  dplyr::group_by(ID, ID_LOOKUP, MAX_SCORE) %>%
  dplyr::summarise(SCORE = sum(SCORE, na.rm = TRUE)) %>% 
  dplyr::mutate(SCORE = SCORE / MAX_SCORE) %>%
  dplyr::ungroup() %>% 
  dplyr::select(-MAX_SCORE) %>%
  # Slice top score with ties per primary df ID
  dplyr::group_by(ID) %>%
  dplyr::slice_max(order_by = SCORE, with_ties = TRUE) %>%
  dplyr::ungroup() %>%
  dplyr::mutate(MATCH_TYPE = "NON-EXACT")

# Identify records not exact or non-exact matched
no_match_df = primary_df %>%
  dplyr::anti_join(
    exact_match_df %>% select(ID) %>% distinct(),
    by = "ID"
  ) %>%
  dplyr::anti_join(
    non_exact_match_df %>% select(ID) %>% distinct(),
    by = "ID"
  ) %>%
  dplyr::transmute(
    ID,
    ID_LOOKUP = NA,
    SCORE = 0,
    MATCH_TYPE = "NONE"
  )

# Stack the exact and non exact matches together and output
output = dplyr::bind_rows(exact_match_df, non_exact_match_df, no_match_df) %>%
  dplyr::left_join(
    primary_df,
    by = "ID"
  ) %>%
  dplyr::left_join(
    lookup_df %>% select(-all_of("POSTCODE")),
    by = "ID_LOOKUP",
    suffix = c("", "_LOOKUP")
  ) %>%
  dplyr::group_by(ID) %>%
  dplyr::mutate(MATCH_COUNT = n_distinct(ID_LOOKUP, na.rm = TRUE)) %>%
  dplyr::ungroup() %>%
  dplyr::select(-c(ID, ID_LOOKUP)); gc()


DBI::dbDisconnect(con); rm(list = ls()); gc()
