
## =======================================================
## Generar base de notas con anomalías controladas
## =======================================================
## Limpiar el entorno de trabajo
rm(list = ls())

## Instalar paquetes (solo si es necesario)
if (!require("pacman")) {install.packages("pacman") ; require("pacman")}

## Cargar librerías
p_load(tidyverse) # Manipulación y visualización de datos


set.seed(123)

n <- 250

notas_grupo <- data.frame(
  id_estudiante = 1:n,
  asistencia = round(runif(n, 0.4, 1.0), 2),
  participacion = round(rnorm(n, mean = 3, sd = 0.8), 1),
  trabajos = round(rnorm(n, mean = 3.5, sd = 0.7), 1),
  quiz_1 = round(rnorm(n, mean = 3.0, sd = 1.0), 1),
  quiz_2 = round(rnorm(n, mean = 3.1, sd = 0.9), 1),
  proyecto_final = round(rnorm(n, mean = 3.8, sd = 0.6), 1)
)

## Calcular promedio ponderado
notas_grupo$promedio <- with(notas_grupo,
                             0.1 * participacion +
                               0.2 * trabajos +
                               0.3 * ((quiz_1 + quiz_2)/2) +
                               0.4 * proyecto_final
)

## Introducir anomalías:
#  - Notas negativas o mayores que 5
#  - Inconsistencias (alta asistencia con bajo promedio)
notas_grupo$promedio[sample(1:n, 3)] <- c(-0.5, 5.8, 7.2)
notas_grupo$promedio[sample(1:n, 2)] <- c(0.4, 0.2)
notas_grupo$asistencia[sample(1:n, 2)] <- c(1.0, 0.95)
notas_grupo$promedio[sample(1:n, 2)] <- c(0.9, 0.7)  # muy bajo con alta asistencia

## Revisar estructura
rm(n)