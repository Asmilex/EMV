## -----------------------------------------------------------------------------
library(foreign)
datos <- read.spss("./datasets/DB_2.sav", to.data.frame = TRUE, reencode = "utf-8")
datos


## -----------------------------------------------------------------------------
summary(datos)


## -----------------------------------------------------------------------------
datos <- datos[-14, ]
colSums(is.na(datos))


## -----------------------------------------------------------------------------
summary(datos)


## -----------------------------------------------------------------------------
boxplot (
  datos,
  main = "Análisis exploratorio de datos",
  xlab = "Indicadores",
  ylab = "Valor",
  col = c(1 : 15)
)


## -----------------------------------------------------------------------------
library(moments)
skewness(datos)


## -----------------------------------------------------------------------------
library("performance")
check_outliers(datos, method = "mahalanobis")


## -----------------------------------------------------------------------------
round(colMeans(datos), 5)


## -----------------------------------------------------------------------------
round(apply(datos, 2, sd), 5)


## -----------------------------------------------------------------------------
datos_normalizados <- scale(datos)
datos_normalizados


## -----------------------------------------------------------------------------
round(colMeans(datos_normalizados), 5)


## -----------------------------------------------------------------------------
round(apply(datos_normalizados, 2, sd), 5)


## -----------------------------------------------------------------------------
par(mar = c(1, 1, 1, 1))
par(mfrow = c(2, 4))

invisible(apply(datos_normalizados, 2, function(x) {
  qqnorm(x, main = NULL)
  abline(a = 0, b = 1, col = "#00b894")
}))


## -----------------------------------------------------------------------------
datos_pca <- datos_normalizados


## -----------------------------------------------------------------------------
library("psych")
cortest.bartlett(cor(datos_pca), nrow(datos_pca))


## -----------------------------------------------------------------------------
round(cor(datos_pca), 5)


## -----------------------------------------------------------------------------
boxplot (
  datos_pca,
  main = "Análisis exploratorio de datos",
  xlab = "Indicadores",
  ylab = "Valor",
  col = c(1 : 15)
)


## -----------------------------------------------------------------------------
check_outliers(datos_pca, method = "mahalanobis")


## -----------------------------------------------------------------------------
outlier <- function(data, na_rm = T) {
        H <- 1.5 * IQR(data)
        data[data < quantile(data, 0.25, na.rm = T) - H] <- NA
        data[data > quantile(data, 0.75, na.rm = T) + H] <- NA
        data[is.na(data)] <- mean(data, na.rm = T)
        data
}

#datos_pca <- apply(datos_pca, 2, outlier)


## -----------------------------------------------------------------------------
datos_pca


## -----------------------------------------------------------------------------
PCA <- prcomp(datos_pca, scale = T, center = T)


## -----------------------------------------------------------------------------
PCA$rotation


## -----------------------------------------------------------------------------
PCA$sdev
summary(PCA)


## -----------------------------------------------------------------------------
library(ggplot2)
varianza_explicada <- PCA$sdev^2 / sum(PCA$sdev^2)
ggplot(
  data = data.frame(varianza_explicada, pc = 1:8),
  aes(x = pc, y = varianza_explicada, fill = varianza_explicada)
) + geom_col(width = 0.3) +
    scale_y_continuous(limits = c(0,0.6)) +
    theme_minimal() +
    labs(x = "Componente principal", y= "Proporcion de varianza explicada")


## -----------------------------------------------------------------------------
varianza_acum <- cumsum(varianza_explicada)
ggplot(
  data = data.frame(varianza_acum, pc = 1:8),
  aes(x = pc, y = varianza_acum ,fill=varianza_acum )
) + geom_col(width = 0.5) +
    scale_y_continuous(limits = c(0,1)) +
    theme_minimal() +
    labs(x = "Componente principal", y = "Proporcion varianza acumulada")


## -----------------------------------------------------------------------------
PCA$sdev^2


## -----------------------------------------------------------------------------
mean(PCA$sdev^2)


## -----------------------------------------------------------------------------
ggplot(
  data = data.frame(varianza_acum, pc = 1:8),
  aes(x = pc, y = varianza_acum)
) + geom_line(size = 1, colour = "#00b894") +
    geom_point(size = 2.5, colour = "#2c3e50") +
    scale_y_continuous(limits = c(0, 1)) +
    theme_minimal() +
    labs(x = "Componente principal", y = "Proporcion varianza acumulada")


## -----------------------------------------------------------------------------
library("factoextra")
fviz_pca(
  PCA,
  axes = c(1, 2),
  alpha.ind = "contrib",
  col.var = "cos2", col.ind = "#2c3e50",
  gradient.cols = c("#ddd839", "#f7a438", "#e9473b"),
  repel = TRUE,
  legend.title = "Distancia"
) + theme_bw()



