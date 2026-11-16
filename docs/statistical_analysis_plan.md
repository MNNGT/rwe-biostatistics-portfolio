# Demonstration Statistical Analysis Plan (SAP)

**Title:** Synthetic observational oncology cohort – illustrative RWE statistical analyses  
**Version:** 1.0 | 16 November 2026  
**Status:** Educational demonstration, not an approved clinical-study SAP

## 1. Objective and study design

Demonstrate time-to-event analysis and repeated-outcome modelling within a synthetic, observational two-group cohort. The setting and every individual record are fictional. No confirmatory clinical hypothesis or causal inference is intended.

## 2. Analysis populations and data sources

- **Time-to-event population:** All 900 simulated participants with a valid follow-up time, event indicator and baseline covariates.
- **12-month logistic-analysis population:** Participants with follow-up of at least 12 months or an event recorded before month 12. Participants censored event-free before month 12 are excluded because their event status at 12 months is unknown.
- **Longitudinal population:** All scheduled visits observed on/before a participant's follow-up end, excluding missing symptom outcomes for complete-case model fitting.
- **Source:** Synthetic input CSV files in `data/`. Full variable definitions are in `data_dictionary.md`.

## 3. Outcomes and covariates

- **Primary time-to-event outcome:** Months to first simulated event, with event = 1 and right censoring at the last observed month (including administrative censoring at 18 months).
- **Binary secondary outcome:** Event by month 12 in the evaluable analysis subset.
- **Repeated binary outcome:** Symptom indicator (1 = present, 0 = absent) at visits scheduled at months 0, 3, 6, 9 and 12.
- **Covariates:** Treatment group (Standard / Enhanced), age (years), clinical stage (I / II / III) and care centre (C1–C4). Baseline stage and treatment serve as categorical predictors.

## 4. Data quality and missingness

Before analyses, verify patient IDs are unique, repeated-visit keys are unique, event coding and ranges are valid, every patient has a baseline visit, and no scheduled visit occurs after documented follow-up. Report missing symptom observations. No symptom imputation is implemented; model fitting uses observed symptom values only. These are simple QC rules, not a regulatory-grade data validation framework.

## 5. Statistical analyses

1. **Kaplan-Meier:** estimate survival probabilities by treatment group; display confidence bands.
2. **Log-rank test:** unadjusted group comparison, with a chi-square reference distribution (1 degree of freedom).
3. **Cox model:** `Surv(time_months, event) ~ treatment + age + stage + strata(center)` with Efron ties; report adjusted hazard ratios, 95% CIs and Wald p-values.
4. **Assumptions:** assess the proportional-hazards assumption using `cox.zph` (Schoenfeld residual diagnostics). A non-significant test does not prove the assumption.
5. **Logistic GLM:** fit `event_12m ~ treatment + age + stage` on the evaluable subset; report adjusted ORs and Wald 95% CIs. Report the number excluded because the 12-month outcome is unknown.
6. **Longitudinal GLMM:** fit `symptom ~ treatment * visit_quarters + age + stage + (1 | patient_id)` using a binomial logit model. Report conditional ORs (Wald 95% CIs) and observed symptom rates over time.

## 6. Reporting and interpretation

Provide summary tables (data quality, Cox HRs, log-rank, logistic ORs, GLMM ORs), KM curves, PH diagnostics and observed symptom-rate plots. All results are descriptive illustrations; clinical interpretation is prohibited.

## 7. Important limitations

- Observational treatment assignment and measured/unmeasured confounding: **no causal effects** may be inferred.
- Excluding early-censored patients from the 12-month logistic analysis may create selection bias.
- GLMM complete-case analyses may be biased if symptom missingness is informative; outcome follow-up ends at the observed event/censoring time.
- No multiple-imputation, competing-risk, propensity-score, cluster-robust inferential adjustment or sensitivity analyses are implemented in this initial portfolio version.
- Simulated data cannot support generalisation to real patients or healthcare settings.
- This educational plan has not undergone independent review, validation or prospective registration.
