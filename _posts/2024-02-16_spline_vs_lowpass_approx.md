--
title: Comparison of Smoothing Spline with Lowpassed Linear Approximation
author: Dan Kelley
date: 2024-02-16
---

Smoothing data is quite a common problem in oceanography.  If we can think of
errors (or uncertainties -- you pick the word you like) as occurring just in
the "y" variable, then I tend to tray two approaches: (1) fit a smoothing
spline and (2) interpolate linearly onto a fixed grid, and then lowpass.

The graph shows a typical result.  Note that the x spacing of the data is very
non-uniform, with points separated greatly at the left of the graph, and packed
together at the right of the graph. In such cases, smoothing splines can have
problems.  You can see that in the blue curve, in the left half of the graph.
The lowpassed linear approximation (red curve) does not have this problem, but
it is perhaps overly linear between points.

If the goal were to look at the left side of the graph, altering the parameters
(namely `deltaSigma` and `n` for the linear approximation, and `df` for the
spline) could yield to results that might be more suitable, depending on the
goal.

But if the goal is to work on the right side of the graph, different settings
might be used.  And, again, it depends on the goal.  In this particular case, I
am interested in the x locations of spots where the curve has zero slope. By
that measure, the two methods are producing similar results. An advantage of
the smoothing spline is that it can output the derivative, saving the analyst
from having to compute the derivative using a form of first difference
(centred, perhaps).

I am just scratching the surface of possible methods here, and definitely not
suggesting which I think is best.  But I can suggest three points for
discussion:
1. The best method will depend on the goal of the analysis. (That's always
   true, no matter the task or topic)
2. It makes sense to trial different methods, with different parameters, on
   real data.
3. Combining methods can also make sense, e.g. using `approx()` to put the x
   data on a uniform grid, and doing a `smooth.spline()` on the results

# Code

This code requires a data file (line 2) that is not provided on this blog posting.

```R
library(oce)
file <- "~/data/argo/D4901076_061.nc"
a <- read.oce(file)
sig0 <- a[["sigma0"]]
pi0 <- a[["spiciness0"]]
png("2024-02-16_spline_vs_lowpass_approx.png", height = 7, width = 7, unit = "in", res = 200)
par(mfrow = c(1, 1), mar = c(3.5, 3.5, 1, 1), mgp = c(2, 0.7, 0))
plot(sig0, pi0,
    xlab = resizableLabel("sigma0"),
    ylab = resizableLabel("spiciness0"),
    ylim = rev(range(pi0)),
    pch = 20, cex = 0.8
)
deltaSigma <- 0.01
n <- 11
df <- 20
sig0out <- seq(min(sig0), max(sig0), deltaSigma)
a <- approx(sig0, pi0, sig0out)
lines(a$x, lowpass(a$y, n = n), col = 2)
s <- smooth.spline(pi0 ~ sig0, df = df)
ps <- predict(s, sig0out)
lines(ps$x, ps$y, col = 4)
grid()
legend("bottomleft",
    lwd = 1, col = c(2, 4), bg = "white",
    legend = c(
        sprintf("lowpass(approx(), n=%d) with delta-sigma=%.3f", n, deltaSigma),
        sprintf("smooth.spline(df=%d)", df)
    )
)
```
