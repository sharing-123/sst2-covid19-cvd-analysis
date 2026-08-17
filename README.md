<img src="assets/banner.svg" alt="Elevated sST2 After COVID-19 — banner" width="100%">

# Elevated sST2 After COVID-19 in Patients With Cardiovascular Comorbidities

Analysis transparency repository for the manuscript *"Elevated Soluble ST2 Three Months After COVID-19 Infection in Patients With Cardiovascular Comorbidities."*

**Live companion page (fuller animation): https://sharing-123.github.io/sst2-covid19-cvd-analysis/**

## Purpose

This repository documents how the statistics reported in the manuscript were produced, so the analytical approach can be followed and checked independently of the paper text.

## What is included

- `syntax/reconstructed_analysis.sps` — a complete IBM SPSS Statistics syntax file covering:
  - Normality testing (Kolmogorov–Smirnov)
  - Descriptive statistics by group
  - Three-group comparisons for categorical variables (chi-square)
  - Three-group comparisons for sST2 (one-way ANOVA with Bonferroni-corrected pairwise post-hoc, plus the nonparametric Kruskal–Wallis-based equivalent)
  - Bivariate correlation and group-comparison tests between admission variables and sST2 within the COVID-19/cardiovascular comorbidity group
  - The multivariable linear regression reported in Table 3

This syntax was **reconstructed from the Methods section of the manuscript**, step by step, to make the statistical plan transparent and reproducible. It is not the original analyst's saved run history — variable names, exact command order, and options may differ from what was actually executed in SPSS, even though the statistical tests and logic match what is described in the paper.

## What is deliberately not included

- No patient-level or raw data of any kind. Data were collected under ethics approval from the National Cardiovascular Centre Harapan Kita Hospital Medicine Ethics Committee, and individual records are not shared here.
- No identifying information.

## Repository structure

```
.
├── assets/banner.svg              animated banner used above
├── docs/index.html                GitHub Pages companion page
├── syntax/reconstructed_analysis.sps
└── README.md
```

## Citation

If you reference this repository, please cite the associated manuscript once published. Citation details will be added here upon publication.
