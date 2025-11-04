# Limpiar el entorno de trabajo
rm(list = ls())

## ==========================================================
## Simulación de notas de estudiantes con valores atípicos
## ==========================================================

# Paquetes
require(pacman)
p_load(tidyverse, janitor)

# Fijar semilla para reproducibilidad
set.seed(2025)

# Número de estudiantes
n <- 100

# Crear base de datos sintética
notas <- tibble(
  id_estudiante = 1:n,
  grupo = sample(c("Viernes", "Martes", "Jueves"), n, replace = TRUE),
  asistencia = round(rnorm(n, mean = 0.9, sd = 0.05), 2),
  participacion = round(rnorm(n, mean = 4, sd = 0.5), 1),
  trabajos = round(rnorm(n, mean = 4, sd = 0.6), 1),
  quiz_1 = round(rnorm(n, mean = 3.8, sd = 0.7), 1),
  quiz_2 = round(rnorm(n, mean = 3.6, sd = 0.8), 1),
  proyecto_final = round(rnorm(n, mean = 4.0, sd = 0.5), 1)
)

# Calcular promedio ponderado (ejemplo)
notas <- notas %>%
  mutate(
    promedio = round((participacion*0.1 + trabajos*0.25 + quiz_1*0.2 + 
                        quiz_2*0.2 + proyecto_final*0.25), 2)
  )

# Introducir anomalías ("notas raras")
# ----------------------------------------------------------
# 1. Valores imposibles (fuera de rango)
notas$quiz_1[sample(1:n, 2)] <- c(7.5, -1.0)
notas$proyecto_final[sample(1:n, 2)] <- c(10, -2)

# 2. Estudiantes con patrones contradictorios (alta asistencia pero notas bajas)
idx_alta_asistencia <- sample(1:n, 3)
notas$asistencia[idx_alta_asistencia] <- runif(3, 0.95, 1)
notas$promedio[idx_alta_asistencia] <- runif(3, 1, 2)

# 3. Estudiantes con notas perfectas en todo (posible copia o error)
idx_perfectos <- sample(1:n, 2)
notas[idx_perfectos, 4:9] <- 5

# 4. Estudiantes con datos faltantes
idx_na <- sample(1:n, 3)
notas$quiz_2[idx_na] <- NA

## 
rm("idx_alta_asistencia","idx_na","idx_perfectos","n")

