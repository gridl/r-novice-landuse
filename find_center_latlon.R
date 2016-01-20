library(data.table)
pcl <- read.table("/Users/hana//workspace/data/psrc_parcel/datasets/parcels_for_google.csv", sep=",", header=TRUE)

# this algorithm comes from 
# http://stackoverflow.com/questions/6671183/calculate-the-center-point-of-multiple-latitude-longitude-coordinate-pairs
resdf <- NULL
for(city in unique(pcl$city_id)) {
	data <- data.table(subset(pcl, city_id==city))
	data$lat <- data$lat * pi/180
	data$long <- data$long * pi/180
	dt <- data.table(with(data, data.frame(X=cos(lat) * cos(long), Y=cos(lat)*sin(long), Z=sin(lat))))
	xyz <- dt[, list(x=mean(X), y=mean(Y), z=mean(Z))]
	lon <- with(xyz, atan2(y, x))
	hyp <- with(xyz, sqrt(x * x + y * y))
	resdf <- rbind(resdf, data.frame(city_id=city, lat=atan2(xyz$z, hyp) * 180/pi, lon=lon* 180/pi))
}

resdf$latlon <- paste(resdf$lat, resdf$lon, sep=":")
write.table(resdf, file="cities_coordinates.csv", sep=",", row.names=FALSE)