## --- Generación de la base simulada ---
require(dplyr)

# Lista de jugadores
jugadores <- c("Vargas", "Cuesta", "Mina", "Machado", "Muñoz",
               "Uribe", "Lerma", "James", "Luis Díaz", "Arias", "Borré")

set.seed(123)

# Generar pases de forma aleatoria
sel_colombia <- data.frame(
  from = sample(jugadores, 35, replace = TRUE),
  to   = sample(jugadores, 35, replace = TRUE)
) %>%
  filter(from != to)

# Aumentar la centralidad de James (más pases salientes y algunos entrantes)
james_extra <- data.frame(
  from = rep("James", 15),
  to   = sample(jugadores[jugadores != "James"], 15, replace = TRUE)
)

# Algunos pases dirigidos hacia James (para simular recepciones)
hacia_james <- data.frame(
  from = sample(jugadores[jugadores != "James"], 5, replace = TRUE),
  to   = rep("James", 5)
)

# Unir todo y agregar pesos
sel_colombia <- bind_rows(sel_colombia, james_extra, hacia_james) %>% count(from, to, name = "peso")

rm(hacia_james,james_extra,jugadores)
