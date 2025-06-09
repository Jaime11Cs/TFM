# Experimentos con datos clínicos del estudio Framingham

Esta carpeta contiene los experimentos realizados con datos clínicos del estudio **Framingham Heart Study**. El objetivo es realizar una exploración preliminar sobre el impacto de las variables **confusoras** en modelos de clasificación de baja dimensionalidad utilizando Random Forest.

---

## Objetivos

- Evaluar el efecto de incluir variables confusoras sobre el rendimiento de modelos Random Forest.
- Analizar el impacto del parámetro `always.split.variables` al forzar el uso de covariables específicas en los splits.
- Comparar el rendimiento de diferentes configuraciones del modelo sobre datos de entrenamiento y test.

---

## Contenido

- `Entrenamiento_Framingham.Rmd`: notebook principal en R Markdown con todo el flujo de análisis.
- `Entrenamiento_Framingham.html`: versión HTML exportada del análisis.
- `framingham.csv`: datos clínicos reales del estudio Framingham.

---

## Código principal: `Entrenamiento_Framingham.Rmd`

1. **Carga y preprocesamiento de datos**
   - Imputación de valores ausentes.
   - Definición de matriz de predictores (**M**) y confusoras (**C**).
   - Asignación de la variable objetivo (**Y**).

2. **Entrenamiento del modelo**
   - Algoritmo: `Random Forest` con `caret::train()` (motor `ranger`).
   - Validación: 5-fold cross-validation + 15 bootstraps.
   - Métrica principal: **Accuracy**.

3. **Configuraciones evaluadas**
   - `M`: solo predictores.
   - `MC`: predictores + todas las confusoras.
   - `M + var`: modelo forzando en los splits una confusora individual (`age`, `sex`, `education`, `BMI`) con `always.split.variables`.

4. **Salidas generadas**
   - Tabla con Accuracy media e IC95% por modelo.
   - Métricas de test: Accuracy, Balanced Accuracy, Sensitivity, Specificity, Kappa, TP, TN, FP, FN.
   - Gráficos comparativos.

---

## Datos utilizados

El fichero `framingham.csv` contiene variables clínicas con las siguientes agrupaciones:

- **M (predictoras)**: subconjunto de variables clínicas con posible valor predictivo.
- **C (confusoras)**: `age`, `sex`, `education`, `BMI`, consideradas potenciales confundidoras.
- **Y (objetivo)**: variable binaria a predecir.

---

## Parámetros de configuración

- **Modelo base**: Random Forest (`ranger`)
- **Validación cruzada**: 5 folds
- **Bootstrapping**: 15 repeticiones
- **Split forzado**: `always.split.variables = c("var")`

---

## Entrada esperada

- `framingham.csv`: debe contener columnas correspondientes a:
  - Predictores (**M**)
  - Confusoras (**C**)
  - Objetivo (**Y**)

---

## Resultados generados

- Boxplot comparativo de Accuracy entre modelos.
- Matriz de confusión de test por modelo.

---

## Interpretación de resultados

- El modelo **MC** (predictores + confusoras) obtuvo la mayor Accuracy.
- Forzar `age` con `always.split.variables` también mejoró el rendimiento.
- Forzar otras variables como `education` o `sex` redujo la precisión del modelo.
- Esto sugiere que **no todas las confusoras son útiles** y que el forzado debe usarse selectivamente.

---

## Reproducibilidad

Para ejecutar el análisis:

```r
rmarkdown::render("entrenamiento_cardio.Rmd")
