exam_authentication <- function(type){
  # four platform authentication
  loginProfile <- list()
  require(googleclassroom)
  cs <- googleclassroom::classroomService()
  require(gitterhub)
  gt <- gitterService()
  gh <- githubService()
  loginProfile$googleclassroom = cs$get_profile()
  loginProfile$gitter=gt$get_userProfile()
  loginProfile$github=gh$get_userProfile()
  loginProfile$time=lubridate::now()
  loginProfile$type=type
  loginProfile
}

