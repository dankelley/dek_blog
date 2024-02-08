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


```R
debug <- FALSE
dmsg <- function(...) if (debug) message(...)

createRDA <- function(rdaName = "results.rda", empty = FALSE) {
    if (empty || !file.exists(rdaName)) {
        dmsg("creating RDA file \"", rdaName, "\"")
        results <- list()
        save(results, file = rdaName)
    } else {
        warning("RDA file \"", rdaName, "\" already exists, so will not be recreated")
    }
}

readRDA <- function(name = NULL, rdaName = "results.rda") {
    if (!file.exists(rdaName)) {
        stop("RDA file \"", rdaName, "\" does not exist yet; use createRDA()")
    }
    get(load(rdaName))[[name]]
}

writeRDA <- function(name = NULL, value = NULL, replace = FALSE, rdaName = "results.rda") {
    if (!file.exists(rdaName)) {
        stop("RDA file \"", rdaName, "\" does not exist yet; use createRDA()")
    }
    load(rdaName)
    names <- names(results)
    if (!replace && name %in% names(results)) {
        stop("use replace=TRUE to replace an existing value")
    }
    results[[name]] <- value
    save(results, file = rdaName)
}

# demo
createRDA(empty = TRUE)
stopifnot(0 != length("test"))
writeRDA("test", 999, replace = TRUE)
stopifnot(999 == readRDA("test")) # expect 999
writeRDA("test", list(A = 1, B = 2), replace = TRUE)
stopifnot(identical(list(A = 1, B = 2), readRDA("test"))) # expect a list
```
