## Eduard Martinez
## R version 4.5.0

####== 1. Configuracion Inicial

## limpiar entorno
rm(list = ls())

## llamar librerías
require(dplyr)
require(skimr)
require(janitor)
require(rio)
require(data.table)
require(stringi)

## importar y filtrar
df <- tibble(dpto_name=rep("Valle",50269) , mpio_name=rep("Cali",50269), unique_id=1:50269)

## número de filas
n <- nrow(df)
set.seed(123)

## generar razon_social ficticia
nombres <- c("ALFA", "BETA", "OMEGA", "DELTA", "GAMMA", "ZETA", "TERRA", "NOVA", "SOLAR", "LUNAR")
tipos <- c("S.A.S", "LTDA", "S.A", "E.U", "S.C.A", "S.C.S")
rubros <- c("CONSTRUCCIONES", "RESTAURANTE", "TEXTILES", "SERVICIOS", "LOGÍSTICA", "TECNOLOGÍA", "CONSULTORÍA")

df$razon_social <- paste(
  sample(nombres, n, replace = TRUE),
  sample(rubros, n, replace = TRUE),
  sample(tipos, n, replace = TRUE)
)

## generar códigos CIIU simulados
ciiu_base <- sprintf("%04d", sample(1000:9999, 500, replace = FALSE))  # 500 códigos únicos

df$ciiu1 <- sample(ciiu_base, n, replace = TRUE)
df$ciiu2 <- sample(c("", ciiu_base), n, replace = TRUE, prob = c(0.5, rep(0.5 / length(ciiu_base), length(ciiu_base))))
df$ciiu3 <- sample(c("", ciiu_base), n, replace = TRUE, prob = c(0.75, rep(0.25 / length(ciiu_base), length(ciiu_base))))
df$ciiu4 <- sample(c("", ciiu_base), n, replace = TRUE, prob = c(0.85, rep(0.15 / length(ciiu_base), length(ciiu_base))))

## generar años aleatorios
df$year_matricula <- sample(1980:2025, size = n, replace = TRUE)
df$year_renueva   <- sample(1980:2025, size = n, replace = TRUE)
df$year_cancela   <- sample(c(NA, 1980:2025), size = n, replace = TRUE, prob = c(0.8, rep(0.2 / length(1980:2025), length(1980:2025))))

## crear variables financieras
df$`Activos M.`    <- round(rnorm(n, mean = 10000, sd = 2500))
df$`Ingresos M.`   <- round(rnorm(n, mean = 5000, sd = 2000))
df$`Pasivos M.`    <- round(rnorm(n, mean = -2000, sd = 2000))
df$`Patrimonio M.` <- df$`Activos M.` + df$`Pasivos M.`

## agregar error en 5% de las filas
filas_error <- sample(1:n, size = round(n * 0.05))
df$`Activos M.`[filas_error] <- 999999

## export datos
export(df , "week-03/data/empresas_cali.rds")


