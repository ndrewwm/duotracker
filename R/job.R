library(rvest)
library(readr)
library(RSelenium)
library(lubridate)

source("get_profile_details.R")

run <- get_profile_metrics("amateurthoughts")

write_csv(run, "./data-raw/metrics.csv", append = TRUE)
