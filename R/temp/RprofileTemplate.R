library(xfun)
library(lubridate)
library(stringr)
library(purrr)
library(dplyr)
library(rlang)
library(gitterhub)
library(rprojroot)
.id="%id%"
.name="%name%"
.gmail="%gmail%"
rprojroot::is_rstudio_project-> .pj
.pj$make_fix_file() -> .root
Sys.setenv("id"=.id,"name"=.name,"gmail"=.gmail)
utils::browseURL("https://tpemartin.github.io/NTPU-R-for-Data-Science/")
utils::browseURL("https://classroom.google.com")
