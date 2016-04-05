---
layout: page
title: R for Data Analysis
subtitle: Data frames and reading in data
minutes: 45
---



> ## Learning Objectives {.objectives}
>
> * Become familiar with data frames
> * Be able to read regular data into R
>

## Data frames

Data frames are similar to matrices, except each column can be a
different atomic type. A data frames is the standard structure for
storing and manipulating rectangular data sets.  Underneath the hood,
data frames are really lists, where each element is an atomic vector,
with the added restriction that they're all the same length.  As you
will see, if we pull out one column of a data frame,we will have a
vector. You will probably find that data frames are more complicated
than vectors and other data structures we have considered, but they
provide powerful capabilities.
 

Data frames can be created manually with the `data.frame` function:


~~~{.r}
df <- data.frame(id = c('a', 'b', 'c', 'd', 'e', 'f'), x = 1:6, y = c(214:219))
df
~~~



~~~{.output}
  id x   y
1  a 1 214
2  b 2 215
3  c 3 216
4  d 4 217
5  e 5 218
6  f 6 219

~~~

As with matrices, you can use the functions `dim`, `nrow` and `ncol` to view the dimensions of the data frame.

 We can access a column
in a `data.frame` by using the `$` operator

~~~{.r}
df$x
~~~



~~~{.output}
[1] 1 2 3 4 5 6

~~~
or

~~~{.r}
df[,'x']
~~~



~~~{.output}
[1] 1 2 3 4 5 6

~~~

We can add columns or rows to a data.frame using `cbind` or `rbind`
(these are the two-dimensional equivalents of the `c` function):

## Adding columns to a data frame

To add a column we can use `cbind`:


~~~{.r}
df <- cbind(df, z=6:1, caps=LETTERS[1:6])
df
~~~



~~~{.output}
  id x   y z caps
1  a 1 214 6    A
2  b 2 215 5    B
3  c 3 216 4    C
4  d 4 217 3    D
5  e 5 218 2    E
6  f 6 219 1    F

~~~
(`LETTERS` and `letters` are built-in constants.)

Since under the hood data frames are lists, we can add columns just like adding new elements to lists:

~~~{.r}
df$zero <- rep(0, 6)
df
~~~



~~~{.output}
  id x   y z caps zero
1  a 1 214 6    A    0
2  b 2 215 5    B    0
3  c 3 216 4    C    0
4  d 4 217 3    D    0
5  e 5 218 2    E    0
6  f 6 219 1    F    0

~~~


## Adding rows to a data frame 

To add a row we use `rbind`:


~~~{.r}
df <- rbind(df, data.frame(id="g", x=11, y=42, z=0, caps='G', zero=NA))
str(df)
~~~



~~~{.output}
'data.frame':	7 obs. of  6 variables:
 $ id  : Factor w/ 7 levels "a","b","c","d",..: 1 2 3 4 5 6 7
 $ x   : num  1 2 3 4 5 6 11
 $ y   : num  214 215 216 217 218 219 42
 $ z   : num  6 5 4 3 2 1 0
 $ caps: Factor w/ 7 levels "A","B","C","D",..: 1 2 3 4 5 6 7
 $ zero: num  0 0 0 0 0 0 NA

~~~


## Deleting rows and handling NA


There are multiple ways to delete a row containing `NA`:


~~~{.r}
df[-7, ]  # The minus sign tells R to delete the row
~~~



~~~{.output}
  id x   y z caps zero
1  a 1 214 6    A    0
2  b 2 215 5    B    0
3  c 3 216 4    C    0
4  d 4 217 3    D    0
5  e 5 218 2    E    0
6  f 6 219 1    F    0

~~~



~~~{.r}
df[!is.na(df$zero), ]  # is.na() returns TRUE where its argument is NA
~~~



~~~{.output}
  id x   y z caps zero
1  a 1 214 6    A    0
2  b 2 215 5    B    0
3  c 3 216 4    C    0
4  d 4 217 3    D    0
5  e 5 218 2    E    0
6  f 6 219 1    F    0

~~~



~~~{.r}
df <- na.omit(df)  # Another function for the same purpose; checks all variables
df
~~~



~~~{.output}
  id x   y z caps zero
1  a 1 214 6    A    0
2  b 2 215 5    B    0
3  c 3 216 4    C    0
4  d 4 217 3    D    0
5  e 5 218 2    E    0
6  f 6 219 1    F    0

~~~

## Combining data frames

We can also row-bind data.frames together:


~~~{.r}
rbind(df, df)
~~~



~~~{.output}
   id x   y z caps zero
