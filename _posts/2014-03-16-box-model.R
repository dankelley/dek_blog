png("2014-03-16-box-model.png")
library(deSolve)
IC <- 0
parms <- list(A = 4e6, gamma = 10)
sperday <- 86400 # seconds per day
times <- seq(0, 10 * sperday, length.out = 200)
F <- function(t) {
    ifelse(1.0 * sperday < t & t < 1.5 * sperday, 10, 0)
}
DE <- function(t, y, parms) {
    h <- y[1]
    dhdt <- (F(t) - parms$gamma * h) / parms$A
    list(dhdt)
}
sol <- lsoda(IC, times, DE, parms)
par(mfrow = c(2, 1), mar = c(3, 3, 1, 1), mgp = c(2, 0.7, 0))
h <- sol[, 2]
Day <- times / 86400
plot(Day, F(times), type = "l", ylab = "River input [m^3/s]")
plot(Day, h, type = "l", ylab = "Lake level [m]")
dev.off()
