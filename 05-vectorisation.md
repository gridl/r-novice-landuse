---
layout: page
title: R for Data Analysis
subtitle: Vectorisation
minutes: 30
---



> ## Learning Objectives {.objectives}
>
> * To understand vectorised operations in R.
>

Most of R's functions are vectorised, meaning that the function will
operate on all elements of a vector without needing to loop through
and act on each element one at a time. This makes writing code more
concise, easy to read, and less error prone.



~~~{.r}
x <- 1:4
x * 2
~~~



~~~{.output}
[1] 2 4 6 8

~~~

The multiplication happened to each element of the vector.

We can also add two vectors together:


~~~{.r}
y <- 6:9
x + y
~~~



~~~{.output}
[1]  7  9 11 13

~~~

Each element of `x` was added to its corresponding element of `y`:


~~~{.r}
x:  1  2  3  4
    +  +  +  +
y:  6  7  8  9
---------------
    7  9 11 13
~~~


Vectorised operations work element-wise on matrices:


~~~{.r}
m <- matrix(1:12, nrow=3, ncol=4)
m * -1  
~~~



~~~{.output}
     [,1] [,2] [,3] [,4]
[1,]   -1   -4   -7  -10
[2,]   -2   -5   -8  -11
[3,]   -3   -6   -9  -12

~~~
 

