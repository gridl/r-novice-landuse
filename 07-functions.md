---
layout: page
title: R for Data Analysis
subtitle: Creating functions
minutes: 45
---



> ## Learning Objectives {.objectives}
>
> * Define a function that takes arguments.
> * Return a value from a function.
> * Test a function.
> * Set default values for function arguments.
> * Explain why we should divide programs into small, single-purpose functions.
>


In this lesson, we'll learn how to write a function so that we can repeat
several operations with a single command.

> ## What is a function? {.callout}
>
> Functions gather a sequence of operations into a whole, preserving it for ongoing use. Functions provide:
>
> * a name we can remember and invoke it by
> * relief from the need to remember the individual operations
> * a defined set of inputs and expected outputs
> * rich connections to the larger programming environment
>


## Defining a function

Let's open a new R script file  and call it functions-lesson.R.


~~~{.r}
sqft.to.acres <- function(a) {
  res <- a/43560
  return(res)
}
~~~

We define `sqft.to.acres` by assigning it to the output of `function`.
The list of argument names are contained within parentheses.
Next, the [body](reference.html#function-body) of the function--the statements that are executed when it runs--is contained within curly braces (`{}`).
The statements in the body are indented by two spaces.
This makes the code easier to read but does not affect how the code operates.

When we call the function, the values we pass to it are assigned to those variables so that we can use them inside the function.
Inside the function, we use a [return statement](reference.html#return-statement) to send a result back to whoever asked for it.

> ## Tip {.callout}
>
> One feature unique to R is that the return statement is not required.
> R automatically returns whichever variable is on the last line of the body
> of the function. Since we are just learning, we will explicitly define the
> return statement.

Let's try running our function.
Calling our own function is no different from calling any other function:


~~~{.r}
sqft.to.acres(43560)
~~~



~~~{.output}
[1] 1

~~~



~~~{.r}
tmp <- 10000
sqft.to.acres(tmp)
~~~



~~~{.output}
[1] 0.2295684

~~~


## Combining functions

The real power of functions comes from mixing, matching and combining them
into ever large chunks to get the effect we want.

Here we convert sqft to acres and append it as an additional column of the dataset:


~~~{.r}
add.acres <- function(dat) {
  myacres <- sqft.to.acres(dat$sqft)
  res <- cbind(dat, acres=myacres)
  return(res)
}
add.acres(head(lu))
~~~



~~~{.output}
  city_id  jobs households population res_units non_res_sqft land_value
1       1   922       2617       6611      2755       615598  275640912
2       2 38502      23596      60745     26346     35964539 1509291684
3       3 22881      45354     127118     48953      9079211 6964260859
4       4 26873       9904      24794     10741     17998962  955239156
5       5 17837      21511      52300     23408      9504741 1978268350
6       6  5029      16555      44472     18417      2588666 1020261165
  buildings occupied_res_units sf_res_units        sqft     city_name
1      2334               2617         2292    58644448 Normandy Park
2     15119              23596        13672   683027700        Auburn
3     47772              45354        47548 45768604944    King-Rural
4      6304               9904         6029   233889021       Sea Tac
5     17112              21511        16438   261146157     Shoreline
6     13713              16555        13525   272113873    Renton PAA
  county_id       acres
1         2    1346.291
2         2   15680.158
3         2 1050702.593
4         2    5369.353
5         2    5995.091
6         2    6246.875

~~~

Now we're going to define
a function that returns cities with sqft per job ratio above certain threshold:


~~~{.r}
job.space.above <- function(dat, threshold=700) {
  idx <- which(dat$jobs > 0)
  ratio <- dat$non_res_sqft[idx]/dat$jobs[idx]
  return(dat[idx,]$city_name[ratio > threshold])
}
job.space.above(lu)
~~~



~~~{.output}
 [1] "Auburn"            "Kent"              "Tukwila"          
 [4] "Kent PAA"          "Enumclaw"          "Pierce-Rural"     
 [7] "Algona"            "Snoqualmie"        "Bear Creek UPD"   
[10] "UUU"               "Skykomish"         "UU"               
[13] "Milton"            "Carnation"         "Milton PAA"       
[16] "Bellevue PAA"      "Tacoma"            "Steilacoom"       
[19] "DuPont"            "Roy"               "Ruston"           
[22] "Fife"              "Eatonville"        "Orting"           
[25] "Edgewood"          "Sumner"            "Bonney Lake"      
[28] "South Prairie"     "Carbonado"         "Wilkeson"         
[31] "Lynnwood"          "Edmonds"           "Mill Creek"       
[34] "Mountlake Terrace" "Lynnwood MUGA"     "Mill Creek MUGA"  
[37] "Bothell MUGA"      "Marysville"        "Lake Stickney Gap"
[40] "Everett MUGA"      "Monroe"            "Arlington"        
[43] "Snohomish"         "Sultan"            "Darrington"       
[46] "Gold Bar UGA"      "Edmonds MUGA"      "Stanwood"         
[49] "Snohomish UGA"     "Gold Bar"          "Granite Falls"    
[52] "Index"             "Maltby UGA"        "PAINE FIELD AREA" 
[55] "Darrington UGA"   

~~~



~~~{.r}
job.space.above(lu, 2000)
~~~



~~~{.output}
[1] "UUU"            "Milton"         "Darrington UGA"

~~~


If you've been writing these functions down into a separate R script
(a good idea!), you can load in the functions into our R session by using the
`source` function:


~~~{.r}
source("functions-lesson.R")
~~~

We've set a
*default argument* to `700` using the `=` operator
in the function definition. This means that this argument will
take on that value unless the user specifies otherwise.


> ## Tip: Pass by value {.callout}
>
> Functions in R almost always make copies of the data to operate on
> inside of a function body. When we modify `dat` inside the function
> we are modifying the copy of the gapminder dataset stored in `dat`,
> not the original variable we gave as the first argument.
>
> This is called "pass-by-value" and it makes writing code much safer:
> you can always be sure that whatever changes you make within the
> body of the function, stay inside the body of the function.
>

> ## Tip: Function scope {.callout}
>
> Another important concept is scoping: any variables (or functions!) you
> create or modify inside the body of a function only exist for the lifetime
> of the function's execution. When we call `cities.above`, the variables `dat`,
> `threshold`, `idx` and `ratio` only exist inside the body of the function. Even if we
> have variables of the same name in our interactive R session, they are
> not modified in any way when executing a function.
>


> ## Challenge 1 {.challenge}
>
> The `paste` function can be used to combine text together, e.g:
>
> 
> ~~~{.r}
> best_practice <- c("Write", "programs", "for", "people", "not", "computers")
> paste(best_practice, collapse=" ")
> ~~~
> 
> 
> 
> ~~~{.output}
> [1] "Write programs for people not computers"
> 
> ~~~
>
>  Write a function called `fence` that takes two vectors as arguments, called
> `text` and `wrapper`, and prints out the text wrapped with the `wrapper`:
>
> 
> ~~~{.r}
> fence(text=best_practice, wrapper="***")
> ~~~
>
> *Note:* the `paste` function has an argument called `sep`, which specifies the
> separator between text. The default is a space: " ". The default for `paste0`
> is no space "".
>

> ## Tip {.callout}
>
> R has some unique aspects that can be exploited when performing
> more complicated operations. We will not be writing anything that requires
> knowledge of these more advanced concepts. In the future when you are
> comfortable writing functions in R, you can learn more by reading the
> [R Language Manual][man] or this [chapter][] from
> [Advanced R Programming][adv-r] by Hadley Wickham. For context, R uses the
> terminology "environments" instead of frames.

[man]: http://cran.r-project.org/doc/manuals/r-release/R-lang.html#Environment-objects
[chapter]: http://adv-r.had.co.nz/Environments.html
[adv-r]: http://adv-r.had.co.nz/


<a id="control-flow"></a>

## Control Flow

The meaning of the control flow structures `if else`, `for` and `while` is the same as in Python or other programming languages. What differs is the syntax. Let's learn these construct on examples.

First let's modify our `job.space.above` funtion to control for both ends of the distribution:

~~~{.r}
job.space.outliers <- function(dat, threshold=700, above=TRUE) {
  idx <- which(dat$jobs > 0)
  ratio <- dat$non_res_sqft[idx]/dat$jobs[idx]
  if(above) {
  	res <- dat[idx,]$city_name[ratio > threshold]
  } else {
  	res <- dat[idx,]$city_name[ratio <= threshold]
  }
  return(res)
}
outl.above <- job.space.outliers(lu, 2000)
outl.above
~~~



~~~{.output}
[1] "UUU"            "Milton"         "Darrington UGA"

~~~



~~~{.r}
outl.below <- job.space.outliers(lu, 50, above=FALSE)
outl.below 
~~~



~~~{.output}
 [1] "Tukwila PAA"            "Black Diamond PAA"     
 [3] "Yarrow Point"           "Hunts Point"           
 [5] "Beaux Arts"             "Pacific PAA"           
 [7] "JBLM"                   "Woodway"               
 [9] "Mountlake Terrace MUGA" "Arlington UGA"         
[11] "Sultan UGA"            

~~~

We have our vectors of cities obtained `outl.above` and `outl.below` and we want to extract data corresponding to those cities from the households dataset:

~~~{.r}
for(city in outl.above) {
	idx <- which(hh$city_name == city)
	print(hh[idx,])
}
~~~



~~~{.output}
   county_id city_id hh10 hh20 hh30 hh40 city_name county_name
92         2      46  889 1459 1530 1528       UUU        King
    county_id city_id hh10 hh20 hh30 hh40 city_name county_name
100         2      54  363  382  389  395    Milton        King
141         4     141 2541 3011 3057 3106    Milton      Pierce
   county_id city_id hh10 hh20 hh30 hh40      city_name county_name
41         1     137   37   65  141  227 Darrington UGA   Snohomish

~~~
This does not look very pretty. We can improve by binding the rows together:

~~~{.r}
res <- NULL
for(city in outl.above) {
	idx <- which(hh$city_name == city)
	res <- rbind(res, hh[idx,])
}
print(res)
~~~



~~~{.output}
    county_id city_id hh10 hh20 hh30 hh40      city_name county_name
92          2      46  889 1459 1530 1528            UUU        King
100         2      54  363  382  389  395         Milton        King
141         4     141 2541 3011 3057 3106         Milton      Pierce
41          1     137   37   65  141  227 Darrington UGA   Snohomish

~~~



~~~{.r}
res <- NULL
for(city in outl.below) {
	idx <- which(hh$city_name == city)
	res <- rbind(res, hh[idx,])
}
print(res)
~~~



~~~{.output}
    county_id city_id hh10 hh20 hh30 hh40              city_name
86          2      40    7   21   36   37            Tukwila PAA
91          2      45   64   36   38   40      Black Diamond PAA
93          2      47  416  432  444  447           Yarrow Point
94          2      48  197  164  173  173            Hunts Point
97          2      51  116  122  125  127             Beaux Arts
102         2      61  295  345  396  398            Pacific PAA
132         4      75 1389 4123 3764 3543                   JBLM
32          1     115  450  496  494  502                Woodway
23          1     119   34   11   13   15 Mountlake Terrace MUGA
28          1     124  213  230  311  402          Arlington UGA
39          1     135  167  174  321  489             Sultan UGA
    county_name
86         King
91         King
93         King
94         King
97         King
102        King
132      Pierce
32    Snohomish
23    Snohomish
28    Snohomish
39    Snohomish

~~~

Sometimes you will find yourself needing to repeat an operation until a certain
condition is met. You can do this with a `while` loop.

Say we want the above data frame but with maximum of five rows:

~~~{.r}
res <- NULL
i <- 1
while(i <= 5) {
	idx <- which(hh$city_name == outl.below[i])
	res <- rbind(res, hh[idx,])
	i = i + 1
}
print(res)
~~~



~~~{.output}
   county_id city_id hh10 hh20 hh30 hh40         city_name county_name
86         2      40    7   21   36   37       Tukwila PAA        King
91         2      45   64   36   38   40 Black Diamond PAA        King
93         2      47  416  432  444  447      Yarrow Point        King
94         2      48  197  164  173  173       Hunts Point        King
97         2      51  116  122  125  127        Beaux Arts        King

~~~

> ## Challenge 2 {.challenge}
>
> How would you vectorise the following loop
> 
> 
> ~~~{.r}
> res <- NULL
> for(city in outl.below) {
>   idx <- which(hh$city_name == city)
>   res <- rbind(res, hh[idx,])
> }
> ~~~

## Challenge solutions


> ## Solution to challenge 1 {.challenge}
>
>  Write a function called `fence` that takes two vectors as arguments, called
> `text` and `wrapper`, and prints out the text wrapped with the `wrapper`:
>
> 
> ~~~{.r}
> fence <- function(text, wrapper){
>   text <- c(wrapper, text, wrapper)
>   result <- paste(text, collapse = " ")
>   return(result)
> }
> best_practice <- c("Write", "programs", "for", "people", "not", "computers")
> fence(text=best_practice, wrapper="***")
> ~~~
> 
> 
> 
> ~~~{.output}
> [1] "*** Write programs for people not computers ***"
> 
> ~~~

> ## Solution to challenge 2 {.challenge}
>
> 
> ~~~{.r}
> hh[which(hh$city_name %in% outl.below),]
> ~~~
> 
> 
> 
> ~~~{.output}
>     county_id city_id hh10 hh20 hh30 hh40              city_name
> 23          1     119   34   11   13   15 Mountlake Terrace MUGA
> 28          1     124  213  230  311  402          Arlington UGA
> 32          1     115  450  496  494  502                Woodway
> 39          1     135  167  174  321  489             Sultan UGA
> 86          2      40    7   21   36   37            Tukwila PAA
> 91          2      45   64   36   38   40      Black Diamond PAA
> 93          2      47  416  432  444  447           Yarrow Point
> 94          2      48  197  164  173  173            Hunts Point
> 97          2      51  116  122  125  127             Beaux Arts
> 102         2      61  295  345  396  398            Pacific PAA
> 132         4      75 1389 4123 3764 3543                   JBLM
>     county_name
> 23    Snohomish
> 28    Snohomish
> 32    Snohomish
> 39    Snohomish
> 86         King
> 91         King
> 93         King
> 94         King
> 97         King
> 102        King
> 132      Pierce
> 
> ~~~
