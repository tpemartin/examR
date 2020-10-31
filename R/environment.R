set_Renviron <- function(studentProfile){
  path_Renviron <- ifelse(
    Sys.getenv('R_USER')=="",
    Sys.getenv('HOME'),
    Sys.getenv('R_USER')
  )
  envLines <- c()
  if(file.exists(
    file.path(path_Renviron,".Renviron")
  )) {
    xfun::read_utf8(
      file.path(path_Renviron,".Renviron")
    ) -> envLines}
  c(
    envLines,
    paste0("googleClassroom_id=",studentProfile$googleclassroom$id),
    paste0("googleClassroom_email=",studentProfile$googleclassroom$emailAddress),

    paste0("gitter_id=",studentProfile$gitter[[1]]$id),
    paste0("gitter_username=",studentProfile$gitter[[1]]$username),

    paste0("github_username=",studentProfile$github$login),
    paste0("github_id=",studentProfile$github$id)
  ) -> envLinesNew

  xfun::write_utf8(
    envLinesNew,
    file.path(path_Renviron,".Renviron")
  )

}
