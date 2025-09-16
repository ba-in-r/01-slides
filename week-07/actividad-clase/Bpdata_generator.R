# ==============================
# Bpdata Generator (Music Streams)
# Author: Eduard F. Martínez González (template by ChatGPT)
# Course: Introducción al Business Analytics — Unidad 4 (Limpieza y Exploración)
# Purpose: Create a realistic, messy dataset for data wrangling practice.
# ==============================

suppressPackageStartupMessages({
  library(tidyverse)
  library(lubridate)
  library(stringi)
})

set.seed(1234)

# ------------------------------
# 1) Parameters
# ------------------------------
n_artists    <- 50
songs_per_ar <- sample(1:4, n_artists, replace = TRUE, prob = c(0.2, 0.45, 0.25, 0.10))
countries    <- c("CO","MX","AR","CL","PE","BR","US","ES","EC","UY")
start_month  <- as.Date("2024-01-01")
end_month    <- as.Date("2025-08-01")
months_seq   <- seq.Date(start_month, end_month, by = "month")

genres <- c("Reggaeton","Pop","Rock","Indie","Electronica","Salsa","Vallenato","Regional","HipHop","R&B")
labels <- c("IndieWave","MajorX","LatAmSounds","CaliRecords","AndesBeats","UrbanFlow","Río Music","Montaña Music")

# ------------------------------
# 2) Helper functions
# ------------------------------
rand_spaces <- function(x, p = 0.12){
  i <- runif(length(x)) < p
  x[i] <- paste0(" ", x[i], "  ")
  x
}

rand_case <- function(x, p = 0.10){
  i <- runif(length(x)) < p
  x[i] <- ifelse(runif(sum(i)) < 0.5, toupper(x[i]), str_to_title(x[i]))
  x
}

typo_accents <- function(x, p = 0.10){
  # randomly remove accents
  i <- runif(length(x)) < p
  x[i] <- stringi::stri_trans_general(x[i], "Latin-ASCII")
  x
}

make_isrc <- function(n){
  # Fake ISRC-like codes: CC-XXX-YY-NNNNN
  paste0(
    sample(LETTERS, n, TRUE), sample(LETTERS, n, TRUE),
    "-",
    replicate(n, paste0(sample(LETTERS, 3, TRUE), collapse="")),
    "-",
    sample(sprintf("%02d", 20:25), n, TRUE),
    "-",
    sample(sprintf("%05d", 1:99999), n, TRUE)
  )
}

# ------------------------------
# 3) Artists and songs
# ------------------------------
artist_base <- tibble(
  artist_id = sprintf("A%03d", 1:n_artists),
  artist    = paste0(sample(c("Ana","Luis","Sofi","Carlos","Juli","Dani","Pablo","Laura","Valen","Andres",
                              "Mar","Leo","Nico","Vane","Santi","Camila","Mateo","Sara","Juan","Tomas"), 
                            n_artists, replace = TRUE), " ",
                      sample(c("Gonzalez","Martinez","Lopez","Ramirez","Perez","Torres","Moreno","Rojas",
                               "Castro","Hernandez","Vargas","Ortega","Mejia"), n_artists, replace = TRUE)),
  country   = sample(c("CO","MX","AR","CL","PE","BR","ES","US"), n_artists, replace = TRUE),
  label     = sample(labels, n_artists, replace = TRUE)
)

songs <- map2_dfr(artist_base$artist_id, songs_per_ar, function(aid, k){
  tibble(
    artist_id = aid,
    song_id   = sprintf("%s_S%03d", aid, 1:k),
    title     = paste(
      sample(c("Amor","Noche","Ciudad","Luz","Ritmo","Destino","Mar","Fuego","Sueños","Baila","Cali","Sol"),
             k, replace = TRUE),
      sample(c("perdido","infinito","brilla","caliente","en la piel","latente","secreto","salvaje"), 
             k, replace = TRUE)
    ),
    genre     = sample(genres, k, replace = TRUE),
    isrc      = make_isrc(k),
    explicit  = sample(c(TRUE, FALSE), k, replace = TRUE, prob = c(0.2, 0.8)),
    duration_ms = round(rnorm(k, mean = 210000, sd = 28000)) %>% pmax(90000)
  )
}) %>%
  left_join(artist_base, by = "artist_id") %>%
  # introduce messy text in artist and title
  mutate(
    artist = rand_spaces(artist),
    artist = rand_case(artist),
    artist = typo_accents(artist, p = 0.18),
    title  = rand_spaces(title, p = 0.10),
    title  = rand_case(title, p = 0.08)
  )