1   a 1 214 6    A    0
2   b 2 215 5    B    0
3   c 3 216 4    C    0
4   d 4 217 3    D    0
5   e 5 218 2    E    0
6   f 6 219 1    F    0
7   a 1 214 6    A    0
8   b 2 215 5    B    0
9   c 3 216 4    C    0
10  d 4 217 3    D    0
11  e 5 218 2    E    0
12  f 6 219 1    F    0

~~~
 
## Merging data frames
Data frames can be merged on one or more columns. Create a second dataset and merge it with our `df` object:

~~~{.r}
df2 <- data.frame(id = letters[1:5], X = 101:105)
df2
~~~



~~~{.output}
  id   X
1  a 101
2  b 102
3  c 103
4  d 104
5  e 105

~~~



~~~{.r}
df <- merge(df, df2, by="id", all=TRUE)
df
~~~



~~~{.output}
  id x   y z caps zero   X
1  a 1 214 6    A    0 101
2  b 2 215 5    B    0 102
3  c 3 216 4    C    0 103
4  d 4 217 3    D    0 104
5  e 5 218 2    E    0 105
6  f 6 219 1    F    0  NA

~~~

> ## Challenge 1 {.challenge}
>
> Create a data frame that holds the following information for yourself:
>
> * First name
> * Last name
> * Height
>
> Then use rbind to add the same information for the people sitting near you.
>
> Now use cbind to add a column of logicals that will, for each
>person, hold the answer to the question,
> "Is there anything in this workshop you're finding confusing?"
>

## Reading in data

Now we want to load our data into R. We will use PSRC land use data, particularly in this lesson the number of households in cities.
Before reading in data, it's a good idea to have a look at its structure.
Let's take a look using our newly-learned shell skills:


~~~{.r}
cd data/ # navigate to the data directory of the project folder
head city__table__households.csv
~~~




~~~{.output}
city_id,households_2010,households_2020,households_2030,households_2040
49.0,43742.0,49969.0,52608.0,57695.0
94.0,13996.0,16912.0,20425.0,24603.0
95.0,40735.0,50907.0,61703.0,73879.0
96.0,2276.0,2484.0,2593.0,2753.0
97.0,762.0,759.0,787.0,822.0
98.0,16315.0,19519.0,20639.0,21839.0
99.0,958.0,1020.0,1126.0,1258.0
100.0,7130.0,8706.0,8867.0,9150.0
101.0,8078.0,9479.0,10496.0,11484.0

~~~

As its file extension would suggest, the file contains comma-separated
values, and seems to contain a header row.

We can use `read.table` to read this into R:


~~~{.r}
hh <- read.table(file="data/city__table__households.csv", header=TRUE, sep=",")
head(hh)
~~~



~~~{.output}
  city_id households_2010 households_2020 households_2030 households_2040
1      49           43742           49969           52608           57695
2      94           13996           16912           20425           24603
3      95           40735           50907           61703           73879
4      96            2276            2484            2593            2753
5      97             762             759             787             822
6      98           16315           19519           20639           21839

~~~

Because we know the structure of the data, we're able
to specify the appropriate arguments to `read.table`.
Without these arguments, `read.table` will do its
best to do something sensible, but it is always more
reliable to explicitly tell `read.table` the structure
of the data. `read.csv` function provides a convenient shortcut
for loading in CSV files.


~~~{.r}
# Here is the read.csv version of the above command
hh <- read.csv(file="data/city__table__households.csv")
head(hh)
~~~



~~~{.output}
  city_id households_2010 households_2020 households_2030 households_2040
1      49           43742           49969           52608           57695
2      94           13996           16912           20425           24603
3      95           40735           50907           61703           73879
4      96            2276            2484            2593            2753
5      97             762             759             787             822
6      98           16315           19519           20639           21839

~~~

> ## Miscellaneous Tips {.callout}
>
> 1. Another type of file you might encounter are tab-separated
> format. To specify a tab as a separator, use `sep="\t"`.
>
> 2. You can also read in files from the Internet by replacing
> the file paths with a web address.
>
> 3. You can read directly from excel spreadsheets without
> converting them to plain text first by using the `xlsx` package.
>

To make sure our analysis is reproducible, we should put the code
into a script file so we can come back to it later. It can be then run using the `source` function, using the file path
as its argument (or by pressing the "source" button in RStudio).

## Using data frames


To recap what we've just learned, let's have a look at our example
data (mumber of households in various cities for various years).

Remember, there are a few functions we can use to interrogate data structures in R:


~~~{.r}
class() # what is the data structure?
typeof() # what is its atomic type?
length() # how long is it? What about two dimensional objects?
attributes() # does it have any metadata?
str() # A full summary of the entire object
dim() # Dimensions of the object - also try nrow(), ncol()
~~~

