---
title: Using RDA Files as a Notebook
author: Dan Kelley
date: 2024-02-08
---

Lots of my work involves quite a few R files that are executed in order.  For
example, `01-prune-data.R` might be executed first, and `02-filter-data.R`
might be executed next.  If the intermediate results are tabular, I might save
them in CSV or similar text files, but quite often I use RDA files, either
because the data are in a complex form (e.g. containing lists) or because the
data are large.

When I get close to the paper-writing stage, though, I often want to pick out
things that not just interconnecting data, but rather processed data. For
example, I might do a `lm()` and then find the coefficients, the p value,
etc., perhaps rounded to the number of digits that I want for publication.  Or
I might want to store the number of data in a particular category.  But the
problem is that one of the many things I might want could be defined in one R
file, and another might be in another file. That means that, when I want to
incorporate the results into a publication, I have to remember not just the name
of an item, but also the name of the particular file that stores it.

Below is a scheme that gets around this.  I won't bother explaining it in much
detail.  I might decide to make it into a package, in which case I'll document
how things work.  But, in a nutshell, the idea is that a single RDA file is
created at an early stage of processing, and that R files may later write
results there as desired.  Note that the stored items can be any R object, e.g.
the full results of `lm()`, etc.  It is, of course, required that the user be
aware of the objects that are already stored.  I will write a function to do
that, perhaps updating this blog posting if I do.  But I plan to use the code
you see below in an actual project, to see what "feels right", rather than
planning it out in advance.  My approach is to use a saw before a plane, a
plane before sandpaper, and so on.

**UPDATE 2024-02-09.** I am going to make a package for this, to save having to copy the code from one spot to another, and doing `source()` in code that uses it. While I'm at it, I'll invent a scheme where you can specify which RDA file to use at the start of your script, and then don't need to name it in calls to e.g. `saveRda()`.  The natural name for the package seems to be `rdan`, for RDA-notebook (also for "arrh Dan", as a pirate might say.)

### Example

Here's an example of why I made this. I like how I can insert comments in
there, as well as values.  And I think it will be convenient in an Rmd or Rnw
file (that is, in a final document) to have all such things loadable in a
single rda file.

```R
> load("results.rda"); str(results)
List of 4
 $ havePair:List of 3
  ..$ value  : Named logi [1:1453] TRUE TRUE TRUE FALSE TRUE TRUE ...
  .. ..- attr(*, "names")= chr [1:1453] "D1901534_152" "D1901534_153" "D3901601_002" "D3901601_003" ...
  ..$ comment: chr "profile has warmish-coldish pair"
  ..$ context: chr "/Users/kelley/git/argo_intrusions/sandbox/dek/01"
 $ m1ar2   :List of 3
  ..$ value  : num 0.709
  ..$ comment: chr "adj R^2 from lm() of tagged fraction vs longitude"
  ..$ context: chr "/Users/kelley/git/argo_intrusions/sandbox/dek/01"
 $ m1p     :List of 3
  ..$ value  : num 3.39e-09
  ..$ comment: chr "p from lm() of tagged fraction vs longitude"
  ..$ context: chr "/Users/kelley/git/argo_intrusions/sandbox/dek/01"
 $ m2p     :List of 3
  ..$ value  : num 0.564
  ..$ comment: chr "p from lm() of # profiles vs longitude"
  ..$ context: chr "/Users/kelley/git/argo_intrusions/sandbox/dek/01"
```

### Code


```R
debug <- FALSE
dmsg <- function(...) if (debug) message(...)

createRDA <- function(rdaName = "results.rda", clear = FALSE) {
    if (clear || !file.exists(rdaName)) {
        dmsg("creating RDA file \"", rdaName, "\"")
        results <- list() # stores name, value, comment and context
        save(results, file = rdaName)
    } else {
        dmsg("RDA file \"", rdaName, "\" already exists, so will not be recreated")
    }
}

readRDA <- function(name = NULL, rdaName = "results.rda") {
    if (!file.exists(rdaName)) {
        stop("RDA file \"", rdaName, "\" does not exist yet; use createRDA()")
    }
    get(load(rdaName))[[name]]
}

writeRDA <- function(name = NULL, value = NULL, comment = "", context = NULL, rdaName = "results.rda") {
    if (!file.exists(rdaName)) {
        stop("RDA file \"", rdaName, "\" does not exist yet; use createRDA()")
    }
    load(rdaName) # defines 'results'
    if (is.null(context)) {
        context <- getwd()
    }
    results[[name]] <- list(value = value, comment = comment, context = context)
    #print(str(results))
    save(results, file = rdaName)
}

## demo
#createRDA(clear = TRUE)
#readRDA("test")
#stopifnot(is.null(readRDA("test")))
#writeRDA("test", 999)
#stopifnot(identical(list(value = 999, comment = ""), readRDA("test")))
#writeRDA("test", list(A = 1, B = 2), "a list")
#stopifnot(identical(A, list(value = list(A = 1, B = 2), comment = "a list")))
```
