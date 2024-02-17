library(oce)
times <- seq(as.POSIXct("2014-02-14", tz = "UTC"), length.out = 50, by = "year")
fraction <- moonAngle(times, longitude = -63, latitude = 43)$illuminatedFraction
full <- fraction > 0.99
timesFull <- times[full]
if (!interactive()) {
    png("2014-02-13-valentine-moon.png",
        unit = "in", res = 200,
        width = 7, height = 3, pointsize = 10
    )
}
par(mar = c(2, 3, 1, 1), mgp = c(2, 0.7, 0))
plot(times, fraction,
    yaxs = "i",
    xlab = "Year", ylab = "Moon Illuminated Fraction",
    col = ifelse(full, 2, 4), pch = 16, cex = 2
)
abline(v = timesFull, col = 2)
mtext(side = 3, at = timesFull, format(timesFull, "%Y"))
