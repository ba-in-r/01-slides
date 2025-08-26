## Eduard Martinez
## R version 4.5.0

####==: 1. Configuracion Inicial

## limpiar entorno
rm(list=ls())

## llamar/instalar librerias
require(pacman)
p_load(dplyr , skimr , rio)

## Leer base de datos
clientes <- import("https://raw.githubusercontent.com/ba-in-r/01-slides/main/week-04/data/datos_clientes.rds")

## exploracion inicial de datos: skim()


####==: 2. Fundamentos de ggplot

### 1.1 ¿Que es ggplot2?

##==: 1. Operador pipe (%>%)

### Veamos un ejemplo:
df = as_tibble(x = women)

## Otra forma de hacerlo es emplear el operador pipe `%>%`:  


## Con `%>%` no es necesario mencionar el objeto en cada nueva transformación. Además, las líneas de código se redujeron a la mitad.

### Veamos otro ejemplo:

## Intente reescribir el siguiente código usando el operador `%>%`:
df <- import("https://www.datos.gov.co/resource/epsv-yhtj.csv")
df <- as_tibble(df)
df <- select(df, -cod_ase_)
df <- mutate(df,ifelse(is.na(estrato),1,estrato))


## **[2.] Combinar conjuntos de datos (adicionar filas/columnas)**

### **2.1 Agregar observaciones**

## Generar conjuntos de datos para hacer la aplicación:
set.seed(0117) # Fijar semilla
obs_1 = tibble(id = 100:105 , 
               age = runif(6,18,25) %>% round() , 
               height = rnorm(6,170,10) %>% round())

obs_2 = tibble(id = 106:107 , 
               age = runif(2,40,50)  %>% round() , 
               height = rnorm(2,165,8) %>% round() , 
               name = c("Lee","Bo"))

## Inspeccionar los datos:


## Combinar el conjunto de datos (bind_rows): 

### **2.2 Adicionar variables a un conjunto de datos**
db_1 <- tibble(id = 102:105 , income = runif(4,1000,2000) %>% round())
db_2 <- tibble(id = 103:106 , age = runif(4,30,40)  %>% round())

## Inspeccionar los datos:


## Combinar el conjunto de datos (bind_cols): 
print("Algo salió mal! la función bind_cols() no tiene en cuenta el identificador de cada observación.") 

### **2.3 Adicionar variables a un conjunto de datos:** `join()`

## Puede adicionar variables a un conjunto de datos usando la familia de funciones de `join()`:
data_1 <- tibble(Casa=c(101,201,201,301),
                 Visita=c(2,1,2,1),
                 Sexo=c("Mujer","Mujer","Hombre","Hombre"))
data_2 <- tibble(Casa=c(101,101,201,201),
                 Visita=c(1,2,1,2),
                 Edad=c(23,35,7,24),
                 Ingresos=c(500000,1000000,NA,2000000))

#### **Ejemplo: left_join()**


#### **Ejemplo: right_join()**


#### **Ejemplo: inner_join()**


#### **Ejemplo: full_join()**


#### **Ejemplo: Join sin identificador único**


### **3.4 Chequear valores unicos**
df_1 <- tibble(Hogar=1,Visita=1,Sexo=1)
df_2 <- tibble(Hogar=1,Visita=1,Edad=1,Ingresos=1)

## Coincidencia en variables:

## unique



## Eduard Martinez
## Update: 11-03-2024

## limpiar entonro
rm(list=ls())

## instalar/llamar pacman
require(pacman)

## usar la función p_load de pacman para instalar/llamar las librerías de la clase
p_load(tidyverse, ## manipular/limpiar conjuntos de datos.
       rio, ## para leer/escribir archivos desde diferentes formatos. 
       skimr, ## skim: describir un conjunto de datos
       janitor) ##  tabyl: frecuencias relativas

## **[1.] Aplicación: GEIH*

# Importe 
cg <- import("input/Enero - Cabecera - Caracteristicas generales (Personas).csv") %>% clean_names()

ocu <- import("input/Enero - Cabecera - Ocupados.csv") %>% clean_names()

# verifique las llaves con el siguiente vector c("directorio","secuencia_p","orden")

# colapse los datos de la GEIH
geih <- left_join(x = cg, y = ocu, by = c("directorio","secuencia_p","orden"))

## **[2.] Descriptivas de un conjunto de datos**

### **2.1 Generales**

