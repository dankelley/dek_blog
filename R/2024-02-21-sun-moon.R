library(oce)

sunMoonPlot <- function(day, lon, lat) {
    angles <- function(day, lon, lat,
                       tz = "America/Halifax", sun = TRUE) {
        tUTC <- t <- seq(as.POSIXct(paste(day, "00:00:00"), tz = tz), length.out = 240, by = "6 min")
        attributes(tUTC)$tzone <- "UTC"
        a <- if (sun) {
            sunAngle(tUTC, lon = lon, lat = lat)
        } else {
            moonAngle(tUTC, lon = lon, lat = lat)
        }
        invisible <- a$altitude < 0
        a$altitude[invisible] <- NA
        a$azimuth[invisible] <- NA
        list(t = t, altitude = a$altitude, azimuth = a$azimuth)
    }
    tz <- "America/Halifax"
    s <- angles(day, lon, lat, sun = TRUE)
    m <- angles(day, lon, lat, sun = FALSE)
    max <- 1.04 * max(c(s$altitude, m$altitude), na.rm = TRUE)

    par(mar = rep(0.5, 4))
    theta <- seq(0, 2 * pi, length.out = 24 * 10)
    radiusx <- cos(theta)
    radiusy <- sin(theta)

    # Horizon and labels+lines for EW and NS
    plot(radiusx, radiusy, type = "l", col = "gray", asp = 1, axes = FALSE, xlab = "", ylab = "")
    lines(c(-1, 1), c(0, 0), col = "gray")
    lines(c(0, 0), c(-1, 1), col = "gray")
    D <- 1.06
    text(0, -D, "S", xpd = TRUE) # xpd so can go in margin
    text(-D, 0, "W", xpd = TRUE)
    text(0, D, "N", xpd = TRUE)
    text(D, 0, "E", xpd = TRUE)
    # Moon calc
    mx <- (90 - m$altitude) / 90 * cos(pi / 180 * (90 - m$azimuth))
    my <- (90 - m$altitude) / 90 * sin(pi / 180 * (90 - m$azimuth))
    t <- s$t
    mlt <- as.POSIXct(sprintf("%s %02d:00:00", day, 1:24), tz = tz)
    ti <- unlist(lapply(mlt, function(X) which.min(abs(X - t))))
    # Sun calc
    sx <- (90 - s$altitude) / 90 * cos(pi / 180 * (90 - s$azimuth))
    sy <- (90 - s$altitude) / 90 * sin(pi / 180 * (90 - s$azimuth))
    slt <- as.POSIXct(sprintf("%s %02d:00:00", day, 1:24), tz = tz)
    si <- unlist(lapply(slt, function(X) which.min(abs(X - t))))
    # plot, with labels to avoid overplotting
    posFlag <- mean(sy, na.rm = TRUE) > mean(my, na.rm = TRUE)
    lines(mx, my, col = 4, lwd = 1)
    points(mx[ti], my[ti], pch = 20, cex = 0.5, col = 4)
    text(mx[ti], my[ti], 1:24,
        cex = 3 / 4,
        pos = if (posFlag) 1 else 3, col = 4
    )
    lines(sx, sy, col = 2, lwd = 1)
    points(sx[ti], sy[ti], pch = 20, cex = 0.5, col = 2)
    text(sx[ti], sy[ti], 1:24,
        cex = 3 / 4,
        pos = if (posFlag) 3 else 1, col = 2
    )
    mtext(paste("Halifax NS", day, sep = "\n"), side = 3, adj = 0, line = -2)
    mtext("Red sun\nBlue moon", side = 3, adj = 1, line = -2)
}

# Halifax, Nova Scotia: solar eclipse of 2024, with days before and after
png("2024-02-21-sun-moon-%d.png", unit = "in", width = 7, height = 7, res = 200)
sunMoon <- sunMoonPlot("2024-04-07", lon = -63.61, lat = 44.67)
sunMoon <- sunMoonPlot("2024-04-08", lon = -63.61, lat = 44.67)
sunMoon <- sunMoonPlot("2024-04-09", lon = -63.61, lat = 44.67)
