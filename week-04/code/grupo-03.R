## Eduard Martinez
## R version 4.5.0

####==: 1. Configuracion Inicial

## limpiar entorno
rm(list=ls())

## llamar/instalar librerias
require(pacman)
p_load(dplyr , ggplot2 , skimr , rio)

## Leer base de datos
clientes <- import("https://raw.githubusercontent.com/ba-in-r/01-slides/main/week-04/data/datos_clientes.rds")
ls()

## exploracion inicial de datos: skim()
skim(clientes)

## preparar datos: filter() ; ejemp: depurar NA


####==: 2. Fundamentos de ggplot

### 2.1 Data to Viz
browseURL("https://r-graph-gallery.com")
browseURL("https://www.data-to-viz.com")

### 2.2 ¿Que es ggplot2?

##  “Grammar of Graphics”
## 1. Datos: el conjunto que queremos graficar.
## 2. Aesthetics (aes): que variables queremos mostrar en el eje X, eje Y, color, tamano, etc.
## 3.	Geometrias (geom_), el tipo de grafico: barras, puntos, lineas, boxplots, etc.
## 4.	Temas y escalas: como personalizamos el diseno (colores, titulos, estilos).

### 2.2 Estructura base de ggplot
## ggplot(data= , aes(x= , y= ))
ggplot(data=clientes , mapping=aes(x=satisfaccion))

####==: 3. Graficos basicos (geometrias)

## cheat sheet ggplot
browseURL("https://rstudio.github.io/cheatsheets/data-visualization.pdf")

### 3.1 Grafico de barras
## geom_bar() y geom_col()
ggplot(data=clientes , mapping=aes(x=satisfaccion)) +
geom_bar()

### 3.2 Histograma
## geom_histogram()
ggplot(data=clientes , mapping=aes(x=gasto_total)) +
geom_histogram()

### 3.3 Diagrama de dispersion
## geom_point()
ggplot(data=clientes , mapping=aes(x=gasto_total , y=satisfaccion)) +
geom_point()

### 3.4 Boxplot
## geom_boxplot()
ggplot(data=clientes , mapping=aes(x=gasto_total , group=satisfaccion)) +
geom_boxplot()

####== 4. Atributos esteticos

### 4.1 Uso de color y fill
## Diferenciar categorias con color/fill
ggplot(data=clientes , mapping=aes(x=gasto_total , y=compras , color=genero)) +
geom_jitter()

### 4.2 Uso de tamaño y forma
## Mapear variables numericas a size y shape
ggplot(data=clientes , mapping=aes(x=gasto_total , y=compras , color=genero , size=edad)) +
geom_jitter()

####== 5. Personalizacion de graficos

### 5.1 Etiquetas
## labs(title= , subtitle= , caption= , x= , y= )
ggplot(data=clientes , aes(x=gasto_total , group=genero , color=genero)) +
geom_density() +
labs(title="Densidad de compras por sexo" , x="Valor en pesos")

### 5.2 Temas
## theme_minimal(), theme_classic(), theme_light()
ggplot(data=clientes , aes(x=gasto_total , group=genero , color=genero)) +
geom_density() +
labs(title="Densidad de compras por sexo" , x="Valor en pesos" , color="Sexo") +
theme_light()

### 5.3 Escalas
## scale_x_continuous(), scale_y_log10(), scale_fill_manual(), etc.
ggplot(data=clientes , aes(x=gasto_total , group=genero , color=genero)) +
geom_density() +
labs(title="Densidad de compras por sexo" , x="Valor en pesos" , color="Sexo") +
theme_light() +
scale_x_continuous(breaks=seq(100000,1200000,150000))

####== 6. Facetas

### 6.1 facet_wrap()
## Crear subgraficos para cada categoria de una variable
ggplot(data=clientes , aes(x=satisfaccion)) +
geom_bar() +
theme_bw() +
facet_wrap(~tratamiento)

### 6.2 facet_grid()
## Comparar dos variables categoricas en forma de grilla


####== 7. Construccion de una narrativa

### 7.1 Elegir una pregunta de negocio
## Ejemplo: ¿que sectores concentran mas ingresos?


### 7.2 Secuencia de graficos
## Construir 2–3 graficos que respondan a la pregunta


### 7.3 Exportacion
## Guardar un grafico con ggsave()




