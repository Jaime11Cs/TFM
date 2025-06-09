# Análisis predictivo sobre datos reales del estudio ROSMAP

Esta carpeta contiene el código y los resultados del análisis realizado con datos reales del estudio ROSMAP (Religious Orders Study and Memory and Aging Project), centrado en integrar datos transcriptómicos post-mortem con variables clínicas, técnicas y neuropatológicas para construir modelos de clasificación mediante Random Forest.

---

## Objetivos

- Evaluar cómo la inclusión de variables confusoras (clínicas, técnicas y neuropatológicas) afecta al rendimiento predictivo de modelos Random Forest
- Identificar genes cuya importancia se mantiene estable a lo largo de múltiples repeticiones, y que puedan ser considerados biomarcadores transcriptómicos robustos
- Analizar cómo el parámetro `always.split.variables` puede mejorar la interpretación de modelos, priorizando vraiables confusoras altamente informativas.
- Validar el efecto de la eliminación de genes redundantes (alta correlación o baja varianza) sobre el rendimiento y la estabilidad del modelo.

---

## Contenido de la carpeta

- entrenamiento_rosmap.Rmd: Script principal en R Markdown que contiene todo el flujo de análisis: preprocesamiento, filtrado de genes, entrenamiento de modelos y análisis de importancia.
- entrenamiento_rosmap.html: Versión renderizada del documento anterior.
- Scripts: Carpeta con funciones auxiliares para entrenamiento de los diferentes modelos en un clúster.
- Datos: Carpeta que incluye los dos documentos `.rds` que contienen las variables confusoras (ROSMAP_RINPMIAGESEX_covs.rds) y los datos ómicos (ROSMAP_RINPMIAGESEX_resids.rds)

--- 

## Descripción del análisis

1. Carga de datos y preprocesamiento
   - Unión de matriz de expresión génica (`M`) y variables confusoras (`C`)
   - Eliminación de genes altamente correlacionados y con baja varianza para la creación de la matriz (`M`)
   - Creación de los distintos DataFrames
     
2. Entrenamiento de los modelos
   - `M` y `M'`: Solo expresión génica (sin filtrado y con filtrado de genes)
   - `MC` y `M'C`: Expresión + covariables clínicas y técnicas.
   - Matrices de expresión génica + `always.split.variables`: Modelos con variables confusoras forzadas en los splits
   - `C`: Modelo con solo las variables confusoras
     
3. Validación
   - Cross-validation (5-fold) + 30 repeticiones por bootstrapping
   - Métrica principal: `Accuracy`
     
4. Análisis de importancia:
   - Extracción de `varImp()` para cada repetición.
   - Evaluación de estabilidad de los rankings mediante correlación de Spearman y análisis de varianza de posiciones.
   - Identificación de genes estables como posibles biomarcadores.
     
5. Estudio del efecto estabilizador de covariables
   - Comparación de rankings de importancia entre modelos con y sin covariables forzadas.
   - Detección de genes cuya posición en el ranking mejora al introducir variables confusoras
---

## Variables utilizadas

- **Matriz M**: Análisis transcriptómico post-mortem altamente dimensional
- **Matriz C**: Variables confusoras
  - Nueropatológicas: `braaksc` (estadios de Braak) y `ceradsc` (escala CERAD).
  - Demográficas: `msex` (sexo, codificado como factor)
  - Técnicas: `rin` (Número de integridad del ADN), `pmi` (Intervalo post-mortem) y `batch` (lote experimental)
- Variable objetivo: `cogdx`, que representa el diagnóstico cognitivo del sujeto en el momento del fallecimiento. Incluye 5 clases:
  - `NCI`: Sin deterioro cognitivo
  - `MCI`: Deterioro cognitivo leve sin causa aparente además de Alzheimer.
  - `MCI con comorbilidad`: MCI con otra causa adicional
  - `AD`: Enfermedad de Alzheimer sin otras causas.
  - `AD con comorbilidad`: Alzheimer acompañado de otra causa de deterioro
 
---

## Resultados destacados

- El mejor modelo fue `M' + ceradsc`, combinando un subconjunto filtrado de genes con una variable neuropatológica forzada.
- Los modelos con forzados explícito de las variables neuropatológicas `braaksc` y `ceradsc` superaron en precisión a llos modelos completos (`MC` y `M'C`)
- El análisis de estabilidad permitió identificar genes como `MTCP1`, `HPCAL1`, `CAMK4` y `MMP24` que se postulan como candidatos robustos con relevancia en la Enfermedad de Alzheimer.
- Se observaron efectos estabilizadores selectivos, algunos genes mejoran su estabilidad solo al introducir variables confusoras específicas, sobre todo `braaksc` y `ceradsc`, lo que sugiere una relación biológica genuina.

---

## Reproducibilidad

```r
rmarkdown::render("entrenamiento_rosmap.Rmd")
``` 


   
  
