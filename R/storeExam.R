#' store exam
#'
#' @return
#' @export
#'
#' @examples none
storeExam <- function(){
  require(dplyr)
  require(stringr)
  list.files(path=.root()) %>%
  str_which("^midterm[:graph:]+\\.[Rr][Mm][Dd]$") -> examRmd

  upload_googledrive(examRmd) -> myExam
  myExam
}
