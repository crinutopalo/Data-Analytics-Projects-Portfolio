# =============================================================================
# 02_first_test.R
# Does consumption of third-generation cephalosporins (J01DD) go together with
# E. coli resistance to them? First test: one year (2024), one dot per country.
#
# Run 01_import_and_clean.R first: it creates data_clean/amr_clean.csv
# =============================================================================

library(tidyverse)

# ---- 1. Hypotheses (write your expectation BEFORE running the tests) ---------
# H0: across countries, consumption and resistance are not associated.
# H1: countries with higher consumption tend to have higher resistance.
#
# My expectation before looking at the numbers (direction, roughly how strong,
# and why, biologically):
# ...

# ---- 2. Load and filter ------------------------------------------------------
min_tests <- 100
amr <- read_csv("data_clean/amr_clean.csv")
d2024 <- amr |> filter(year == 2024, n_tested >= min_tests)
nrow(d2024)          # expect 28 countries

# ---- 3. Rank correlation (Spearman) ------------------------------------------
# Spearman compares rankings, so one extreme country (e.g. Bulgaria) cannot
# dominate the result. A warning about ties is normal here: R then uses an
# approximate p-value.
cor.test(d2024$ddd, d2024$pct_resistant, method = "spearman")

# ---- 4. Straight-line model --------------------------------------------------
fit <- lm(pct_resistant ~ ddd, data = d2024)
summary(fit)

# ---- 5. Which countries do not follow the trend? -----------------------------
# residual = observed resistance minus the resistance the line predicts
d2024 |>
  mutate(predicted = fitted(fit), residual = resid(fit)) |>
  arrange(desc(abs(residual))) |>
  select(country, ddd, pct_resistant, predicted, residual)
