# Binary outcome across repeated visits: random-intercept logistic GLMM.
# Inspired by MSc coursework STA-LOGE, including glmer() and GEE comparison.

run_longitudinal_glmm <- function(cohort, visits) {
  stopifnot(requireNamespace("lme4", quietly = TRUE))
  analysis <- merge(visits, cohort[, c("patient_id", "age", "stage", "treatment")],
                    by = "patient_id", all.x = TRUE, sort = FALSE)
  analysis <- analysis[!is.na(analysis$symptom), , drop = FALSE]
  analysis$treatment <- factor(analysis$treatment, levels = c("Standard", "Enhanced"))
  analysis$stage <- factor(analysis$stage, levels = c("I", "II", "III"))
  analysis$visit_quarters <- analysis$visit_month / 3
  analysis$age_10 <- (analysis$age - mean(analysis$age)) / 10
  analysis$patient_id <- factor(analysis$patient_id)

  # Conditional (patient-specific) odds ratios; not equivalent to marginal GEE ORs.
  fit <- lme4::glmer(symptom ~ treatment * visit_quarters + age_10 + stage +
                       (1 | patient_id),
                    data = analysis, family = stats::binomial(link = "logit"),
                    control = lme4::glmerControl(optimizer = "bobyqa",
                                                optCtrl = list(maxfun = 200000)))
  beta <- lme4::fixef(fit)
  se <- sqrt(diag(as.matrix(stats::vcov(fit))))
  glmm_table <- data.frame(
    variable = names(beta), odds_ratio = exp(unname(beta)),
    ci95_low = exp(unname(beta) - 1.96 * se),
    ci95_high = exp(unname(beta) + 1.96 * se),
    row.names = NULL
  )
  write.csv(glmm_table, "outputs/tables/glmm_conditional_odds_ratios.csv", row.names = FALSE)

  summaries <- stats::aggregate(symptom ~ treatment + visit_month, data = analysis, FUN = mean)
  write.csv(summaries, "outputs/tables/observed_symptom_rates.csv", row.names = FALSE)
  grDevices::png("outputs/figures/observed_symptom_rates.png", width = 1250, height = 850, res = 145)
  plot(NA, xlim = c(0, 12), ylim = c(0, 1), xlab = "Months since baseline",
       ylab = "Observed symptom proportion", main = "Repeated symptom assessments (synthetic data)")
  for (i in seq_along(levels(analysis$treatment))) {
    group <- levels(analysis$treatment)[i]
    subs <- summaries[summaries$treatment == group, ]
    subs <- subs[order(subs$visit_month), ]
    lines(subs$visit_month, subs$symptom, type = "b", pch = i + 15,
          lwd = 2, col = c("#275A87", "#CC7542")[i])
  }
  legend("topleft", legend = levels(analysis$treatment), pch = c(16, 17),
         col = c("#275A87", "#CC7542"), lty = 1, bty = "n")
  grDevices::dev.off()

  cat("\nLONGITUDINAL GLMM: observations=", nrow(analysis),
      "; patients=", length(unique(analysis$patient_id)), "\n", sep = "")
  print(glmm_table, row.names = FALSE)
  if (lme4::isSingular(fit)) warning("Singular GLMM fit: check random-effects structure.")
  invisible(list(model = fit, conditional_or = glmm_table, observed = summaries))
}
