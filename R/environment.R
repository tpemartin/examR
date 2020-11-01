set_Renviron <- function(studentProfile=NULL,idName=F,examInfo=NULL){
  path_Renviron <- ifelse(
    Sys.getenv('R_USER')=="",
    Sys.getenv('HOME'),
    Sys.getenv('R_USER')
  )
  envLines_idName <-
    envLines_studentProfile <-
    envLines_old <-
    envLines_examInfo <-
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
  if(!is.null(examInfo)){
    c(
      paste0("examDateTime=", examDateTime)
    ) -> envLines_examInfo
  }
  envLinesNew <- c(
    envLines_old,
    envLines_studentProfile,
    envLines_idName,
    envLines_examInfo
  )

  xfun::write_utf8(
    envLinesNew,
    file.path(path_Renviron,".Renviron")
  )

}
