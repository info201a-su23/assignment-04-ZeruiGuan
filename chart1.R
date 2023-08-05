library(ggplot2)
library(dplyr)

prison_data <- read.csv("us-prison-pop.csv")
jail_data <- read.csv("us-jail-pop.csv")

merged_data <- merge(prison_data, jail_data, by = c("fips",
                                                    "year",
                                                    "state",
                                                    "county_name"))

merged_data <- na.omit(merged_data)

grouped_data <- merged_data %>%
  group_by(year) %>%
  summarise(total_prison_pop = sum(total_prison_pop),
            total_jail_pop = sum(total_jail_pop))

grouped_data <- grouped_data[grouped_data$year >= 1999, ]

ggplot(grouped_data, aes(x = year)) +
  geom_bar(aes(y = total_prison_pop, fill = "Prison"), stat="identity") +
  geom_bar(aes(y = total_jail_pop, fill = "Jail"), stat="identity") +
  labs(x = "Year", y = "Total Prison/Jail Population",
       title = "Comparison of Total Prison and Jail Populations Over Time")