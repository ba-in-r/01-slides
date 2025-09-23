# ------------------------------------------------------------
# Script: synthetic_reggaeton_spotify_dataset.R
# Objetivo: Generar una base de datos sintética (tipo Spotify)
#           con artistas de reggaetón, álbumes y canciones,
#           pensada para demostraciones de K-means.
# Autor: Tú ;)
# ------------------------------------------------------------

# Paquetes

  require(tidyverse)
  require(stringi)

set.seed(1234)

# ---------------------------
# 1) Catálogos base
# ---------------------------
artists <- c(
  "Bad Bunny","J Balvin","Daddy Yankee","Karol G","Ozuna","Anuel AA",
  "Maluma","Nicky Jam","Rauw Alejandro","Wisin & Yandel","Becky G",
  "Feid","Sech","Myke Towers","Farruko","Natti Natasha","Tego Calderón"
)

genres <- c("reggaeton","reggaeton-pop","trap latino","dembow","urbano latino")

# Popularidad base por artista (0-100)
artist_popularity <- tibble(
  artist = artists,
  artist_popularity = pmin(100, pmax(30, round(rnorm(length(artists), 75, 10))))
)

# ---------------------------
# 2) Generación de álbumes
# ---------------------------
make_albums <- function(artist) {
  n_albums <- sample(2:6, 1)
  years <- sort(sample(2015:2025, n_albums, replace = FALSE))
  tibble(
    artist = artist,
    album = paste0(
      str_replace_all(artist, "[& ]", "_"),
      "_", str_pad(seq_len(n_albums), 2, pad = "0")
    ),
    release_year = years,
    genre = sample(genres, n_albums, replace = TRUE,
                   prob = c(0.35, 0.25, 0.2, 0.1, 0.1))
  )
}

albums <- map_df(artists, make_albums) %>%
  left_join(artist_popularity, by = c("artist" = "artist"))

# ---------------------------
# 3) Generación de canciones con “clusters latentes”
#    (útil para K-means)
# ---------------------------
# Definimos 4 perfiles de canción (no visibles en el output):
#   C1: Reggaetón clásico     -> alta danceability/energy, tempo ~95-105
#   C2: Reggaetón pop         -> valence más alto, tempo ~100-120
#   C3: Trap latino           -> valence/danceability más bajo, tempo ~65-85 (o doble ~150-170)
#   C4: Dembow/party uptempo  -> energy/danceability muy altos, tempo ~120-150

sample_cluster <- function(genre) {
  # Mezcla por género (probabilidades)
  case_when(
    genre == "reggaeton"      ~ c(0.45, 0.25, 0.15, 0.15),
    genre == "reggaeton-pop"  ~ c(0.25, 0.50, 0.10, 0.15),
    genre == "trap latino"    ~ c(0.10, 0.10, 0.65, 0.15),
    genre == "dembow"         ~ c(0.15, 0.15, 0.10, 0.60),
    TRUE                       ~ c(0.35, 0.30, 0.20, 0.15)
  ) %>%
    { sample(1:4, size = 1, prob = .) }
}

r01 <- function(mu, sd) pmin(1, pmax(0, rnorm(1, mu, sd)))

# Generador de rasgos por cluster
traits_from_cluster <- function(k) {
  # Devuelve lista con valores: danceability, energy, valence, acousticness,
  # instrumentalness, liveness, speechiness, tempo, duration_ms, explicit
  switch(as.character(k),
         # C1 Reggaetón clásico
         "1" = list(
           danceability   = r01(0.82, 0.07),
           energy         = r01(0.78, 0.08),
           valence        = r01(0.55, 0.15),
           acousticness   = r01(0.08, 0.05),
           instrumentalness = r01(0.01, 0.01),
           liveness       = r01(0.15, 0.10),
           speechiness    = r01(0.08, 0.04),
           tempo          = rnorm(1, 100, 6),
           duration_ms    = round(rnorm(1, 205000, 15000)),
           explicit       = rbinom(1, 1, 0.35)
         ),
         # C2 Pop/latin pop
         "2" = list(
           danceability   = r01(0.77, 0.08),
           energy         = r01(0.70, 0.10),
           valence        = r01(0.70, 0.12),
           acousticness   = r01(0.10, 0.06),
           instrumentalness = r01(0.01, 0.01),
           liveness       = r01(0.14, 0.08),
           speechiness    = r01(0.07, 0.04),
           tempo          = rnorm(1, 112, 10),
           duration_ms    = round(rnorm(1, 215000, 15000)),
           explicit       = rbinom(1, 1, 0.25)
         ),
         # C3 Trap latino
         "3" = list(
           danceability   = r01(0.60, 0.12),
           energy         = r01(0.55, 0.12),
           valence        = r01(0.38, 0.15),
           acousticness   = r01(0.12, 0.07),
           instrumentalness = r01(0.02, 0.02),
           liveness       = r01(0.18, 0.10),
           speechiness    = r01(0.12, 0.06),
           tempo          = sample(c(rnorm(1, 76, 7), rnorm(1, 158, 8)), 1),
           duration_ms    = round(rnorm(1, 225000, 20000)),
           explicit       = rbinom(1, 1, 0.55)
         ),
         # C4 Dembow/party
         "4" = list(
           danceability   = r01(0.86, 0.06),
           energy         = r01(0.84, 0.06),
           valence        = r01(0.62, 0.12),
           acousticness   = r01(0.05, 0.04),
           instrumentalness = r01(0.01, 0.01),
           liveness       = r01(0.16, 0.10),
           speechiness    = r01(0.09, 0.04),
           tempo          = rnorm(1, 136, 10),
           duration_ms    = round(rnorm(1, 190000, 12000)),
           explicit       = rbinom(1, 1, 0.40)
         )
  )
}

