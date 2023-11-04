png("2014-03-16-box-model.png")
library(deSolve)
IC <- 0
parms <- list(A = 4e6, gamma = 20)
sperday <- 86400 # seconds per day
times <- seq(0, 20 * sperday, length.out = 500)
R <- function(t) {
    1 + ifelse(10.0 * sperday < t & t < 10.5 * sperday, 9, 0)
}
DE <- function(t, y, parms) {
    h <- y[1]
    dhdt <- (R(t) - parms$gamma * h) / parms$A
    list(dhdt)
}
sol <- lsoda(IC, times, DE, parms)
par(mfrow = c(2, 1), mar = c(3, 3, 1, 1), mgp = c(2, 0.7, 0))
h <- sol[, 2]
Day <- times / 86400
plot(Day, R(times), type = "l", ylab = "River input [m^3/s]")
plot(Day, h, type = "l", ylab = "Lake level [m]")
lines(h = 1 / parms$gamma) # theoretical steady state for 1 m^3/s
dev.off()
