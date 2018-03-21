library(rgdal)
library(GISTools)


spatial.shp <- readOGR("Y:\\Hackathon\\spatial isolation.shp")
proj4string(spatial.shp) <- CRS("+init=epsg:27700")

x <- spatial.shp$medianINT2




y <- range(x)[2] - range(x)[1]

spatial.shp$spatial_isolation <- (x - min(x)) / y * 100


#Write to ShapeFile
writeOGR(obj=spatial.shp, driver = "ESRI Shapefile", dsn = "Y:\\Hackathon", layer = "SpatialIsolationRescaled")


install.packages("rjson")
library(rjson)
json_file <- "Y:\\Hackathon\\gen_Data.json"

library(dplyr)

setwd("Y:/Hackathon")



random_data <- fromJSON(json_file)



library("jsonlite")
library(purrr)


x <- names(random_data)

y <- random_data[x[1]]
df <- data.frame(comment = y[[1]], stringsAsFactors = F)

for (i in 2:length(x)){
  y <- random_data[x[i]]
  df2 <- data.frame(comment = y[[1]], stringsAsFactors = F)
  df <- rbind(df, df2)
}

names(df) <- gsub("comment.", "", names(df))

datain = df
bng = datain 
coordinates(bng) = ~ lng + lat 
bng@proj4string = CRS("+proj=longlat +datum=WGS84") 
latlon = spTransform(bng, CRS("+init=epsg:27700")) 
out = cbind(datain, coordinates(latlon)) 
colnames(out) = c(names(datain),'e','n') 
write.table(out, 'random_data.csv', row.names=F, col.names=T, sep=',')


library(ggplot2)

f <- fortify(spatial.shp)

df_3 <- data.frame(lng = c(min(f$long),
                         max(f$long)),
                 lat = c(min(f$lat),
                         max(f$lat)))

names(df_3) <- c("e","n")

datain = df_3
bng = datain 
coordinates(bng) = ~ e + n 
bng@proj4string = CRS("+init=epsg:27700") 
latlon = spTransform(bng, CRS("+proj=longlat +datum=WGS84")) 
out = cbind(datain, coordinates(latlon)) 
colnames(out) = c(names(datain),'e','n') 







socialIsolation.shp <- readOGR("Y:\\Hackathon\\SocialIsolation.shp")
proj4string(socialIsolation.shp) <- CRS("+init=epsg:27700")

df <- data.frame(singleAdult = socialIsolation.shp$Norm..Adul,
                disability = socialIsolation.shp$Norm..Disa,
                incomeDep = socialIsolation.shp$Income.Dep,
                noQual = socialIsolation.shp$No.qualifi,
                widow = socialIsolation.shp$Norm..Wido,
                infr = socialIsolation.shp$Civil.infr,
                education = socialIsolation.shp$Education)


norm <- function(x){
  rang <- range(x)
  (x- rang[1]) / (rang[2] - rang[1])
}


for (i in 1:ncol(df)){
  df[i] <- norm(df[i])
}


library(caret)
library(psych)


a  <-   principal(df, rotate = 'none')

prin <- vector(mode = "double", length = 7)
  
for (i in 1:7)
{
  prin[i] = a$loadings[i] / sum(a$loadings[,1]^2)
}

df$score <- 0

for (i in 1:7) {
  df$score <- df$score + (df[[i]] * prin[i])
}

hist(df$score)

df$score <- norm(df$score)



socialIsolation.shp$score <- df$score

socialIsolation.shp@proj4string = CRS("+proj=longlat +datum=WGS84") 

socialIsolation.shp <- spTransform(socialIsolation.shp, CRS("+init=epsg:27700")) 

#Write to ShapeFile
writeOGR(obj=socialIsolation.shp, driver = "ESRI Shapefile", dsn = "Y:\\Hackathon", layer = "SocialIsolationIndex2")

spatial.shp$LSOA11CD

SpatialIsolationRescaled <- readOGR("Y:\\Hackathon\\SpatialIsolationRescaled.shp")
proj4string(SpatialIsolationRescaled) <- CRS("+init=epsg:27700")

socialIsolation.shp$score <- socialIsolation.shp$score * 100

hist(socialIsolation.shp$score)

cor(SpatialIsolationRescaled$sptl_sl*-1, socialIsolation.shp$score)
plot(SpatialIsolationRescaled$sptl_sl, socialIsolation.shp$score)
abline(lm(socialIsolation.shp$score ~ SpatialIsolationRescaled$sptl_sl), col='red')

df <- data.frame(LSOA_CD = spatial.shp$LSOA11CD,
                 spatial_i = SpatialIsolationRescaled$sptl_sl * -1, 
                 social_i = socialIsolation.shp$score)

df$sp <- "A"
df$sp <- ifelse(df$spatial_i > quantile(df[[2]], 0.33), "B", df$sp)
df$sp <- ifelse(df$spatial_i > quantile(df[[2]], 0.66), "C", df$sp)
table(df$sp)

df$so <- "1"
df$so <- ifelse(df$social_i > quantile(df[[3]], 0.33), "2", df$so)
df$so <- ifelse(df$social_i > quantile(df[[3]], 0.66), "3", df$so)

with(df, table(sp,so))

write.csv(df, "socio-spatial isolation.csv")


rm(list=ls())



ss <- readOGR("Y:\\Hackathon\\socio-spatial isolation.shp")
proj4string(ss) <- CRS("+init=epsg:27700")


x <- names(ss)


names(ss) <- c(x[1:8], "spatial_in", "social_in", "spatial_key", "social_key", "sospmatrix")

ss$spatial_in <- as.character(ss$spatial_in) %>% as.numeric() + 100 
summary(ss$spatial_in)

writeOGR(obj=ss, driver = "ESRI Shapefile", dsn = "Y:\\Hackathon", layer = "socio-spatial isolation")

