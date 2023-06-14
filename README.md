# Crime-Data-Download-and-Analysis-Scripts-in-R

This repository contains R scripts for downloading principal offence category data from the Crown Prosecution Service (CPS) website and performing analysis on crime data. The scripts are described below:

## Data Download Script - datadownload.R
This script allows you to download principal offence category data from the CPS website. It iterates over a specified range of years and months, and downloads the corresponding CSV files for each month.

### Prerequisites
Before running the script, ensure that you have the following packages installed:

•&nbsp; **'httr:** for making HTTP requests
<br/> You can install the required packages using the following command in R:

```text
  install.packages("httr")
```

### Usage
1. Open the script **'datadownload.R'** in your R development environment.
2. Set the base URL for the CPS data by modifying the **'baseUrl'** variable. By default, it is set to **"http://www.cps.gov.uk/data/case_outcomes/"**.
3. Specify the range of years and months you want to download data for by modifying the **'startYear'', 'endYear',** and **'months'** variables. The script will download data      for all combinations of years and months within the specified range. save those as the following.
4. Set the base destination path for saving the downloaded files by modifying the **'baseDestinationPath'** variable. By default, it is set to "C:\Users\ENNY\Downloads\R           Assignment\Dataset - Assignment". Make sure the path exists before running the script.
5. Run the script in your R environment.

The script will iterate over the specified years and months, create the necessary folders, construct the URLs for the files, and download them using the **'GET'** function from the **'httr'** package. The downloaded files will be saved in the respective year and month folders within the base destination path.

If a file cannot be downloaded using the original URL, the script will attempt an alternative URL format before reporting a failure.

### Example
Here's an example configuration to download data for the years 2014 to 2016:

```text
  # Set the base URL
  baseUrl <- "http://www.cps.gov.uk/data/case_outcomes/"

  # Define the range of years and months
  startYear <- 2015
  endYear <- 2016
  months <- c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")

  # Specify the base destination path
  baseDestinationPath <- "C:\\Users\\ENNY\\Downloads\\R Assignment\\Dataset - Assignment"

  # ...
  # (Run the script)
  # ...
```
The script will download the corresponding CSV files for each month and save them in the respective year and month folders within the base destination path.

For any failed downloads, the script will print an error message indicating the file that could not be downloaded.

Note: The example configuration assumes that the base destination path already exists. If it doesn't, the script will attempt to create it before downloading the files.

## Crime Data Analysis Script - crime-analysis.R
This script performs analysis on crime data. It assumes that you have already downloaded the principal offence category data using the **'datadownload.R'** script.
### Prerequisites
Before running the script, ensure that you have the following packages installed:<br/>
 
- **tidyverse:** for data manipulation
- **psych:** for descriptive statistics
- **rpart:** for decision tree analysis
- **RColorBrewer:** for color palettes
- **cluster:** for clustering analysis
- **ggplot2:** for data visualization
- **gridExtra:** for arranging plots

You can install the required packages using the following command in R:

```text
  install.packages(c("tidyverse", "psych", "rpart", "RColorBrewer", "cluster", "ggplot2", "gridExtra"))
```
### Usage
1. Open the script **'principal-offense-category-outcome-analytics.R'** in your R development environment.
2. Set the base directory where your crime data files are located by modifying the **'data_directory'** variable.
3. Specify the years and months you want to analyze by modifying the **'years_list'** and **'months_list'** variables.
4. Run the script in your R environment.

The script will read the crime data from CSV files, perform data cleaning, and then perform various analyses and visualizations on the crime data using the specified libraries and functions.

The analysis and visualization outputs include descriptive statistics, total convictions by crime category, total unsuccessful convictions by crime category, monthly convictions by crime category, monthly trends for specific crime categories, predicted crime rates for each crime category, predicted crime locations for each crime category, and clustering of crime data using the k-means algorithm.

The generated plots will be saved as image files in the current working directory with the following filenames:

- convictions_plot.jpg: Total convictions by crime category.
- unsuccessful_convictions_plot.jpg: Total unsuccessful convictions by crime category.
- monthly_convictions_plot.jpg: Monthly convictions by crime category.

### Running the Scripts
To run the scripts, open an R environment or an R script and execute the code line by line or in its entirety.

### License
This project is licensed under the **MIT License**.

Made with ❤️ and R Language.
