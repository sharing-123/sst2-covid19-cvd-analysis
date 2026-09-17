* Supplementary Statistical Analysis - reconstructed SPSS syntax.
* Extends reconstructed_analysis.sps with the confounder-adjusted,
* diagnostic, threshold, correlation, and missing-data sensitivity
* analyses reported in the manuscript's Supplementary Statistical
* Analysis document. Reconstructed from that document for transparency;
* it mirrors the described plan step by step and is not a saved run
* history from the original analysis software.

GET FILE='sst2_covid19_dataset.sav'.
DATASET ACTIVATE DataSet1.

* --- S1. Confounder-adjusted comparison of sST2 across groups (ANCOVA) ---
* Group (1=Case, 2=Control 1, 3=Control 2) as fixed factor; age, sex, DM,
* hypertension, CAD, and obesity as covariates. Estimated marginal means
* and Bonferroni-adjusted pairwise contrasts are requested directly.

UNIANOVA sst2 BY group WITH age sex dm ht cad obesity
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /EMMEANS=TABLES(group) WITH(age=MEAN sex=MEAN dm=MEAN ht=MEAN cad=MEAN obesity=MEAN) COMPARE ADJ(BONFERRONI)
  /PRINT=ETASQ DESCRIPTIVE HOMOGENEITY
  /CRITERIA=ALPHA(0.05)
  /DESIGN=age sex dm ht cad obesity group.

* --- S2. Regression diagnostics and log-transformed sensitivity model ---
* Re-run the Table 3 model, saving residual and influence diagnostics.

USE ALL.
COMPUTE filter_case=(group=1).
FILTER BY filter_case.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA COLLIN TOL
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN
  /DEPENDENT sst2
  /METHOD=ENTER ht dm dyslipidemia smoking cad obesity spo2 pao2 lactate ct_value
  /RESIDUALS DURBIN
  /SAVE COOK ZRESID.

EXAMINE VARIABLES=ZRE_1
  /PLOT NPPLOT
  /STATISTICS DESCRIPTIVES.

COMPUTE log_sst2 = LN(sst2).
EXECUTE.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA
  /NOORIGIN
  /DEPENDENT log_sst2
  /METHOD=ENTER ht dm dyslipidemia smoking cad obesity spo2 pao2 lactate ct_value.

* --- S3. Nonlinearity check for PaO2 and Ct value ---
* SPSS has no native restricted-cubic-spline procedure. The manuscript's
* spline model (three-knot natural cubic spline via Python/statsmodels,
* patsy cr()) is reconstructed outside SPSS; see analysis/rcs_and_roc.py
* in this repository for the equivalent computation.

* --- S4. Logistic regression and ROC threshold analysis ---
* High sST2 = concentration above the 75th percentile within the case
* group (2840.9 pg/mL).

COMPUTE high_sst2 = (sst2 > 2840.9).
EXECUTE.

LOGISTIC REGRESSION VARIABLES high_sst2
  /METHOD=ENTER pao2 ct_value
  /PRINT=CI(95)
  /CRITERIA=PIN(0.05) POUT(0.10) ITERATE(20) CUT(0.5).

ROC pao2 ct_value BY high_sst2 (1)
  /PLOT=CURVE(REFERENCE)
  /PRINT=SE COORDINATES
  /CRITERIA=CUTOFF(INCLUDE) TESTPOS(LARGE) DISTRIBUTION(FREE) CI(95)
  /MISSING=EXCLUDE.

* Note: ROC above is requested on pao2 and ct_value directly; because
* lower values indicate higher risk, the coordinate table's "positive if
* greater than or equal to" cutoffs should be read in that reversed
* sense, consistent with the Youden-optimal cutoffs of approximately
* 88 mmHg (PaO2) and 18 (Ct value) reported in the manuscript.

* --- S5. Correlation of sST2 with additional biomarkers ---

NONPAR CORR
  /VARIABLES=sst2 hs_crp d_dimer nt_probnp troponin
  /PRINT=SPEARMAN TWOTAIL NOSIG
  /MISSING=PAIRWISE.

* --- S6. Missing data and multiple imputation sensitivity analysis ---
* hs-CRP, D-dimer, NT-proBNP, and troponin missing 35%, 38%, 42%, and 40%
* of the case group respectively. Thirty imputed datasets, pooled with
* Rubin's rules, per the manuscript's Supplementary Statistical Analysis.

MULTIPLE IMPUTATION hs_crp d_dimer nt_probnp troponin sst2 ht dm dyslipidemia
  smoking cad obesity spo2 pao2 lactate ct_value
  /IMPUTE METHOD=AUTO NIMPUTATIONS=30 MAXITER=10 SEED=42
  /MISSINGSUMMARIES NONE.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS CI(95) R ANOVA
  /NOORIGIN
  /DEPENDENT sst2
  /METHOD=ENTER ht dm dyslipidemia smoking cad obesity spo2 pao2 lactate ct_value
    hs_crp d_dimer nt_probnp troponin.

FILTER OFF.
USE ALL.
EXECUTE.
