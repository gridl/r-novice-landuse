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

### DBI, RMySQL, RSQLite
For direct connection to MySQL or SQLite tables. Example:

~~~{.r}
mydb <- dbConnect(MySQL(), user="psrcurbansim", password="password", dbname="psrc_2014_parcel_baseyear")
query <- dbSendQuery(mydb, "SELECT * from schools")
schools <- fetch(query)
head(schools)
~~~

~~~{.r}
  school_id category scnty                   sname codist math_index total_score sxcoord parcel_id
1         1        E     3 5-12 LEARNING COMMUNITY  27400    2.52250     7.66000 1231019    721309
2         2        H     4                    ACES  31006    0.00000     0.00000 1296422   1145459
3         3        E     1        ADAMS ELEMENTARY  17001    2.62667     7.96000 1256548    411436
4         4        H     1          AE 2 @ DECATUR  17210    2.47000     8.00000 1283393     78426
5         5        E     1              AE SQUARED  17001    3.05000     8.66333 1273128    403969
6         6        M     4 ALDERWOOD MIDDLE SCHOOL  31015    2.54500     7.64500 1286736    956604
  public reading_index student_count sycoord schoolcode  szip school_district_id staff  pcl_y
1      1       2.82750           149   69662       5027 98499                 63     0  70087
2      1       0.00000           209  336737       4247 98204                 20     0 335320
3      1       3.02333           354  249531       2138 98107                 30     0 249413
4      1       3.51000          1699  253434       3766 98115                 50     0 118839
5      1       3.25333           307  259108       3974 98115                 30     0 253224
6      1       2.95000           709  301211       3560 98036                 22     0 301214
    pcl_x    scity
1 1231276 LAKEWOOD
2 1294903  EVERETT
3 1256254  SEATTLE
4 1259537  SEATTLE
5 1283529  SEATTLE
6 1286736 LYNNWOOD
~~~

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
