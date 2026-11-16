# RWE Biostatistics Portfolio | Portfolio de biostatistique RWE

**Marie-Noelle Nogeant · MSc Santé publique / Public Health · Aix-Marseille Université**  
**R · Kaplan–Meier · Cox · Logistic regression / Régression logistique · Longitudinal GLMM / Modèle mixte longitudinal**

### 📊 [Consulter le rapport scientifique / View the scientific report](https://mnngt.github.io/rwe-biostatistics-portfolio/reports/analysis_report.html)

**🔎 [Qualité des données / Data quality](https://mnngt.github.io/rwe-biostatistics-portfolio/reports/analysis_report.html#data-quality)** · [Fichier HTML dans le dépôt / HTML file in the repository](reports/analysis_report.html) · [Code source R Markdown / R Markdown source](reports/analysis_report.Rmd)

> **FR :** Les liens vers le rapport interactif fonctionnent après activation de **GitHub Pages** sur la branche `main` à la racine `/ (root)`. Le fichier `file:///...` de l'ordinateur local n'est pas accessible aux visiteurs.  
> **EN:** The browser-viewable report links work after **GitHub Pages** is enabled for the `main` branch at `/ (root)`. A local `file:///...` path is not accessible to visitors.

[Français](#français) · [English](#english)

---

## Français

### Présentation

Portfolio méthodologique consacré à une **cohorte observationnelle fictive de 900 patients**, comprenant des données de survie et des mesures répétées de symptômes. Le projet illustre la construction d'un pipeline reproductible d'analyse de données de santé, inspiré des méthodes programmées sous R pendant le Master 2 en Santé publique (MQERS).

**Toutes les données sont synthétiques.** Les résultats ne constituent ni une étude clinique réelle, ni une preuve d'efficacité d'un traitement, ni une estimation causale.

### Méthodes présentées

| Domaine | Contenu |
| --- | --- |
| Qualité des données | Unicité des identifiants, valeurs manquantes, règles de cohorte et suivi |
| Analyse de survie | Kaplan-Meier, test du log-rank, modèle de Cox ajusté |
| Diagnostic de Cox | Hypothèse des risques proportionnels : résidus de Schoenfeld (`cox.zph`) |
| Régression | Régression logistique multivariée, OR et IC à 95 % |
| Données longitudinales | GLMM logistique à intercept aléatoire par patient |
| Reproductibilité | Scripts R, tableaux CSV, figures PNG, rapport R Markdown, informations de session |

### Documents

- [Rapport scientifique bilingue](reports/analysis_report.Rmd) · [Plan d'analyse statistique (SAP)](docs/statistical_analysis_plan.md)
- [Dictionnaire des données](docs/data_dictionary.md) · [Correspondance avec les enseignements](docs/coursework_mapping.md)

### Exécution

Dans RStudio, ouvrir ce dossier et définir sa racine comme répertoire de travail. Installer les dépendances une seule fois, si nécessaire :

```r
install.packages(c("survival", "lme4", "rmarkdown", "knitr"))
source("run_all.R")
rmarkdown::render("reports/analysis_report.Rmd")
```

Les tableaux sont enregistrés dans `outputs/tables/`, les graphiques dans `outputs/figures/` et le rapport HTML dans `reports/analysis_report.html`. Le générateur Python dans `tools/` est facultatif : les CSV synthétiques nécessaires sont déjà fournis.

### Précautions et limites

Les affectations de traitement sont observationnelles et fictives ; aucun effet causal ne peut être conclu. L'analyse logistique à 12 mois exclut les personnes censurées précocement sans événement connu. Les OR conditionnels du GLMM ne sont pas interchangeables avec des effets marginaux de type GEE. Le projet n'implémente pas le matching, l'IPTW, les risques concurrents ni une validation réglementaire du SAP.

---

## English

### Overview

A reproducible methodological portfolio using a **fictional observational cohort of 900 patients**, with time-to-event outcomes and repeated binary symptom measurements. It demonstrates an end-to-end healthcare-data analysis workflow, drawing on statistical methods programmed in R during MSc Public Health (MQERS) coursework.

**All data are synthetic.** This is not a real clinical study, evidence of treatment efficacy, or a causal-effect analysis.

### Methods demonstrated

| Area | Implementation |
| --- | --- |
| Data quality | Unique identifiers, missingness, cohort rules and follow-up consistency |
| Survival analysis | Kaplan–Meier, log-rank test, adjusted Cox regression |
| Cox diagnostics | Proportional-hazards assumption using Schoenfeld residuals (`cox.zph`) |
| Regression | Multivariable logistic regression, odds ratios and 95% confidence intervals |
| Longitudinal data | Patient-level random-intercept logistic GLMM |
| Reproducibility | R scripts, CSV tables, PNG figures, R Markdown report, session information |

### Documentation

- [Bilingual scientific report](reports/analysis_report.Rmd) · [Statistical Analysis Plan (SAP)](docs/statistical_analysis_plan.md)
- [Data dictionary](docs/data_dictionary.md) · [Coursework mapping](docs/coursework_mapping.md)

### How to run

Open the repository folder in RStudio and set the working directory to its root. Install dependencies once if needed:

```r
install.packages(c("survival", "lme4", "rmarkdown", "knitr"))
source("run_all.R")
rmarkdown::render("reports/analysis_report.Rmd")
```

Tables are saved to `outputs/tables/`, figures to `outputs/figures/`, and the HTML report to `reports/analysis_report.html`. The Python data generator in `tools/` is optional: the synthetic CSV inputs are included.

### Limitations and ethics

Treatment assignment is simulated and observational; causal effects cannot be inferred. The 12-month logistic analysis excludes early-censored individuals with unknown outcomes. Conditional GLMM odds ratios are not interchangeable with marginal GEE effects. Propensity-score matching, IPTW, competing-risk modelling and regulatory SAP validation are outside the scope of this demonstration.

**No confidential patient, institutional surveillance or original teaching datasets are included.**
