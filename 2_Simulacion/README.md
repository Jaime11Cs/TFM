# Simulación controlada de datos transcriptómicos y clínicos
Esta carpeta contiene el código y los archivos necesarios para generar datos sintéticos con estructura causal definida, con el fin de analizar el efecto de las variables confusoras sobre el rendimiento de modelos de clasificación basados en Random Forest.

## Objetivos

- Generar un dataset simulado con control total sobre la relación entre variables confusoras (clínicas y técnicas), expresión génica y diagnóstico.
- Evaluar el impacto de las variables confusoras sobre el rendimiento predictivo de modelos Random Forest.
- Estudiar como cambia la importancia de los genes según la configuración del modelo.
- Validar el uso del parámetro `always.split.variables` como herramienta para controlar el efecto de variables confusoras.

---

## Contenido de la carpeta

- `generador_simulacion.ipynb`: Notebook de Python que genera los datos simulados con estructura causal. Incluye la definición de los grupos de genes (A, B, D y Ruido) y la variable objetivo.
- `generador_simulacion.html`: Version renderizada del Jupyter Notebook anterior
- `dataset_simulado.csv`: Dataset de salida generado por el notebook. Incluye variables clínicas, genes simulados y diagnóstico binario.
- `analisis_simulacion.Rmd`: Código en R que entrena modelos Random Forest, realiza validación cruzada y bootstrapping, evalúa el rendimiento y analiza la importancia de variables.
- `analisis_simulacion.html`: Versión renderizada del R Markdown anterior.

--- 

## Descripción del simulador

El simulador genera un conjunto de datos sintéticos con las siguientes características:

- **Variables clínicas (matriz C)**
  - `edad`: variable continua (media = 60; rango 40-85).
  - `sexo`: binaria, generada a partir de una N(0, 1) con corte en 0.
  - `RIN`: variable técnica continua (media = 6; rango: 0-10).
  - `Lote`: variable categórica con 4 niveles
  
- **Genes simulados (matriz M)**:
  - Grupo A: 100 genes correlacionados con `edad` (0.4) y correlacionados internamente (0.3-0.6)
  - Grupo B: 200 genes correlacionados con `sexo` (0.4) y correlacionados entre sí (0.2-0.4)
  - Grupo D: 300 genes con correlación interna (0.2-0.4) y sin relación con variables confusoras
  - Grupo Ruido: 400 genes independientes entre sí respecto a las variables confusoras y la variable objetivo
    
- **Variable objetivo (Y)**:
  - Binaria, generada como combinación de genes de los grupos A y B junto con `edad` y `sexo`

--- 

## Código de simulación (generador_simulacion.ipynb)

- Librerías usadas: **numpy**, **pandas**, **scipy**, **matplotlib**, **seaborn**, **sklearn** y **statsmodels**
- Parámetros connfigurables:
   - Número de individuos
   - Valores de correlación interna de los grupos de genes y correlación externa sobre las variables de confusión
   - Número de genes pertenecientes a cada grupo
   - Variables y grupos de genes que construyen la variable objetivo
- Salida: `dataset_simulado.csv`

## Código de análisis (analisis_simulacion.Rmd)
1. Carga de datos, explorción incial, creación de DataFrames y partición train/test.
2. Entrenamiento de modelos `Random Forest` con:
   - Solo expresión génica (**M**, **AB**, **ABD**)
   - Expresión + variables confusoras (**MC**, **AB+C** y **ABD+C**)
   - Modelos forzando el uso de variables confusoras usando `always.split.variables`
   - Modelo con solo las variables confusoras (**C**)
3. Validación cruzada de 5 particiones y 15 bootstraps
4. Evaluación de Balanced Accuracy + IC 95%
5. Análisis de importancia de variables (`varImp`)

---

## Resultados

- Los modelos con covariables (`AB+C`, `ABD+C`) superaron en rendimiento a los modelos con solo expresión génica.
- El uso de `always.split.variables` con `edad` mejoró significativamente la clasificación
- Covariables no informativas como `rin` o `lote` no mejoran el modelo, aunque fueron forzadas en los splits
- El análisis de importancia de variables permitió erificar que Random Forest prioriza los genes informativos incluso en presencia de ruido.

---

## Reproducibilidad

En un entorno con Python 3 y Jupyter:

```python
jupyter nbconvert --execute generador_simulacion.ipynb
```

```r
rmarkdown::render("analisis_simulacion.Rmd")
