lu <- read.table(file="data/city__dataset_table__lu_indicators__2010.tab", header=TRUE, sep="\t")
lu <- merge(lu, cities, by="city_id", all=TRUE)
lu <- na.omit(lu)

summary(lu)
hhsize <- lu$population/lu$households
hist(hhsize)
lu <- cbind(lu, hh_size=hhsize)
head(lu[order(lu$hh_size),])
tail(lu[order(lu$hh_size),])


lu <- cbind(lu, acres=lu$sqft/43560)
plot(lu$res_units/lu$acres, lu$hh_size)

boxplot(hh_size ~ county_id, lu)

plot(households ~ res_units, lu)
abline(0,1)

plot(jobs ~ non_res_sqft, lu)
fit <- lm(jobs ~ non_res_sqft, lu)
summary(fit)
abline(fit)

lu2 <- subset(lu, county_id != 2)
plot(jobs ~ non_res_sqft, lu2)
fit2 <- lm(jobs ~ non_res_sqft, lu2)
abline(fit2)

plot(jobs ~ non_res_sqft, lu, log="xy")
luno0 <- subset(lu, jobs > 0 & non_res_sqft > 0)
fit <- lm(log(jobs) ~ log(non_res_sqft), luno0)
plot(log(jobs) ~ log(non_res_sqft), luno0)
abline(fit)

library(data.table)
hhdt <- data.table(hhc)
hhdt[, sum(households), by=county_id]
chh <- hhdt[, list(hh2010=sum(households_2010), hh2020=sum(households_2020), hh2030=sum(households_2030), hh2040=sum(households_2040)), by=county_id]
chh <- as.matrix(chh)
years <- seq(2010, 2040, by=10)
cols <- c("black", "blue", "green", "red")
plot(years, chh[1,2:5], type="b", xlab="", ylab="households", ylim=range(chh[,2:5]), col=cols[1])
for(icounty in 2:nrow(chh)) {
	lines(years, chh[icounty,2:5], col=cols[icounty], type='b')
}
legend("topleft", legend=c("King", "Pierce", "Snohomish", "Kitsap"), col=cols, lty=1)


library(googleVis)
coord <- read.table('data/cities_coordinates.csv', header=TRUE, sep=",")
hhc <- merge(hhc, coord, by="city_id")
hhc <- cbind(hhc, tip = paste(hhc$city_name, "HH2040: ", hhc$households_2040, sep=','))
map <- gvisMap(hhc, "latlon", tipvar="tip", options=list(height="30cm"))
plot(map)
