# semilla
rm(list=ls())
require(dplyr)
set.seed(123)
n <- 1500

barrios <- c(
  "San Antonio","San  Antonio","San Fernando","Granada","Ciudad  Jardín",
  "El Ingenio","Pance","Centenario","San Cayetano","Santa Mónica",
  "La Flora","San Bosco","Tequendama","El Refugio","Napoles","San Judas"
)

tipos <- c("Apartamento","Casa","Apartaestudio","Casa","Apartamento")

# helpers para “ensuciar” textos
rand_spaces <- function(x) ifelse(runif(length(x)) < 0.15, paste0("  ", x, " "), x)
variant_ciudad <- function(n){
  base <- sample(c("Cali","  Cali ","Santiago de Cali"), n, replace = TRUE, prob = c(0.7,0.1,0.2))
  # inyectar algunos vacíos
  idx <- sample(seq_len(n), size = round(0.03*n))
  base[idx] <- ""
  base
}

# rangos geográficos aproximados para Cali
lat <- runif(n, min = 3.38, max = 3.49)
lon <- runif(n, min = -76.57, max = -76.45)

# fechas dentro del último año
dates <- as.Date("2024-09-01") + sample(0:365, n, replace = TRUE)

# precios y áreas con dispersión + valores atípicos intencionales
precio <- round(rlnorm(n, meanlog = log(350e6), sdlog = 0.5), -3)
area   <- round(rlnorm(n, meanlog = log(85), sdlog = 0.45), 0)

# habitaciones y baños con distribución discreta
hab <- pmin(6, pmax(1, rpois(n, lambda = 3)))
ban <- pmin(5, pmax(1, rpois(n, lambda = 2)))

# direcciones simples con variaciones
vias <- c("Calle","Carrera","Avenida","Transversal")
dir_txt <- sprintf("%s %d #%d-%d", sample(vias, n, TRUE), sample(1:120,n,TRUE), sample(1:120,n,TRUE), sample(1:60,n,TRUE))
dir_txt <- rand_spaces(dir_txt)

# construir data frame “sucio”
df <- tibble(
  id = sample(100000:999999, n, replace = FALSE),
  fecha_publicacion = as.character(dates),        # como texto (para coerción posterior)
  precio_cop  = as.character(precio),             # como texto (para coerción posterior)
  area_m2     = as.character(area),               # como texto (para coerción posterior)
  habitaciones = as.character(hab),               # como texto
  banos        = as.character(ban),               # como texto
  barrio       = rand_spaces(sample(barrios, n, TRUE)),
  direccion    = dir_txt,
  ciudad       = variant_ciudad(n),
  lat = as.character(round(lat, 6)),              # como texto
  lon = as.character(round(lon, 6)),              # como texto
  tipo_propiedad = rand_spaces(sample(tipos, n, TRUE)))

# introducir NAs y strings vacíos aleatorios
for (col in c("precio_cop","area_m2","habitaciones","banos","barrio","direccion","tipo_propiedad")) {
  idx_na <- sample(seq_len(n), size = round(0.03*n))
  df[[col]][idx_na] <- ifelse(runif(length(idx_na)) < 0.5, NA, "")
}

# crear duplicados intencionales (~4%)
dups <- df %>% slice(sample(1:n, size = round(0.04*n)))

# datos final
datos_vivienda <- bind_rows(df, dups) %>% arrange(fecha_publicacion)
names(datos_vivienda)[2] <- "Fecha Publicacion"
names(datos_vivienda)[4] <- "Area M2"
names(datos_vivienda)[12] <- "Tipo Propiedad"

# eliminar objeto
rm(list = setdiff(ls(), "datos_vivienda"))


