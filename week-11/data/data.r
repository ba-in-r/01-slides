## ---- 1. Preparación del entorno ----
rm(list = ls())

library(tidyverse)
set.seed(123)  # Reproducibilidad


## ---- 2. Generación de base simulada ----
# Lista de contactos (nodos)
contactos <- c("Ana", "Beto", "Carla", "Diana", "Esteban", 
               "Felipe", "Gina", "Hugo", "Isabel", "Juan")

# Simular mensajes enviados y recibidos
mensajes <- data.frame(
  emisor = sample(contactos, 60, replace = TRUE),
  receptor = sample(contactos, 60, replace = TRUE),
  hora = sample(seq.POSIXt(
    as.POSIXct("2025-10-09 08:00"),
    as.POSIXct("2025-10-09 23:00"),
    by = "10 min"), 60, replace = TRUE)
) %>%
  filter(emisor != receptor) %>%
  group_by(emisor, receptor) %>%
  summarise(mensajes = n(), .groups = "drop")

rm(contactos)
cat("\f")
head(mensajes)