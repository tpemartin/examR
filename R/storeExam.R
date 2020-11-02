#' store exam
#'
#' @return
#' @export
#'
#' @examples none
storeExam <- function(){
  require(dplyr)
  require(stringr)
  filename <- paste0("midterm1_",Sys.getenv("id"))
  list.files(path=.root()) -> allfiles
  allfiles %>%
  str_which(paste0(filename,"\\.[Rr][Mm][Dd]")) -> which_examRmd
  examRmd <- allfiles[[which_examRmd]]
  tempfilename <- tempfile(pattern=filename,fileext = "Rmd")
  file.link(
    from=examRmd,
    to=tempfilename
  )
  upload_googledrive(tempfilename) -> myExam
  Sys.setenv("backupExamDownloadLink"=myExam$drive_resource[[1]]$webViewLink)
  get_activityReportTemplate() -> template
  template$type[[1]]= "store_exam"
  append(template,
         list(
           filename=examRmd,
           tempfilename=tempfilename,
           googledrive=myExam
         )) -> activityReport
  log_activity(
    activityReport,
    type="store_exam",
    studentId=Sys.getenv("id")
  )
  invisible(myExam)
}
#' Restore exam from cloud
#'
#' @return
#' @export
#'
#' @examples none
restoreExam <- function(){
  backupExamDownloadLink=Sys.getenv('backupExamDownloadLink')
  if(backupExamDownloadLink==""){ # data missing
    drive_ls(
      as_id("https://drive.google.com/drive/folders/1IL5L2s_gaUTcwXk6OAalTHyOsswswaq0?usp=sharing"),
      pattern=paste0("midterm1_",Sys.getenv("id"))
    ) -> list_possiblefiles
    require(purrr)
    require(dplyr)
    map_chr(list_possiblefiles$drive_resource,
        ~.x$modifiedTime) %>%
      lubridate::ymd_hms() %>%
     {which(.==max(.))} -> whichIsTheLastest

    backupExamDownloadLink <- list_possiblefiles$drive_resource[[whichIsTheLastest]]$webViewLink
    Sys.setenv("backupExamDownloadLink"=backupExamDownloadLink)
  }
  require(googledrive)
  drive_download(
    as_id(backupExamDownloadLink)
  )
  get_activityReportTemplate() -> template
  template$type[[1]]= "restore_exam"
  append(template,
         list(
           backupExamDownloadLink=backupExamDownloadLink
         )) -> activityReport
  log_activity(
    activityReport,
    type="restore_exam",
    studentId=Sys.getenv("id")
  )

}
