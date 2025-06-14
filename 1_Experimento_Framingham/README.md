# Experiments with Clinical Data from the Framingham Study

This folder contains experiments performed using clinical data from the **Framingham Heart Study**. The goal is to conduct a preliminary analysis of the impact of **confounding variables** on low-dimensional classification models using Random Forest.

---

## Objectives

- Evaluate the effect of including confounding variables on the performance of Random Forest models.
- Analyze the impact of the `always.split.variables` parameter when forcing specific covariates into tree splits.
- Compare the performance of different model configurations on training and test data.

---

## Contents

- `Entrenamiento_Framingham.Rmd`: main R Markdown notebook with the full analysis workflow.
- `Entrenamiento_Framingham.html`: exported HTML version of the notebook.
- `framingham.csv`: real clinical data from the Framingham study.

---

## Main script: `Entrenamiento_Framingham.Rmd`

1. **Data loading and preprocessing**
   - Imputation of missing values.
   - Definition of predictor matrix (**M**) and confounder matrix (**C**).
   - Assignment of the target variable (**Y**).

2. **Model training**
   - Algorithm: `Random Forest` using `caret::train()` with the `ranger` engine.
   - Validation: 5-fold cross-validation + 15 bootstraps.
   - Main metric: **Accuracy**.

3. **Evaluated configurations**
   - `M`: predictors only.
   - `MC`: predictors + all confounding variables.
   - `M + var`: model forcing a single confounder (`age`, `sex`, `education`, `BMI`) in the splits using `always.split.variables`.

4. **Generated outputs**
   - Table with mean Accuracy and 95% CI for each model.
   - Test metrics: Accuracy, Balanced Accuracy, Sensitivity, Specificity, Kappa, TP, TN, FP, FN.
   - Comparative plots.

---

## Data used

The file `framingham.csv` contains clinical variables grouped as follows:

- **M (predictors)**: subset of clinical variables with potential predictive value.
- **C (confounders)**: `age`, `sex`, `education`, `BMI`, considered potential confounders.
- **Y (target)**: binary variable to predict.

---

## Configuration parameters

- **Base model**: Random Forest (`ranger`)
- **Cross-validation**: 5 folds
- **Bootstrapping**: 15 repetitions
- **Forced split**: `always.split.variables = c("var")`

---

## Required input

- `framingham.csv`: must contain columns for:
  - Predictors (**M**)
  - Confounders (**C**)
  - Target variable (**Y**)

---

## Output produced

- Comparative boxplot of Accuracy across models.
- Test confusion matrix per model.

---

## Result interpretation

- The **MC** model (predictors + confounders) achieved the highest Accuracy.
- Forcing `age` using `always.split.variables` also improved performance.
- Forcing variables like `education` or `sex` reduced model accuracy.
- This suggests that **not all confounders are equally useful**, and forcing them should be applied selectively.

---

## Reproducibility

To run the analysis:

```r
rmarkdown::render("Entrenamiento_Framingham.Rmd")

