# Dictionnaire des données synthétiques / Synthetic data dictionary

**FR —** Deux fichiers CSV sont fournis. Tous les identifiants sont fictifs ; aucune donnée ne concerne de véritables patients.  
**EN —** Two CSV files are included. All identifiers are fictional; no records refer to real patients.

## `data/synthetic_cohort.csv` — Une ligne par patient / One row per patient

| Variable | Description en français | English description |
| --- | --- | --- |
| `patient_id` | Identifiant fictif unique, P0001–P0900 | Fictional unique identifier, P0001–P0900 |
| `age` | Âge simulé à l'inclusion, années | Simulated baseline age, years |
| `sex` | Sexe simulé : `Female` / `Male` | Simulated sex category: `Female` / `Male` |
| `stage` | Stade clinique fictif : I / II / III | Fictional clinical stage: I / II / III |
| `center` | Centre de soins simulé : C1–C4 | Simulated care centre: C1–C4 |
| `treatment` | Groupe de traitement fictif : `Standard` / `Enhanced` | Fictional treatment group: `Standard` / `Enhanced` |
| `time_months` | Durée observée jusqu'à l'événement ou à la censure, en mois | Observed time to event or right censoring, in months |
| `event` | 1 = événement observé ; 0 = censuré à droite | 1 = event observed; 0 = right censored |

## `data/synthetic_visits.csv` — Une ligne par visite / One row per visit

| Variable | Description en français | English description |
| --- | --- | --- |
| `patient_id` | Clé de liaison avec la cohorte | Key linking the visit to the cohort |
| `visit_month` | Mois programmé depuis l'inclusion : 0, 3, 6, 9, 12 | Scheduled month since baseline: 0, 3, 6, 9, 12 |
| `symptom` | Indicateur binaire fictif (0/1) ou manquant | Fictional binary symptom indicator (0/1) or missing |

## Variables dérivées / Derived variables

| Variable | Description en français | English description |
| --- | --- | --- |
| `visit_quarters` | Temps en trimestres (`visit_month / 3`) | Follow-up time in quarters (`visit_month / 3`) |
| `age_10` | Âge centré sur la moyenne des observations et divisé par 10 | Age centred on the analysis-sample mean and divided by 10 |
| `event_12m` | Événement avant ou à 12 mois, dans le sous-échantillon évaluable | Event at or before month 12 in the evaluable subset |

## Simulation et limites / Simulation and limitations

**FR —** Les visites sont générées uniquement jusqu'à la fin du suivi observé. Le générateur attribue environ 2,5 % de valeurs manquantes au symptôme selon un mécanisme simulé aléatoire. Le traitement n'est pas randomisé et les relations entre covariables, événements et symptômes sont artificielles. Cela ne représente ni une maladie réelle, ni un traitement, ni un essai clinique.  
**EN —** Visits are generated only through observed follow-up. The generator assigns approximately 2.5% missing symptom values under a simulated random mechanism. Treatment is not randomised, and covariate–outcome associations are artificial. The data do not represent a real disease, treatment or clinical trial.
