#' store exam
#'
#' @return
#' @export
#'
#' @examples none
storeExam <- function(){
  require(dplyr)
  require(stringr)
  require(googledrive)
  if(!exists(".root")){
    rprojroot::is_rstudio_project-> .pj
    tryCatch({
      .pj$make_fix_file()
    },
    error=function(e){
      stop("Please start your RStudio as an exam project.")
    }) ->> .root
  }

  filename <- paste0("midterm1_",Sys.getenv("school_id"))
  list.files(path=.root()) -> allfiles
  allfiles %>%
  str_which(paste0(filename,"\\.[Rr][Mm][Dd]")) -> which_examRmd
  if(length(which_examRmd)==0){
    stop("There is no proper exam file in your project.")
  }
  examRmd <- allfiles[[which_examRmd]]
  tempfilename <- tempfile(pattern=filename,fileext = ".Rmd")
  file.copy(
    from=examRmd,
    to=tempfilename,
    overwrite = T
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
    studentId=Sys.getenv("school_id"),
    logSysEnv = T
  )
  message("Your exam file is stored successfully.")
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
      pattern=paste0("midterm1_",Sys.getenv("school_id"))
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
    as_id(backupExamDownloadLink), overwrite = T, verbose = F
  ) -> myDownload
  get_activityReportTemplate() -> template
  template$type[[1]]= "restore_exam"
  append(template,
         list(
           backupExamDownloadLink=backupExamDownloadLink
         )) -> activityReport
  log_activity(
    activityReport,
    type="restore_exam",
    studentId=Sys.getenv("school_id"),
    logSysEnv = T
  )
  message(
    "Your file is restored successfully as\n",
    myDownload$name,
    "\nPlease rename your restored file (",
    myDownload$name,
    ") to \n",
    stringr::str_remove(
      myDownload$name, paste0("(?<=",Sys.getenv('school_id'),")[:alnum:]+(?=\\.)")
    ),
    "\nbefore you turn in."
  )

}
