# Predictive Analysis on Real ROSMAP Data

This folder contains the code and results of the analysis conducted using real data from the ROSMAP study (Religious Orders Study and Memory and Aging Project). The focus is on integrating post-mortem transcriptomic data with clinical, technical, and neuropathological variables to build classification models using Random Forest.

---

##  Objectives

- Evaluate how the inclusion of confounding variables (clinical, technical, and neuropathological) affects the predictive performance of Random Forest models.
- Identify genes whose importance remains stable across multiple repetitions, and which may be considered robust transcriptomic biomarkers.
- Analyze how the `always.split.variables` parameter can improve model interpretability by prioritizing highly informative confounders.
- Validate the impact of removing redundant genes (high correlation or low variance) on model performance and stability.

---

## Folder contents

- `entrenamiento_rosmap.Rmd`: Main R Markdown script containing the full analysis pipeline: preprocessing, gene filtering, model training, and variable importance analysis.
- `entrenamiento_rosmap.html`: Rendered version of the R Markdown file.
- `Scripts/`: Folder with helper functions for training various models on a computing cluster.
- `Datos/`: Folder containing two `.rds` files:
  - `ROSMAP_RINPMIAGESEX_covs.rds`: confounding variables
  - `ROSMAP_RINPMIAGESEX_resids.rds`: omics data

---

## Analysis description

1. **Data loading and preprocessing**
   - Merge gene expression matrix (**M**) and confounders (**C**)
   - Remove highly correlated and low-variance genes to construct filtered matrix (**M'**)
   - Create datasets for training comparable models

2. **Model training**
   - `M` and `M'`: gene expression only (unfiltered and filtered)
   - `MC` and `M'C`: expression + clinical/technical covariates
   - Forced confounders + `always.split.variables`: confounding variables are forced in splits
   - `C`: confounders only

3. **Validation**
   - 5-fold cross-validation + 30 bootstraps per model
   - Main metric: **Accuracy**

4. **Variable importance analysis**
   - Extract `varImp()` for each repetition
   - Assess ranking stability using Spearman correlation and variance analysis
   - Identify stable genes as potential biomarkers

5. **Stabilizing effect of covariates**
   - Compare variable importance rankings with and without forced confounders
   - Detect genes whose importance ranking improves when confounders are included

---

## Variables used

- **Matrix M**: High-dimensional post-mortem transcriptomic data
- **Matrix C**: Confounders
  - **Neuropathological**: `braaksc` (Braak staging), `ceradsc` (CERAD score)
  - **Demographic**: `msex` (sex, coded as factor)
  - **Technical**: `rin` (RNA integrity number), `pmi` (post-mortem interval), `batch` (experimental batch)
- **Target variable**: `cogdx`, representing cognitive diagnosis at time of death, with 5 classes:
  - `NCI`: No cognitive impairment
  - `MCI`: Mild cognitive impairment, not explained by other causes
  - `MCI with comorbidity`: MCI with another cause
  - `AD`: Alzheimer's disease without other causes
  - `AD with comorbidity`: AD with additional causes of impairment

---

## Key results

- The best model was `M' + ceradsc`, combining a filtered gene subset with a forced neuropathological variable.
- Models that explicitly forced `braaksc` and `ceradsc` outperformed full models (`MC`, `M'C`).
- Stability analysis identified genes such as `MTCP1`, `HPCAL1`, `CAMK4`, and `MMP24` as potential biomarkers, supported by literature.
- Selective stabilizing effects were observed: certain genes became more stable only when specific confounders (especially `braaksc`, `ceradsc`) were included, suggesting genuine biological relevance.

---

## Reproducibility

To reproduce the analysis in R:

```r
rmarkdown::render("entrenamiento_rosmap.Rmd")



   
  
