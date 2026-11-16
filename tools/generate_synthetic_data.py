"""Create entirely synthetic example files for an R biostatistics portfolio.

This is a small data-generation utility, not a clinical data pipeline.
Requires: Python 3, numpy, pandas.
Run from the repository root: python tools/generate_synthetic_data.py
Do not treat simulated associations as clinical findings.
"""

from pathlib import Path
import numpy as np
import pandas as pd

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "data"
OUT.mkdir(parents=True, exist_ok=True)
rng = np.random.default_rng(20261116)
n = 900
age = np.rint(np.clip(rng.normal(61, 12, n), 25, 88)).astype(int)
stage = rng.choice(["I", "II", "III"], n, p=[0.40, 0.37, 0.23])
center = rng.choice(["C1", "C2", "C3", "C4"], n)
sex = rng.choice(["Female", "Male"], n)

# Observational treatment assignment: some measured baseline imbalance.
logit_pr = -0.05 - 0.018 * (age - 61) - 0.25 * (stage == "III") + 0.07 * (stage == "II")
pr = 1 / (1 + np.exp(-logit_pr))
treatment = np.where(rng.uniform(size=n) < pr, "Enhanced", "Standard")

# Event times and independent dropout, followed by 18-month administrative censoring.
log_haz = (np.log(0.037) + 0.024 * (age - 61) + 0.32 * (stage == "II")
           + 0.66 * (stage == "III") - 0.28 * (treatment == "Enhanced"))
true_event = -np.log(rng.uniform(size=n)) / np.exp(log_haz)
loss_time = rng.uniform(10, 22, n)
time = np.minimum.reduce([true_event, loss_time, np.full(n, 18.0)])
event = ((true_event <= loss_time) & (true_event <= 18.0)).astype(int)
cohort = pd.DataFrame({
    "patient_id": [f"P{i:04d}" for i in range(1, n + 1)],
    "age": age, "sex": sex, "stage": stage, "center": center,
    "treatment": treatment, "time_months": np.round(np.maximum(time, 0.001), 6),
    "event": event,
})
cohort.to_csv(OUT / "synthetic_cohort.csv", index=False)

# Binary symptom observations at scheduled visits, stopping at follow-up end.
# Individual heterogeneity is represented by a random intercept.
random_intercept = rng.normal(0, 0.65, n)
rows = []
for i in range(n):
    for visit in [0, 3, 6, 9, 12]:
        if visit > time[i] + 1e-9:
            continue
        z = (-0.65 + 0.018 * (age[i] - 61)
             + (0.34 if stage[i] == "II" else 0.71 if stage[i] == "III" else 0)
             + 0.05 * (visit / 3)
             + (-0.24 - 0.06 * (visit / 3) if treatment[i] == "Enhanced" else 0)
             + random_intercept[i])
        p = 1 / (1 + np.exp(-z))
        outcome = int(rng.uniform() < p)
        if rng.uniform() < 0.025:
            outcome = np.nan
        rows.append([f"P{i+1:04d}", visit, outcome])
visits = pd.DataFrame(rows, columns=["patient_id", "visit_month", "symptom"])
visits.to_csv(OUT / "synthetic_visits.csv", index=False)
print(f"Generated {len(cohort)} synthetic patients and {len(visits)} synthetic visits")
