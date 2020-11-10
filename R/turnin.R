#' Turn in exam
#'
#' @return
#' @export
#'
#' @examples none
turninExam <- function(){
  require(dplyr)
  require(stringr)
  require(googledrive)
  attention()
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

  upload_googledrive(examRmd) -> myExam

  get_activityReportTemplate() -> template
  template$type[[1]]= "turnin_exam"
  append(template,
         list(
           filename=examRmd,
           googledrive=myExam
         )) -> activityReport
  log_activity(
    activityReport,
    type="turnin_exam",
    studentId=Sys.getenv("school_id"),
    logSysEnv = T
  )
  message("Your exam file is submitted successfully.")
  invisible(myExam)
}
