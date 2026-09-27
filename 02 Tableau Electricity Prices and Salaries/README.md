# EU household electricity affordability (2007–2023)

An interactive look at electricity affordability across the countries of the European Union, from 2007 until 2023, and how it shifted since 2022. 


**Live dashboard:** https://public.tableau.com/views/EUElectricityAffordability20072023/Dashboard1

![Dashboard](images/dashboardscreenshot.png)

---

## Business question

How much of a household's income goes toward the electricity bill across the countries of the EU and has it changed since the 2022 energy crisis?


## Data

Two Eurostat datasets, joined equally in a hub structure, where income is the table base and electricity price is connected independently : 

- **`nrg_pc_204`** — household electricity prices, consumption band DC (2,500–4,999 kWh/year), all taxes and levies included
- **`earn_nt_net`** — net annual earnings, single person without children, 100% of average wage

The time range covers the period from 2007 until 2023. It ends with 2023, because the data from 2024 and 2025, which was present in the dataset, is not comparable to the data until 2023. Since 2024 the data is produced by the Joint Research Centre (European Commission) and before it was estimated by OECD.  


**Assumption used throughout:** annual consumption is fixed at **3,750 kWh** — the midpoint of Eurostat's 2,500–4,999 kWh consumption band. This is a self-calculated proxy figure, not a per-country measured consumption value, and it applies uniformly across all 27 countries.

## Methodology

**Affordability Ratio** = ((average electricity price × 3,750 kWh) / net annual income) × 100

Affordability ratio is the estimated share of a single person's net income (at 100% of average wage), based on an assumed annual consumption of 3,750 kWh, expressed as a percentage. 


2019 is used as the baseline year for year-over-year comparisons, since it's the last full year before the 2020–2022 energy price shocks. 

The map's colour scale is fixed (not automatic) across a 1.00–12.00 range, so colours stay comparable as the year filter changes.

## Dashboard

- **KPI row** — four KPI cards : 
    - EU-27 average electricity price
    - least affordable country
    - most affordable country
    - EU-27 change in affordability since 2019
- **Map** — share of net income spent on electricity by country, for the year selected in the filter above it
- **Year filter** — applies only to the map. The trend chart shows the complete range of years from 2007 until 2023, rather than concentrating on one single year.
- **Trend chart** — shows how the ratio has changed since 2007 for the EU-27 average and several different countries. 

## Key findings

- The EU-27 average electricity price in 2023 was **€0.287/kWh** (all taxes included)
- **Latvia** had the least affordable electricity in 2023, at **8.14%** of net income
- **Luxembourg** had the most affordable, at **1.55%**, in 2023. 
- The EU-27 average affordability ratio rose from **3.41% (2019) to 3.80% (2023)** — a **+0.39 percentage-point** increase, or **+11.4%** relative to the 2019 level

## Recommendation


Countries like Romania, Bulgaria, and Latvia spent a higher share of income on electricity than the European average, making them the countries where households are under the most pressure and where further investigation is warranted. These countries sit largely in Eastern and Southeastern Europe, a region historically reliant on Russian gas and therefore more exposed to the 2022 energy crisis.

A clear pattern is Romania's spike in 2022, visible on the chart — but it isn't explained by this analysis, and shouldn't be read as a diagnosed cause.

At the EU-27 level, the rise from 3.41% to 3.80% shows that affordability hasn't fully recovered since the 2022 peak.

A natural follow-up would be comparing the affordability ratio to general inflation, to see whether the share spent on electricity worsened faster than the cost of living overall, or moved at roughly the same pace.

## Limitations

- The three KPI tiles for least affordable, most affordable, and EU-27 change since 2019 are **static text**, calculated and typed in at build time — they do not update if the underlying data is refreshed.
- The 3,750 kWh consumption figure is a fixed assumption applied to all countries, not an actual measured or country-specific consumption value.
- Underlying income data has a break in series starting in 2024, which is why the ratio isn't extended past 2023.
- Gas prices were not included in the study, only electricity. 