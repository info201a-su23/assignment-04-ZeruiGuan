library(ggplot2)
library(dplyr)

jail_population_data <- read.csv("us-jail-pop.csv")

data <- na.omit(jail_population_data)
columns_to_sum <- c("aapi_jail_pop", "black_jail_pop",
                    "latinx_jail_pop","native_jail_pop",
                    "white_jail_pop")
row_sums <- rowSums(t(data[, columns_to_sum])) / nrow(data)

df <- data.frame(values = row_sums)
race_plot <- ggplot(df, aes(x = c("AAPI", "Black", "Latin", "Native",
                                  "White"), y = values)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(x = "Race",
       y = "average jail population per year per county",
       title = "Average Jail Population by Race") +
  theme_minimal()

columns_to_sum_2 <- c("male_jail_pop", "female_jail_pop")
row_sums_2 <- rowSums(t(data[, columns_to_sum_2])) / nrow(data)

df_2 <- data.frame(values = row_sums_2)
gender_plot <- ggplot(df_2, aes(x = c("Male", "Female"), y = values)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(x = "Gender", y = "average jail population per year per county",
       title = "Average Jail Population by Gender") +
  theme_minimal()
  