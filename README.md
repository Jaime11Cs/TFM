# Análisis predictivo en datos transcriptómicos y clínicos del estudio ROSMAP

Este repositorio contiene el código y los resultados asociados al Trabajo de Fin de Máster (TFM) en Bioinformática, centrado en el análisis predictivo y la selección de variables relevantes en datos de expresión génica y variables clínicas asociados al deterioro cognitivo.

---

## Descripción del proyecto

El objetivo principal es evaluar el impacto de diferentes subconjuntos de datos (transcriptómicos, clínicos y técnicos) en la predicción del estado neuropatológico utilizando modelos de Random Forest. Se utilizan datos del estudio [ROSMAP](https://www.radc.rush.edu/), simulaciones controladas y análisis de importancia de variables para identificar biomarcadores potenciales.

---

## Estructura del repositorio
<pre> ## Estructura del repositorio ``` TFM/ ├── Primera Parte: Exploración Preliminar/ │ └── [...archivos de exploración y análisis preliminar] │ ├── Segunda Parte: Simulacion Controlada/ │ └── [...scripts y datos simulados con estructura causal] │ ├── Tercera Parte: Aplicacion a datos reales/ │ ├── Datos_ROSMAP/ │ ├── Scripts para entrenamiento/ │ ├── TFM_DatosReales.Rmd │ └── TFM_DatosReales.html │ └── README.md ``` </pre>
---

## Tecnologías y herramientas utilizadas

- Lenguaje: **R**
- Librerías: `ranger`, `caret`, `clusterProfiler`, `tidyverse`, `ggplot2`, `upSample`, `SMOTE`, etc.
- Análisis: modelos de clasificación, selección de variables, simulaciones, Random Forest.
- Datos: reales (ROSMAP) y simulados con estructura causal conocida.

---

## Cómo reproducir los análisis

1. Clona este repositorio:

```bash
git clone git@github.com:Jaime11Cs/TFM.git
cd TFM
