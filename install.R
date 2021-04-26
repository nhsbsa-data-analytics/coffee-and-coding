# Load utils
library(utils)

# Install new cran packages
cran_required_packages <- c(
)
new_cran_packages <- cran_required_packages[!(cran_required_packages %in% utils::installed.packages()[, "Package"])]
if(length(new_cran_packages)) utils::install.packages(new_cran_packages)