> ## Tip: element-wise vs. matrix multiplication {.callout}
>
> Very important: the operator `*` gives you element-wise multiplication!
> To do matrix multiplication, we need to use the `%*%` operator:
> 
> 
> ~~~{.r}
> m %*% matrix(1, nrow=4, ncol=1)
> ~~~
> 
> 
> 
> ~~~{.output}
>      [,1]
> [1,]   22
> [2,]   26
> [3,]   30
> 
> ~~~
> 
> 
> 
> ~~~{.r}
> matrix(1:4, nrow=1) %*% matrix(1:4, ncol=1)
> ~~~
> 
> 
> 
> ~~~{.output}
>      [,1]
> [1,]   30
> 
> ~~~
>
> For more on matrix algebra, see the [Quick-R reference
> guide](http://www.statmethods.net/advstats/matrix.html)

To combine a matrix with a vector, keep in mind that the element-wise combination happens by columns:

~~~{.r}
m
~~~



~~~{.output}
     [,1] [,2] [,3] [,4]
[1,]    1    4    7   10
[2,]    2    5    8   11
[3,]    3    6    9   12

~~~



~~~{.r}
x
~~~



~~~{.output}
[1] 1 2 3 4

~~~



~~~{.r}
m * x
~~~



~~~{.output}
     [,1] [,2] [,3] [,4]
[1,]    1   16   21   20
[2,]    4    5   32   33
[3,]    9   12    9   48

~~~
To do it by rows, first create a matrix from the vector and then combine the two matrices:

~~~{.r}
xm <- matrix(rep(x, 3), nrow=3, byrow=TRUE)
xm
~~~



~~~{.output}
     [,1] [,2] [,3] [,4]
[1,]    1    2    3    4
[2,]    1    2    3    4
[3,]    1    2    3    4

~~~



~~~{.r}
m * xm
~~~



~~~{.output}
     [,1] [,2] [,3] [,4]
[1,]    1    8   21   40
[2,]    2   10   24   44
[3,]    3   12   27   48

~~~




> ## Challenge 3 {.challenge}
>
> Given the following matrix:
>
> 
> ~~~{.r}
> m <- matrix(1:12, nrow=3, ncol=4)
> m
> ~~~
> 
> 
> 
> ~~~{.output}
>      [,1] [,2] [,3] [,4]
> [1,]    1    4    7   10
> [2,]    2    5    8   11
> [3,]    3    6    9   12
> 
> ~~~
>
> Write down what you think will happen when you run:
>
> 1. `m ^ -1`
> 2. `m * c(1, 0, -1)`
> 3. `m > c(0, 20)`
> 4. `m * c(1, 0, -1, 2)`
>
> Did you get the output you expected? If not, ask a helper!
>

> ## Challenge 4 {.challenge}
>
> We're interested in looking at the sum of the
> following sequence of fractions:
>
> 
> ~~~{.r}
>  x = 1/(1^2) + 1/(2^2) + 1/(3^2) + ... + 1/(n^2)
> ~~~
>
> This would be tedious to type out, and impossible for high values of
> n.  Use vectorisation to compute x when n=100. What is the sum when
> n=10,000?


## Applying functions across rows/columns

What if we need an operation (average, sum etc.)  across rows or across columns? 

<img src="fig/r-operations-across-axes.svg" alt="Operations Across Axes" />

To support this, we can use the `apply` function.

> ## Tip {.callout}
>
> To learn about a function in R, e.g. `apply`, we can read its help
> documention by running `help(apply)` or `?apply`.

`apply` allows us to repeat a function on all of the rows (`MARGIN = 1`) or columns (`MARGIN = 2`) of a data frame. For example, using the `m` matrix, instead of

~~~{.r}
mean(m[1,])
~~~



~~~{.output}
[1] 5.5

~~~



~~~{.r}
mean(m[2,])
~~~



~~~{.output}
[1] 6.5

~~~



~~~{.r}
mean(m[3,])
~~~



~~~{.output}
[1] 7.5

~~~
we do

~~~{.r}
apply(m, 1, mean) # average across rows
~~~



~~~{.output}
[1] 5.5 6.5 7.5

~~~
Also, we can do

~~~{.r}
apply(m, 2, min) # minimum across columns
~~~



~~~{.output}
[1]  1  4  7 10

~~~



~~~{.r}
apply(m, 2, sum) # sum across columns
~~~



~~~{.output}
[1]  6 15 24 33

~~~

Similarly, with our pierce subset dataset:

~~~{.r}
apply(pierce[,3:6], 2, sum)
~~~



~~~{.output}
  hh10   hh20   hh30   hh40 
299055 360567 409423 462854 

~~~
and the households dataset:

~~~{.r}
apply(hh[,3:6], 2, sum)
~~~



~~~{.output}
hh10 hh20 hh30 hh40 
  NA   NA   NA   NA 

~~~
because

~~~{.r}
sum(c(3, NA))
~~~



~~~{.output}
[1] NA

~~~



~~~{.r}
sum(c(3, NA), na.rm=TRUE)
~~~



~~~{.output}
[1] 3

~~~
Therefore

~~~{.r}
apply(hh[,3:6], 2, sum, na.rm=TRUE)
~~~



~~~{.output}
   hh10    hh20    hh30    hh40 
1460716 1725533 1906077 2107710 

~~~

## Challenge solutions

> ## Solution to challenge 3 {.challenge}
>
> Given the following matrix:
>
> 
> ~~~{.r}
> m <- matrix(1:12, nrow=3, ncol=4)
> m
> ~~~
> 
> 
> 
> ~~~{.output}
>      [,1] [,2] [,3] [,4]
> [1,]    1    4    7   10
> [2,]    2    5    8   11
> [3,]    3    6    9   12
> 
> ~~~
>
>
> Write down what you think will happen when you run:
>
> 1. `m ^ -1`
>
> 
> ~~~{.output}
>           [,1]      [,2]      [,3]       [,4]
> [1,] 1.0000000 0.2500000 0.1428571 0.10000000
> [2,] 0.5000000 0.2000000 0.1250000 0.09090909
> [3,] 0.3333333 0.1666667 0.1111111 0.08333333
> 
> ~~~
>
> 2. `m * c(1, 0, -1)`
>
> 
> ~~~{.output}
>      [,1] [,2] [,3] [,4]
> [1,]    1    4    7   10
> [2,]    0    0    0    0
> [3,]   -3   -6   -9  -12
> 
> ~~~
>
> 3. `m > c(0, 20)`
>
> 
> ~~~{.output}
>       [,1]  [,2]  [,3]  [,4]
> [1,]  TRUE FALSE  TRUE FALSE
> [2,] FALSE  TRUE FALSE  TRUE
> [3,]  TRUE FALSE  TRUE FALSE
> 
> ~~~
>

> ##  Challenge 4 {.challenge}
>
> We're interested in looking at the sum of the
> following sequence of fractions:
>
> 
> ~~~{.r}
>  x = 1/(1^2) + 1/(2^2) + 1/(3^2) + ... + 1/(n^2)
> ~~~
>
> This would be tedious to type out, and impossible for
> high values of n.
> Can you use vectorisation to compute x, when n=100?
> How about when n=10,000?
>
> 
> ~~~{.r}
> sum(1/(1:100)^2)
> ~~~
> 
> 
> 
> ~~~{.output}
> [1] 1.634984
> 
> ~~~
> 
> 
> 
> ~~~{.r}
> sum(1/(1:1e04)^2)
> ~~~
> 
> 
> 
> ~~~{.output}
> [1] 1.644834
> 
> ~~~
> 
> 
> 
> ~~~{.r}
> n <- 10000
> sum(1/(1:n)^2)
> ~~~
> 
> 
> 
> ~~~{.output}
> [1] 1.644834
> 
> ~~~
> 
> We can also obtain the same results using a function:
> 
> ~~~{.r}
> inverse_sum_of_squares <- function(n) {
>   sum(1/(1:n)^2)
> }
> inverse_sum_of_squares(100)
> ~~~
> 
> 
> 
> ~~~{.output}
> [1] 1.634984
> 
> ~~~
> 
> 
> 
> ~~~{.r}
> inverse_sum_of_squares(10000)
> ~~~
> 
> 
> 
> ~~~{.output}
> [1] 1.644834
> 
> ~~~
> 
> 
> 
> ~~~{.r}
> n <- 10000
> inverse_sum_of_squares(n)
> ~~~
> 
> 
> 
> ~~~{.output}
> [1] 1.644834
> 
> ~~~
>

