## limpiar entorno
rm(list = ls())

## cargar paquetes
require(wordcloud)    # Generación de wordclouds
require(RColorBrewer) # Paletas de colores
require(dplyr)        # Manipulación de datos
require(stringr)      # Procesamiento de strings

## generar corpus de comentarios
comentarios <- c(
  "El producto es excelente, muy buena calidad y llegó rápido a mi casa",
  "Servicio al cliente excepcional, recomiendo totalmente esta tienda online",  
  "La entrega fue un poco lenta pero el producto cumple todas las expectativas",
  "Excelente relación calidad precio, muy satisfecho con esta compra",
  "El producto llegó defectuoso, tuve que hacer la devolución inmediatamente",
  "Buena calidad en general pero el precio me parece un poco elevado",
  "Servicio rápido y muy eficiente, el producto es exactamente como se describe",
  "No recomiendo para nada este producto, la calidad es muy mala",
  "Excelente atención al cliente y producto de muy alta calidad",
  "La entrega fue perfecta y el producto supera las expectativas iniciales",
  "Precio competitivo y buena calidad, definitivamente volvería a comprar aquí",
  "El servicio postventa es excelente, resolvieron mi problema rápidamente"
)

## crear dataframe
corpus_df <- data.frame(
  id = 1:length(comentarios),
  texto = comentarios,
  stringsAsFactors = FALSE
)

rm(comentarios)