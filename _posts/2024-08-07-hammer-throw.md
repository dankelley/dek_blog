---
author: Dan Kelley
date: 2024-08-07
title: What is the optimal angle for a hammer throw?
---

# Introduction

According to Reference 1, the best angle for hammer throw is approximately
44 deg, but athletes prefer to throw nearer 42 deg. My goal here is to see
whether that matches what I might expect from simple physics.

# Procedure

As a base case, I will use the gold-medal results from the 2024 Olympics,
according to Reference 2:

* Camryn Rogers (Canada) female Gold Medal 76.97 m.
* Ethan Katzberg (Canada) male Gold Medal 84.12 m.

My procedure uses published characteristics of the ball (ignoring the
connector), and I adjust the throwing speed until the maximum
distance for any angle agrees with the results stated above.

# Results

The simulations yielded results as follows.

* male: U = 28.801 m/s, best angle=44.22 deg, distance=84.12 m
* female: U = 27.520 m/s, best angle=44.29 deg, distance=76.97 m

These are consistent with the contention in Reference 1 that the optimal
throwing angle is approximately 44 deg.

# References

 1. <https://www.frontiersin.org/journals/sports-and-active-living/articles/10.3389/fspor.2022.853536/full>
 2. <https://olympics.com/en/paris-2024/results/athletics/men-s-hammer-throw/fnl-000100>

# Code

```{r}
library(deSolve)
g <- 9.8
UU <- list(female = 27.52, male = 28.801)
mm <- list(female = 4, male = 7.25)
DD <- list(female = 85e-3, male = 110e-3)
gender <- "male"
m <- mm[[gender]]
D <- DD[[gender]]
U <- UU[[gender]]
A <- pi * (D / 2)^2
rho <- 1.3
CD <- 0.47 # https://en.wikipedia.org/wiki/Drag_coefficient
func <- function(t, y, parms) {
    u <- y[3]
    w <- y[4]
    U <- sqrt(u^2 + w^2)
    dxdt <- u
    dzdt <- w
    dudt <- -0.5 * rho * CD * u * U * A / m
    dwdt <- -0.5 * rho * CD * w * U * A / m - g
    res <- c(dxdt, dzdt, dudt, dwdt)
    list(res)
}
throw <- function(
    angle, U, h0 = 1.7,
    m = 4, # 4kg women, 7.25 kg men
    D = 85e-3, # 85mm women, 110mm men
    plot = FALSE) {
    times <- seq(0, 5, length.out = 5000)
    theta <- angle * pi / 180
    u <- U * cos(theta)
    w <- U * sin(theta)
    y <- c(0, h0, u, w)
    s <- lsoda(y = y, times = times, func = func)
    inair <- s[, 3] >= 0
    s <- s[inair, ]
    distance <- max(s[, 2])
    if (plot) {
        par(mar = c(2, 2, 1, 1), mgp = c(2, 0.7, 0))
        plot(s[, 2], s[, 3],
            xlim = c(0, 1.1 * distance[1]),
            type = "l", asp = 1,
            xaxs = "i", xlab = "Distance [m]", ylab = "Height [m]"
        )
        abline(h = 0)
        mtext(sprintf(
            "U=%.2f m/s, angle=%.1f deg, distance=%.2f m",
            U, angle, distance
        ))
    }
    distance
}
o <- optimize(\(angle) throw(angle, U, m = m, D = D), c(30, 50), maximum = TRUE)
cat(sprintf(
    "%6s: U = %.3f m/s, best angle=%.2f deg, distance=%.2f m\n",
    gender, U, o$maximum, o$objective
))
```
