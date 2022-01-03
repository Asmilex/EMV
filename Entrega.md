---
title: "Análisis exploratorio"
date: "03 enero, 2022"
author:
- "Andrés Millán"
- "Paula Villanueva"
output:
  html_document:
    toc: true
    toc_depth: 3
    toc_float: true
    number_sections: true
    theme: united
    highlight: tango

  pdf_document:
    toc: true
    toc_depth: 3
    number_sections: true
    theme: united
    highlight: tango
---



# Abstract

Se ha realizado un análisis exploratorio de un conjunto de datos. Este dataset recoge 8 indicadores económicos de 13 empresas. Tras estudiar la información recogida en el conjunto, tratando posibles valores perdidos y outliers, se han aplicado dos tipos de técnicas:

- **Análisis univariante numérico y gráfico**. En él, se ha elaborado un análisis descriptivo numérico clásico y un análisis de supuesto de normalidad.
- **Técnicas multivariantes**: se ha estudiado la correlación entre variables, la reducción de la dimensión mediante variables observables y latentes. Además, se ha estudiado la normalidad multivariante de los datos.

Finalmente, se ha construido un clasificador basado en clustering no jerárquico con el fin de estudiar cómo se agrupan las diferentes empresas. Descubrimos que (...terminar con lo que hemos encontrado...)


# Introducción

Se ha realizado el análisis exploratorio de los datos contenidos en la base de datos `DB_2`. Esta base de datos contiene un grupo constituido por 13 empresas que se ha clasificado según las puntuaciones obtenidas en 8 indicadores económicos.

Primero, se ha limpiado el dataset de cualquier anomalía posible. Hemos encontrado una instancia probablemente errónea, que contenía valores perdidos e indicadores sin ningún sentido. A continuación, se ha realizado un análisis descriptivo numérico clásico, esto es, se han obtenido las medidas de tendencia central, los cuartiles, el coeficiente de simetría, la dispersión, etc. Además, se han estudiado posibles outliers. Se ha comprobado también la normalidad de las variables individualmente mediante gráficos de normalidad.

Una vez preparado el conjunto inicial, procedemos a realizar el análisis exploratorio multivariante. Se comprobó la correlación entre las variables mediante un test de Bartlett. A continuación, se realizó un estudio de la posibilidad de reducción de la dimensión mediante variables observables, en cuyo caso se ha elegido el número óptimo de componentes principales usando distintas técnicas gráficas, y mediante variables latentes, en cuyo caso se ha elegido el número óptimo de factores a considerar. Lo siguiente fue analizar la normalidad multivariante de los datos con los tests con el paquete MVN.

Finalmente, para completar nuestro objetivo, se ha realizado un análisis cluster, es decir, un agrupamiento de los objetos formando clusters de objetos con un alto grado de homogeneidad interna y heterogeneidad. En concreto, se ha utilizado el método de las k medias, un método no jerárquico.


# Materiales y métodos

## Materiales

- Hablar dataset
- Estadísticos descriptivos básicos
- Boxplots

La base de datos elegida contiene un grupo constituido por 13 empresas que se ha clasificado según las puntuaciones obtenidas en 8 indicadores económicos:

- X1: Indicador de volumen de facturación.
- X2: Indicador de nivel de nueva contratación.
- X3: Indicador del total de clientes.
- X4: Indicador de beneficios de la empresa .
- X5: Indicador de retribución salarial de los empleados.
- X6: Indicador de organización empresarial dentro de la empresa.
- X7: Indicador de relaciones con otras empresas.
- X8: Indicador de nivel de equipamiento (ordenadores, maquinaria, etc...).

A continuación se muestra una tabla con los estadísticos descriptivos básicos.


```
##        x1               x2                x3               x4         
##  Min.   : 0.128   Min.   : 0.9444   Min.   : 2.167   Min.   : 0.0299  
##  1st Qu.: 2.476   1st Qu.: 8.6931   1st Qu.: 8.667   1st Qu.: 4.0673  
##  Median : 7.584   Median :14.8487   Median :15.167   Median : 5.4044  
##  Mean   : 6.957   Mean   :14.9138   Mean   :15.167   Mean   : 5.3976  
##  3rd Qu.:10.734   3rd Qu.:21.7262   3rd Qu.:21.667   3rd Qu.: 6.5147  
##  Max.   :14.364   Max.   :25.4261   Max.   :28.167   Max.   :11.3959  
##        x5               x6               x7               x8        
##  Min.   : 2.557   Min.   : 6.135   Min.   : 1.064   Min.   : 3.949  
##  1st Qu.: 3.525   1st Qu.:10.170   1st Qu.: 3.982   1st Qu.: 6.833  
##  Median : 5.336   Median :11.374   Median : 5.584   Median : 8.103  
##  Mean   : 5.107   Mean   :21.006   Mean   : 6.598   Mean   :13.074  
##  3rd Qu.: 5.874   3rd Qu.:31.586   3rd Qu.:10.160   3rd Qu.:20.154  
##  Max.   :10.037   Max.   :43.278   Max.   :12.374   Max.   :26.571
```

