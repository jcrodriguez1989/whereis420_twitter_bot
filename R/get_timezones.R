#' Get World Cities Timezones
#'
#' Tries to get timezones, if it does not work, returns the already saved ones.
#'
#' @importFrom dplyr `%>%`
#' @importFrom rvest html_node html_table read_html
#'
get_timezones <- function() {
  try_res <- try({
    timezones <- read_html("https://www.zeitverschiebung.net/en/all-time-zones.html") %>%
      html_node(".table-colored") %>%
      html_table()
  })
  timezones
}
