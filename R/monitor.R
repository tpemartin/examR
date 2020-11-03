log_activity <- function(studentProfile, type, studentId, logSysEnv=F) {
  require(googledrive)
  # require(digest)
  # logId <- sha1(paste0(studentId,lubridate::now()),10)

  # 產生第一個setup log
  tempdir <- tempdir()
  if (!exists(tempdir)) dir.create(tempdir, showWarnings = F)
  destfile <- tempfile(
    paste0("log_", type, "_", studentId),
    fileext = ".log"
  )
  # destfile = file.path(tempdir,paste0("log_",logId,"_",type,"_",studentId,".log"))

  if(logSysEnv){
    sys_env <- as.list(Sys.getenv())
    studentProfile <-
      append(
        studentProfile,
        list(
          sys_env=sys_env
        )
      )
    studentProfile <-
      append(studentProfile, get_ip())
  }
  xfun::write_utf8(
    jsonlite::toJSON(
      studentProfile,
      auto_unbox = T
    ),
    con = destfile
  )

  upload_googledrive(destfile) -> gd_response
  invisible(gd_response)
}

# helpers -----------------------------------------------------------------

get_activityReportTemplate <- function(){
  activityReport <- list(
    timestamp=lubridate::format_ISO8601(lubridate::now(), usetz = T),
    id=Sys.getenv("id"),
    type=list()
  )
 activityReport
}

get_ip <- function(){
  httr::GET("http://ip-api.com/json/")-> myIp
  httr::content(myIp) -> ipContent
  list(
    ip=ipContent$query,
    ipQuery=ipContent
  )
}


# log_download <- function(studentProfile,type,studentId){
#   download_exam(path=.root())
#   get_gitterGithubGoogleDriveUsageReport() -> usageReport
#
#   list(
#     usageReport,
#   )
#
#   # setup should keep platform id already.
#
# }