## -----------------------------------------------------------------------------
fviz_pca(
  PCA,
  axes = c(1, 3),
  alpha.ind = "contrib",
  col.var = "cos2",
  col.ind = "#2c3e50",
  gradient.cols = c("#ddd839", "#f7a438", "#e9473b"),
  repel = TRUE,
  legend.title = "Distancia"
) + theme_bw()


## -----------------------------------------------------------------------------
fviz_pca(
  PCA,
  axes = c(2, 3),
  alpha.ind = "contrib",
  col.var = "cos2",
  col.ind = "#2c3e50",
  gradient.cols = c("#ddd839", "#f7a438", "#e9473b"),
  repel = TRUE,
  legend.title = "Distancia"
  ) + theme_bw()


## -----------------------------------------------------------------------------
library("polycor")
library("ggcorrplot")
datos_af <- datos_normalizados
poly_cor <- hetcor(datos_af)$correlations
ggcorrplot(poly_cor, type = "lower", hc.order = T)


## -----------------------------------------------------------------------------
modelo1 <- fa(
  poly_cor,
  nfactors = 3,
  rotate = "none",
  fm = "mle"
) # modelo máxima verosimilitud


## -----------------------------------------------------------------------------
modelo2 <- fa(
  poly_cor,
  nfactors = 3,
  rotate = "none",
  fm = "minres"
) # modelo mínimo residuo


## -----------------------------------------------------------------------------
sort(modelo1$communality,decreasing = T) -> c1
sort(modelo2$communality,decreasing = T) -> c2
head(cbind(c1,c2))


## -----------------------------------------------------------------------------
sort(modelo1$uniquenesses, decreasing = T) -> u1
sort(modelo2$uniquenesses, decreasing = T) -> u2
head(cbind(u1,u2))


## -----------------------------------------------------------------------------
scree(poly_cor)
fa.parallel(poly_cor, n.obs = 13, fa = "fa", fm = "mle")


## -----------------------------------------------------------------------------
modelo_varimax <- fa(poly_cor, nfactors = 3, rotate = "varimax", fa = "mle")


## -----------------------------------------------------------------------------
print(modelo_varimax$loadings, cut = 0)
fa.diagram(modelo_varimax)


## -----------------------------------------------------------------------------
library(stats)
factanal(datos_af, factors = 3, rotation="none")


## -----------------------------------------------------------------------------
library(MVN)
hz_test <- mvn(data = datos_pca, mvnTest = "hz", multivariateOutlierMethod = "quan")


## -----------------------------------------------------------------------------
royston_test <- mvn(data = datos_pca, mvnTest = "royston", multivariatePlot = "qq")


## -----------------------------------------------------------------------------
royston_test$multivariateNormality


## -----------------------------------------------------------------------------
hz_test <- mvn(data = datos[, -1], mvnTest = "hz")
hz_test$multivariateNormality


## -----------------------------------------------------------------------------
# install.packages("tidyverse")
# install.packages("cluster")
# install.packages("factoextra")

# Cargamos los paquetes indicados
library(tidyverse)
library(cluster)
library(factoextra)


## -----------------------------------------------------------------------------
distancias <- get_dist(datos_normalizados)

fviz_dist(
  distancias,
  gradient = list(low = "#00AFBB", mid = "white", high = "#FC4E07")
)


## -----------------------------------------------------------------------------
k2 <- kmeans(datos_normalizados, centers = 2, nstart = 25)
k3 <- kmeans(datos_normalizados, centers = 3, nstart = 25)
k4 <- kmeans(datos_normalizados, centers = 4, nstart = 25)
k5 <- kmeans(datos_normalizados, centers = 5, nstart = 25)

# plots to compare
p1 <- fviz_cluster(k2, geom = "point", data = datos_normalizados) + ggtitle("k = 2")
p2 <- fviz_cluster(k3, geom = "point", data = datos_normalizados) + ggtitle("k = 3")
p3 <- fviz_cluster(k4, geom = "point", data = datos_normalizados) + ggtitle("k = 4")
p4 <- fviz_cluster(k5, geom = "point", data = datos_normalizados) + ggtitle("k = 5")


library(gridExtra)
grid.arrange(p1, p2, p3, p4, nrow = 2)


## -----------------------------------------------------------------------------
fviz_nbclust(datos_normalizados, kmeans, method = "wss")


## -----------------------------------------------------------------------------
fviz_nbclust(datos_normalizados, kmeans, method = "silhouette")


## -----------------------------------------------------------------------------
gap_stat <- clusGap(datos_normalizados, FUN = kmeans, nstart = 25, K.max = 10, B = 50)
fviz_gap_stat(gap_stat)


## -----------------------------------------------------------------------------
print(k4)

