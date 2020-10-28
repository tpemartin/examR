setup_exam <- function(){
  .examProject <- file.path(getwd(),"midterm1")
  if(!dir.exists(.examProject)) dir.create(.examProject)
  packageList <- c(
    "googledrive","lubridate","dplyr","purrr",
    "stringr", "xfun", "rlang", "rprojroot"
  )
  for(.x in seq_along(packageList)){
    if(!require(packageList[[.x]], character.only = T)){
      install.packages(packageList[[.x]])
      library(packageList[[.x]], character.only = T)
    }
  }
  if(!require(gitterhub)){
    install.packages("https://www.dropbox.com/s/i724mtnpfd6avfe/gitterhub_0.1.4.tgz?dl=1")
    library(gitterhub)
  }

  .id <<- rstudioapi::showPrompt("","輸入你的學號")
  .name <<- rstudioapi::showPrompt("","輸入你的姓名")
  .gmail <<- rstudioapi::showPrompt("","輸入你的google classroom登入gmail")

  # chatroom
  as.character(chatroom$id) -> chatroom$id
  loc_chatroom <- which(chatroom$id==.id)
  gitter <- ifelse(
    length(loc_chatroom)==0,
    "",
    paste0(chatroom$roomUrl[loc_chatroom],
         collapse = "\n"))

  stringr::str_replace_all(rprofileContent,
                           c("%id%"=.id,
                             "%name%"=.name,
                             "%gmail%"=.gmail,
                             "%gitter%"=gitter)) ->
    .myRprofile

  download_exam(.examProject)
  rstudioapi::initializeProject(
    path = .examProject)
  xfun::write_utf8(
    .myRprofile, con=file.path(.examProject,".Rprofile")
  )
  rstudioapi::openProject(.examProject)
}
# xfun::read_utf8(
# file.path(.root(),"R/temp/RprofileTemplate.R")
# ) -> rprofileContent
# usethis::use_data(rprofileContent, internal=T, overwrite = T)
