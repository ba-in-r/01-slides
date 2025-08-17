## Eduard Martinez
## R version 4.5.0

####== 1. Configuracion Inicial

## limpiar entorno
rm(list=ls())

## llamar/instalar librerias
require(pacman)
p_load(dplyr , ggplot2 , skimr , rio)

## Leer base de datos
clientes <- import("https://raw.githubusercontent.com/ba-in-r/01-slides/main/week-04/data/datos_clientes.rds")

## exploracion inicial de datos: skim()


## preparar datos: filter() ; ejemp: depurar NA


####== 2. Fundamentos de ggplot

### 1.1 ¿Que es ggplot2?

##  “Grammar of Graphics”
## 1. Datos: el conjunto que queremos graficar.
## 2. Aesthetics (aes): que variables queremos mostrar en el eje X, eje Y, color, tamano, etc.
## 3.	Geometrias (geom_), el tipo de grafico: barras, puntos, lineas, boxplots, etc.
## 4.	Temas y escalas: como personalizamos el diseno (colores, titulos, estilos).

### 1.2 Estructura base de ggplot
## ggplot(data= , aes(x= , y= ))


####== 2. Graficos basicos (geometrias)

### 2.1 Grafico de barras
## geom_bar() y geom_col()


### 2.2 Histograma
## geom_histogram()


### 2.3 Diagrama de dispersion
## geom_point()


### 2.4 Boxplot
## geom_boxplot()


####== 3. Atributos esteticos

### 3.1 Uso de color y fill
## Diferenciar categorias con color/fill


### 3.2 Uso de tamaño y forma
## Mapear variables numericas a size y shape


####== 4. Personalizacion de graficos

### 4.1 Etiquetas
## labs(title= , subtitle= , caption= , x= , y= )


### 4.2 Temas
## theme_minimal(), theme_classic(), theme_light()


### 4.3 Escalas
## scale_x_continuous(), scale_y_log10(), scale_fill_manual(), etc.


####== 5. Facetas

### 5.1 facet_wrap()
## Crear subgraficos para cada categoria de una variable


### 5.2 facet_grid()
## Comparar dos variables categoricas en forma de grilla


####== 6. Construccion de una narrativa

### 6.1 Elegir una pregunta de negocio
## Ejemplo: ¿que sectores concentran mas ingresos?


### 6.2 Secuencia de graficos
## Construir 2–3 graficos que respondan a la pregunta


### 6.3 Exportacion
## Guardar un grafico con ggsave()




