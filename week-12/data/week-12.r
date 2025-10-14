# Limpiar el entorno de trabajo
rm(list = ls())

## packages
require(dplyr)

# Productos disponibles en el supermercado
productos <- c("Leche", "Pan", "Mantequilla", "Cereal", "Huevos",
               "Queso", "Café", "Azúcar", "Frutas", "Verduras")

# Simular 20 transacciones con productos aleatorios
set.seed(123)
ventas <- lapply(1:100, function(i) {
  sample(productos, size = sample(2:6, 1), replace = FALSE)
})

# Revisar algunas transacciones
rm(productos)
cat("\f")
ventas[1:5]


