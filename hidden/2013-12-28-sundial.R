# gnonom style sundial
png("../docs/assets/images/2013-12-28-sundial.png",
    width = 7, height = 6, unit = "in",
    res = 200, pointsize = 13
)
library(oce)
sundial <- function(
    lon = -63.60, lat = 44.65,
    days = c("2014-03-20", "2014-06-20", "2014-09-23", "2014-12-21"),
    keys = c(
        "Spring equinox", "Summer solstice",
        "Autumn equinox", "Winter solstice"
    ),
    debug = 0) {
    col <- 1:4
    glwd <- 8
    timezone <- floor(0.5 + lon / 15)
    L <- 1 # horiz gnomon length (arbitrary)
    nhours <- 24
    first <- TRUE
    for (season in 1:4) {
        hours <- seq.POSIXt(as.POSIXct(days[season], tz = "UTC"),
            by = "1 hour", length.out = nhours
        )
        for (hour in seq_along(hours)) {
            t <- hours[hour]
            tlocal <- t + 3600 * timezone
            sa <- sunAngle(t, lon = lon, lat = lat)
            gy <- seq(0, L, length.out = 10)
            gx <- rep(0, length(gy))
            gz <- gy * tan(lat * pi / 180)
            R <- gz / tan(-sa$altitude * pi / 180) # radius of shadow
            theta <- (90 - sa$azimuth) * pi / 180
            par(mar = rep(2, 4))
            x <- gx + R * cos(theta)
            y <- gy + R * sin(theta)
            len <- max(sqrt(x^2 + y^2))
            x <- x / len * L
            y <- y / len * L
            if (sa$altitude > 0) {
                if (first) {
                    first <- FALSE
                    D <- L * 5
                    plot(x, y,
                        type = "n", pch = 20, asp = 1,
                        xlim = c(-L, L), ylim = c(-L / 5, L),
                        axes = FALSE, col = col[season], xlab = "", ylab = ""
                    )
                    ## Draw gnomon as a gray bar
                    segments(0, 0, 0, L, lwd = glwd, col = "gray")
                    grid()
                    abline(h = 0, lwd = 1.5 * par("lwd"), lty = "dotted")
                    abline(v = 0, lwd = 1.5 * par("lwd"), lty = "dotted")
                    mtext("South", side = 1, at = 0)
                    mtext("West", side = 2, at = 0)
                    mtext("North", side = 3, at = 0)
                    mtext("East", side = 4, at = 0)
                    legend("topright",
                        lwd = glwd, col = "gray",
                        legend = "Gnomon"
                    )
                    legend("bottomright",
                        legend = sprintf("%.3fE %.3fN", lon, lat)
                    )
                    legend("topleft",
                        lwd = 1, col = 1:4, cex = 3 / 4,
                        legend = keys
                    )
                    box()
                    points(0, 0, pch = 20, cex = 2)
                    segments(0, 0, x, y, col = col[season])
                } else {
                    segments(0, 0, x, y, col = col[season])
                    if (debug) {
                        points(x, y)
                    }
                }
                if (season == 2) {
                    xend <- tail(x, 1)
                    yend <- tail(y, 1)
                    text(1.05 * xend, 1.05 * yend, format(tlocal, "%H"))
                }
            }
        }
    }
}
sundial()
dev.off()
