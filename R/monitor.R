log_activity <- function(studentProfile,type,studentId){
  require(googledrive)
  require(digest)
  logId <- sha1(paste0(studentId,lubridate::now()),10)

  # 產生第一個setup log
  tempdir = tempdir()
  if(!exists(tempdir)) dir.create(tempdir, showWarnings = F)

  destfile = file.path(tempdir,paste0("log_",logId,"_",type,"_",studentId,".log"))

  xfun::write_utf8(
    jsonlite::toJSON(
      studentProfile, auto_unbox = T
    ),
    con=destfile
  )

  upload_googledrive(destfile)
}

log_download <- function(studentProfile,type,studentId){
  download_exam(path=.root())
  get_gitterGithubGoogleDriveUsageReport() -> usageReport

  list(
    usageReport,
  )

  # setup should keep platform id already.

}
