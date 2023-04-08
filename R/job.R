library(rvest)
library(readr)
library(RSelenium)
library(lubridate)

run <- get_profile_metrics("amateurthoughts")

write_csv(run, "./data-raw/metrics.csv", append = TRUE)
