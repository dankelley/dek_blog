png("../docs/assets/images/2016-02-09-noreaster-%d.png",
    units = "in", res = 200, width = 7, height = 7, pointsize = 10
)

# The data have changed since I first blogged on this, in 2016, and here
# I am using data downloaded 2023-11-05. The old data can be found at
# https://raw.githubusercontent.com/dankelley/dankelley.github.io/master/assets/44150.txt
# at least as of 2023-11-05, but that repository may be deleted
# without notice.

# 1
library(oce)
lon <- -64.018
lat <- 42.505
data(coastlineWorldFine, package = "ocedata")
par(mfrow = c(1, 1))
plot(coastlineWorldFine, clongitude = -64.0, clatitude = 42.5, span = 2000)
points(lon, lat, bg = "red", cex = 2, pch = 21)
data(topoWorld) # coarse resolution
contour(topoWorld[["longitude"]], topoWorld[["latitude"]], topoWorld[["z"]],
    levels = -1000, lty = 2, drawlabels = FALSE, add = TRUE
)

# 2
# Cache file to avoid download delay (or failure)
url <- "https://www.meds-sdmm.dfo-mpo.gc.ca/alphapro/wave/waveshare/csvData/c44150_csv.zip"
zipfile <- gsub(".*/", "", url)
file <- gsub("_", ".", gsub(".zip", "", zipfile))
if (!file.exists(file)) {
    download.file(url, zipfile)
    unzip(zipfile)
}
dall <- read.csv(file, header = TRUE)
time <- as.POSIXct(dall$DATE, "%m/%d/%Y %H:%M", tz = "UTC")
start <- as.POSIXct("2015-12-26 00:00", tz = "UTC")
end <- as.POSIXct("2016-02-09 15:00:00", tz = "UTC")
# trim data before Boxing Day, 2015 and after Feb 9, 2016
keep <- start <= time & time <= end
d <- subset(dall, keep)
time <- subset(time, keep)

# 3
# Note that the column names have been changed by the data provider,
# since the year 2016 when I first blogged about this.
# variable names are described at
# https://www.meds-sdmm.dfo-mpo.gc.ca/isdm-gdsi/waves-vagues/formats-eng.html#Par
waveHeight <- d[["VWH."]] # "characteristic significant wave height" was WVHT
dominantWavePeriod <- d[["VTPK"]] # "wave spectrum peak period (MEDS)" was DPD
windDirection <- d[["WDIR.1"]] # was WDIR
windSpeed <- d[["WSPD.1"]] # was WSPD
airPressure <- d[["ATMS"]] # was PRES
theta <- 90 - windDirection # convert from CW-from-North to CCW-from-East
# multiply by -1 to convert from "wind from" to "wind to"
windU <- -windSpeed * cos(theta * pi / 180)
windV <- -windSpeed * sin(theta * pi / 180)

# 4
par(mfrow = c(5, 1))
oce.plot.ts(time, airPressure / 10, ylab = "Air press [kPa]", drawTimeRange = FALSE, mar = c(2, 3, 1, 1))
oce.plot.ts(time, windSpeed, ylab = "Wind speed [m/s]", drawTimeRange = FALSE, mar = c(2, 3, 1, 1))
oce.plot.ts(time, windDirection, ylab = "wind dir", drawTimeRange = FALSE, mar = c(2, 3, 1, 1))
oce.plot.ts(time, waveHeight, ylab = "Height [m]", drawTimeRange = FALSE, mar = c(2, 3, 1, 1))
oce.plot.ts(time, dominantWavePeriod, ylab = "Period [s]", drawTimeRange = FALSE, mar = c(2, 3, 1, 1))

# 5
par(mfrow = c(1, 1))
cm <- colormap(waveHeight, zlim = c(0, 10), col=oceColorsJet)
par(mar = c(3.5, 3.5, 1.5, 1), mgp = c(2, 0.7, 0))
drawPalette(zlim = cm$zlim, col = cm$col)
plot(windU, windV,
    asp = 1, cex = 1.4, pch = 21, bg = cm$zcol,
    xlim = c(-1, 1) * max(abs(c(windU, windV))),
    ylim = c(-1, 1) * max(abs(c(windU, windV))),
    xlab = "Eastward wind [m/s]", ylab = "Northward wind [m/s]"
)
mtext("Colour indicates wave height [m]", side = 3, line = 0.25)
for (ring in seq(10, 30, 10)) {
    circleX <- ring * cos(seq(0, 2 * pi, pi / 20))
    circleY <- ring * sin(seq(0, 2 * pi, pi / 20))
    lines(circleX, circleY, col = "lightgray")
}
abline(h = 0, col = "lightgray")
abline(v = 0, col = "lightgray")
abline(0, 1, col = "lightgray")
abline(0, -1, col = "lightgray")

dev.off()
