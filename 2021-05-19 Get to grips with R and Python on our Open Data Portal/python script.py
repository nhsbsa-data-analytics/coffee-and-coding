
import requests 
import pandas as pd

# Define the url for the API call
base_endpoint = "https://opendata.nhsbsa.net/api/3/action"
action_method = "/datastore_search_sql?sql=" # SQL

# Define the parameters for the SQL query
resource_name = "EPD_202001"
pco_code = "13T00" # Newcastle Gateshead CCG
bnf_chemical_substance = "0407010H0" # Paracetamol

# Construct the SQL query
query = f"""
    SELECT *
    FROM {resource_name} 
    WHERE pco_code = '{pco_code}' AND bnf_chemical_substance = '{bnf_chemical_substance}' 
"""

# Send API call and grab the response as a json
response = requests.get(
    base_endpoint 
    + action_method 
    + query.replace(" ", "%20") # Encode spaces in the url
).json()

# Convert the records in the response to a dataframe
result_df = pd.DataFrame(response['result']['result']['records'])

# Lets inspect the QUANTITY column
result_df.hist(column='QUANTITY')

# Can we try removing the background
result_df.hist(column='QUANTITY', grid=False)

# How about using more bins
result_df.hist(column='QUANTITY', grid=False, bins=50)

# What about one bin per value of QUANTITY
result_df.hist(
    column='QUANTITY', 
    grid=False, 
    bins=int(max(result_df['QUANTITY']))
)

# Lets see if QUANTITY varies by BNF_DESCRIPTION
result_df.hist(
    column='QUANTITY', 
    by='BNF_DESCRIPTION',
    grid=False, 
    bins=50,
    sharex=True, # All the rows share the same x axis
    layout=(18, 1), # 18 rows and one column
    figsize=(10, 20) # Make the graph big enough 
)

# We can see that BNF_DESCRIPTION contains different forms for the drugs... 
# why don't we limit this to 'tablet' and check again
tablet_df = result_df[result_df['BNF_DESCRIPTION'].str.contains('tablet')]
tablet_df.hist(
    column='QUANTITY', 
    by='BNF_DESCRIPTION',
    grid=False, 
    bins=int(max(tablet_df['QUANTITY'])), # Bin by each value of QUANTITY
    sharex=True,
    layout=(5, 1),
    figsize=(5, 10)
)

# We can see there are peaks for certain QUANTITY so lets examine the 10 most 
# common QUANITTY
tablet_df['QUANTITY'].value_counts().head(10)
