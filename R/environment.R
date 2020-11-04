set_Renviron <- function(studentProfile=NULL,idName=F, examDateTime=NULL){
  path_Renviron <- ifelse(
    Sys.getenv('R_USER')=="",
    Sys.getenv('HOME'),
    Sys.getenv('R_USER')
  )
  envLines_idName <-
    envLines_studentProfile <-
    envLines_old <-
    envLines_examDateTime <-
    c()
  if(file.exists(
    file.path(path_Renviron,".Renviron")
  )) {
    xfun::read_utf8(
      file.path(path_Renviron,".Renviron")
    ) -> envLines_old}
  if(!is.null(studentProfile)){
    c(
      paste0("googleClassroom_id=",studentProfile$googleclassroom$id),
      paste0("googleClassroom_email=",studentProfile$googleclassroom$emailAddress),

      paste0("gitter_id=",studentProfile$gitter[[1]]$id),
      paste0("gitter_username=",studentProfile$gitter[[1]]$username),

      paste0("github_username=",studentProfile$github$login),
      paste0("github_id=",studentProfile$github$id)
    ) -> envLines_studentProfile
  }
  if(idName){
    c(
      paste0("school_id=",.id),
      paste0("name=",.name)
    ) -> envLines_idName
  }
  if(!is.null(examDateTime)){
    c(
      paste0("examDateTime=", examDateTime)
    ) -> envLines_examDateTime
  }
  envLinesNew <- c(
    envLines_old,
    envLines_studentProfile,
    envLines_idName,
    envLines_examDateTime
  )

  xfun::write_utf8(
    envLinesNew,
    file.path(path_Renviron,".Renviron")
  )

}
attention <- function() {
  if (Sys.getenv("read_rule") == "") {
    rstudioapi::showDialog(
      title = "請留意!!!",
      message = "剛才跳出的幾個平台頁面是你考試期間允許登入的平台，其他自行連結過去的平台只能瀏覽但不能有登入動作。否則算是違反考試規則。"
    )
    rstudioapi::showDialog(
      title = "考試期間",
      message = "gitter只能和考試組員（非自己作業組員）、老師及助教討論，與其他對象討論也屬違反考試規則。使用任何其他媒介傳送送訊息亦屬違規。"
    )
    rstudioapi::showDialog(
      title = "考卷檔",
      message = "要雲端備份，執行storeExam(); 要從雲端拿回最近一份備份，執行restoreExam(); 要交卷，執行turninExam()"
    )

    rstudioapi::showDialog(
      title = "感謝",
      message = "感謝你的配合，祝考試順利。"
    )
    Sys.setenv("read_rule" = "have read")
  }
  info <- list(
    timestamp = lubridate::format_ISO8601(
      lubridate::now(),
      usetz=T
    ),
    id=Sys.getenv("school_id")
  )
  log_activity(info, "read_rule", Sys.getenv("school_id"), logSysEnv=T)
}
