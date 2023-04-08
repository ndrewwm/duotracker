#' Pull relevant metrics from a Duolingo user's profile
#'
#' @export
#' @import RSelenium
#' @import rvest
#' @import lubridate
#'
#' @param username string, the username to search
#'
#' @return tibble, metrics
get_profile_metrics <- function(username) {
  curtime <- now(tzone = "US/Mountain")
  url <- paste0("https://www.duolingo.com/profile/", username)

  # start a RSelenium server
  driver <- rsDriver(
    browser = "firefox",
    chromever = NULL,
    extraCapabilities = list("moz:firefoxOptions" = list("args" = list("--headless")))
  )
  server <- driver[["server"]]
  client <- driver[["client"]]

  # navigate to the profile, wait for the dynamic content to load, then pull the source
  client$navigate(url)
  Sys.sleep(3)
  res <- client$getPageSource()[[1]]

  client$close()
  server$stop()

  # parse the gathered html, and return
  tryCatch(
    {
      out <- res |>
        minimal_html() |>
        html_elements("h4") |>
        html_text()

      data.frame(
        "day_streak" = out[1],
        "total_xp" = out[2],
        "current_league" = out[3],
        "top3_finishes" = out[4],
        "date" = curtime
      )
    },
    error = function(cond) {
      message("Metrics could not be parsed.")
      message(cond)
      return(data.frame("day_streak" = NA, "total_xp" = NA, "current_league" = NA, "top3_finishes" = NA, date = curtime))
    }
  )
}
