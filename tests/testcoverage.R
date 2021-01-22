library(covr)
oldwd <- getwd()
setwd(paste0(oldwd, "/tests/testthat"))
res_all <- file_coverage(c("../../dropdown.R", "../../server.R", "../../utils.R"), 
                     "testutils.R")
res_utils <- file_coverage(c("../../utils.R"), 
                           "testutils.R")
print(paste("percent coverage, all files: ", percent_coverage(res_all)))
print(paste("percent coverage, utils file: ", percent_coverage(res_utils)))
setwd(oldwd)

