# Function to install packages if not already installed
check_install_load = function(lib_name){
  
  # Check if already installed
  if(!lib_name %in% rownames(installed.packages())){
    
    # If not install
    install.packages(lib_name)
  }
  
  # Then load
  library(lib_name, character.only = TRUE)
}

# Install purr if required
check_install_load('purrr')

# Library
lib_vec = c('readr', 'jsonlite')

# Map install packages function to vector
purrr::walk(lib_vec, check_install_load)

# Define SQL query
url = "https://opendata.nhsbsa.net/api/3/action/datastore_search_sql?resource_id=EPD_202407&sql=
SELECT regional_office_name, practice_name, practice_code, chemical_substance_bnf_descr, sum(items) as items, sum(nic) as nic from `EPD_202407` 
where BNF_CHAPTER_PLUS_CODE = '04: Central Nervous System' 
group by regional_office_name, practice_name, practice_code, chemical_substance_bnf_descr"

# Encode url
sql_query = URLencode(url)

# Get data from api
api_data = jsonlite::fromJSON(sql_query)

# File location
results_url = api_data$result$gc_urls$url

# Read in data from file
data = readr::read_csv(results_url)

# Inspect data
head(data, 5)

# Convert all column names to uppercase
names(data) = toupper(names(data))

# Save file
saveRDS(data, "2024-10-30-lapply/cc_lapply_opd_data.Rds")