Let's use them to explore the household dataset.


~~~{.r}
class(hh)
~~~



~~~{.output}
[1] "data.frame"

~~~

The household data is stored in a "data.frame". This is the default
data structure when you read in data, and (as we've heard) is useful
for storing data with mixed types of columns.

Let's add a column with the name of each city and merge the two datasets:


~~~{.r}
cities <- read.table(file="data/cities.csv", header=TRUE, sep=",")
head(cities)
~~~



~~~{.output}
  city_id       city_name county_id
1      49 Snohomish-Rural         1
2      94        Lynnwood         1
3      95         Everett         1
4      96           Brier         1
5      97      Brier MUGA         1
6      98         Edmonds         1

~~~
Let's look at some of the columns.

~~~{.r}
typeof(cities$city_id)
~~~



~~~{.output}
[1] "integer"

~~~



~~~{.r}
typeof(cities$city_name)
~~~



~~~{.output}
[1] "integer"

~~~
If you were expecting a the answer to be "character", you would rightly be
surprised by the answer. Let's take a look at the class of this column:


~~~{.r}
class(cities$city_name)
~~~



~~~{.output}
[1] "factor"

~~~
One of the default behaviours of R is to treat any text columns as "factors"
when reading in data. The reason for this is that text columns often represent
categorical data, which need to be factors to be handled appropriately by
the statistical modeling functions in R.

However it's not obvious behaviour, and something that trips many people up. We can
disable this behaviour and read in the data again.


~~~{.r}
options(stringsAsFactors=FALSE)
cities <- read.table(file="data/cities.csv", header=TRUE, sep=",")
class(cities$city_name)
~~~



~~~{.output}
[1] "character"

~~~

Remember, if you do turn it off automatic conversion to factors you will need to
explicitly convert the variables into factors when
running statistical models.
This can be useful, because it forces you to think about the
question you're asking, and makes it easier to specify the ordering of the categories.

However there are many in the R community who find it more sensible to
leave this as the default behaviour.

> ## Tip: Changing options {.callout} 
> When R starts, it runs any
>code in the file `.Rprofile` in the project directory. You can make
>permanent changes to default behaviour by storing the changes in that
>file. BE CAREFUL, however. If you change R's default options,
>programs written by others may not run correctly in your environment
>and vice versa. For this reason, some argue that most such changes
>should be in your scripts, where they are visible.


Let's merge the cities dataset with our households dataset.

~~~{.r}
hh <- merge(hh, cities, by="city_id", all=TRUE)
head(hh)
~~~



~~~{.output}
  city_id households_2010 households_2020 households_2030 households_2040
1       1            2617            2891            3000            3042
2       2           23596           27690           31164           34383
3       3           45354           49603           51937           55922
4       4            9904           12232           14401           16365
5       5           21511           24731           26511           28714
6       6           16555           18963           19916           19962
      city_name county_id
1 Normandy Park         2
2        Auburn         2
3    King-Rural         2
4       Sea Tac         2
5     Shoreline         2
6    Renton PAA         2

~~~
Let's add names of counties.

~~~{.r}
counties <- data.frame(county_id=1:4, county_name=c("Snohomish", "King", "Kitsap", "Pierce"))
hh <- merge(hh, counties, by="county_id", all=TRUE)
head(hh)
~~~



~~~{.output}
  county_id city_id households_2010 households_2020 households_2030
1         0      56              NA              NA              NA
2         0     140              NA              NA              NA
3         1     109           14853           17874           18051
4         1     113            9488           12157           13841
5         1     110            4836            5808            6218
6         1     108            4464            4986            5398
  households_2040     city_name county_name
1              NA Covington PAA        <NA>
2              NA      Enumclaw        <NA>
3           18542  Everett MUGA   Snohomish
4           15639  Lake Stevens   Snohomish
5            6688        Monroe   Snohomish
6            5873 Mukilteo MUGA   Snohomish

~~~

The first thing you should do when reading data in, is check that it matches what
you expect, even if the command ran without warnings or errors. The `str` function,
short for "structure", is really useful for this:


~~~{.r}
str(hh)
~~~



~~~{.output}
'data.frame':	142 obs. of  8 variables:
 $ county_id      : int  0 0 1 1 1 1 1 1 1 1 ...
 $ city_id        : num  56 140 109 113 110 108 104 105 111 103 ...
 $ households_2010: num  NA NA 14853 9488 4836 ...
 $ households_2020: num  NA NA 17874 12157 5808 ...
 $ households_2030: num  NA NA 18051 13841 6218 ...
 $ households_2040: num  NA NA 18542 15639 6688 ...
 $ city_name      : chr  "Covington PAA" "Enumclaw" "Everett MUGA" "Lake Stevens" ...
 $ county_name    : chr  NA NA "Snohomish" "Snohomish" ...

~~~

We can see that the object is a `data.frame` with 142 observations (rows),
and 8 variables (columns). Below that, we see the name of each column, followed
by a ":", followed by the type of variable in that column, along with the first
few entries.

We can retrieve or modify the column or row names
of the data.frame:


~~~{.r}
colnames(hh) 
~~~



~~~{.output}
[1] "county_id"       "city_id"         "households_2010" "households_2020"
[5] "households_2030" "households_2040" "city_name"       "county_name"    

~~~



~~~{.r}
colnames(hh)[3:6] <- paste0("hh", seq(10, 40, by=10))
head(hh, n=10)
~~~



~~~{.output}
   county_id city_id  hh10  hh20  hh30  hh40         city_name county_name
1          0      56    NA    NA    NA    NA     Covington PAA        <NA>
2          0     140    NA    NA    NA    NA          Enumclaw        <NA>
3          1     109 14853 17874 18051 18542      Everett MUGA   Snohomish
4          1     113  9488 12157 13841 15639      Lake Stevens   Snohomish
5          1     110  4836  5808  6218  6688            Monroe   Snohomish
6          1     108  4464  4986  5398  5873     Mukilteo MUGA   Snohomish
7          1     104  1409  1474  1836  2215 Larch Way Overlap   Snohomish
8          1     105  7804 10878 11153 11644      Bothell MUGA   Snohomish
9          1     111  6502  8031  9007 10019         Arlington   Snohomish
10         1     103 12883 15834 17192 18660   Mill Creek MUGA   Snohomish

~~~


~~~{.r}
rownames(hh)[1:20]
~~~



~~~{.output}
 [1] "1"  "2"  "3"  "4"  "5"  "6"  "7"  "8"  "9"  "10" "11" "12" "13" "14"
[15] "15" "16" "17" "18" "19" "20"

~~~

See those numbers in the square brackets on the left? That tells you
the number of the first entry in that row of output. 

There are a few related ways of retrieving and modifying this information.
`attributes` will give you both the row and column names, along with the
class information, while `dimnames` will give you just the rownames and
column names.

In both cases, the output object is stored in a `list`:


~~~{.r}
str(dimnames(hh))
~~~



~~~{.output}
List of 2
 $ : chr [1:142] "1" "2" "3" "4" ...
 $ : chr [1:8] "county_id" "city_id" "hh10" "hh20" ...

~~~

We can look at some summary statistics:

~~~{.r}
summary(hh)
~~~



~~~{.output}
   county_id        city_id            hh10               hh20       
 Min.   :0.000   Min.   :  1.00   Min.   :     0.0   Min.   :     1  
 1st Qu.:1.000   1st Qu.: 36.25   1st Qu.:   523.5   1st Qu.:   609  
 Median :2.000   Median : 71.50   Median :  3501.5   Median :  4200  
 Mean   :2.092   Mean   : 71.50   Mean   : 10433.7   Mean   : 12325  
 3rd Qu.:3.000   3rd Qu.:106.75   3rd Qu.:  9080.2   3rd Qu.: 10844  
 Max.   :4.000   Max.   :142.00   Max.   :286525.0   Max.   :335516  
                                  NA's   :2          NA's   :2       
      hh30               hh40           city_name        
 Min.   :     2.0   Min.   :     2.0   Length:142        
 1st Qu.:   776.2   1st Qu.:   869.2   Class :character  
 Median :  4332.5   Median :  4587.5   Mode  :character  
 Mean   : 13614.8   Mean   : 15055.1                     
 3rd Qu.: 11889.0   3rd Qu.: 14257.2                     
 Max.   :363492.0   Max.   :396033.0                     
 NA's   :2          NA's   :2                            
 county_name       
 Length:142        
 Class :character  
 Mode  :character  
                   
                   
                   
                   

~~~

## Challenge Solutions

> ## Solution to Challenge 1 {.challenge}
>
> Create a data frame that holds the following information for yourself:
>
> * First name
> * Last name
> * Height
>
> Then use rbind to add the same information for the people sitting near you.
>
> Now use cbind to add a column of logicals answering the question,
> "Is there anything in this workshop you're finding confusing?"
>
> 
> ~~~{.r}
> my_df <- data.frame(first_name = "Software", last_name = "Carpentry", height = 170)
> my_df <- rbind(my_df, list("Jane", "Smith", 160))
> my_df <- rbind(my_df, list(c("Jo", "John"), c("White", "Lee"), c(165, 179)))
> my_df <- cbind(my_df, confused = c(FALSE, FALSE, TRUE, FALSE))
> ~~~
