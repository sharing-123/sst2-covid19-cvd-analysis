<img src="assets/banner.svg" alt="Elevated sST2 after COVID-19" width="100%">

# Elevated sST2 After COVID-19 in Patients With Cardiovascular Comorbidities

This repository exists to show how the numbers in the manuscript *"Elevated Soluble ST2 Three Months After COVID-19 Infection in Patients With Cardiovascular Comorbidities"* were actually produced. Anyone reading the paper can come here, work through the same steps, and check that the analysis holds up on its own terms rather than taking the Methods section on faith.

A fuller, animated version of the results lives at https://sharing-123.github.io/sst2-covid19-cvd-analysis/

## Why this exists

Papers describe what was done in prose. That prose is usually enough for a reader to trust the result, but it is not enough to reproduce it, and reviewers or readers who want to check a specific test are often left guessing at exact settings and command order. This repository closes that gap for the sST2 manuscript. It reconstructs the statistical plan from the Methods section and the Supplementary Statistical Analysis, step by step, in a form that can actually be run.

None of the files here are the original analyst's saved SPSS output or run history. They are a faithful rebuild from the paper's description of the plan. Variable names, the exact order commands were entered in, and some default options may differ from what ran in the original session, but the tests, the models, and the logic match what the manuscript reports.

## What's in the primary analysis

`syntax/reconstructed_analysis.sps` covers the core statistics behind Tables 1 through 3. It runs the normality testing with the Kolmogorov Smirnov test, descriptive statistics by group, chi square comparisons for categorical variables across the three groups, the one way ANOVA and Kruskal Wallis comparisons for sST2 with Bonferroni corrected pairwise post hoc tests, the bivariate correlation and group comparison tests within the COVID-19/cardiovascular comorbidity group, and the multivariable linear regression reported in Table 3.

## What's in the supplementary analysis

The manuscript's Supplementary Statistical Analysis document answers several follow up questions a careful reviewer would ask, and this repository reconstructs each one.

`syntax/supplementary_analysis.sps` covers the confounder adjusted group comparison using ANCOVA with age, sex, diabetes mellitus, hypertension, coronary artery disease, and obesity as covariates. It also covers regression diagnostics for the Table 3 model (variance inflation factors, residuals, Cook's distance, the Durbin Watson statistic) plus a log transformed sensitivity model, the logistic regression and ROC threshold analysis for admission PaO2 and Ct value, the correlation of sST2 with hs CRP, D dimer, NT proBNP, and troponin, and a multiple imputation sensitivity analysis for the biomarkers that missing data excluded from the primary model.

One piece does not have a native SPSS procedure. Checking whether PaO2 and Ct value relate to sST2 in a strictly linear way calls for a restricted cubic spline, which SPSS cannot fit directly. `analysis/rcs_and_roc.py` handles that in Python, and also reproduces the ROC step so the two approaches can be checked against each other.

The interactive charts on the companion page are drawn from `docs/supplementary_summary_stats.json`, which holds only group level summary numbers such as adjusted means, variance inflation factors, spline predictions, ROC curve coordinates, correlation coefficients, and imputation estimates. Nothing patient level sits in that file.

## What's deliberately left out

No patient level or raw data of any kind is shared here. The data behind this manuscript were collected under ethics approval from the National Cardiovascular Centre Harapan Kita Hospital Medicine Ethics Committee, and individual records stay out of this repository entirely. There is no identifying information anywhere in it.

## Layout

```
.
├── assets/banner.svg                        banner used above
├── docs/index.html                          companion page with interactive charts
├── docs/supplementary_summary_stats.json    summary statistics behind those charts
├── syntax/reconstructed_analysis.sps        primary analysis, Tables 1 to 3
├── syntax/supplementary_analysis.sps        supplementary analysis
├── analysis/rcs_and_roc.py                  spline check plus an ROC cross-check
└── README.md
```

## Citing this work

If you reference this repository, please cite the associated manuscript once it is published. Citation details will be added here at that point.
