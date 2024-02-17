Q <- 0.95 # quantile for slope cutoff
library(oce)
library(dod)
topoFile <- dod.topo(-67, -59, 43, 47.3, resolution = 0.5)
topo <- read.topo(topoFile)
x <- topo[["longitude"]]
y <- topo[["latitude"]]
z <- topo[["z"]]
asp <- 1 / cos(mean(y) * pi / 180)

g <- grad(z, x, y)
G0 <- asp * g$gx - g$gy # note the asp factor
zlim <- quantile(abs(G0), Q) * c(-1, 1)
if (!interactive()) {
    png("topobathy_NS.png",
        width = 7, height = 5.5, unit = "in", res = 400,
        type = "cairo", antialias = "none", family = "Arial"
    )
}
# Water
water <- G0
water[z > 0] <- NA
cmwater <- colormap(
    zlim = zlim,
    col = cmocean::cmocean("deep", direction = -1)
)
imagep(x, y, water,
    asp = asp,
    colormap = cmwater,
    decimate = FALSE,
    mar = c(2.0, 2.0, 1.0, 1.0),
    drawPalette = FALSE
)
# Land
land <- G0
land[z < 0] <- NA
cmland <- colormap(zlim = zlim, col = cmocean::cmocean("solar"))
imagep(x, y, land,
    asp = asp,
    colormap = cmland,
    decimate = FALSE,
    add = TRUE,
    drawPalette = FALSE
)
if (!interactive()) {
    dev.off()
}
