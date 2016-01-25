---
layout: page
title: R for Data Analysis
subtitle: Wrapping up
minutes: 15
---

> ## Learning Objectives {.objectives}
>
> * To be aware of useful packages
>



## Useful packages

### acs, USCensus2010
For downloading and working with ACS and Census data.

### ggplot2
For fancy graphs.

<img src="fig/08-plot-ggplot2-ch5-sol-1.png" alt="ggplot2-example" />

### data.table

For convenient operations on tables. Example:


~~~{.r}
library(data.table)
dt <- data.table(hh)
dt[, sum(hh40), by=county_id]
~~~



~~~{.output}
   county_id      V1
1:         1  404472
2:         2 1088531
3:         3  151853
4:         4  462854

~~~



~~~{.r}
dt[,list(hh10=sum(hh10), hh40=sum(hh40), N=.N), by=county_id]
~~~



~~~{.output}
   county_id   hh10    hh40  N
1:         1 266135  404472 46
2:         2 797467 1088531 57
3:         3  98059  151853 11
4:         4 299055  462854 26

~~~

Another useful package for this kind of operations is **dplyr**.

### shiny
For creating web-based interfaces. [Example](https://rstudio.stat.washington.edu/shiny/wppExplorer/inst/explore/)

### googleVis
For plotting on google maps. Example:

~~~{.r}
library(googleVis)
coord <- read.table('data/cities_coordinates.csv', header=TRUE, sep=",")
hhc <- merge(hh, coord, by="city_id")
hhc <- cbind(hh, tip = paste(hh$city_name, "HH2040: ", hh$hh40, sep=','))
map <- gvisMap(hhc, "latlon", tipvar="tip", options=list(height="30cm"))
plot(map)
~~~

Package **maptools** can be used with shapefiles.

### magrittr
Allows writing R commands as a pipe.

~~~{.r}
library(magrittr)
hh %>% subset(county_id == 2) %>% head %>% print
~~~



~~~{.output}
   county_id city_id  hh10  hh20  hh30  hh40     city_name county_name
49         2       1  2617  2891  3000  3042 Normandy Park        King
50         2       2 23596 27690 31164 34383        Auburn        King
51         2       4  9904 12232 14401 16365       Sea Tac        King
52         2       5 21511 24731 26511 28714     Shoreline        King
53         2       6 16555 18963 19916 19962    Renton PAA        King
54         2       8  7480  9100 10833 12410       Tukwila        King

~~~
