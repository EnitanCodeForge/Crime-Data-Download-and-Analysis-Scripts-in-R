library(httr)

# Set the base URL
baseUrl <- "http://www.cps.gov.uk/data/case_outcomes/"

# Define the range of years and months
startYear <- 2015
endYear <- 2016
months <- c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")

# Specify the base destination path
baseDestinationPath <- "C:\\Users\\ENNY\\Downloads\\R Assignment\\Dataset - Assignment"
if (!file.exists(baseDestinationPath)) {
  tryCatch({
    dir.create(baseDestinationPath)
    cat("Created year folder:", baseDestinationPath, "\n")
  }, error = function(e) {
    cat("Failed to create year folder:", baseDestinationPath, "\n")
    next
  })
}

# Iterate over the years and months
for (year in startYear:endYear) {
  # Create the year folder
  yearFolder <- file.path(baseDestinationPath, as.character(year))
  if (!file.exists(yearFolder)) {
    tryCatch({
      dir.create(yearFolder)
      cat("Created year folder:", year, "\n")
    }, error = function(e) {
      cat("Failed to create year folder:", year, "\n")
      next
    })
  }
  
  for (month in months) {
    # Construct the URL for the file
    url <- paste0(baseUrl, tolower(month), "_", year, "/principal_offence_category_", tolower(month), "_", year, ".csv")
    
    # Download the file
    fileName <- paste0("principal_offence_category_", tolower(month), "_", year, ".csv")
    filePath <- file.path(yearFolder, fileName)
    tryCatch({
      GET(url, write_disk(filePath, overwrite = TRUE))
      cat("Downloaded:", fileName, "\n")
    }, error = function(e) {
      # Construct the URL for the file
      url <- paste0(baseUrl, tolower(month), "_", year, "/Principal_Offence_Category_", substr(month, 1, 3), ".csv")
      # Download the file
      fileName <- paste0("Principal_Offence_Category_", substr(month, 1, 3), ".csv")
      filePath <- file.path(yearFolder, fileName)
      tryCatch({
        GET(url, write_disk(filePath, overwrite = TRUE))
        cat("Downloaded:", fileName, "\n")
      }, error = function(e) {
        cat("Failed to download:", fileName, "\n")
      })
    })
  }
}