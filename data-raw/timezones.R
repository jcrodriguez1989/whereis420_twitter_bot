## code to prepare `timezones` dataset goes here

library("dplyr")
library("rvest")

timezones <- read_html("https://www.zeitverschiebung.net/en/all-time-zones.html") %>%
  html_node(".table-colored") %>%
  html_table()

usethis::use_data(timezones, overwrite = TRUE)
