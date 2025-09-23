library(dplyr)
library(NbClust) #Indices de clusters
library(factoextra) #Graficar los indices de los clusters
library(cluster) #Otro metodo pal numero de clusters
library(ggplot2) #Pa el numero de clusters de NbClust

datos_originales <- read.csv("Credit_Card_Customer_Data.csv")
glimpse(datos_originales)

#Variables 1 y 2 son de identifiación del cliente por lo que no son utiles para
#el analisis:
datos <- datos_originales[, -c(1, 2)]
glimpse(datos)

#Vemos si se pueden visualizar facilmente los clusters
plot(datos)


#Clustering Jerarquico
#Estandarizar los datos:
datos2 <- as.data.frame(scale(datos))
glimpse(datos2)

datos2 <- datos2 %>%
  mutate_if(is.double, as.numeric)
#Esto nos sirve para calcular las distancias más facil

#Calcular la distancia euclidiana:
datos_dist <- dist(datos2)
class(datos_dist)
#Es clase dist, es decir, una matriz de distancia

#Construir los clusters jerarquicos con el modelo de agregación centroide:
hclust_centroide <- hclust(datos_dist, method = "centroid")
hclust_centroide
class(hclust_centroide)
#Hay varios metodos para el cluster, pero en este caso se uso centroide

#Generar el dendograma
plot(hclust_centroide)
#Se ve horrible entonces lo vamos a solucionar
plot(as.dendrogram(hclust_centroide), main = "Dendrograma Método Centroide", 
     type = "rectangle", horiz = TRUE, hang = -1, cex = 0.2, 
     xlab = "Distancia")
#As.dendrogram lo hace un dendrograma más claro, main es titulo, type es pa que
#las columnas sean rectangulos, horiz es coord_flip, hang hace que las
#observaciones esten en la misma altura, cex es pal tamaño del texto de las
#observaciones, y xlab es pal rotulo del x.

#Cambiemos el criterio del cluster
hclust_media <- hclust(datos_dist, method = "average")
plot(hclust_media, main = "Dendrograma Método Promedio", hang = -1, cex = 0.2)

#Determinar el numero de clusters (emplear 30 indicadores de uso más común):
res_centroid <- NbClust(datos2, distance = "euclidean", min.nc = 2,
                        max.nc = 10, method = "centroid", index = "all")

str(res_centroid)
res_centroid$All.index
#Min.nc es el numero de minimo de clusters y max es el maximo, por defecto son
#2 e 15, index es el indice que se planea calcular, se puede hacer 1 solamente,
#por defecto es all.

fviz_nbclust(res_centroid, ggtheme = theme_minimal())
#No me sirvio (hablar con el profesor en la clase), en todo caso es 5 el optimo
#porque dice en la consola.

votes_centroid <- as.data.frame(table(res_centroid$Best.nc[1, ])) %>%
  rename(Clusters = Var1, Votes = Freq) %>%
  mutate(Clusters = as.numeric(as.character(Clusters)))

votes_centroid %>%
  ggplot(aes(x = Clusters, y = Votes)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Número óptimo de clusters según NbClust",
       x = "Número de clusters",
       y = "Cantidad de índices que lo recomiendan") +
  theme_minimal()
#Alternativa pa fviz_nbclust (no usar si les sirve la funcion fviz)

#El otro criterio que hicimos antes
res_media <- NbClust(datos2, distance = "euclidean", min.nc = 2, 
                     max.nc = 10, method = "average", index = "all")
#El numero optimo de clusters es 3 para la mayoria

votes_media <- as.data.frame(table(res_media$Best.nc[1, ])) %>%
  rename(Clusters = Var1, Votes = Freq) %>%
  mutate(Clusters = as.numeric(as.character(Clusters)))

votes_media %>%
  ggplot(aes(x = Clusters, y = Votes)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Número óptimo de clusters según NbClust",
       x = "Número de clusters",
       y = "Cantidad de índices que lo recomiendan") +
  theme_minimal()

#Emplear siluetas para el numero de clusters
plot(silhouette(cutree(hclust_centroide, 5), datos_dist))
#Ningún grafico de esta puta unidad me sirve, en todo caso el 2 no es tan util,
#porque la silueta promedio es de 0.44

#Manualmente
sil_centroid.5 <- silhouette(cutree(hclust_centroide, 5), datos_dist)
mean(sil_centroid.5[, "sil_width"])
fviz_silhouette(sil_centroid.5)
#Este me sirvio (no usar si les sirve el plot)

#Intentar con 2 clusters
sil_centroid.2 <- silhouette(cutree(hclust_centroide, 2), datos_dist)
mean(sil_centroid.2[, "sil_width"])
fviz_silhouette(sil_centroid.2)
#2 tiene un mejor promedio que 5 por lo que puede ser una mejor opcion, ahora
#revisaremos 3

sil_centroid.3 <- silhouette(cutree(hclust_centroide, 3), datos_dist)
mean(sil_centroid.3[, "sil_width"])
fviz_silhouette(sil_centroid.3)
#Promedio de 0.37

sil_centroid.4 <- silhouette(cutree(hclust_centroide, 4), datos_dist)
mean(sil_centroid.4[, "sil_width"])
#Promedio de 0.21
#Es mejor el de 2 clusters

#Ahora con el de la media
sil_media.3 <- silhouette(cutree(hclust_media, 3), datos_dist)
mean(sil_media.3[, "sil_width"])
fviz_silhouette(sil_media.3)
#Tiene un promedio de 0.52

sil_media.2 <- silhouette(cutree(hclust_media, 2), datos_dist)
mean(sil_media.2[, "sil_width"])
fviz_silhouette(sil_media.2)
#Promedio de 0.57
#Sigue siendo mejor 2 clusters
#Un promedio entre 0.51 y 0.7 son los mejores

