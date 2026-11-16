# Execute from the repository root: Rscript run_all.R
# In RStudio: Session > Set Working Directory > To Project Directory

required <- c("survival", "lme4")
missing <- required[!vapply(required, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing)) {
  stop("Missing packages: ", paste(missing, collapse = ", "),
       ". Install once with install.packages(c('survival', 'lme4')).")
}

if (!file.exists("data/synthetic_cohort.csv") ||
    !file.exists("data/synthetic_visits.csv")) {
  stop("Synthetic input CSV files are missing: check data/ directory.")
}

dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

cohort <- read.csv("data/synthetic_cohort.csv", stringsAsFactors = FALSE)
visits <- read.csv("data/synthetic_visits.csv", stringsAsFactors = FALSE,
                   na.strings = c("NA", ""))

source("R/00_data_quality.R")
source("R/01_survival_analysis.R")
source("R/02_logistic_regression.R")
source("R/03_longitudinal_glmm.R")

validate_data(cohort, visits)
survival_result <- run_survival_analysis(cohort)
logistic_result <- run_logistic_regression(cohort)
glmm_result <- run_longitudinal_glmm(cohort, visits)

writeLines(capture.output(sessionInfo()), "outputs/session_info.txt")
message("\nAll analyses completed. See outputs/figures and outputs/tables.")
message("Optional report: rmarkdown::render('reports/analysis_report.Rmd')")
