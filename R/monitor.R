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

#' Check student progress between start and end
#'
#' @param start A date/time
#' @param end A date/time
#'
#' @return A list of report
#' @export
#'
#' @examples none
check_status <- function(){
  require(lubridate)
  start=ymd_hms(Sys.getenv("start_time"),tz="Asia/Taipei")
  end=start+hours(2)+minutes(15)
  gitterStatus <- examR:::getLastActivityTimeOfAllRooms()
  gitterStatus %>%
    filter(lastAccessTime > start) -> gitterViolations
  githubStatus <- check_githubViolation(start, end)

  activityReport <- get_activityReportTemplate()

  totalViolations <- length(gitterViolations)+length(githubStatus)

  activityReport$id <- Sys.getenv("school_id")
  activityReport$type <- list("status_check")
  activityReport$totalViolations <- totalViolations
  activityReport$gitter <- gitterViolations
  activityReport$github <- githubStatus
  log_activity(activityReport,
               type="status_check",logSysEnv = T)

}

#
# require(gitterhub)
# require(purrr)
# require(lubridate)
# start <- ymd_hms("2020-10-28 13:00:00", tz="Asia/Taipei")
# end <- start+days(2)
# examPeriod <- start %--% end


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