#Hacer eso pero con otros metodos para ver cual es el mejor resultado
#Metodo de enlace completo
hclust_completo <- hclust(datos_dist, method = "complete")
res_completo <- NbClust(datos2, distance = "euclidean", min.nc = 2,
                        max.nc = 10, method = "complete", index = "all")
#La mayoria de indices dice que es mejor 3

#Visualizar los totales
votes_completo <- as.data.frame(table(res_completo$Best.nc[1, ])) %>%
  rename(Clusters = Var1, Votes = Freq) %>%
  mutate(Clusters = as.numeric(as.character(Clusters)))

votes_completo %>%
  ggplot(aes(x = Clusters, y = Votes)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Número óptimo de clusters según NbClust",
       x = "Número de clusters",
       y = "Cantidad de índices que lo recomiendan") +
  theme_minimal()

#Ver promedio de silueta entre 2 y 3 para ver que es mejor
sil_completo.2 <- silhouette(cutree(hclust_completo, 2), datos_dist)
mean(sil_completo.2[, "sil_width"])
fviz_silhouette(sil_completo.2)

sil_completo.3 <- silhouette(cutree(hclust_completo, 3), datos_dist)
mean(sil_completo.3[, "sil_width"])
fviz_silhouette(sil_completo.3)
#Es mejor 2

#Y asi lo mismo con otros metodos como mcquitty (2 clusters), ward.D, ward.D2
#(3 clusters)

#Se puede tmb revisar con otros tipos de distancia

#Realizar los clusters (2) con el metodo promedio
grupos_media <- cutree(hclust_media, 2)
head(grupos_media, 10)
#Los 1s son el primer cluster y los 2 son el segundo

#Incluir esos grupos a los datos originales:
datos_con_segmentacion <- cbind(datos_originales, (as.factor(grupos_media)))
names(datos_con_segmentacion)[8] <- "cluster"
str(datos_con_segmentacion)

#Comparar la media con el centroide
grupos_centroide = cutree(hclust_centroide, 2)
table(grupos_media, grupos_centroide)
#Se nota que estos dos dan exactamente los mismos resultados

plot(table(grupos_media, grupos_centroide), main = "Matriz de confusión para los dos
algoritmos de clasificación",
     xlab = "Centroide", ylab = "Enlace promedio")
#Como solo hay 2 cajas entonces los grupos son los mismos.

#Ver los clusters graficamente
#geom_jitter
datos_con_segmentacion %>%
  ggplot(aes(x = Total_Credit_Cards, y = Avg_Credit_Limit, col = cluster)) +
  geom_jitter(alpha = 0.6)

#Mostrar los clusters en el dendrograma
plot(hclust_media, main = "Dendrograma Método de Enlace Promedio",
     hang = -1, cex = 0.1, ylab = "Distancia")
rect.hclust(hclust_media, k = 2, border = 2:5)

#Dendrograma y mapa de clusters visualizados de mejor manera
fviz_dend(hclust_media, k = 2, cex = 0.5, color_labels_by_k = TRUE,
          rect = TRUE)

fviz_cluster(list(data = datos2, cluster = grupos_media)) + 
  theme_minimal()


#Clustering Particionado
#Usamos exactamente los mismo, solo que ahora usamos el metodo de kmeans
#Puesto que este hace un clustering particionado (que no se sobrepongan)
res_kmeans <- NbClust(datos2, distance = "euclidean", min.nc = 2,
                        max.nc = 10, method = "kmeans", index = "all")

votes_kmeans <- as.data.frame(table(res_kmeans$Best.nc[1, ])) %>%
  rename(Clusters = Var1, Votes = Freq) %>%
  mutate(Clusters = as.numeric(as.character(Clusters)))

votes_kmeans %>%
  ggplot(aes(x = Clusters, y = Votes)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  labs(title = "Número óptimo de clusters según NbClust",
       x = "Número de clusters",
       y = "Cantidad de índices que lo recomiendan") +
  theme_minimal()

#Una silueta que dice directamente cual es mejor (solo funciona con kmeans)
fviz_nbclust(datos2, kmeans, method = "silhouette", k.max = 10) +
  theme_minimal() + 
  ggtitle("Coeficiente de silueta")

kmeans1 = kmeans(datos2, 2)

plot(silhouette(kmeans1$cluster, dist(datos2)), border = NA)
#Este si me sirvio, el promedio es mucho menor que el conseguido en los clusters
#jerarquicos, y esto es porque el algoritmo jerarquico es más adecuado

#Calcular los clusters de kmeans
cluster_kmeans <- kmeans(x = datos2, centers = 2)
attributes(cluster_kmeans) #Todos los compartimientos del objeto
#Cluster es un vector de numeros enteros (el grupo), centers es el centro de cada
#grupo, size es el numero de observaciones en cada cluster

cluster_kmeans$size
#El tamaño de cada cluster

grupos_kmeans <- cluster_kmeans$cluster
#Extraer los grupos de cada cluster

#Comparar los clusters de kmeans con el del jerarquico
table(grupos_kmeans, grupos_media)
plot(table(grupos_media, grupos_kmeans), main = "Matriz de confusión para los dos
algoritmos de clasificación",
     xlab = "Centroide", ylab = "Enlace promedio")
#Se ve que en el grupo 1 del kmeans estan todos los del promedio, pero en el 
#grupo 1 del promedio 386 personas estan el grupo 2. De igual manera en el grupo 
#2 de kmeans hay solo 50 personas que estan en comun

#Visualizar los clusters
fviz_cluster(cluster_kmeans, datos2) + 
  theme_minimal()

