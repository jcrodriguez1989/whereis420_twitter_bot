#' Get Places Where it is 4:20 PM
#'
#' Filters timezones for cities where it is 4:20 PM.
#'
#' @importFrom dplyr `%>%` filter mutate tibble
#' @importFrom lubridate hour minute now
#' @importFrom purrr map_dfr
#'
#' @export
#'
get_420_places <- function() {
  timezones <- get_timezones()
  # Initialize hour and minute vectors (lubridate is not working well for this).
  current_hour <- integer(nrow(timezones))
  current_min <- integer(nrow(timezones))
  for (i in seq_len(nrow(timezones))) {
    time <- now(tzone = timezones$`Time Zone`[[i]])
    current_hour[[i]] <- hour(time)
    current_min[[i]] <- minute(time)
  }
  timezones$hour <- current_hour
  timezones$minute <- current_min

  # Filter places where it is 4PM, and the nearest to 20 minutes.
  places_420 <- mutate(timezones, mins_20_diff = abs(20 - minute)) %>%
    filter(hour == 16) %>%
    filter(mins_20_diff == min(mins_20_diff))

  # Nicely format city/country for 420 places.
  map_dfr(
    seq_len(nrow(places_420)),
    function(i) {
      place <- places_420[i,]
      tibble(
        city = paste0("", strsplit(place$`Major Cities in Time Zone`, ", ")[[1]]),
        country = paste0("", place$Country),
        time = paste0(place$hour, ifelse(place$minute < 10, ":0", ":"), place$minute)
      )
    }
  ) %>%
    mutate(location = ifelse(
      nchar(city) > 0  & nchar(country) > 0, paste(city, country, sep = ", "), paste0(city, country)
    ))
}
