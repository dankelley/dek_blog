---
author: Dan Kelley
date: 2014-06-15
title: DE solution in R (nonlinear oscillator)
---

The function `lsoda()` from the `deSolve` package is a handy function for
solving differential equations in R. This is illustrated here with a classic
example: the nonlinear oscillator.

As explained in any introductory Physics textbook, the nonlinear oscillator
equation
*d*θ<sup>*2*</sup>/*dt*<sup>2</sup> + sin *θ* = 0
can be simplified to a linear form
*d*<sup>2</sup>*θ*/*dt*<sup>2</sup> + *θ* = 0
provided that *θ* ≪ 1.

It is a simple matter to show that the linear form has solution
*θ* = *a*sin (*t*),
given initial conditions *θ* = 0 and *dθ*/*dt* = *a* at time *t=0*.

Although the nonlinear form is harder to solve analytically, it is amenable to
numerical solution, using the `lsoda()` function provided by the `deSolve`
package.

The first step is to break the second-order DE down into two first-order DEs:
*ϕ* = *dθ/dt* and *dϕ/dt* =  −*sin θ*.

```R
library(deSolve)
de <- function(t, y, parms, ...)
{
    theta <- y[1]
    phi <- y[2]
    list(c(dthetadt=phi, dphidt=-sin(theta)))
}

a <- 0.1
y0 <- c(0, a)
t <- seq(0, 4*pi, pi/100)
sol <- lsoda(y=y0, times=t, func=de)
ylim <- max(range(sol[,2])) * c(-1, 1)
par(mar=c(3.5, 3.5, 1, 1), mgp=c(2, 0.7, 0))
plot(sol[,1], sol[,2], type='l', ylim=ylim, col='blue',
    xlab=expression(t), ylab=expression(theta(t)))
grid()
lines(t, a*sin(t), col='red', lty='dashed')
```

![](/dek_blog/docs/assets/images/2014-06-15-nonlinear-oscillator_files/unnamed-chunk-1-1.png)

# Some test cases

For more exploration, it is convenient to define the above as a
stand-alone function that takes `a` as a parameter.

```R
library(deSolve)
oscillator <- function(a=0.1)
{
    de <- function(t, y, parms, ...)
    {
        theta <- y[1]
        phi <- y[2]
        list(c(dthetadt=phi, dphidt=-sin(theta)))
    }
    y0 <- c(0, a)
    t <- seq(0, 8*pi, pi/100)
    sol <- lsoda(y=y0, times=t, func=de)
    ylim <- max(range(sol[,2])) * c(-1, 1)
    par(mar=c(3.5, 3.5, 1, 1), mgp=c(2, 0.7, 0))
    plot(sol[,1], sol[,2], type='l', ylim=ylim, col='blue',
         xlab=expression(t), ylab=expression(theta(t)))
    grid()
    lines(t, a*sin(t), col='red')
    legend("bottomleft", col=c("red", "blue"), lwd=1,
           legend=c("linear", "nonlinear"),
           bg="white")
}
```

Now, a few examples are easy to construct.

Start with a somewhat nonlinear problem

```R
oscillator(1)
```

![](/dek_blog/docs/assets/images/2014-06-15-nonlinear-oscillator_files/unnamed-chunk-3-1.png)

Readers should try increasing $a$ a bit at a time, e.g. the example below has a
distinctly non-sinusoidal character.

```R
oscillator(1.999)
```

![](/dek_blog/docs/assets/images/2014-06-15-nonlinear-oscillator_files/unnamed-chunk-4-1.png)

# Exercises

Further explore the behaviour in the neighborhood of *a=2*. Are changes
subtle or dramatic in that region? Are there other regions of interest? Consult
the literature if this problem interests you.
