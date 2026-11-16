# Plan d'analyse statistique (SAP) / Statistical Analysis Plan (SAP)

**Projet / Project:** Cohorte observationnelle oncologique entièrement synthétique / Fully synthetic observational oncology cohort  
**Version:** 1.1 — 16 novembre / November 16, 2026  
**Statut / Status:** Démonstration pédagogique, non validée pour une étude clinique / Educational demonstration; not an approved clinical-study SAP

## 1. Objectifs et conception / Objectives and study design

**FR —** Illustrer les analyses de survie, les régressions multivariées et la modélisation de mesures répétées dans une cohorte fictive à deux groupes de traitement. Aucune hypothèse clinique confirmatoire ni estimation causale n'est prévue.  
**EN —** Demonstrate survival analysis, multivariable regression and repeated-outcome modelling in a fictional two-group cohort. No confirmatory clinical hypothesis or causal inference is intended.

## 2. Populations d'analyse / Analysis populations

- **Survie / Time-to-event:** 900 patients synthétiques avec dates, statut d'événement et covariables valides / 900 synthetic patients with valid follow-up, event indicator and covariates.
- **Régression à 12 mois / 12-month logistic analysis:** patients avec suivi ≥ 12 mois ou événement avant 12 mois / participants followed ≥ 12 months or with an event before month 12; exclusion des censures précoces sans événement / early event-free censoring excluded.
- **Longitudinal / Longitudinal:** visites observées avant la fin du suivi, en excluant les symptômes manquants pour l'ajustement / observed visits before follow-up ends, excluding missing symptom outcomes for model fitting.
- **Source:** `data/synthetic_cohort.csv` et / and `data/synthetic_visits.csv`; voir / see `data_dictionary.md`.

## 3. Critères de jugement et covariables / Outcomes and covariates

- **Principal / Primary:** temps jusqu'au premier événement simulé, censure à droite (administrative à 18 mois) / time to first simulated event, right censored (administrative at month 18).
- **Secondaire / Secondary:** événement survenu avant ou à 12 mois parmi les dossiers évaluables / event by month 12 among evaluable records.
- **Répété / Repeated:** symptôme binaire aux mois 0, 3, 6, 9 et 12 / binary symptom at months 0, 3, 6, 9 and 12.
- **Covariables:** traitement / treatment (`Standard`, `Enhanced`), âge / age, stade / stage (`I`, `II`, `III`), centre / centre (`C1`–`C4`).

## 4. Qualité des données et valeurs manquantes / Data quality and missingness

**FR —** Vérifier unicité des identifiants patients, absence de doublons patient-visite, bornes des variables, présence d'une visite initiale et absence de visite après la fin du suivi. Décrire les symptômes manquants ; pas d'imputation dans cette version. Ces contrôles ne constituent pas une validation réglementaire.  
**EN —** Check patient ID uniqueness, unique patient-visit keys, variable ranges, baseline visit presence and no visits beyond follow-up. Describe missing symptom observations; no imputation is applied. These are not regulatory-grade validation checks.

## 5. Analyses statistiques / Statistical analyses

1. **Kaplan-Meier** — Estimation par traitement avec bandes d'incertitude / estimate survival by treatment with confidence bands.
2. **Log-rank** — Comparaison non ajustée, loi de référence du Chi-deux à 1 ddl / unadjusted comparison, chi-square reference with 1 df.
3. **Cox** — `Surv(time_months, event) ~ treatment + age + stage + strata(center)` ; liens Efron / Efron ties; HR ajustés, IC à 95 %, valeurs p / adjusted HRs, 95% CIs and p-values.
4. **Diagnostics** — `cox.zph` et résidus de Schoenfeld / `cox.zph` and Schoenfeld residuals; un test non significatif ne prouve pas l'hypothèse / non-significance does not prove proportional hazards.
5. **Logistique / Logistic GLM** — `event_12m ~ treatment + age + stage` ; OR ajustés et IC de Wald à 95 %, décompte des exclusions pour censure précoce / adjusted ORs, Wald 95% CIs and count of early-censored exclusions.
6. **GLMM longitudinal** — `symptom ~ treatment * visit_quarters + age_10 + stage + (1 | patient_id)`, famille binomiale logit / binomial logit family. `age_10 = (age - mean(age)) / 10`, calculé parmi les observations utilisées / calculated in the fitted analysis sample. Rapporter les OR conditionnels et IC de Wald à 95 % / report conditional ORs and Wald 95% CIs.

## 6. Rapports / Reporting

**FR —** Rapporter contrôles qualité, tableaux de HR et OR, test du log-rank, courbes Kaplan-Meier, diagnostics de Schoenfeld, taux de symptômes observés et informations de session R. Le rapport bilingue est produit depuis `reports/analysis_report.Rmd`.  
**EN —** Report quality checks, HR and OR tables, log-rank results, Kaplan–Meier curves, Schoenfeld diagnostics, observed symptom rates and R session information. The bilingual report is rendered from `reports/analysis_report.Rmd`.

## 7. Limites / Limitations

**FR —** Affectation observationnelle et confusion résiduelle : aucune inférence causale. Biais possible par exclusion des censures précoces à 12 mois et par analyse des symptômes observés uniquement. Pas d'imputation multiple, d'analyse des risques concurrents, de matching ou IPTW, ni d'inférence robuste par clusters. Aucune généralisation aux patients réels ; SAP non évalué indépendamment.  
**EN —** Observational treatment assignment and residual confounding prohibit causal inference. Early-censoring exclusions and observed-only symptom analysis may introduce bias. No multiple imputation, competing-risk modelling, propensity matching or IPTW, or cluster-robust inference is implemented. Results cannot be generalised to real patients; this SAP has not been independently reviewed.
