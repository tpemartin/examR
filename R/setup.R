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
  if(!require(gitterhub, quietly = T)){
    install.packages("https://www.dropbox.com/s/i724mtnpfd6avfe/gitterhub_0.1.4.tgz?dl=1")
    library(gitterhub)
  }

  # 考生身份驗證
  {
   studentProfile <- exam_authentication(type="setup")
   set_Renviron(studentProfile, idName=F)
  }

  # Sys.setenv(
  #   googleClassroom_id=studentProfile$googleclassroom$id,
  #   googleClassroom_email=studentProfile$googleclassroom$emailAddress,
  #
  #   gitter_id=studentProfile$gitter[[1]]$id,
  #   gitter_username=studentProfile$gitter[[1]]$username,
  #
  #   github_username=studentProfile$github$login,
  #   github_id=studentProfile$github$id
  #   )

  # 設定.Rprofile

  ## 四次學號輸入
  wrongMessage=""
  flag_wrongId =T
  count=0; maxcount=4
  while(flag_wrongId && count < maxcount){
    count=count+1
    .id <<- rstudioapi::showPrompt("",
                                   paste0(wrongMessage,"Please input your NTPU id"))
    flag_wrongId <- stringr::str_detect(.id,"^[74](107|109|108|106)(61|73|74|76|83|72|82|81|79|78|77|84|86)[:digit:]{3}$", negate = T)
    if(flag_wrongId) wrongMessage="Wrong id input"
    if(count==4) stop("Too many error inputs")
  }


  .name <<- rstudioapi::showPrompt("","Please input your name")
  .gmail <- studentProfile$googleclassroom$emailAddress

  # 取得考生討論室連結
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

  set_Renviron(idName=T)

  download_exam(.examProject, logActivity=F)

  # 記錄考生活動
  activityReport <- list(
    timestamp=lubridate::format_ISO8601(lubridate::now(), usetz = T),
    id=.id,
    name=.name,
    type=list("exam_download","setup"),
    profile=studentProfile
  )
  log_activity(activityReport,
               type="set_up",
               studentId=.id)

  # 建立project
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
