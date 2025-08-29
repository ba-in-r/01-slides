## Eduard Martinez
## R version 4.5.0

####==: 1. Configuracion Inicial

## limpiar entorno
rm(list=ls())

## llamar/instalar librerias
require(pacman)
p_load(dplyr , ggplot2 , skimr , rio)

## Chequear files
list.files(recursive = T)

####==: 2. Leer y explorar los datos

### Leer base de datos
rues <- import("https://raw.githubusercontent.com/ba-in-r/01-slides/main/week-05/week-05/input/empresas.rds")

### exploracion inicial de datos: skim()


### Filtrar los datos de las elecciones


####==: 3. Descriptivas de un conjunto de datos

### 3.1 Generales
# sum()
# mean()
# sd()
# summary()


####==: 4. Visualizar

### 4.1. EJemplo de visualizacion


### 4.2. EJemplo de visualizacion


####==: 5. Resumen y agregación

### 5.1 summarise() con estadísticos básicos (mean(), median(), sd(), n()).


### 5.2 group_by() para agrupamientos.


### 5.3 Otros ejemplos de agrupamiento


####==: 6. Visualizar

### 6.1. EJemplo de visualizacion con datos agregados


### 6.2. EJemplo de visualizacion con datos agregados


