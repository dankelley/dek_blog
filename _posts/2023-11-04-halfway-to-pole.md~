---
title: Halfway to the Pole
date: 2023-11-04
---
<script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
<script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>

# Introduction

Nova Scotia straddles 45N, and there is a tourist spot named Mastadon Ridge
Park that claims to be halway between the pole and the equator.  But it is not
at 45N, because that's the halfway point for a spherical earth, not the
flattened earth on which we live.

So, is it really at this halfway point?  The following R code is an attempt
to answer that question.
```R
library(oce)
L <- geodDist(0, 0, 0, 90)
uniroot(\(lat) geodDist(0, 0, 0, lat) - L/2, c(0, 90))$root
```

This code indicates that the halfway point is at 45.11432N, which is about 16
km from 45N.

The [Mastadon Ridge website](https://mastodonridge.ca/experience/halfway-to-the-equator/) shows a letter
(dated 1952, when some could be called a 'field man') that indicates that the
halfway point is 45 degrees 8 minutes, 50 seconds.  Converted to decimal, that
is 45.14444, which is very close to the value from the R code given above.
(The difference, 45.14444 - 45.14432, is just 14 metres!)

So, yes, we see that Mastadon Ridge really *is* at the halfway point to the
equator.

