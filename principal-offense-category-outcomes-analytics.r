library(tidyverse)
library(psych)
library(rpart)
library(RColorBrewer)
library(cluster)
library(ggplot2)
library(gridExtra)


data_directory <- 'C:/Users/ENNY/Downloads/R Assignment/Dataset - Assignment/'
months_list <- c('january', 'february', 'march', 'april', 'may', 'june', 'july', 'august', 'september', 'october', 'november', 'december')
new_crime_data <- tibble()

years_list <- c('2015', '2016')

for (yr in years_list) {
  for (mon in months_list) {
    file_path <- paste(data_directory, yr, '/principal_offence_category_', mon, '_', yr, '.csv', sep="")
    month_data <- read.csv(file_path, stringsAsFactors = FALSE,
                           colClasses = c("Number.of.Theft.And.Handling.Unsuccessful" = "character", 
                                          "Number.of.Fraud.And.Forgery.Convictions" = "character",
                                          "Number.of.Sexual.Offences.Convictions" = "character",
                                          "Number.of.Burglary.Convictions" = "character",
                                          "Number.of.Motoring.Offences.Unsuccessful" = "character",
                                          "Number.of.Admin.Finalised.Unsuccessful" = "character",
                                          "Number.of.All.Other.Offences..excluding.Motoring..Convictions" = "character"))
    month_data <- month_data %>%
      mutate(Month = mon, Year = yr) # Include Month and Year columns
    new_crime_data <- bind_rows(new_crime_data, month_data)
  }
}





head(new_crime_data)


# check for missing values
null_data<- sum(is.na(new_crime_data))
null_data



# check for duplicates
data_dublicate<- sum(duplicated(new_crime_data))
data_dublicate

str(new_crime_data)

view(new_crime_data)

percentage_columns <- grep("Percentage",names(new_crime_data),value = TRUE)

new_crime_data <- select(new_crime_data,-one_of(percentage_columns))

new_crime_data$Month <- factor(new_crime_data$Month, labels = unique(new_crime_data$Month))
new_crime_data$Year <- factor(new_crime_data$Year, labels = unique(new_crime_data$Year))
new_crime_data$X <- factor(new_crime_data$X)
new_crime_data[, c(2:26)] <- mutate(new_crime_data[, c(2:26)], 
                                across(where(is.character), parse_number))
new_crime_data <- new_crime_data[, c(1:28)]


view(new_crime_data)

categories <- c("Homicide.Convictions", "Offences.Against.The.Person.Convictions", 
                "Sexual.Offences.Convictions", "Burglary.Convictions", 
                "Robbery.Convictions","Theft.And.Handling.Convictions", 
                "Fraud.And.Forgery.Convictions", "Criminal.Damage.Convictions", 
                "Drugs.Offences.Convictions","Public.Order.Offences.Convictions", 
                "All.Other.Offences..excluding.Motoring..Convictions", "Motoring.Offences.Convictions")

new_crime_data %>%
  select(matches(categories)) %>%
  describe()


new_crime_data %>%
  select(-c(Year, Month, X))%>%
  select(!matches(categories)) %>%
  describe()

# Calculate total convictions by crime category
convictions_summary <- new_crime_data %>%
  select(Year, Month, matches(categories)) %>%
  group_by(Year, Month)%>%
  summarize(across(starts_with("Number.of"), sum, na.rm =T)) %>%
  pivot_longer(cols = starts_with("Number.of"), names_to = "Category", values_to = "TotalConvictions")

# Visualize total convictions by crime category
convictions_plot <- ggplot(convictions_summary, aes(x = reorder(Category, -TotalConvictions), y = TotalConvictions, fill = Month)) +
  geom_bar(stat = "identity", position = "stack", color = "#74C476") +  # Shade of green
  labs(x = "Crime Category", y = "Total Convictions", title = "Total Convictions by Crime Category") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  facet_wrap(~Year)
convictions_plot

# Save the plot as an image
ggsave("convictions_plot.jpg", convictions_plot, width = 12, height = 6.67)


# Calculate total unsuccessful convictions by crime category
unsuccessful_convictions_summary <- new_crime_data %>%
  select(Year, Month,  !matches(categories)) %>%
  group_by(Year, Month)%>%
  summarize(across(starts_with("Number.of"), sum, na.rm = T)) %>%
  pivot_longer(cols = starts_with("Number.of"), names_to = "Category", values_to = "TotalUnsuccessfulConvictions")

# Calculate total unsuccessful convictions by crime category
unsuccessful_convictions_plot <- ggplot(unsuccessful_convictions_summary, aes(x = reorder(Category, -TotalUnsuccessfulConvictions), y = TotalUnsuccessfulConvictions, fill = Month)) +
  geom_bar(stat = "identity", position = "stack", fill = "#5AAE61") +  # Shade of green
  labs(x = "Crime Category", y = "Total Unsuccessful Convictions", title = "Total Unsuccessful Convictions by Crime Category") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  facet_wrap(~Year)
unsuccessful_convictions_plot

ggsave("unsuccessful_convictions_plot.jpg", unsuccessful_convictions_plot, width = 12, height = 6.67)


