---
title: Why I use base graphics instead of ggplot2
date: 2020-09-30
---

With base graphics, a histogram of 100 million points

```R
d <- data.frame(x=rnorm(1e8))
system.time(hist(x))
```

takes just

```
     user  system elapsed
    0.044   0.004   0.052
```

which means that the result is ready as my pinkie finger is rising from the
'Return' key.

In contrast, if I use ggplot as in

```R
library(ggplot2)
system.time({p<-ggplot(d) + aes(x=x) + geom_histogram();print(p)})
```

I find I have to wait *much* longer.  The results are

```
  `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
     user  system elapsed
   43.877  13.766  60.200
```

so this sub-second task has ballooned to a full minute.  Since this is not a
large dataset in my line of work, the test shows that my brand-new machine acts
more like something from the 1980s.

Don't get me wrong.  I liked the eighties.  But I don't want to go back to 
1980s computing power.

And now that I'm revealing myself to be a cranky old fart, I'll add two more
complaints about ggplot defaults:

1. The function ought to choose an appropriate binwidth, instead of saying that
   it has chosen a poor default.
2. While the ggplot graph looks pretty enough for a magazine, the default
   low-contrast style can be a problem for some viewers and some
   printing/reproduction methods. (Yes, I know I can change to a more sensible
   style, but awkward defaults are annoying.)

