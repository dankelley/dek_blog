pdf("halifax.pdf")
# tofficial <- as.POSIXct("2024-04-08 19:38:02", tz = "UTC") # mid-eclipse
tofficial <- as.POSIXct("2024-04-08 18:27:21", tz = "UTC") # C1
LAT <- 44.64533
LON <- -63.57239

library(oce)
# 44.6476° N, 63.5728° W
S <- \(x) sinpi(x / 180)
C <- \(x) cospi(x / 180)
angle <- function(t, longitude = LON, latitude = LAT) {
    sa <- sunAngle(t, longitude = longitude, latitude = latitude)
    ma <- moonAngle(t, longitude = longitude, latitude = latitude)
    saz <- sa$azimuth
    sal <- sa$altitude
    maz <- ma$azimuth
    mal <- ma$altitude
    # Next is from law of cosines.
    180 / pi * acos(S(mal) * S(sal) + C(mal) * C(sal) * C(maz - saz))
}
# time is from reference 3
times <- tofficial + seq(-1800, 1800, 30)
misfit <- sapply(times, angle)
oce.plot.ts(times, misfit, ylim=c(0.34, 0.5),
    ylab = "Sun-Moon Angular Misfit [deg)",
    type = "o", pch = 20, grid = TRUE,
    drawTimeRange = FALSE
)
abline(h = 0)
interval <- tofficial + c(-1800, 1800)
o <- optimize(function(t) angle(t), interval = interval)
abline(h = o$objective)
mtext(sprintf("%.7f", o$objective), at = o$objective, side = 4, line = 0.5)
tbest <- as.POSIXct(o$minimum, tz = "UTC")
abline(v = tbest)
mtext(format(tbest, "%Y-%m-%d %H:%M UTC"), at = tbest)

abline(v = tofficial, col = "red")
mtext(sprintf("Here: %s ", format(tbest, tz = "UTC")), line = -1, adj = 1, col = "black")
mtext(sprintf("NASA: %s ", format(tofficial, tz = "UTC")), line = -2, adj = 1, col = "red")
