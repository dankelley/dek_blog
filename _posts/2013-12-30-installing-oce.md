---
title: Installing oce in R
year: 2013-12-30
author: Dan Kelley
---

Several of the blog items have used the oce package.  The official version of
this can be installed from within R by

```R
install.packages("oce")
```

and more up-to-date versions can be installed using the `devtools` package,
which is itself installed with

```R
install.packages("devtools")
```

after which installing the latest development version of oce is accomplished
with

```R
library(devtools)
install_github('ocedata', 'dankelley', 'master')
install_github('oce', 'dankelley', 'develop')
```

Note that the `ocedata` package does not need to be updated frequently, as it
only updated when new datasets are added to oce. The official version of oce is
only updated every few months, but the branch named `develop` (used above) may
be updated several times a day, if the author is adding new features or fixing
bugs.

For more on oce, see the [oce website on
github](http://www.github.com/dankelley/oce).
