## Eduard Martinez
## R version 4.5.0

####== 1. Configuracion Inicial

## limpiar entorno
rm(list=ls())

## llamar librerias
require(dplyr)
require(skimr)
require(janitor)
require(rio)

## Leer base de datos: creemos un objeto llamado db (ustedes pueden asignar otro nombre)
db = import("https://raw.githubusercontent.com/eduard-martinez/datasets/main/week-04/output/empresas_cali.rds")

####== 2. Exploracion inicial de datos

### 2.1. Inspeccion general

## glimpse()


## skim()


## head()


## tail()


## acceder a una variable: $ ; ejemp. table()


### 2.2. Revisar nombres de variables

## chequear nombres: names()


## Buenas practicas (nombres claros): clean_names()  ; ejemp: crear objeto llamado "data"


## renombrar una variable: rename() ; ejemp: nombre_mpio=mpio_name


####== 3. Seleccion y filtrado de datos

### 3.1. Mantener variables por nombre, rango o patron 

## mantener determinadas variables: select() ; ejemp: razon_social, ciuu1 y year_matricula


## eliminar una variable: select() ; ejem: dpto_name


## starts_with(): ejemp: razon_social y variables que inician por ciiu


## starts_with(): ejemp: razon_social y variables que terminan en _m


### 3.2. Segun condiciones (==, !=, <, >, %in%, between()).

## filter()
quantile(db$activos_m , seq(0,1,0.01))
quantile(db$patrimonio_m , seq(0,1,0.01))
quantile(db$pasivos_m , seq(0,1,0.01))

### 3.3. Combinar condiciones con & y |.
empresas = filter(.data=db , activos_m <= 20000)
empresas = filter(.data=db , activos_m>=1000 & activos_m <= 20000)

####== 4. Ordenamiento

## arrange() ascendente y descendente (desc()).
empresas = arrange(empresas , activos_m)

empresas = arrange(empresas , desc(activos_m),patrimonio_m)
View(empresas).    

## Ordenar por multiples columnas.

####== 5. Creacion y modificacion de variables

## mutate() para nuevas columnas o transformar existentes.
empresas = mutate(empresas , positivo = ingresos_m > 0)
table(empresas$positivo)

empresas = mutate(empresas , positivo_d = ifelse(ingresos_m > 0,1,0)) 

empresas = mutate(empresas , ciiu1 = as.numeric(ciiu1)) 

## Funciones utiles: case_when(), nchar(), as.numeric().
empresas = mutate(empresas , rango = 
                             case_when(activos_m < 5000 ~ "menor a 5000" , 
                                       activos_m > 10000 ~ "mayor a 10000",
                                       activos_m >= 5000 & activos_m <= 10000 ~ "entre 5000 y 10000"
                                       )
                  )

View(empresas)
table(empresas$rango)




