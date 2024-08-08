library(deSolve)
throw <- function(angle, U, h0 = 1.7, m = 4, D = 85e-3, plot = FALSE) {
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
    maxDistance <- max(s[, 2])
    if (plot) {
        par(mar = c(3, 3, 1, 1), mgp = c(2, 0.7, 0))
        plot(s[, 2], s[, 3],
            xlim = c(0, 1.1 * maxDistance),
            type = "l", asp = 1,
            lwd = 2, col = 4,
            xaxs = "i", xlab = "Distance [m]", ylab = "Height [m]"
        )
        grid()
        abline(h = 0)
        text(maxDistance, 0, labels = sprintf("%.2fm", maxDistance), pos = 1)
        mtext(sprintf("m=%.2fkg, D=%.2fm with U=%.2fm/s, angle=%.2f deg, h0=%.1fm", m, D, U, angle, h0))
    }
    maxDistance
}

# Find best angle for given speed, with the latter determined manually by
# running throw() with a series of U values, adjusting until the maximal
# distance matched the Olympic results to the published accuracy.
distance <- list(female = 76.97, male = 84.12)
for (gender in c("male", "female")) {
    U <- list(female = 27.52, male = 28.801)[[gender]]
    m <- list(female = 4, male = 7.26)[[gender]]
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
# Draw a sample illustration of a trajectory (the male test case).
png("2024-08-07-hammer-throw.png", unit = "in", width = 7, height = 3, res = 200)
throw(angle = 42, U = 28.333, m = 7.26, D = 110e-3, plot = TRUE)
dev.off()
