"""Reconstructed analysis for the manuscript's Supplementary Statistical
Analysis, sections S3 (restricted cubic splines) and S4 (logistic
regression / ROC threshold analysis).

SPSS has no native restricted-cubic-spline procedure, so this part of
the analysis plan is reconstructed here in Python. It mirrors the
statistical approach described in the manuscript step by step; it is
not the original analyst's saved run history, and it does not ship with
patient-level data. Point it at a local extract with the columns named
below (matching the variable names in syntax/reconstructed_analysis.sps)
to reproduce the group-level results published in the paper.

Requires: pandas, numpy, statsmodels, scikit-learn.
"""

import numpy as np
import pandas as pd
import statsmodels.formula.api as smf
from sklearn.metrics import roc_auc_score, roc_curve

DATA_PATH = "sst2_covid19_dataset.csv"  # not included in this repository


def load_case_group(path: str) -> pd.DataFrame:
    df = pd.read_csv(path)
    return df[df["group"] == 1].copy()  # 1 = Case: CVD comorbidity + COVID-19


def restricted_cubic_spline(case: pd.DataFrame):
    """S3: nonlinearity check for PaO2 and Ct value, three-knot natural
    cubic splines (patsy cr()), compared against the linear model."""
    linear = smf.ols("sst2 ~ pao2 + ct_value", data=case).fit()
    spline = smf.ols("sst2 ~ cr(pao2, df=3) + cr(ct_value, df=3)", data=case).fit()
    print(f"Linear AIC={linear.aic:.1f} R2={linear.rsquared:.3f}")
    print(f"Spline AIC={spline.aic:.1f} R2={spline.rsquared:.3f}")
    return spline


def roc_threshold_analysis(case: pd.DataFrame):
    """S4: dichotomise sST2 at its 75th percentile within the case group,
    then find the Youden-optimal cutoff for PaO2 and Ct value."""
    cutoff = case["sst2"].quantile(0.75)
    high_sst2 = (case["sst2"] > cutoff).astype(int)

    results = {}
    for var in ["pao2", "ct_value"]:
        x = case[var]
        auc = roc_auc_score(high_sst2, -x)  # lower value -> higher risk
        fpr, tpr, thr = roc_curve(high_sst2, -x)
        youden = tpr - fpr
        best = int(np.argmax(youden))
        results[var] = {
            "auc": round(float(auc), 3),
            "cutoff": round(float(-thr[best]), 1),
            "sensitivity": round(float(tpr[best]), 3),
            "specificity": round(float(1 - fpr[best]), 3),
        }
    return cutoff, results


if __name__ == "__main__":
    case = load_case_group(DATA_PATH)
    print("=== S3: restricted cubic spline ===")
    restricted_cubic_spline(case)
    print("\n=== S4: ROC threshold analysis ===")
    cutoff, results = roc_threshold_analysis(case)
    print(f"High-sST2 cutoff (75th percentile): {cutoff:.1f} pg/mL")
    for var, r in results.items():
        print(var, r)
