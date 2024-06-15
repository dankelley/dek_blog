url <- "https://downloads.psl.noaa.gov/Datasets/noaa.oisst.v2.highres/"
file <- "sst.day.mean.2024.nc"
# Change cache to FALSE to force a download.  But note that it is a
# large file, so you're wise to experiment with plot aesthetics on
# a cached file.
cache <- TRUE # set FALSE to force download (bad idea if you're experimenting)
if (!cache || !file.exists(file)) {
    download.file(paste0(url, file), file)
}
library(ncdf4)
library(oce)
data(coastlineWorldMedium, package = "ocedata")
# Cache variables to speed experimentation with plot aesthetics.
if (!exists("sstOrig")) {
    message("reading from ", file)
    nc <- nc_open(file)
    lonOrig <- ncvar_get(nc, "lon")
    latOrig <- ncvar_get(nc, "lat")
    sstOrig <- ncvar_get(nc, "sst")
    time <- ncvar_get(nc, "time")
    t <- as.POSIXct("1800-01-01 00:00:00", tz = "UTC") + time * 86400
    nc_close(nc)
}

looklon <- 287 <= lonOrig & lonOrig <= 308
looklat <- 38 <= latOrig & latOrig <= 47.0
lon <- lonOrig[looklon]
lat <- latOrig[looklat]
sst <- sstOrig[looklon, looklat, ]
sstdim <- dim(sst)
cm <- colormap(zlim = range(sst, na.rm = TRUE), col = oceColorsTurbo)
# Adjust height to avoid whitespace at top+bottom or left+right
if (!interactive()) {
    png("2024-06-15-sst.png",
        width = 7, height = 4.15, unit = "in", res = 200,
        pointsize = 10
    )
}
asp <- 1 / cospi(mean(range(lat)) / 180)
# Show most recent day
for (i in length(t)) {
    message(format(t[i]))
    imagep(lon, lat, sst[, , i],
        asp = asp, colormap = cm,
        mar = c(2.2, 2.2, 1.5, 0.5)
    )
    contour(lon, lat, sst[, , i],
        levels = seq(-2, 34, 2),
        drawlabels = !FALSE,
        add = TRUE
    )
    polygon(360 + coastlineWorldMedium[["longitude"]],
        coastlineWorldMedium[["latitude"]],
        col = "tan"
    )
    mtext(t[i])
}
dev.off()
