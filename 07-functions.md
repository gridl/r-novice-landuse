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

Let's define two functions that will convert temperature from Fahrenheit to
Kelvin, and Kelvin to Celsius:


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
cities.above <- function(dat, threshold=700) {
  idx <- which(dat$jobs > 0)
  ratio <- dat$non_res_sqft[idx]/dat$jobs[idx]
  return(dat$city_name[ratio > threshold])
}
cities.above(lu)
~~~



~~~{.output}
 [1] "Auburn"            "Kent"              "Tukwila"          
 [4] "Kent PAA"          "Enumclaw"          "Pierce-Rural"     
 [7] "Algona"            "Newcastle PAA"     "Snoqualmie"       
[10] "Black Diamond PAA" "Beaux Arts"        "Skykomish"        
[13] "UU"                "Milton"            "Carnation"        
[16] "Milton PAA"        "Bellevue PAA"      "Poulsbo PUTA"     
[19] "Steilacoom"        "DuPont"            "University Place" 
[22] "Fircrest"          "Ruston"            "Eatonville"       
[25] "Puyallup"          "Orting"            "Edgewood"         
[28] "Sumner"            "Bonney Lake"       "Carbonado"        
[31] "Buckley"           "Brier"             "Edmonds"          
[34] "Meadowdale Gap"    "Mill Creek"        "Mountlake Terrace"
[37] "Mill Creek MUGA"   "Larch Way Overlap" "Bothell MUGA"     
[40] "Lake Stickney Gap" "Mukilteo MUGA"     "Everett MUGA"     
[43] "Monroe"            "Snohomish"         "Sultan"           
[46] "Woodway"           "Darrington"        "Marysville UGA"   
[49] "Arlington UGA"     "Snohomish UGA"     "Silver Firs Gap"  
[52] "Granite Falls"     "Stanwood UGA"      "Index"            
[55] "Granite Falls UGA" "Bothell"          

~~~



~~~{.r}
cities.above(lu, 2000)
~~~



~~~{.output}
[1] "Black Diamond PAA" "UU"                "Granite Falls UGA"

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


> ## Tip: Testing and documenting {.callout}
>
> It's important to both test functions and document them:
> Documentation helps you, and others, understand what the
> purpose of your function is, and how to use it, and its
> important to make sure that your function actually does
> what you think.
>
> When you first start out, your workflow will probably look a lot
> like this:
>
>  1. Write a function
>  2. Comment parts of the function to document its behaviour
>  3. Load in the source file
>  4. Experiment with it in the console to make sure it behaves
>     as you expect
>  5. Make any necessary bug fixes
>  6. Rinse and repeat.
>
> Formal documentation for functions, written in separate `.Rd`
> files, gets turned into the documentation you see in help
> files. The [roxygen2][] package allows R coders to write documentation alongside
> the function code and then process it into the appropriate `.Rd` files.
> You will want to switch to this more formal method of writing documentation
> when you start writing more complicated R projects.
>
> Formal automated tests can be written using the [testthat][] package.

[roxygen2]: http://cran.r-project.org/web/packages/roxygen2/vignettes/rd.html
[testthat]: http://r-pkgs.had.co.nz/tests.html

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
