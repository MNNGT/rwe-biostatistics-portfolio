# RWE Biostatistics Portfolio

**Survival analysis · Cox regression · Logistic regression · Longitudinal GLMM · Data quality**

**Author:** Marie-Noelle Nogeant | MSc Public Health, Aix-Marseille University  
**Context:** Demonstration portfolio for RWE / biostatistics roles.  
**Data:** 100% synthetic. No real patients, public-health surveillance extracts or institutional datasets are shared.

## Overview

This repository demonstrates an end-to-end, reproducible analysis of a **synthetic observational oncology cohort** (900 simulated patients), with time-to-event outcomes and repeated binary symptom assessments. The study is fictional; its findings must not be used for clinical decisions.

It adapts statistical methods practised in my MSc coursework (STA-MLTC, STA-COXC, STA-MLTL and STA-LOGE) into a single illustrative pipeline.

## Methods demonstrated

| RWE / biostatistics task | Implementation |
| --- | --- |
| Data quality | Primary keys, ranges, missingness, follow-up consistency, baseline records |
| Time-to-event analyses | Kaplan-Meier, log-rank test, adjusted Cox model |
| Model diagnostics | Proportional-hazards assessment using Schoenfeld residuals (`cox.zph`) |
| Regression | Multivariable logistic GLM, ORs and Wald 95% confidence intervals |
| Longitudinal data | Logistic mixed-effects model (GLMM) with patient-level random intercept |
| Reproducible reporting | CSV tables, PNG figures, R Markdown report, session information |

**Scope:** Methods are showcased on simulated data. This is **not** a validated clinical study or a claim of causal treatment effects. Propensity-score matching/weighting, GEE, competing-risk models and formal clinical-study SAP validation are not implemented here.

## Repository structure

```text
rwe-biostatistics-portfolio/
├── README.md
├── run_all.R
├── R/
│   ├── 00_data_quality.R
│   ├── 01_survival_analysis.R
│   ├── 02_logistic_regression.R
│   └── 03_longitudinal_glmm.R
├── data/
│   ├── synthetic_cohort.csv
│   └── synthetic_visits.csv
├── tools/
│   └── generate_synthetic_data.py
├── docs/
│   ├── statistical_analysis_plan.md
│   ├── data_dictionary.md
│   └── coursework_mapping.md
├── reports/
│   └── analysis_report.Rmd
└── outputs/
    ├── figures/
    └── tables/
```

## Run the R analyses

Prerequisites: R 4.2+ and the packages `survival` and `lme4`. RStudio is optional.

Open the project folder in RStudio and set the **working directory to the repository root**. Install the R packages **once**, if necessary:

```r
install.packages(c("survival", "lme4", "rmarkdown", "knitr"))
```

Then:

```r
source("run_all.R")
rmarkdown::render("reports/analysis_report.Rmd")
```

Or, from a terminal in the repository root:

```bash
Rscript run_all.R
```

After execution, tables are written to `outputs/tables/`, figures to `outputs/figures/`, and environment information to `outputs/session_info.txt`. The optional HTML report is rendered into `reports/`.

### Re-generate the synthetic data (optional)

The included sample CSVs were generated with the fixed Python random seed `20261116` using the reproducible generator in `tools/`. **This generator is a convenience for simulated input data; the statistical analyses are implemented in R.** To replace the sample CSVs:

```bash
python -m pip install numpy pandas
python tools/generate_synthetic_data.py
```

Re-running the generator overwrites the simulated CSVs. The two tracked CSV files already suffice for running the R pipeline; Python is **not required** to run the statistical analyses.

## How to interpret the outputs

- **Hazard ratios** from the Cox model are adjusted associations between covariates and instantaneous event rates, under the proportional-hazards assumption.
- **Odds ratios** from the logistic model describe the odds of an observed 12-month event among patients whose 12-month outcome can be determined. Patients censored before month 12 without an event are excluded, which can introduce selection bias.
- **Conditional odds ratios** from the GLMM describe within-model patient-specific associations in repeated symptom observations. They are not directly interchangeable with marginal GEE effects.
- No effect estimate from these synthetic data should be interpreted as medical evidence.

Consult [the statistical analysis plan](docs/statistical_analysis_plan.md) and [data dictionary](docs/data_dictionary.md) for the design, analysis population, assumptions and limitations.

## Data provenance and ethics

All example data are simulated specifically for this demonstration. Dataset values, associations and sample size are fictional. The repository does not contain patient-level research extracts, institutional datasets, or original university teaching datasets. The MSc exercise files themselves are not redistributed here.

## Reproducibility note

The scripts were assembled and adapted for this portfolio and should be **executed and reviewed locally before representing the outputs as validated**. The repository is intended to showcase analytical workflows, rather than production-ready clinical software.
