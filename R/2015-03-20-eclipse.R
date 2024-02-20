library(oce)

# From a website
tofficial <- as.POSIXct("2015-03-20 9:45:39", tz = "UTC")

# Angle misfit function
angle <- function(t, lon = 15 + 40 / 60, lat = 78 + 12 / 60) {
    sa <- sunAngle(t, longitude = lon, latitude = lat, useRefraction = TRUE)
    ma <- moonAngle(t, longitude = lon, latitude = lat)
    saz <- sa$azimuth
    sal <- sa$altitude
    maz <- ma$azimuth
    mal <- ma$altitude
    scale <- cos(0.5 * (ma$altitude + sa$altitude) * pi / 180)
    sqrt((scale * (saz - maz))^2 + (sal - mal)^2)
}
# Variation over 2 hours
times <- tofficial + seq(-1800, 1800, 30)
misfit <- sapply(times, function(t) angle(t))
interval <- tofficial + c(-1800, 1800)
# Best fit
o <- optimize(function(t) angle(t), interval = interval)
# Plot
png("2015-03-20-eclipse.png", unit = "in", width = 7, height = 5, res = 200, pointsize = 10)
oce.plot.ts(times, misfit,
    xlab = "",
    ylab = "Sun-Moon Angular Misfit [deg)",
    pch = 20, drawTimeRange = FALSE, grid = TRUE
)
tbest <- as.POSIXct(o$minimum)
abline(v = tbest, col = 2, lty = 2)
abline(v = tofficial, lty = 2)
mtext(text = format(tofficial, "%Y %b %d"), adj = 0)
legend("topright",
    lwd = 1, lty = 2, col = 1:2, bg = "white",
    legend = c(
        format(tofficial, "%H:%M:%S UTC (published)", tz = "UTC"),
        format(tbest, "%H:%M:%S UTC (this calculation)", tz = "UTC")
    )
)
