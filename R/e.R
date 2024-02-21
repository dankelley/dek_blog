C <- function(x0, y0 = 0, R, col) {
    thetapi <- seq(0, 2, 1 / 128)
    polygon(x0 + R * cospi(thetapi), y0 + R * sinpi(thetapi), col = col)
}
plot(c(-1, 1), c(-2, 2), type = "n", xlab = "", ylab = "", asp = 1)
C(0, 1, 0.5, 7) # sun
d <- 0.05
C(d, 1, 0.52, "gray") # moon
text(1.5, 1, d)
d <- 0.35
C(0, -1, 0.5, 7) # sun
C(d, -1, 0.52, "gray") # moon
text(1.5, -1, d)