# ---------------------------
# 4) Construcción de canciones por álbum
# ---------------------------
make_songs_for_album <- function(row) {
  # row es una fila de 'albums'
  n_tracks <- sample(8:16, 1)
  cluster_ids <- replicate(n_tracks, sample_cluster(row$genre))
  
  base <- tibble(
    track_n = seq_len(n_tracks),
    track_id = stri_rand_strings(n_tracks, 10, pattern = "[A-Za-z0-9]"),
    track_name = paste0("Track_", str_pad(track_n, 2, pad = "0")),
    artist = row$artist,
    album = row$album,
    genre = row$genre,
    release_year = row$release_year
  )
  
  traits <- map(cluster_ids, traits_from_cluster)
  traits_df <- tibble(
    danceability    = map_dbl(traits, "danceability"),
    energy          = map_dbl(traits, "energy"),
    valence         = map_dbl(traits, "valence"),
    acousticness    = map_dbl(traits, "acousticness"),
    instrumentalness= map_dbl(traits, "instrumentalness"),
    liveness        = map_dbl(traits, "liveness"),
    speechiness     = map_dbl(traits, "speechiness"),
    tempo           = map_dbl(traits, "tempo"),
    duration_ms     = map_dbl(traits, "duration_ms"),
    explicit        = map_dbl(traits, "explicit")
  )
  
  # Otros campos tipo Spotify
  
  # key (0-11), mode (0/1)
  musical <- tibble(
    key = sample(0:11, n_tracks, replace = TRUE),
    mode = sample(0:1,  n_tracks, replace = TRUE)
  )
  
  # Popularidad de pista (0-100) basada en pop del artista + rasgos + año
  # y ruido aleatorio; streams ~ lognormal dependiente de popularidad
  pop_noise <- rnorm(n_tracks, 0, 6)
  recency_boost <- scales::rescale(row$release_year, to = c(0, 10), from = c(2015, 2025))
  
  # Popularidad base del artista
  art_pop <- artist_popularity %>% filter(artist == row$artist) %>% pull(artist_popularity)
  
  # Score intermedio para popularidad de canción
  score <- pmin(100, pmax(0,
                          0.55 * art_pop +                       # artista importa mucho
                            10 * traits_df$danceability +
                            6  * traits_df$energy +
                            4  * traits_df$valence +
                            0.8 * recency_boost +
                            pop_noise
  ))
  
  popularity <- round(scales::rescale(score, to = c(20, 98)))
  
  # Streams (número grande); usamos una log-normal ajustada por popularidad
  mu_streams <- log(1e5) + (popularity - 50) / 25  # factor exponencial
  streams <- round(rlnorm(n_tracks, meanlog = mu_streams, sdlog = 0.6))
  
  bind_cols(base, traits_df, musical) %>%
    mutate(popularity = popularity,
           streams = streams)
}

songs <- albums %>%
  split(.$album) %>%
  map_df(~ make_songs_for_album(.x[1,]))

# Reordenamos columnas
spotify <- songs %>% select(
  track_id, track_name, artist, album, genre, release_year,
  duration_ms, explicit, key, mode,
  danceability, energy, valence, acousticness, instrumentalness, liveness, speechiness,
  tempo, popularity, streams
)

rm("albums","artist_popularity","genres","make_albums","make_songs_for_album","r01","sample_cluster","traits_from_cluster","artists","songs")

