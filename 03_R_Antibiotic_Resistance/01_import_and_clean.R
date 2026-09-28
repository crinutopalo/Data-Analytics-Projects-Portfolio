# =============================================================================
# 01_import_and_clean.R
# Project 3: antibiotic consumption (ATC J01DD) vs E. coli resistance to
#            third-generation cephalosporins, across European countries
#
# Data (downloaded 28 Sep 2026):
#   - ECDC EARS-Net : % resistant isolates, number of isolates tested
#   - ECDC ESAC-Net : consumption, DDD per 1000 inhabitants per day, total care
#
# How to run:
#   1. In RStudio: File > New Project > Existing Directory > "03 R health"
#   2. Put this script in that folder (next to the "sources data" folder)
#   3. First time only: install.packages(c("tidyverse", "readxl"))
#   4. Run it section by section (Ctrl+Enter) and read what each line does.
#   Check the file extensions below match your files (.csv / .xlsx).
# ============================================================================

library(tidyverse)   # readr, dplyr, tidyr, ggplot2
library(readxl)      # read .xlsx files

# ---- 1. Settings (each one is a choice to justify in your write-up) ---------
data_dir   <- "sources data"
min_tests  <- 100    # minimum tested isolates per country-year
first_year <- 2005   # before 2005 too few countries report

# ---- 2. Resistance: percentage resistant ------------------------------------
# "-" in the ECDC files means "no value", so we tell R to read it as NA
resist_pct <- read_csv(
  file.path(data_dir, "ECDC_surveillance_data_Antimicrobial_resistance_R.csv"),
  na = c("", "NA", "-")
) |>
  transmute(country = RegionName, year = Time, pct_resistant = NumValue)

# ---- 3. Resistance: number of isolates tested -------------------------------
resist_n <- read_csv(
  file.path(data_dir, "ECDC_surveillance_data_Antimicrobial_resistance_total.csv"),
  na = c("", "NA", "-")
) |>
  transmute(country = RegionName, year = Time, n_tested = NumValue)

# ---- 4. Consumption: wide table -> one row per country and year -------------
# finds the ESAC-Net Excel file by its name, whatever the exact extension case
consumption_file <- list.files(data_dir, pattern = "^esac_net.*xlsx",
                               ignore.case = TRUE, full.names = TRUE)
stopifnot(length(consumption_file) == 1)   # stops if 0 or 2+ files match

consumption <- read_excel(consumption_file, na = c("", "-")) |>
  select(-Country, -`EU/EEA crude population-weighted mean`) |>  # empty column + EU average
  rename(year = Year) |>
  mutate(year = as.numeric(year)) |>   # the Excel file stores years as text
  pivot_longer(-year, names_to = "country", values_to = "ddd")

# Cyprus 2023 is 0.00 while its other years are about 1.1-1.3: not a real zero
consumption <- consumption |>
  mutate(ddd = if_else(country == "Cyprus" & year == 2023, NA_real_, ddd))

# ---- 5. Join the three tables ------------------------------------------------
amr <- resist_pct |>
  inner_join(resist_n,    by = c("country", "year")) |>
  inner_join(consumption, by = c("country", "year")) |>
  filter(country != "Liechtenstein", year >= first_year)

# ---- 6. Checks: compare with the numbers you expect --------------------------
nrow(amr)                        # expect 586 rows
amr_complete <- amr |> drop_na(pct_resistant, ddd)
nrow(amr_complete)               # expect 481 (both values present)
amr_main <- amr_complete |> filter(n_tested >= min_tests)
nrow(amr_main)                   # expect 470 with min_tests = 100
n_distinct(amr_main$country)     # expect 30
amr_main |> count(year)          # about 15-18 countries in 2005-2009, 26-28 from 2016
glimpse(amr_main)

# ---- 7. Save the cleaned table (raw files stay untouched) -------------------
dir.create("data_clean", showWarnings = FALSE)
# keeps n_tested, so you can change the cutoff later without re-cleaning
write_csv(amr_complete, "data_clean/amr_clean.csv")

# ---- 8. First look: one dot per country, 2024 --------------------------------
amr_main |>
  filter(year == 2024) |>
  ggplot(aes(x = ddd, y = pct_resistant, label = country)) +
  geom_point() +
  geom_text(vjust = -0.7, size = 3) +
  labs(
    title = "Consumption vs resistance, 2024",
    x = "J01DD consumption (DDD per 1000 inhabitants per day)",
    y = "E. coli resistant to 3rd-generation cephalosporins (%)"
  )
