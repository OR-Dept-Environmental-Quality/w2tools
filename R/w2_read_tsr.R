#' Read W2 Time Series (TSR) plot outputs
#'
#' @param dir The path to the directory where the TSR file is located.
#' @param tsr The TSR file name.
#' @param sim_name The name of the model scenario. String format. Default is NA.
#' @param year The model starting or reference year. Should be the same as YEAR
#' in the w2 control file. Default is 1900. The year and Julian day from the TSR
#' file are converted to POSIXct datetimes. UTC is the default timezone.
#' #' @export
w2_read_tsr <- function(dir, tsr, sim_name = NA_character_, year = 1900) {

  tsr.raw <- readr::read_csv(file.path(dir, tsr))

  seg = as.numeric(sub( pattern = ".*_seg([0-9]+).*","\\1", x = tsr))

  tsr.1 <- tsr.raw %>%
    janitor::clean_names()

  tsr.names <- names(tsr.1)

  tsr.f <- tsr.1 %>%
    mutate(datetime = lubridate::ymd_hms(paste0(year ,"-01-01 00:00:00"),
                                         tz = "UTC") + lubridate::ddays(jday - 1),
           date = format(datetime, format = "%Y-%m-%d"),
           sim = sim_name,
           segment = seg) %>%
    select(sim, datetime, date, segment, dplyr::matches(tsr.names))

  return(tsr.f)

}

#' Read all W2 Time Series (TSR) plot outputs
#'
#' Function will read any text file with the regex pattern = "^tsr_.*opt.
#'
#' @param dir The path to the directory where the TSR file is located.
#' @param sim_name The name of the model scenario. String format. Default is NA.
#' @param year The model starting or reference year. Should be the same as YEAR
#' in the w2 control file. Default is 1900. The year and Julian day from the TSR
#' file are converted to POSIXct datetimes. UTC is the default timezone.
#' #' @export
w2_read_tsr_all <- function(dir, sim_name = NA_character_, year = 1900) {


  files_tsr <- list.files(path = dir, pattern = "^tsr_.*opt$",
                          full.names = FALSE, recursive = FALSE)

  df_tsr <- lapply(files_tsr, w2_read_tsr, dir = dir,
                   sim_name = sim_name, year = year) %>%
    dplyr::bind_rows() %>%
    dplyr::arrange(segment, datetime)

  return(df_tsr)

}
