
#' check github event that might violate the within perio restrictions
#'
#' @param username A character. Github login username
#' @param start A date/time
#' @param end A date/time
#'
#' @return A list of violation events
#' @export
#'
#' @examples none
check_githubViolation <- function(start, end){
  require(gitterhub)
  require(dplyr)
  require(purrr)
  require(lubridate)
  gh <- githubService()
  username <- gh$get_userInfo$login
  possibleViolationEvents <-
    getUserEvents_afterTime(
      username, startTime = start)
  possibleViolationEvents %>%
    keep(
      ~{ymd_hms(.x$created_at) %within% examPeriod}
    ) -> violationEvents
  violationEvents
}