# Utilice summary para una descripción general 

# select + summarize_all 


### **2.2 Agrupadas**

# ingreso laboral promedio por sexo

# ingreso laboral promedio por sexo y tipo de contrato

# ingreso laboral promedio/mediano y años promedio en fondo de pension por sexo

# ingreso laboral promedio/mediano y años promedio en fondo de pension por sexo y tipo contrato

# guardar resultados en objeto


### **2.3 Pivotear**

# pivot_longer

# pivot_wider



## Clase 06
## Eduard Martinez
## Update: 2023-09-13

## [1.] Checklist
### Lectures previas
### Script de la clase
### Versión de R
R.version.string

### Librerías
# Instalar/llamar pacman
require(pacman)

# Usar la función p_load de pacman para instalar/llamar las librerías de la clase
p_load(rio, skimr, janitor)

## [2.] ¿Qué es tidy-data?
### 2.1. Raw data y tidy data
### 2.2. Reglas de un conjunto de datos tidy
### 2.3. tidyverse
# Instalar y cargar el tidyverse en su entorno de R
library("tidyverse")

### 2.4. Instalar y cargar el tidyverse en su entorno de R

## [3.] Adicionar variables a un conjunto de datos
### 3.1. Conjuntos de datos disponibles en la memoria de R
data(package="datasets")

### 3.2 Función $
# Crear un objeto con la base de datos mtcars
df = as_tibble(x = women)

# Crear una variable con la estatura en centímetros
df$height_cm = df$height*2.54

### 3.3 mutate()
# Generar una variable con la relación weight/height_cm
df = mutate(.data = df , weight_hcm = weight/height_cm)

### 3.4 Generar variables usando condicionales
df$height_180 = ifelse(test=df$height_cm>180 , yes=1 , no=0)
df = mutate(.data=df , sobrepeso = ifelse(test=weight_hcm>=0.85 , yes=1 , no=0))

# Generar una variable con categorías para la relación weight/height_cm
df = mutate(df , category = case_when(weight_hcm>=0.85 ~ "pesado",
                                      weight_hcm>=0.8 & weight_hcm<0.85 ~ "promedio",
                                      weight_hcm<0.8 ~ "liviano"))

### 3.5 Aplicar funciones a variables
# Convertir todas las variables en caracteres
df = mutate_all(.tbl=df , .funs = as.character)

# Convertir solo algunas variables a numéricas
df = mutate_at(.tbl=df , .vars = c("height","weight","height_cm","weight_hcm"),.funs = as.numeric)

# Convertir a numéricas solo las variables que son caracteres
df2 = mutate_if(.tbl=df , .predicate = is.character,.funs = as.numeric)

## [4.] Remover filas y/o columnas
### 4.1 Seleccionar variables
# Seleccionar variables usando partes del nombre
select(.data = db[1:3,], starts_with("Sepal"))

# Seleccionar variables usando el tipo
select_if(.tbl = db[1:3,], is.character)

# Seleccionar variables usando un vector
vars = c("Species","Sepal.Length","Petal.Width")
select(.data = db[1:3,], all_of(vars))

# Deseleccionar variables
select(.data = db[1:3,], -Species)

### 4.2 Remover filas/observaciones
# Remover filas usando condicionales
subset(x = df, height > 180)
filter(.data = df, mass > 100)



## Formatos *wide* y *long* (pivot_longer(), pivot_wider()).
clientes <- import("https://raw.githubusercontent.com/eduard-martinez/datasets/main/week-04/output/clientes_cali.rds")

####== 7. Introducción al operador pipe

## Qué es y por qué mejora la legibilidad (|> y %>%).


## Ejemplos simples (sin dplyr) → comparación sin pipe / con pipe.


## Aplicar pipe en dplyr sobre ejemplos ya vistos (filter() + select() + arrange()).


####== 8. Resumen y agregación

## summarise() con estadísticos básicos (mean(), median(), sd(), n()).

## group_by() para agrupamientos.

## Varias agregaciones en un pipeline.


####== 9. Unión de bases de datos

### Tipos de *joins*.

## Claves primarias y foráneas.
sedes <- import("https://raw.githubusercontent.com/eduard-martinez/datasets/main/week-04/output/sedes_cali.rds")

####== 10. Encadenamiento de operaciones completo

### Flujo: importar → explorar → filtrar → transformar → resumir → exportar.

### Lectura vertical con pipe.


