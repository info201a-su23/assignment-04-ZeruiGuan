library(dplyr)
library(data.table)
df_prison <- read.csv("us-prison-pop.csv")
df_jail <- read.csv("us-jail-pop.csv")

highest_prison <- df_prison %>% 
  filter(year == 2016)
highest_prison_pop_sum <- sum(highest_prison$total_prison_pop, na.rm=TRUE)
lowest_prison <- df_prison %>% 
  filter(year == 1970)
lowest_prison_pop_sum <- sum(lowest_prison$total_prison_pop, na.rm=TRUE)

p_increase_rate <- paste0(((highest_prison_pop_sum / lowest_prison_pop_sum) ^ (1 / (2016 - 1970)) - 1) * 100, "%")

highest_j <- df_jail %>% 
  filter(year == 2016)
highest_j_pop_sum <- sum(highest_j$total_jail_pop, na.rm=TRUE)
lowest_j <- df_jail %>% 
  filter(year == 1970)
lowest_j_pop_sum <- sum(lowest_j$total_jail_pop, na.rm=TRUE)

j_increase_rate <- paste0(((highest_j_pop_sum / lowest_j_pop_sum) ^ (1 / (2016 - 1970)) - 1) * 100, "%")


prison_summary_table <- data.table(
  Prison_Num_Rows = nrow(df_prison),
  Prison_Num_Columns = ncol(df_prison),
  Prison_Num_states = length(unique(df_prison$state)),
  Prison_Pop_Highest_year = df_prison %>% 
    filter(total_pop == max(total_pop, na.rm=TRUE)) %>% pull(year),
  Prison_Highest_pop_state = df_prison %>% 
    filter(total_pop == max(total_pop, na.rm=TRUE)) %>% pull(state),
  Prison_Lowest_year = min(df_prison$year),
  Prison_Increase_rate = p_increase_rate
)

jail_summary_table <- data.table(
  Jail_Num_Rows = nrow(df_jail),
  Jail_Num_Columns = ncol(df_jail),
  Jail_Num_states = length(unique(df_jail$state)),
  Jail_Highest_year = df_jail %>% 
    filter(total_pop == max(total_pop, na.rm=TRUE)) %>% pull(year),
  Jail_Highest_pop_state = df_jail %>% 
    filter(total_pop == max(total_pop, na.rm=TRUE)) %>% pull(state),
  Jail_Lowest_year = min(df_jail$year),
  Jail_Increase_rate = j_increase_rate
)
