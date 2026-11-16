# Binomial GLM for documented 12-month event status.
# Inspired by MSc coursework STA-MLTL; not a causal treatment-effect estimate.

run_logistic_regression <- function(cohort) {
  # Patients censored before month 12 have unknown 12-month event status.
  status_known <- (cohort$time_months >= 12) |
                  (cohort$event == 1 & cohort$time_months < 12)
  analysis <- cohort[status_known, , drop = FALSE]
  analysis$event_12m <- as.integer(analysis$event == 1 & analysis$time_months <= 12)
  analysis$treatment <- factor(analysis$treatment, levels = c("Standard", "Enhanced"))
  analysis$stage <- factor(analysis$stage, levels = c("I", "II", "III"))
  if (nrow(analysis) < 100L || length(unique(analysis$event_12m)) < 2L) {
    stop("Insufficient evaluable data for the logistic model.")
  }

  fit <- stats::glm(event_12m ~ treatment + age + stage, data = analysis,
                    family = stats::binomial(link = "logit"))
  estimates <- stats::coef(fit)
  standard_errors <- sqrt(diag(stats::vcov(fit)))
  or_table <- data.frame(
    variable = names(estimates),
    odds_ratio = exp(unname(estimates)),
    ci95_low = exp(unname(estimates) - 1.96 * standard_errors),
    ci95_high = exp(unname(estimates) + 1.96 * standard_errors),
    p_value = summary(fit)$coefficients[, 4],
    row.names = NULL
  )
  write.csv(or_table, "outputs/tables/logistic_odds_ratios.csv", row.names = FALSE)

  predicted <- stats::predict(fit, type = "response")
  brier <- mean((predicted - analysis$event_12m)^2)
  write.csv(data.frame(n_eligible = nrow(analysis), n_excluded_early_censored = sum(!status_known),
                       observed_event_fraction = mean(analysis$event_12m), brier_score = brier),
            "outputs/tables/logistic_model_summary.csv", row.names = FALSE)
  cat("\nLOGISTIC: eligible=", nrow(analysis), " / ", nrow(cohort),
      "; Brier score=", signif(brier, 3), "\n", sep = "")
  print(or_table, row.names = FALSE)
  invisible(list(model = fit, or = or_table, eligible = analysis))
}
