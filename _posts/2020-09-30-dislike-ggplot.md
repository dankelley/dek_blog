---
title: Why I use base graphics instead of ggplot2
date: 2020-09-30
---

With base graphics, a histogram of 100 million points

```R
d <- data.frame(x = rnorm(1e8))
system.time(hist(d$x))
```

takes

```
     user  system elapsed
    3.910   0.821   4.907
```
By contrast, if I use ggplot as in

```R
library(ggplot2)
system.time({p<-ggplot(d) + aes(x=x) + geom_histogram();print(p)})
```

I see that the results take an order of magnitude longer:

```
  `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
     user  system elapsed
   35.308  13.481  50.338
```

As if an othe rder-of-magnitude speed reduction were not enough, there are some other
things that I dislike.

1. The function ought to choose an appropriate binwidth, instead of saying that
   it has chosen a poor default.
2. The ggplot is in a low-contrast style can be a problem for some viewers and
   some printing/reproduction methods. (I know I don't need to use the default,
   of course.)

