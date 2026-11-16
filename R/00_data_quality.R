# Data quality checks for a synthetic, observational oncology cohort.
# Adapted from data-management exercises; all published data are simulated.

validate_data <- function(cohort, visits, output_directory = "outputs/tables") {
  required_cohort <- c("patient_id", "age", "sex", "stage", "center", "treatment", "time_months", "event")
  required_visits <- c("patient_id", "visit_month", "symptom")
  stopifnot(all(required_cohort %in% names(cohort)))
  stopifnot(all(required_visits %in% names(visits)))

  # Patient and observation keys, required fields, valid ranges.
  stopifnot(nrow(cohort) > 0L, !anyDuplicated(cohort$patient_id))
  stopifnot(!anyNA(cohort[, required_cohort]))
  stopifnot(all(cohort$age >= 18 & cohort$age <= 100))
  stopifnot(all(cohort$time_months > 0 & cohort$time_months <= 18))
  stopifnot(all(cohort$event %in% c(0, 1)))
  stopifnot(all(cohort$treatment %in% c("Standard", "Enhanced")))
  stopifnot(all(cohort$stage %in% c("I", "II", "III")))
  stopifnot(all(cohort$center %in% paste0("C", 1:4)))
  stopifnot(all(cohort$sex %in% c("Female", "Male")))
  stopifnot(!anyNA(visits[, c("patient_id", "visit_month")]))
  stopifnot(!anyDuplicated(visits[, c("patient_id", "visit_month")]))
  stopifnot(all(visits$patient_id %in% cohort$patient_id))
  stopifnot(all(visits$visit_month %in% c(0, 3, 6, 9, 12)))
  stopifnot(all(is.na(visits$symptom) | visits$symptom %in% c(0, 1)))

  # Each visit must occur on/before the patient's observed follow-up end.
  visit_follow_up <- cohort$time_months[match(visits$patient_id, cohort$patient_id)]
  stopifnot(all(visits$visit_month <= visit_follow_up + 1e-5))
  baseline_visits <- table(visits$patient_id[visits$visit_month == 0])
  stopifnot(length(baseline_visits) == nrow(cohort), all(baseline_visits == 1L))

  summary_data <- data.frame(
    metric = c("patients", "patient_events", "event_rate", "observed_visits",
               "missing_symptoms", "missing_symptom_fraction", "duplicates"),
    value = c(nrow(cohort), sum(cohort$event), mean(cohort$event), nrow(visits),
              sum(is.na(visits$symptom)), mean(is.na(visits$symptom)), 0)
  )
  dir.create(output_directory, recursive = TRUE, showWarnings = FALSE)
  write.csv(summary_data, file.path(output_directory, "data_quality_summary.csv"), row.names = FALSE)
  message("Data quality checks passed for ", nrow(cohort), " synthetic patients.")
  invisible(summary_data)
}
