download_exam <- function(path){
  filename <- file.path(path,paste0("midterm1_",.id,".Rmd"))
  download_file(downloadLink,
                output=filename, quiet=T)
  upload_log(filename)
  xfun::read_utf8(filename) -> contentlines
  stringr::str_replace_all(
    contentlines,
    c("%id%"=.id,
      "%name%"=.name)
  ) -> newContentLines
  xfun::write_utf8(newContentLines, con=filename)

}


# helpers -----------------------------------------------------------------

upload_log <- function(filename){
  require(lubridate)
  .tempfile =file.path(tempdir(),paste0("log_",Sys.getenv("id"),"_",format_ISO8601(now()),".txt"))
  xfun::write_utf8(paste0(filename, " download at ", now()),con=.tempfile)

  drive_upload(.tempfile,
               activeFolder,
               verbose = F) -> examUpload
}
# library(googledrive)
# drive_ls()
# drive_ls(path="https://drive.google.com/drive/u/0/folders/1i0CKWCLVS99ULX5F9YM6kdtTfI4DF3v9") -> list_files
# list_files[1,] %>%
#   drive_share(
#     role = "reader",
#     type = "anyone"
#   ) -> examFile
# examFile$drive_resource[[1]]$webContentLink -> downloadLink
#
# internalData = load("~/Github/examR/R/sysdata.rda")
# internalData
#
# usethis::use_data(
#   activeFolder,
#   downloadLink,
#   rprofileContent, internal = T,
#   overwrite = T
# )