```
##        x1        x2        x3        x4        x5        x6        x7        x8 
##  4.545099  8.162600  8.437954  2.823818  1.991911 13.779784  4.030662  8.249730
```

En la siguiente gráfica se muestran los diagramas de cajas de las variables.

<img src="C:/Users/Andre/.vscode-R/tmp/b1c11fa47eb9e671bc734451f395548a2b0d126319f5a70a0a55b3a9d77ce101_files/figure-html/unnamed-chunk-114-1.png" width="672" />


## Métodos estadísticos

En este apartado se indican las distintas técnicas estadísticas que se han utilizado.

Primero, se ha realizado un análisis numérico y gráfico de cada variable. De esta forma, mediante en visionado de la estructura del archivo de datos, se han estudiado las posibles recodificaciones y valores perdidos. También se ha realizado un análisis descriptivo numérico clásico, esto es, usando las funciones `summary`, `boxplot` y `skewness` hemos obtenido las medidas de tendencia central, dispersión, cuartiles, simetría, etc.
Por otra parte, con la función `check_outliers` hemos detectado los posibles outliers mediante el método de mahalanobis.
Para comprobar el supuesto de normalidad, hemos utilizado `colMeans` y para normalizar los datos hemos usado `scale`. De esta forma, podemos visualizar la normalidad con `qqplot`.

Con respecto al análisis exploratorio multivariante, se ha utilizado el test de Bartlett, `cortest.bartlett`, para estudiar la correlación entre las variables.
En cuanto al Análisis de Componentes Principales, éste se ha realizado con `prcomp` y se han utilizado técnicas gráficas, tales como `ggplot` y `fviz_pca`.
Sobre el AF, se han utilizado otras técnicas gráficas, como `ggcorrplot`, `scree`, `parallel` y `diagram`, y `factanal` para realizar el test de hipótesis que constrasta si el número de factores es suficiente.
Para realizar el análisis de la normalidad multivariante, se ha utilizado el paquete `MVN`. Específicamente, hemos usado dos tests diferentes: el de Henze-Zirkler y el de Royston.

Finalmente, para realizar el agrupamiento de los objetos, se ha utilizado la técnica `kmeans`, variando el número de clusters con el fin de comprobar cómo se agrupan las empresas.


# Resultados

- Resumen de lo más destacado
- Probablemente debamos usar bastantes gráficas.
- Exposición objetiva.
- Hablar sobre los posibles outliers, que decidimos no quitarlos.


En este apartado se mostrarán los resultados obtenidos tras aplicar las técnicas mencionadas anteriormente.

## Análisis exploratorio univariante

### Valores perdidos

Mediante la carga y visionado de datos podemos detectar los posibles valores perdidos.


```
## re-encoding from utf-8
```

