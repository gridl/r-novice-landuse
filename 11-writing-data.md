---
layout: page
title: R for Data Analysis
subtitle: Writing data
minutes: 20
---



> ## Learning Objectives {.objectives}
>
> * To be able to write out data from R
>


## Writing data

At some point, you'll also want to write out data from R.

We can use the `write.table` function for this, which is
very similar to `read.table` from before.



~~~{.r}
lu.subset <- lu[county_id==2,]

write.table(lu.subset,
  file="cleaned-data/lu-King.csv",
  sep=","
)
~~~

Let's switch back to the shell to take a look at the data to make sure it looks
OK:


~~~{.r}
# head cleaned-data/lu-King.csv
~~~

Hmm, that's not quite what we wanted. Where did all these
quotation marks come from? Also the row numbers are
meaningless.

Let's look at the help file to work out how to change this
behaviour.


~~~{.r}
?write.table
~~~

By default R will wrap character vectors with quotation marks
when writing out to file. It will also write out the row and
column names.

Let's fix this:


~~~{.r}
write.table(
  lu.subset,
  file="cleaned-data/lu-King.csv",
  sep=",", quote=FALSE, row.names=FALSE
)
~~~

Now lets look at the data again using our shell skills:


~~~{.r}
# head cleaned-data/lu-King.csv
~~~

That looks better!



