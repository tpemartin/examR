#' authentication
#'
#' @param type a character
#'
#' @return
#' @export
#'
#' @examples none.
exam_authentication <- function(type="auth"){
  require(dplyr)
  # four platform authentication
  loginProfile <- list()
  require(gargle)
  require(gh)
  .token <<- token_fetch(
    scopes = c("https://www.googleapis.com/auth/drive")
  )
  googledrive::drive_auth(token=.token)
  googleInfo <- gargle::token_userinfo(.token)
  names(googleInfo) %>%
    stringr::str_replace_all(
      c('emailAddress'="email")
    ) -> newnames

  names(googleInfo) <- newnames

  loginProfile$googleclassroom = googleInfo
  github_username = rstudioapi::showPrompt("Setup Github","Please input your Github login ID (username)")
  githubInfo <- gh("GET /users/:username", username=github_username)
  loginProfile$gitter=githubInfo
  loginProfile$github=githubInfo
  loginProfile$time=lubridate::now()
  loginProfile$type=type
  loginProfile
}

