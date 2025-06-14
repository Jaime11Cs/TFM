# TFM: Predictive Analysis with Random Forest on Transcriptomic and Clinical Data

This repository contains all the code, simulations, and analyses developed for the Master’s Thesis (TFM) in Bioinformatics.

---

## Objectives

The main goal of this work is to understand the role of confounding variables in non-linear machine learning models, specifically in Random Forest algorithms. To achieve this, machine learning techniques are applied to both real and simulated transcriptomic datasets in order to study their behavior. More specifically, the following objectives are proposed:

- Generate synthetic data with full control over confounding variables, allowing their effect to be analyzed in a controlled environment.
- Study the impact of confounding variables on the identification of relevant genes.
- Evaluate the effect of forcing splits on confounding variables using the `always.split.variables` parameter when training Random Forest models.
- Identify genes whose importance as predictors of neuropathological status is consistent and stable across multiple repetitions, and which could therefore be considered potentially relevant transcriptomic biomarkers.

---

## Motivation

In classical linear models, such as multiple regression, the treatment of confounding variables is well established. However, when using non-linear models such as Random Forest—especially in high-dimensional settings—the handling of confounders is more complex.

If a confounding variable is highly correlated with omics predictors, it may be ignored during the split process, being replaced by variables that mask its true effect. Moreover, in settings where the number of predictors far exceeds the number of samples, linear models tend to eliminate confounding bias through regularization, but Random Forest does not.

Hence, the central research question becomes:  
**Is it possible to train Random Forest models that properly integrate confounding variables to maximize predictive accuracy while preserving the interpretability of key genes?**

---

##  Repository structure

- [`1_Experimentos_Cardio/`](./1_Experimentos_Cardio): Experiments using clinical data from the Framingham study.
- [`2_Simulacion/`](./2_Simulacion): Generation of simulated datasets with explicit causal structure.
- [`3_Experimentos_ROSMAP/`](./3_Experimentos_ROSMAP): Experiments using real transcriptomic data from the ROSMAP study.

---

##  Technologies and tools used

- Languages: **R** and **Python**
- R packages: `ranger`, `caret`, `clusterProfiler`, `tidyverse`, `ggplot2`, `upSample`, `SMOTE`, etc.
- Techniques: classification models, variable selection, feature importance analysis, data simulation, Random Forest.
- Data: real (ROSMAP, Framingham) and simulated data with known causal structure.

---

## How to reproduce the analyses

1. Clone the repository:

```bash
git clone git@github.com:Jaime11Cs/TFM.git
cd TFM

```

## Autor

**Jaime Carreto Sánchez**  
Master’s Degree in Bioinformatics 
University of Murcia
Mail: jaime.carretos@um.es