# ------------------------------
# 4) Panel by month x country
# ------------------------------
panel <- crossing(
  song_id = songs$song_id,
  month   = months_seq,
  estu_cod_reside_mcpio = sample(c("76001","11001","05001","08001","13001","17001","18001","19001","23001","68001"), 
                                 length(months_seq), replace = TRUE) # Borrowing DANE-like municipio code name to relate with your other exercises
) %>%
  left_join(songs, by = "song_id") %>%
  mutate(
    year  = year(month),
    month_num = month(month),
    # baseline popularity by artist+genre
    base_pop = rexp(n(), rate = 1/5000) +
               rlnorm(n(), meanlog = 6 + as.numeric(factor(genre))/20, sdlog = 0.5),
    # seasonal effect
    seas = 1 + 0.25*sin(2*pi*month_num/12) + 0.1*cos(2*pi*month_num/6),
    # country multiplier (simulate different markets)
    country_mult = case_when(
      country %in% c("CO","MX") ~ 1.3,
      country %in% c("US","ES") ~ 1.1,
      TRUE ~ 1.0
    ),
    # final streams + noise
    streams = round(base_pop * seas * country_mult * runif(n(), 0.8, 1.2))
  ) %>%
  select(
    artist_id, artist, song_id, title, isrc, genre, explicit, duration_ms, label,
    country, estu_cod_reside_mcpio, year, month, streams
  )

# ------------------------------
# 5) Derived features and injected issues
# ------------------------------
Bpdata <- panel %>%
  mutate(
    # rolling "trend" variable at song-level (approximation)
    trend_idx = ave(streams, song_id, FUN = function(x) {
      if (length(x) < 3) return(rep(NA_real_, length(x)))
      z <- stats::filter(x, rep(1/3, 3), sides = 1)
      as.numeric(z)
    }),
    # audio features proxies
    danceability = pmin(pmax(rnorm(n(), 0.6, 0.2), 0), 1),
    energy       = pmin(pmax(rnorm(n(), 0.55, 0.25), 0), 1),
    valence      = pmin(pmax(rnorm(n(), 0.5, 0.25), 0), 1),
    # introduce NAs (NDAs) at random
    danceability = ifelse(runif(n()) < 0.04, NA, danceability),
    energy       = ifelse(runif(n()) < 0.03, NA, energy),
    valence      = ifelse(runif(n()) < 0.03, NA, valence),
    # small proportion of negative or zero streams (data entry error)
    streams      = ifelse(runif(n()) < 0.01, -abs(streams), streams),
    # outliers
    streams      = ifelse(runif(n()) < 0.005, streams * sample(c(8,12,20), size = 1, replace = TRUE), streams)
  ) %>%
  # Shuffle columns to be a bit messy
  select(
    month, year, artist, artist_id, title, song_id, isrc, genre, label, country,
    estu_cod_reside_mcpio, explicit, duration_ms, streams, danceability, energy, valence, trend_idx
  ) %>%
  arrange(artist_id, song_id, month)

# create duplicates intentionally (~3.5%)
dups <- Bpdata %>% slice(sample(1:nrow(Bpdata), size = round(0.035*nrow(Bpdata))))
Bpdata <- bind_rows(Bpdata, dups) %>%
  arrange(artist_id, song_id, month)

# ------------------------------
# 6) Metadata dictionary (as attributes)
# ------------------------------
var_dict <- tribble(
  ~variable, ~description,
  "month", "Fecha (primer día del mes)",
  "year", "Año calendario",
  "artist", "Nombre del artista (texto sucio intencional)",
  "artist_id", "ID del artista (A###)",
  "title", "Título de la canción (texto sucio intencional)",
  "song_id", "ID de la canción por artista",
  "isrc", "Código ISRC simulado",
  "genre", "Género musical",
  "label", "Disquera/Label",
  "country", "País del artista",
  "estu_cod_reside_mcpio", "Código de municipio (DANE-like, usado aquí como ejemplo)",
  "explicit", "Marcador de contenido explícito (TRUE/FALSE)",
  "duration_ms", "Duración de la canción en milisegundos",
  "streams", "Reproducciones mensuales (con outliers, errores y valores negativos intencionales)",
  "danceability", "Proxy de 'danceability' (0-1, con NA intencionales)",
  "energy", "Proxy de 'energy' (0-1, con NA intencionales)",
  "valence", "Proxy de 'valence' (0-1, con NA intencionales)",
  "trend_idx", "Media móvil (3) de streams por canción"
)

attr(Bpdata, "dictionary") <- var_dict

# ------------------------------
# 7) Save
# ------------------------------
# NOTE: Intentionally keep inconsistent column order / names to encourage wrangling
dir.create("data", showWarnings = FALSE)
readr::write_csv(Bpdata, "data/Bpdata.csv")
saveRDS(Bpdata, file = "data/Bpdata.rds")

# Optional: also export dictionary
readr::write_csv(var_dict, "data/Bpdata_dictionary.csv")

# ------------------------------
# 8) Return object
# ------------------------------
Bpdata
save(Bpdata,"Downloads/Datos.Rdata")

