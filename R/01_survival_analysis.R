# Kaplan-Meier, log-rank, adjusted Cox model and proportional-hazards diagnostic.
# Inspired by MSc coursework STA-MLTC and STA-COXC; illustrative synthetic data.

run_survival_analysis <- function(cohort) {
  stopifnot(requireNamespace("survival", quietly = TRUE))
  cohort$treatment <- factor(cohort$treatment, levels = c("Standard", "Enhanced"))
  cohort$stage <- factor(cohort$stage, levels = c("I", "II", "III"))
  cohort$center <- factor(cohort$center)

  outcome <- survival::Surv(time = cohort$time_months, event = cohort$event)
  fit_km <- survival::survfit(outcome ~ treatment, data = cohort)
  log_rank <- survival::survdiff(outcome ~ treatment, data = cohort)
  log_rank_p <- stats::pchisq(log_rank$chisq, df = length(log_rank$n) - 1L, lower.tail = FALSE)

  # Stratifying by centre permits a separate baseline hazard in each centre.
  fit_cox <- survival::coxph(outcome ~ treatment + age + stage + strata(center),
                             data = cohort, ties = "efron", x = TRUE)
  ph_check <- survival::cox.zph(fit_cox)

  estimates <- stats::coef(fit_cox)
  intervals <- stats::confint(fit_cox)
  coefficient_table <- summary(fit_cox)$coefficients
  hr_table <- data.frame(
    variable = names(estimates),
    hazard_ratio = exp(unname(estimates)),
    ci95_low = exp(intervals[, 1]),
    ci95_high = exp(intervals[, 2]),
    p_value = coefficient_table[, "Pr(>|z|)"],
    row.names = NULL
  )
  write.csv(hr_table, "outputs/tables/cox_hazard_ratios.csv", row.names = FALSE)
  write.csv(data.frame(test = "Log-rank", chi_square = unname(log_rank$chisq),
                       degrees_of_freedom = length(log_rank$n) - 1L, p_value = log_rank_p),
            "outputs/tables/logrank_test.csv", row.names = FALSE)

  ph_table <- data.frame(variable = rownames(ph_check$table),
                         ph_check$table, row.names = NULL, check.names = FALSE)
  write.csv(ph_table, "outputs/tables/cox_ph_assumptions.csv", row.names = FALSE)

  grDevices::png("outputs/figures/kaplan_meier.png", width = 1250, height = 850, res = 145)
  plot(fit_km, col = c("#275A87", "#CC7542"), lty = c(1, 2), lwd = 2,
       conf.int = TRUE, xlab = "Months since baseline", ylab = "Event-free survival probability",
       main = "Kaplan-Meier estimates by treatment (synthetic data)", mark.time = TRUE)
  legend("bottomleft", legend = c("Standard", "Enhanced"),
         col = c("#275A87", "#CC7542"), lty = c(1, 2), lwd = 2, bty = "n")
  grDevices::dev.off()

  # Schoenfeld-residual diagnostic: low p-values flag possible PH violations.
  grDevices::png("outputs/figures/cox_schoenfeld.png", width = 1250, height = 900, res = 140)
  plot(ph_check)
  grDevices::dev.off()

  cat("\nSURVIVAL: log-rank p =", signif(log_rank_p, 3), "\n")
  print(hr_table, row.names = FALSE)
  invisible(list(km = fit_km, cox = fit_cox, ph = ph_check, hr = hr_table))
}
