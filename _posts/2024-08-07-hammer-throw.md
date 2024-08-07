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
connector), and an adjustment of throwing speed to get the predicted distance
(across any angle) to agree with the results stated above.

Once that was done, I used the estimated in-practice angle of 42 deg, to find
the difference in throwing speed, to shed some light on the penalty paid by
athletes for using a sub-optimal release angle.

# Results

The output from the R code, i.e.

```
* male: with U = 28.833 m/s, the optimal angle of 44.26 deg yields distance 84.12 m
* female: with U = 27.520 m/s, the optimal angle of 44.03 deg yields distance 76.97 m
```

indicates that the optimal angle is 44.26 deg for the male case and 44.03 deg
for the female case.  These are consistent with Reference 1.

However, the speed increases required to achieve the same distances with the
apparently preferred angle of 42 deg is very slight, about 4 cm/s or a 0.15
percent increase, as indicated by the following output from the R code.

```
* male: with angle = 42.00 deg, using U = 28.877 m/s yields distance-observed = 0.009 m
 NOTE: this is a speed increase of 0.044 m/s (i.e. 0.15%)
* female: with angle = 42.00 deg, using U = 27.561 m/s yields distance-observed = 0.010 m
 NOTE: this is a speed increase of 0.041 m/s (i.e. 0.15%)
```

# References

 1. <https://www.frontiersin.org/journals/sports-and-active-living/articles/10.3389/fspor.2022.853536/full>
 2. <https://olympics.com/en/paris-2024/results/athletics/men-s-hammer-throw/fnl-000100>

# Code

```R
library(deSolve)
distance <- list("female" = 76.97, "male" = 84.12)
func <- function(t, y, parms) {
    A <- parms$A
    m <- parms$m
    CD <- parms$CD
    rho <- parms$rho
    g <- parms$g
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
throw <- function(angle, U, h0 = 1.7,
                  m = 4, # 4kg women, 7.25 kg men
                  D = 85e-3, # 85mm women, 110mm men
                  gender = "female",
                  plot = FALSE) {
    m <- list(female = 4, male = 7.25)[[gender]]
    D <- list(female = 85e-3, male = 110e-3)[[gender]]

    times <- seq(0, 5, length.out = 5000)
    theta <- angle * pi / 180
    u <- U * cos(theta)
    w <- U * sin(theta)
    y <- c(0, h0, u, w)
    # CD is from https://en.wikipedia.org/wiki/Drag_coefficient
    parms <- list(g = 9.8, rho = 1.3, CD = 0.47, m = m, A = pi * (D / 2)^2)
    s <- lsoda(y = y, times = times, func = func, parms)
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

# Find best angle for given speed, with the latter determined manually by
# running throw() with a series of U values, adjusting until the maximal
# distance matched the Olympic results to the published accuracy.
for (gender in c("male", "female")) {
    U <- list(female = 27.52, male = 28.833)[[gender]]
    m <- list(female = 4, male = 7.25)[[gender]]
    D <- list(female = 85e-3, male = 110e-3)[[gender]]
    o <- optimize(\(angle) throw(angle, U, m = m, D = D), c(20, 60), maximum = TRUE)
    cat(sprintf(
        "* %s: with U = %.3f m/s, the optimal angle of %.2f deg yields distance %.2f m\n",
        gender, U, o$maximum, o$objective
    ))
    # Find speed to give recorded distance, at the assumed angle of 42 deg
    angle <- 42
    o <- optimize(\(U) abs(throw(angle, U, m = m, D = D) - distance[[gender]]),
        c(10, 100),
        maximum = FALSE
    )
    pc <- function(a, b) round(100 * (a - b) / b, 2)
    cat(sprintf(
        "* %s: with angle = %.2f deg, using U = %.3f m/s yields distance-observed = %.3f m\n",
        gender, angle, o$minimum, o$objective
    ))
    cat(
        sprintf(
            " NOTE: this is a speed increase of %.3f m/s (i.e. %.2f%%)\n",
            o$minimum - U, pc(o$minimum, U)
        )
    )
}
```