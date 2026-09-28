# =============================================================================
# 03_robustness.R
# How solid is the link between consumption (J01DD) and E. coli resistance?
#   A. Is a straight line the right shape, or does log(consumption) fit better?
#   B. Does the result depend on a few countries?
#   C. Is the link there in every year, and does the minimum-tests cutoff matter?
#
# Run 01_import_and_clean.R first: it creates data_clean/amr_clean.csv
# =============================================================================

library(tidyverse)

# ---- 1. Load ------------------------------------------------------------------
amr   <- read_csv("data_clean/amr_clean.csv")
d2024 <- amr |> filter(year == 2024, n_tested >= 100)
nrow(d2024)          # expect 28

dir.create("figures", showWarnings = FALSE)   # charts are saved here

# Helper: one row of results for a set of countries
summarise_fit <- function(data, label) {
  test <- suppressWarnings(cor.test(data$ddd, data$pct_resistant, method = "spearman"))
  fit  <- lm(pct_resistant ~ ddd, data = data)
  tibble(
    scenario  = label,
    countries = nrow(data),
    rho       = unname(test$estimate),
    p_value   = test$p.value,
    slope     = unname(coef(fit)["ddd"]),
    r_squared = summary(fit)$r.squared
  )
}

# ---- A. Straight line or curve? (2024) ----------------------------------------
fit_lin <- lm(pct_resistant ~ ddd,      data = d2024)
fit_log <- lm(pct_resistant ~ log(ddd), data = d2024)

tibble(
  model     = c("straight line", "log(consumption)"),
  r_squared = c(summary(fit_lin)$r.squared, summary(fit_log)$r.squared),
  AIC       = c(AIC(fit_lin), AIC(fit_log))
)
# Both models have 2 parameters, so they can be compared directly.
# Higher R-squared and LOWER AIC = better fit.
# Expect about 0.50 vs 0.57 for R-squared, and about 185 vs 180 for AIC.

p_shape <- ggplot(d2024, aes(x = ddd, y = pct_resistant)) +
  geom_point() +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              colour = "grey50", linetype = "dashed") +
  geom_smooth(method = "lm", formula = y ~ log(x), se = FALSE,
              colour = "firebrick") +
  geom_text(aes(label = country), vjust = -0.7, size = 3, check_overlap = TRUE) +
  labs(
    title = "Resistance rises steeply at low antibiotic use, then levels off (2024)",
    subtitle = "Dashed line: straight-line fit. Red curve: log fit.",
    x = "Use of 3rd-generation cephalosporins\n(daily doses per 1,000 inhabitants per day)",
    y = "E. coli resistant to 3rd-generation cephalosporins (%)"
  )
p_shape
ggsave("figures/shape_2024.png", p_shape, width = 8, height = 5, dpi = 200)

# ---- B. Does it depend on a few countries? (2024) -----------------------------
scenarios <- list(
  "All countries"                  = character(0),
  "Without Cyprus"                 = "Cyprus",
  "Without Bulgaria"               = "Bulgaria",
  "Without Cyprus, Latvia, France" = c("Cyprus", "Latvia", "France")
)

bind_rows(
  imap(scenarios, \(drop, label) summarise_fit(filter(d2024, !country %in% drop), label))
)
# The "All countries" row should match your earlier result:
# rho 0.773, slope 7.82, R-squared 0.495.

# ---- C. Same test in every year, at three cutoffs -----------------------------
# These are NOT 20 independent tests: the same countries appear every year.
# The point is to see whether the link is stable over time, and whether the
# minimum-tests cutoff (50, 100 or 200) changes the picture.
rho_for_cutoff <- function(k) {
  amr |>
    filter(n_tested >= k) |>
    group_by(year) |>
    filter(n() >= 10) |>                 # skip years with fewer than 10 countries
    summarise(
      countries = n(),
      rho       = unname(suppressWarnings(
                    cor.test(ddd, pct_resistant, method = "spearman")$estimate)),
      p_value   = suppressWarnings(
                    cor.test(ddd, pct_resistant, method = "spearman")$p.value),
      .groups = "drop"
    ) |>
    mutate(min_tests = k)
}

rho_by_year <- bind_rows(lapply(c(50, 100, 200), rho_for_cutoff))

rho_by_year |> filter(min_tests == 100) |> print(n = 25)
# 20 years (2005-2024). The 2024 row should show rho 0.773 with 28 countries.

p_years <- ggplot(rho_by_year, aes(x = year, y = rho, colour = factor(min_tests))) +
  geom_hline(yintercept = 0, linetype = "dashed") +
  geom_line() +
  geom_point(aes(size = countries)) +
  scale_y_continuous(limits = c(-0.2, 1)) +
  labs(
    title = "Higher consumption goes with higher resistance in every year",
    subtitle = "Rank correlation (Spearman rho) between consumption and resistance, 2005-2024",
    x = "Year", y = "Rank correlation (rho)",
    colour = "Minimum tests", size = "Countries"
  )
p_years
ggsave("figures/rho_by_year.png", p_years, width = 8, height = 5, dpi = 200)
