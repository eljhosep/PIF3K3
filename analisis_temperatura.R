# Limpiar el entorno
rm(list = ls()) # limpiar datos
dev.off() #limpiar grafica
cat("\014") # limpiar consola

# Cargar paquetes necesarios
library(readxl)
library(ggplot2)

# Leer el archivo Excel
datos_temperatura <- read_excel("C:\\Users\\elias\\Desktop\\lecturaArduino\\datos_temperatura.xlsx")

# Renombrar las columnas
names(datos_temperatura) <- c("Timestamp", "Temperatura")

# Asegurarse de que la columna Timestamp es de tipo POSIXct (fecha y hora)
datos_temperatura$Timestamp <- as.POSIXct(datos_temperatura$Timestamp, format="%Y-%m-%d %H:%M:%S")

# Convertir la columna Temperatura a numérico
datos_temperatura$Temperatura <- as.numeric(datos_temperatura$Temperatura)

# Verificar si hay valores NA en la columna Temperatura y eliminarlos
datos_temperatura <- na.omit(datos_temperatura)

# Crear una nueva columna para el mes y año
datos_temperatura$Mes_Año <- format(datos_temperatura$Timestamp, "%Y-%m")

# Crear el boxplot
boxplot(Temperatura ~ Mes_Año, data = datos_temperatura,
        xlab = "Mes", ylab = "Temperatura Promedio (C)", 
        main = "Boxplot de Temperatura Promedio (C)",
        xaxt = "n", col = rainbow(length(unique(datos_temperatura$Mes_Año))))

# Agregar etiquetas personalizadas en el eje x
axis(1, at = 1:length(unique(datos_temperatura$Mes_Año)), labels = unique(datos_temperatura$Mes_Año), las=2)

# Calcular la media y mediana por grupo
mediana_por_grupo <- tapply(datos_temperatura$Temperatura, datos_temperatura$Mes_Año, median)
media_por_grupo <- tapply(datos_temperatura$Temperatura, datos_temperatura$Mes_Año, mean)

# Mostrar los valores de la mediana en los boxplots
text(x = 1:length(mediana_por_grupo), y = mediana_por_grupo, labels = round(mediana_por_grupo, 2), pos = 3, col = "black")

# Mostrar un punto representando la media en los boxplots
points(x = 1:length(media_por_grupo), y = media_por_grupo, col = "white", pch = 19)

# Calcular las medidas de tendencia central
media <- mean(datos_temperatura$Temperatura)
mediana <- median(datos_temperatura$Temperatura)
xmin <- min(datos_temperatura$Temperatura)
xmax <- max(datos_temperatura$Temperatura)
rango <- xmax - xmin

# Calcular la moda
if (length(datos_temperatura$Temperatura) > 0 & !anyNA(datos_temperatura$Temperatura)) {
  moda <- as.numeric(names(sort(-table(datos_temperatura$Temperatura)))[1])
} else {
  moda <- NA
}

# Calcular las medidas de dispersión
varianza <- var(datos_temperatura$Temperatura)
coef_variacion <- sd(datos_temperatura$Temperatura) / mean(datos_temperatura$Temperatura) * 100
covarianza <- cov(datos_temperatura$Temperatura, datos_temperatura$Temperatura)

############# TABLA FRECUENCIA ##########

# Calcular la frecuencia de cada valor en la variable "Temperatura"
frecuencia <- table(datos_temperatura$Temperatura)

# Crear una tabla con los valores y sus frecuencias
tabla_frecuencia <- data.frame(Valor = as.numeric(names(frecuencia)), Frecuencia = as.numeric(frecuencia))

# Mostrar la tabla de frecuencia
print(tabla_frecuencia)

############ HISTOGRAMA ##############

# Crear el histograma
hist(datos_temperatura$Temperatura, 
     main = "Histograma de Temperatura Promedio (C)",
     xlab = "Temperatura Promedio (C)",
     ylab = "Frecuencia",
     col = "skyblue",
     border = "black",
     breaks = 10)  # Ajustar el número de barras cambiando el valor de "breaks"

############## PARETO #########

# Calcular la frecuencia acumulada
frecuencia_acumulada <- cumsum(sort(frecuencia, decreasing = TRUE))

# Calcular el porcentaje acumulado
porcentaje_acumulado <- frecuencia_acumulada / sum(frecuencia) * 100

# Crear el gráfico de Pareto
par(mar = c(5, 5, 4, 2) + 0.1)
barplot(sort(frecuencia, decreasing = TRUE), col = "skyblue", main = "Gráfico de Pareto de Temperatura Promedio (C)", xlab = "Temperatura Promedio (C)", ylab = "Frecuencia", ylim = c(0, max(frecuencia)), border = "black")
par(new = TRUE)
plot(cumsum(sort(frecuencia, decreasing = TRUE)), col = "red", type = "b", pch = 20, xaxt = "n", yaxt = "n", xlab = "", ylab = "")
axis(4)
mtext("Porcentaje Acumulado", side = 4, line = 3)

############# TORTA #############3

# Crear el gráfico de pastel
pie(frecuencia, main = "Gráfico de Pastel de Temperatura Promedio (C)", col = rainbow(length(frecuencia)), cex = 0.8)

######### OJIVA ##############

# Calcular la frecuencia acumulada
frecuencia_acumulada <- cumsum(frecuencia)

# Crear el gráfico de la ojiva
plot(names(frecuencia_acumulada), frecuencia_acumulada, type = "o", col = "blue", xlab = "Temperatura Promedio (C)", ylab = "Frecuencia Acumulada", main = "Gráfico de Ojiva de Temperatura Promedio (C)")

################ TALLOS Y HOJAS #######

# Crear un diagrama de tallo y hojas
stem(datos_temperatura$Temperatura)
