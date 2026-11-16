# Synthetic data dictionary

Two CSV tables are provided. IDs are invented; there are no real patients.

## `data/synthetic_cohort.csv` (one row per synthetic participant)

| Variable | Description |
| --- | --- |
| `patient_id` | Fictional unique identifier, P0001–P0900 |
| `age` | Simulated baseline age in years |
| `sex` | Simulated category, `Female` / `Male` |
| `stage` | Simulated clinical severity stage, `I` / `II` / `III` |
| `center` | Simulated care centre, C1–C4 |
| `treatment` | Simulated observational treatment group, `Standard` / `Enhanced` |
| `time_months` | Follow-up time to event or right censoring, in months |
| `event` | 1 = simulated event observed; 0 = right censored |

## `data/synthetic_visits.csv` (one row per visit)

| Variable | Description |
| --- | --- |
| `patient_id` | Key linking visit to cohort table |
| `visit_month` | Scheduled month after inclusion: 0, 3, 6, 9 or 12 |
| `symptom` | Simulated binary symptom indicator (0/1) or missing |

Visits are generated only until the participant's observed follow-up time. Approximately 2.5% of the symptom measurements are set to missing at random by the simulation generator; this is a mechanism specified for the simulation and must not be assumed for real-world datasets.

## Modelling choices

The generator simulates age, stage, treatment assignment, event times, loss to follow-up and repeated symptoms. Baseline factors influence the simulated hazards and symptom probabilities. Treatment groups are not randomized. The model is deliberately simplified and does not mimic an actual disease, therapy, trial or approved clinical pathway.
