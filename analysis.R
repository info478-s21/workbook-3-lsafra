# Analysis

# Set up - make sure to set your working directory using RStudio
library(tidyr)
library(dplyr)
library(ggplot2)

# Create the `charts/` directory (you can do this from R!)
dir.create("./charts/")
# Load prepped data
data <- read.csv("./data/prepped/all_data.csv")

# Are HALE and life expectancy correlated?
# - Plot 2016 life expectancy against 2016 HALE. Save the graph to `charts/`
data %>%
  filter(year==2016) %>%
  ggplot(aes(x=le, y=hale))+geom_point()+xlab("Life Expectancy (years)")+ylab("Health Adjusted Life Expectancy (years)")
ggsave("hale_le_comparison.png", path="~/Documents/INFO478/workbook-3-lsafra/charts/")

# - Compute the correlation between 2016 life expectancy against 2016 HALE
cor(data_2016$hale,data_2016$le)
# Are HALE and DALYs correlated?
# - Plot 2016 HALE against 2016 DALYs. Save the graph to `charts/`
data %>% 
  filter(year==2016) %>%
  ggplot(aes(x=hale, y=dalys))+geom_point()+xlab("Health Adjusted Life Expectancy (years)")+ylab("Disability Adjusted Life Years")
ggsave("hale_dalys_comparison.png", path="~/Documents/INFO478/workbook-3-lsafra/charts/")

# - Compute the correlation between 2016 HALE and DALYs
data_2016 <- data %>%
  filter(year==2016)
cor(data_2016$hale, data_2016$dalys)

# As people live longer, do they live healthier lives 
# (i.e., is a smaller fraction of life spent in poor health)?
# Follow the steps below to attempt to answer this question.

# First, you will need to reshape the data to create columns *by metric-year*
# This will create `hale_2016`, `hale_1990`, `le_2016`, etc.
# To do this, I suggest that you use the `pivot` function in the new
# tidyverse release:https://tidyr.tidyverse.org/articles/pivot.html#wider
wide_data <- pivot_wider(data, names_from = year, values_from = c(hale, dalys, le))

# Create columns to store the change in life expectancy, and change in hale
wide_data$delta_le <- wide_data$le_2016-wide_data$le_1990
wide_data$delta_hale <- wide_data$hale_2016-wide_data$hale_1990
wide_data$delta_dalys <- wide_data$dalys_2016-wide_data$dalys_1990

# Plot the *change in hale* against the *change in life expectancy*
# Add a 45 degree line (i.e., where x = y), and save the graph to `charts/`
# What does this mean?!?! Put your interpretation below
ggplot(wide_data, aes(delta_hale,delta_le)) +
  geom_point() +
  labs(title = "Change in HALE vs. Change in Life Expectancy",
       x="Change in HALE (years)", y="Change in Life Expectancy (years)") +
  geom_abline(slope=1, intercept=0)
ggsave("change_in_hale_le.png", path="~/Documents/INFO478/workbook-3-lsafra/charts/")
ggplot(wide_data, aes(delta_le,delta_hale)) +
  geom_point()+
  geom_abline(slope=1, intercept=0)
# Interpretation: The slope of the scatter points appears to be greater than 1,
# whereas the slope of the x=y line is 1.  This means that changes in life expectancy are
# not matched by changes in health adjusted life expectancy.  As people live longer,
# they are not necessarily staying health for longer.



