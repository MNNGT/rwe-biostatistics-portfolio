# Coursework-to-portfolio mapping

The analysis methods were selected after reviewing the author's MSc R Markdown coursework. The original assignments and underlying teaching datasets are **not** distributed in this portfolio.

| University exercise | Demonstrated practical method | Adaptation in this portfolio |
| --- | --- | --- |
| STA-MLTC (survival analysis) | `survfit`, `survdiff`, `coxph`, `cox.zph`, model interpretation | `R/01_survival_analysis.R` |
| STA-COXC (advanced survival) | Survival analysis with clinical endpoints, competing-risk concepts and diagnostics | Basic Cox/KM retained; competing-risk extensions excluded from first public version |
| STA-MLTL (linear/logistic models) | `glm(family=binomial)`, odds ratios and confidence intervals | `R/02_logistic_regression.R` |
| STA-LOGE (longitudinal data) | `geeglm`, `glmer`, random intercept, repeated observations | `R/03_longitudinal_glmm.R` (GLMM only; no GEE claim) |
| INF-STAR preparatory exercise | Filtering, consistency assertions and synthetic-data programming | `R/00_data_quality.R` |

This integrated portfolio is **a new demonstration project**; it is not a verbatim upload of coursework or a published peer-reviewed study. Functions, inputs and modelling choices were harmonised to a common synthetic cohort.
