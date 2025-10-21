# ============================================================
# Base sintética ajustada: ~40% aprueba, 80% de los reprobados se retiran
# ============================================================

library(tidyverse)
set.seed(1234)

n <- 2000

# Variables explicativas
datos <- tibble(
  id_estudiante = 1:n,
  horas_estudio = rnorm(n, mean = 6, sd = 2),
  asistencia = rnorm(n, mean = 85, sd = 10),
  participacion = rnorm(n, mean = 70, sd = 15),
  uso_de_R = sample(1:5, n, replace = TRUE, prob = c(0.1,0.2,0.3,0.25,0.15)),
  trabajos_entregados = sample(0:5, n, replace = TRUE, prob = c(0.05,0.1,0.15,0.25,0.25,0.2)),
  afinidad_estadistica = rnorm(n, mean = 60, sd = 20)
) |> 
  mutate(
    horas_estudio = pmax(0, pmin(horas_estudio, 15)),
    asistencia = pmax(50, pmin(asistencia, 100)),
    participacion = pmax(0, pmin(participacion, 100)),
    afinidad_estadistica = pmax(0, pmin(afinidad_estadistica, 100))
  )

# ------------------------------------------------------------
# Modelo logit subyacente calibrado a ~40% de aprobación
# ------------------------------------------------------------
b0 <- -8          # intercepto ajustado
b_horas <- 0.25
b_asistencia <- 0.03
b_participacion <- 0.02
b_usoR <- 0.4
b_trabajos <- 0.45
b_afinidad <- 0.015

lineal <- b0 + 
  b_horas * datos$horas_estudio +
  b_asistencia * datos$asistencia +
  b_participacion * datos$participacion +
  b_usoR * datos$uso_de_R +
  b_trabajos * datos$trabajos_entregados +
  b_afinidad * datos$afinidad_estadistica

p_aprueba <- 1 / (1 + exp(-lineal))

datos <- datos |>
  mutate(
    prob_aprueba = p_aprueba,
    aprueba = rbinom(n, size = 1, prob = prob_aprueba)
  )

# ------------------------------------------------------------
# Variable de retiro (80% de los que reprueban)
# ------------------------------------------------------------
datos <- datos |>
  mutate(
    prob_retira = if_else(aprueba == 1, 0.05, 0.80),
    retira = rbinom(n, size = 1, prob = prob_retira)
  )


rm("b_afinidad","b_asistencia","b_horas","b_participacion","b_trabajos","b_usoR","b0","lineal","n","p_aprueba" )

     



