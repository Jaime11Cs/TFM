# Experimentos con datos clínicos del estudio Framingham

Esta carpeta contiene los experimentos realizados con datos clínicos del estudio Framingham Heart Study. El objetivo de esta fase es realizar una exploración preliminar sobre el impacto de las variables confusoras en modelos de clasificación de baja dimensionalidad utilizando Random Forest.

## Objetivo

- Evaluar el efecto de incluir variables confusoras en el rendimiento de modelos Random Forest.
- Estudiar cómo cambia la precisión del modelo cuando se fuerza el uso de ciertas variables confusoras mediante `always.split.variables`.
- Comparar las métricas de evaluación en entrenamiento y test para diferentes configuraciones del modelo.

## Contenido

- `entrenamiento_cardio.Rmd`: R Markdown principal que contiene todo el flujo de entrenamiento, validación cruzada, bootstrapping y evaluación en test.:
  - Modelo M (solo predictores)
  - Modelo MC (predictores + confusoras)
  - Modelos con forzado individual de variables confusoras usando `always.split.variables`
- `entrenamiento_cardio.html`: Versión en HTML del notebook `entrenamiento_cardio.Rmd`
- `framingham.csv`: Datos de entrada del estudio Framingham.

---

## Datos utilizados

Se ha trabajado con una matriz de datos clínicos del estudio Framingham, incluyendo variables como:

- Variables predictoras (matriz **M**): subconjunto de variables clínicas que se desean usar para predecir el outcome.
- Variables confusoras (matriz **C**): edad, sexo, BMI y educación, introducidas como potenciales confundidoras del modelo.

---

## Parámetros y configuración

- Modelos entrenados con `caret::train()` usando el método `"ranger"`.
- Validación cruzada de 5 folds.
- 15 repeticiones por bootstrapping.
- Comparación entre tres configuraciones:
  - **M**: solo variables predictoras.
  - **MC**: incluye también las confusoras.
  - **M + confusora_i**: modelo con una única variable confusora forzada en los splits mediante `always.split.variables`.

---

## Entrada

- Conjunto de datos clínicos (formato `.csv`), con variables predictores y confusoras.
- Lista de variables a forzar en los splits del modelo.

## Salidas

- Tabla resumen con métricas de evaluación por modelo.
- Boxplot comparativo para la métrica **Accuracy** de todos los modelos.
- Matriz de confusión para los datos de Test para todos los modelos del experimentos.

## Resultados

- Las métricas de Accuracy, Balanced Accuracy, Sensitivity y Specificity se calcularon para todos los modelos.
- El modelo **MC** ofreció el mejor rendimiento general en test.
- El forzado de algunas variables como `age` mejoró el rendimiento del modelo base, mientras que otras como `education` lo empeoraron.
- Los resultados se recogen en la tabla incluida en el informe (`Tabla 1` del TFM).

---

## Reproducibilidad

Para ejecutar este análisis:

```r
rmarkdown::render("entrenamiento_framingham.Rmd")
