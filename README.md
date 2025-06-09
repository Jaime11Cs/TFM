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

## Motivación

En los modelos lineales clásicos, como la regresión múltiple, el tratamiento de variables confusoras está bien establecido. Sin embargo, cuando se trabaja con modelos no lineales como Random Forest, especialmente en escenarios de alta dimensionalidad, el manejo de variables confusoras es más complejo.

Si una variable confusora está altamente correlacionada con variables ómicas, puede ser ignorada en los splits del modelo, siendo sustituida por predictores que enmascaran su efecto real. Además, en contextos donde el número de predictores supera ampliamente al de muestras, los modelos lineales tienden a eliminar el sesgo por regularización, pero Random Forest no.

Por ello, surge la siguiente pregunta:  
**¿Es posible construir modelos Random Forest que integren correctamente las variables confusoras para maximizar la precisión predictiva y, al mismo tiempo, preservar la interpretabilidad de los genes relevantes?**

---

## Estructura del repositorio

- [`1_Experimentos_Cardio/`](./1_Experimentos_Cardio/):  Experimentos de predicción con datos del estudio de Framingham. 
- [`2_Simulacion/`](./2_Simulacion): Generación de datos simulados con estructura causal controlada.
- [`3_Experimentos_ROSMAP/`](./3_Experimentos_ROSMAP): Experimentos con datos reales transcriptómicos del estudio ROSMAP.

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
Correo: jaime.carretos@um.es
