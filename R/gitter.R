#' Get last activity time of each room belong to the authenticated user
#'
#' @return A list of each room's last activity time
#' @export
#'
#' @examples none
getLastActivityTimeOfAllRooms <- function(){
  require(gitterhub)
  require(dplyr)
  require(purrr)
  require(lubridate)
  gt <- gitterService()
  myRooms <- gt$list_allMyRooms()
  map_dfr(
    myRooms,
    ~{
      data.frame(
        roomId=null2emtpychar(.x$id),
        name=null2emtpychar(.x$name),
        lastAccessTime=null2emtpychar(.x$lastAccessTime),
        public=.x$public
      )
    }
  ) -> rooms_lastAcitivityTime

  rooms_lastAcitivityTime$lastAccessTime <-
    ymd_hms(rooms_lastAcitivityTime$lastAccessTime)
  list(
    checkTime=now(),
    rooms_lastAcitivityTime=rooms_lastAcitivityTime
  )
}

# roomActivity <- getRoomLastActivityTime()

# helpers -------------------------------------------------------------------


null2emtpychar <- function(x){
  ifelse(is.null(x),"",x)
}

# purrr::map_chr(
#   myRooms,
#   ~null2emtpychar(.x$lastAccessTime)
# ) %>%
#   ymd_hms() -> lastAccessTime
# examDateTime <- c(
#   start=ymd_hms("2020-11-04 12:50:00",
#                 tz="Asia/Taipei"),
#   end=ymd_hms("2020-11-04 15:20:00",
#               tz="Asia/Taipei")
#   )
# examDateTime <-  examDateTime - weeks(1)
# lastAccessTime %within%
#   (examDateTime[[1]] %--% examDateTime[[2]])
# pick <- lastAccessTime > examDateTime[[1]]
# roomsPicked <- myRooms[pick]
# roomsPicked %>%
#   purrr::map_chr(
#     ~{null2emtpychar(.x$name)}
#   )
#
# ymd_hms(lastAccessTime)
# purrr::map(
#   myRooms,
#   ~.x$name
# )
# purrr::map(
#   myRooms,
#   ~.x$public
# )
# purrr::map(
#   myRooms,
#   ~.x$id
# )

