# w2tools
 R package to assist post processing of CE-QUAL-W2 model outputs

## Install

```R
devtools::install_github("OR-Dept-Environmental-Quality/w2tools", 
                         host = "https://api.github.com", 
                         dependencies = TRUE, force = TRUE, upgrade = "never")
```
## Example

```R
library(w2tools)
library(heatsourcetools)
library(dplyr)
library(tidyr)
library(writexl)

sim1_name <- "Calibratiton"
sim1_dir <- "//path/to/W2_model"
sim1_w2_year <- 2016

# Read all TSR outputs
tsr_sim1_raw <- w2_read_tsr_all(dir = sim1_dir, 
                            sim_name = sim1_name, 
                            year = sim1_w2_year)
                            
                  
# Extract datetime and temperture output columns and pivot into wide format 
# where rows = datetime and column headers = segments
tsr_sim1_temps <- tsr_sim1_raw %>%
  pivot_wider(id_cols = matches(c("sim", "datetime", "date")), 
                                names_from = "segment",
                                values_from = "t2_c")
                                
# Calculate 7dadm for the temperture output and pivot into wide format 
# where rows = datetime and column headers = segments
# Note calc_7dadm function comes from DEQ's heatsourcetools R pacakge found on 
# DEQ's GitHub respository
tsr_sim1_7dadm <- calc_7dadm(tsr_sim1_raw, datetime_col = "datetime", sim_col = "sim",
                        dis_col = "segment", value_col = "tvolavg_c") %>%
  filter(constituent == "7DADM Temperature") %>%
  pivot_wider(id_cols = matches(c("sim", "constituent", "datetime", "date")), 
              names_from = "segment",
              values_from = "value")

# Save to xlsx file
write_xlsx(list(t_7dadm = tsr_sim1_7dadm, 
                t_hourly = tsr_sim1_temps), 
           path = "sim1_temperature_output.xlsx")

```
