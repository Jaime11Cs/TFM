# Simulación controlada de datos transcriptómicos y clínicos
Esta carpeta contiene el código y los archivos necesarios para generar datos sintéticos con estructura causal definida, con el fin de analizar el efecto de las variables confusoras sobre el rendimiento de modelos de clasificación basados en Random Forest.

## Objetivos

- Generar un dataset simulado con control total sobre la relación entre variables confusoras (clínicas y técnicas), expresión génica y diagnóstico.
- Evaluar el impacto de las variables confusoras sobre el rendimiento predictivo de modelos Random Forest.
- Estudiar como cambia la importancia de los genes según la configuración del modelo.
- Validar el uso del parámetro `always.split.variables` como herramienta para controlar el efecto de variables confusoras.

## Contenido de la carpeta

- `generador_simulacion.ipynb`: Notebook de Python que genera los datos simulados con estructura causal. Incluye la definición de los grupos de genes (A, B, D y Ruido) y la variable objetivo.
- `generador_simulacion.html`: Version renderizada del Jupyter Notebook anterior
- `dataset_simulado.csv`: Dataset de salida generado por el notebook. Incluye variables clínicas, genes simulados y diagnóstico binario.
- `analisis_simulacion.Rmd`: Código en R que entrena modelos Random Forest, realiza validación cruzada y bootstrapping, evalúa el rendimiento y analiza la importancia de variables.
- `analisis_simulacion.html`: Versión renderizada del R Markdown anterior.

## Descripción del simulador

El simulador genera un conjunto de datos sintéticos con las siguientes características:
- **Variables clínicas (matriz C)**
  - `edad`: variable continua (media = 60; rango 40-85).
  - `sexo`: binaria, generada desde normal (umbral 0).
  - `RIN`: variable técnica continua (media = 6; rango: 0-10).
  - `Lote`: variable categórica con 4 niveles