```
##              x1         x2        x3          x4        x5        x6        x7
## 1  1.279554e-01  0.9444263  2.166667  5.79433292  5.480291 11.096322  3.982094
## 2  1.552544e+00  4.2996830  4.333333  5.40439487  5.335612 11.011499  5.584143
## 3  1.214796e+00  6.8997865  6.500000  4.06727850  6.889363 24.763075  7.276582
## 4  2.475883e+00  8.6930622  8.666667  7.40941778  4.137916 31.585770 10.339785
## 5  6.013061e+00 11.2399245 10.833333  0.02990288 10.036760 10.169836  1.966363
## 6  6.735028e+00 13.1271733 13.000000  1.54954845  5.874234  6.134638  1.063619
## 7  7.583921e+00 14.8487119 15.166667 11.39590764  2.709851  6.955054  1.667021
## 8  8.014212e+00 18.1598131 17.333333  6.32676834  2.556536 41.523867 12.373881
## 9  8.119725e+00 19.5660634 19.500000  6.51471573  3.462434 31.037808 10.160371
## 10 1.151672e+01 21.7261519 21.666667  5.06008196  5.918977 43.278324 12.235597
## 11 1.073365e+01 24.1410834 23.833333  3.96939242  5.595512 11.374130  5.236333
## 12 1.198526e+01 24.8071237 26.000000  4.88552952  4.870252  9.709267  4.088848
## 13 1.436357e+01 25.4261297 28.166667  7.76111352  3.524603 34.436416  9.798433
## 14 2.002300e+04 18.0000000 16.000000  8.00000000  8.000000 10.000000        NA
##           x8
## 1   5.798710
## 2   8.102565
## 3  14.398706
## 4  17.872456
## 5   7.550620
## 6   3.948938
## 7   4.750391
## 8  26.231918
## 9  20.154125
## 10 26.571424
## 11  7.333438
## 12  6.832688
## 13 20.413416
## 14        NA
```

### Análisis descriptivo numérico clásico

A continuación se muestran los estadísticos descriptivos básicos.


```r
summary(datos)
```

```
##        x1               x2                x3               x4         
##  Min.   : 0.128   Min.   : 0.9444   Min.   : 2.167   Min.   : 0.0299  
##  1st Qu.: 2.476   1st Qu.: 8.6931   1st Qu.: 8.667   1st Qu.: 4.0673  
##  Median : 7.584   Median :14.8487   Median :15.167   Median : 5.4044  
##  Mean   : 6.957   Mean   :14.9138   Mean   :15.167   Mean   : 5.3976  
##  3rd Qu.:10.734   3rd Qu.:21.7262   3rd Qu.:21.667   3rd Qu.: 6.5147  
##  Max.   :14.364   Max.   :25.4261   Max.   :28.167   Max.   :11.3959  
##        x5               x6               x7               x8        
##  Min.   : 2.557   Min.   : 6.135   Min.   : 1.064   Min.   : 3.949  
##  1st Qu.: 3.525   1st Qu.:10.170   1st Qu.: 3.982   1st Qu.: 6.833  
##  Median : 5.336   Median :11.374   Median : 5.584   Median : 8.103  
##  Mean   : 5.107   Mean   :21.006   Mean   : 6.598   Mean   :13.074  
##  3rd Qu.: 5.874   3rd Qu.:31.586   3rd Qu.:10.160   3rd Qu.:20.154  
##  Max.   :10.037   Max.   :43.278   Max.   :12.374   Max.   :26.571
```

Para ver cómo es la distribución de las variables, representaremos el diagrama de cajas.


```r
boxplot (
  datos,
  main = "Análisis exploratorio de datos",
  xlab = "Indicadores",
  ylab = "Valor",
  col = c(1 : 15)
)
```

<img src="C:/Users/Andre/.vscode-R/tmp/b1c11fa47eb9e671bc734451f395548a2b0d126319f5a70a0a55b3a9d77ce101_files/figure-html/unnamed-chunk-117-1.png" width="672" />

Además, tambien se ha obtenido el coeficiente de simetría.


```r
library(moments)
skewness(datos)
```

```
##            x1            x2            x3            x4            x5 
## -6.571128e-02 -2.178143e-01  2.441493e-16  8.611432e-02  9.539367e-01 
##            x6            x7            x8 
##  4.214678e-01  1.014152e-01  4.874442e-01
```

### Valores extremos

Se ha comprobado si hay outliers.


```r
library("performance")
check_outliers(datos, method = "mahalanobis")
```

```
## OK: No outliers detected.
```

### Supuesto de normalidad

Se ha comprobado si los datos están normalizados (es decir, media 0 y varianza 1). Para ello, calculamos la media y la desviación típica de cada variable.


```r
round(colMeans(datos), 5)
```

```
##       x1       x2       x3       x4       x5       x6       x7       x8 
##  6.95664 14.91378 15.16667  5.39757  5.10710 21.00585  6.59793 13.07380
```


```r
round(apply(datos, 2, sd), 5)
```

```
##       x1       x2       x3       x4       x5       x6       x7       x8 
##  4.54510  8.16260  8.43795  2.82382  1.99191 13.77978  4.03066  8.24973
```

# Discusión

- Recordar objetivo
- Interpretación de los resultados
- Discutir cómo se han conseguido esos resultados

# Conclusiones
