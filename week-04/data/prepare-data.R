## Eduard Martinez
## R version 4.5.0

####== 1. Configuracion Inicial

## limpiar entorno
rm(list=ls())

## llamar/instalar librerias
require(pacman)
p_load(dplyr , ggplot2 , skimr , rio)

## reproducibilidad
set.seed(123)  

## n
n <- 2104

clientes <- tibble(
  id_cliente   = 1:n,
  edad         = sample(18:65, n, replace=TRUE),
  genero       = sample(c("Hombre","Mujer"), n, replace=TRUE, prob=c(0.45,0.55)),
  ciudad       = sample(c("Bogotá","Medellín","Cali","Barranquilla","Cartagena"),
                        n, replace=TRUE, prob=c(0.3,0.25,0.2,0.15,0.1)),
  segmento     = sample(c("Estudiante","Profesional","Empresario"),
                        n, replace=TRUE, prob=c(0.3,0.5,0.2)),
  tratamiento  = sample(c(0,1), n, replace=TRUE, prob=c(0.5,0.5))
) %>%
  mutate(
    ## número de compras depende de edad, tratamiento y segmento
    compras     = rpois(n, lambda = ifelse(tratamiento==1, 3, 2)) +
      ifelse(segmento=="Empresario", 2, 0),
    ## gasto total depende de compras y segmento
    gasto_total = round(compras * runif(n, 20000, 100000), -3),
    ## satisfacción depende de tratamiento y variabilidad aleatoria
    satisfaccion = pmin(5, pmax(1, round(rnorm(n, mean=3 + 0.5*tratamiento, sd=1))))
  )

## export data
export(clientes , "week-04/data/datos_clientes.rds")

