<img src="assets/banner.svg" alt="Elevated sST2 After COVID-19 — banner" width="100%">

# Elevated sST2 After COVID-19 in Patients With Cardiovascular Comorbidities

Analysis transparency repository for the manuscript *"Elevated Soluble ST2 Three Months After COVID-19 Infection in Patients With Cardiovascular Comorbidities."*

**Live companion page (fuller animation): https://sharing-123.github.io/sst2-covid19-cvd-analysis/**

## Purpose

This repository documents how the statistics reported in the manuscript were produced, so the analytical approach can be followed and checked independently of the paper text.

## What is included

- `syntax/reconstructed_analysis.sps` — a complete IBM SPSS Statistics syntax file covering the manuscript's primary analysis:
  - Normality testing (Kolmogorov–Smirnov)
  - Descriptive statistics by group
  - Three-group comparisons for categorical variables (chi-square)
  - Three-group comparisons for sST2 (one-way ANOVA with Bonferroni-corrected pairwise post-hoc, plus the nonparametric Kruskal–Wallis-based equivalent)
  - Bivariate correlation and group-comparison tests between admission variables and sST2 within the COVID-19/cardiovascular comorbidity group
  - The multivariable linear regression reported in Table 3

- `syntax/supplementary_analysis.sps` — a second syntax file covering the manuscript's **Supplementary Statistical Analysis**:
  - S1. Confounder-adjusted group comparison (ANCOVA: age, sex, DM, hypertension, CAD, obesity as covariates)
  - S2. Regression diagnostics (VIF, residuals, Cook's distance, Durbin–Watson) and a log-transformed sensitivity model
  - S4. Logistic regression and ROC threshold analysis for admission PaO2 and Ct value
  - S5. Correlation of sST2 with hs-CRP, D-dimer, NT-proBNP, and troponin
  - S6. Multiple imputation (MICE) sensitivity analysis for the biomarkers excluded from the primary model

- `analysis/rcs_and_roc.py` — a short Python script for **S3, the restricted-cubic-spline nonlinearity check**, which SPSS has no native procedure for, plus a Python reproduction of the S4 ROC analysis for cross-checking.

- `docs/supplementary_summary_stats.json` — the group-level summary statistics (adjusted means, VIFs, spline predictions, ROC curve points, correlations, imputation estimates) that drive the interactive charts on the companion page. No patient-level values, only published aggregates.

Every syntax and script file was **reconstructed from the manuscript and its Supplementary Statistical Analysis**, step by step, to make the statistical plan transparent and reproducible. None of them is the original analyst's saved run history — variable names, exact command order, and options may differ from what was actually executed, even though the statistical tests and logic match what is described in the paper.

## What is deliberately not included

- No patient-level or raw data of any kind. Data were collected under ethics approval from the National Cardiovascular Centre Harapan Kita Hospital Medicine Ethics Committee, and individual records are not shared here.
- No identifying information.

## Repository structure

```
.
├── assets/banner.svg                        animated banner used above
├── docs/index.html                          GitHub Pages companion page (interactive charts)
├── docs/supplementary_summary_stats.json    summary statistics behind the S1–S6 charts
├── syntax/reconstructed_analysis.sps        primary analysis (Tables 1–3)
├── syntax/supplementary_analysis.sps        supplementary analysis (S1, S2, S4–S6)
├── analysis/rcs_and_roc.py                  supplementary analysis (S3, plus a cross-check of S4)
└── README.md
```

## Citation

If you reference this repository, please cite the associated manuscript once published. Citation details will be added here upon publication.