# Prepare monthly counts data for visualization
monthly_counts <- new_crime_data %>%
  select(Year, Month, matches(categories)) %>%
  group_by(Year, Month) %>%
  pivot_longer(starts_with("Number.of"), names_to = "Category", values_to = "Convictions")

# Convert "Category" column to a factor
monthly_counts$Category <- factor(monthly_counts$Category)

# Display the head and structure of monthly counts data
head(monthly_counts)
str(monthly_counts)

# Visualize monthly convictions by crime category
category_colors <- c("#FF0000", "#00FF00", "#0000FF", "#FFFF00", "#FF00FF", "#00FFFF", "#FFA500", "#008000", "#800080", "#800000", "#808000", "#008080", "#FFC0CB")

monthly_convictions_plot <- ggplot(monthly_counts, aes(x = Month, y = Convictions, fill = Category)) +
  geom_bar(stat = "identity", position = 'stack') +
  labs(x = "Month", y = "Convictions", color = "Crime Category") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  scale_fill_manual(values = category_colors) +
  facet_wrap(~ Year)

monthly_convictions_plot


homicide_convictions <- new_crime_data %>%
  group_by(Year, Month) %>%
  summarise(total_convictions = sum(Number.of.Homicide.Convictions, na.rm = T))

ggplot(homicide_convictions, aes(x = Month, y = total_convictions, fill = Year)) +
  geom_bar(stat = "identity", position = "dodge", color = "steelblue") +
  labs(x = "Month", y = "Number of Homicide Convictions", title = "Homicide Convictions by Month") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
  

theft_convictions <- new_crime_data %>%
  select(Year, Month, Number.of.Theft.And.Handling.Convictions) %>%
  arrange(Month)

ggplot(theft_convictions, aes(x = Month, y = Number.of.Theft.And.Handling.Convictions, fill = Year)) +
  geom_boxplot(color = 'steelblue') +
  labs(x = "Month", y = "Number of Theft and Handling Convictions", title = "Theft and Handling Convictions over Time") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))


# Save the plot as an image
ggsave("monthly_convictions_plot.jpg", monthly_convictions_plot, width = 12, height = 6.67)

# Function to predict crime rate
predict_crime_rate <- function(data, category) {
  regression_formula <- as.formula(paste("Number.of.", category, " ~ Month", sep = ""))
  regression_model <- lm(regression_formula, data = data)
  
  prediction_data <- data.frame(Month = unique(new_crime_data$Month))
  predicted_values <- predict(regression_model, newdata = prediction_data)
  
  result <- data.frame(Month = unique(new_crime_data$Month), PredictedRate = predicted_values)
  return(result)
}

# Predict crime rates for each category
crime_rate_predictions <- lapply(categories, function(category) {
  predict_crime_rate(new_crime_data, category)
})

# Display predicted crime rates for each category
for (i in seq_along(crime_rate_predictions)) {
  category <- categories[i]
  predictions <- crime_rate_predictions[[i]]
  
  cat("Predicted Crime Rates for", category, ":\n")
  print(predictions)
  cat("\n")
}

# Function to predict crime locations
predict_crime_area <- function(data, category) {
  dt_formula <- as.formula(paste("X ~ Number.of.", category, " + Month", sep = ""))
  dt_model <- rpart(dt_formula, data = data, method = "class")
  
  variable <- paste("Number.of.", category, sep = "")
  prediction_data <- data %>%
    select(variable, Month)
  predicted_areas <- predict(dt_model, newdata = prediction_data, type = "class")
  
  result <- data.frame(variable = prediction_data[[variable]], Month = prediction_data$Month, X = predicted_areas)
  return(result)
}

# Predict crime locations for each category
crime_location_predictions <- lapply(categories, function(category) {
  predict_crime_area(new_crime_data, category)
})

# Display predicted crime locations for each category
for (i in seq_along(crime_location_predictions)) {
  category <- categories[i]
  predictions <- crime_location_predictions[[i]]
  
  cat("Predicted Crime Locations for", category, ":\n")
  print(predictions)
  cat("\n")
}

summary(new_crime_data)


clean_data <- na.omit(new_crime_data)

# Prepare the data for clustering
cluster_data <- clean_data %>%
  select(-c(Month, X)) %>%
  select(matches(categories))


# Prepare the data for clustering
cluster_data <- clean_data %>%
  select(-c(X, Month, Year)) %>%
  select(matches("Number.of"))

head(cluster_data)
# Perform k-means clustering
set.seed(123)  # Set a seed for reproducibility
k <- 3  # Number of clusters
kmeans_result <- kmeans(cluster_data, centers = k)

# Add cluster labels to the new_crime_data dataframe
clean_data$Cluster <- factor(kmeans_result$cluster)

# Set smaller plot margins
par(mar = c(0, 0, 0, 0))

# Visualize the clusters
clusplot(cluster_data, kmeans_result$cluster, color = TRUE, shade = TRUE, labels = 2, lines = 0)

# Explore the cluster centers
cluster_centers <- as.data.frame(kmeans_result$centers)
colnames(cluster_centers) <- colnames(cluster_data)
cluster_centers

