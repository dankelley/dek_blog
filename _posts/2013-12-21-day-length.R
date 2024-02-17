library(oce)
if (!interactive()) png("2013-12-21-day-length.png")
daylength <- function(t, lon = -63.60, lat = 44.65) {
    t <- as.numeric(t)
    alt <- function(t) {
        sunAngle(t, longitude = lon, latitude = lat)$altitude
    }
    rise <- uniroot(alt, lower = t - 86400 / 2, upper = t)$root
    set <- uniroot(alt, lower = t, upper = t + 86400 / 2)$root
    set - rise
}
# Compute day length for December, 2013.
t0 <- as.POSIXct("2013-12-01 12:00:00", tz = "UTC")
t <- seq.POSIXt(t0, by = "1 day", length.out = 1 * 31)
dayLength <- unlist(lapply(t, daylength))
# Set up to plot two panels, with narrowed margins.
par(mfrow = c(2, 1), mar = c(3, 3, 1, 1), mgp = c(2, 0.7, 0))
# daylength in the top panel
plot(t, dayLength / 3600,
    type = "o", pch = 20,
    xlab = "", ylab = "Day length (hours)"
)
grid()
solstice <- as.POSIXct("2013-12-21", tz = "UTC")
abline(v = solstice + c(0, 86400))
# daylenfth difference in bottom panel
plot(t[-1], diff(dayLength),
    type = "o", pch = 20,
    xlab = "Day in 2013", ylab = "Seconds gained per day"
)
grid()
abline(v = solstice + c(0, 86400))
