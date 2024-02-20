# https://www.timeanddate.com/eclipse/in/canada/halifax?iso=20240408#:~:text=April%208%2C%202024%20—%20Total%20Solar,—%20Halifax%2C%20Nova%20Scotia%2C%20Canada
# Maximum:	Mon, Apr 8, 2024 at 4:38 pm 0.946 Magnitude
tofficial <- as.POSIXct("2024-04-08 16:38:03",
    format = "%Y-%m-%d %H:%M:%S", tz = "UTC"
) + 3 * 3600
print(tofficial)

library(oce)
# 44.6476° N, 63.5728° W
angle <- function(t, lon = -63.4728, lat = 44.6476) {
    sa <- sunAngle(t, longitude = lon, latitude = lat, useRefraction = TRUE)
    ma <- moonAngle(t, longitude = lon, latitude = lat)
    saz <- sa$azimuth
    sal <- sa$altitude
    maz <- ma$azimuth
    mal <- ma$altitude
    scale <- cos(0.5 * (ma$altitude + sa$altitude) * pi / 180)
    rval <- sqrt((scale * (saz - maz))^2 + (sal - mal)^2)
    if (FALSE && rval < 0.3518) {
        cat(sprintf(
            "%s saz=%.1f maz=%.1f sal=%.2f mal=%.2f misfit=%.5f\n",
            format(t), saz, maz, sal, mal, rval
        ))
    }
    rval
}
# time is from reference 3
times <- tofficial + seq(-3.0 * 1800, -2.2 * 1800, 10)
misfit <- NULL
for (i in seq_along(times)) {
    misfit <- c(misfit, angle(times[i]))
}
misfit <- sapply(times, \(t) angle(t))
plot(times, misfit,
    xlab = "",
    ylab = "Sun-Moon Angular Misfit [deg)",
    type = "o", pch = 20
)
abline(h = 0)
interval <- tofficial + c(-3.0 * 1800, -2.2 * 1800)
o <- optimize(function(t) angle(t), interval = interval)
tbest <- as.POSIXct(o$minimum)
abline(v = tbest)
mtext(text = tbest, side = 3, at = tbest)
print(str(sunAngle(tbest, longitude=-63.4728, latitude = 44.6476)))
cat("expect 228 and 43.2\n")
stop()

eclipse <- nasa + o$minimum
abline(v = eclipse, col = "black")
abline(v = nasa, col = "red")
mtext(sprintf("Here: %s ", format(eclipse)), line = -1, adj = 1, col = "black")
mtext(sprintf("NASA: %s ", format(nasa)), line = -2, adj = 1, col = "red")
