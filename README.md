# TFM: Análisis predictivo con Random Forest sobre datos transcriptómicos y clínicos

Este repositorio contiene todo el código, simulaciones y análisis desarrollados en el contexto del Trabajo de Fin de Máster (TFM) en Bioinformática.

---
## Objetivos
El objetivo principal de este trabajo es comprender el papel de las variables de confusión en modelos
de Machine Learning no lineales, concretamente en algoritmos del tipo Random Forest. Para ello, se
aplicarán técnicas de aprendizaje automático sobre datos transcriptómicos reales y simulados para
observar su comportamiento. De forma más específica, se plantean los siguientes objetivos:

- Generar datos sintéticos con control total sobre las variables de confusión, con el propósito de
analizar su efecto en modelos de Machine Learning bajo un entorno controlado.
- Estudiar el impacto de las variables de confusión sobre la identificación de genes relevantes
- Estudiar el efecto de forzar la división basada en variables confusoras utilizando el parámetro ***always.split.variables*** en el entrenamiento de modelos ***Random Forest***
- Identifcar genes cuya importancia como predictores del estado neuropatológico sea consistente y estable a lo largo de múltiples repeticiones y que, por tanto, puedan considerarse biomarcadores transcriptómicos potencialmente relevantes.
  
---

## Tecnologías y herramientas utilizadas

- Lenguaje: **R** y **Python**
- Librerías: `ranger`, `caret`, `clusterProfiler`, `tidyverse`, `ggplot2`, `upSample`, `SMOTE`, etc.
- Análisis: modelos de clasificación, selección de variables, simulaciones, Random Forest.
- Datos: reales (ROSMAP) y simulados con estructura causal conocida.

---

## Cómo reproducir los análisis

1. Clona este repositorio:

```bash
git clone git@github.com:Jaime11Cs/TFM.git
cd TFM
```
---

## Autor

**Jaime Carreto Sánchez**  
Máster en Bioinformática  
Universidad de Murcia
Github: @Jaime11Cs
Universidad [Universidad de Murcia]  
Correo: jaime.carretos@um.es 
GitHub: [@Jaime11Cs](https://github.com/Jaime11Cs)

