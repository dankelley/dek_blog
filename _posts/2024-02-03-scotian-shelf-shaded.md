---
title: Scotian Shelf Bathymetry in Shaded View
author: Dan Kelley
date: 2024-02-03
---

The following code makes a shaded view of the shape of the ocean bottom near
Nova Scotia. It is impossible to find actual depths from such a diagram -- for
that, a normal bathymetric chart is better -- but it *is* quite evocative.

![scotian_shelf_shaded](/dek_blog/docs/assets/images/2024-02-04-scotian-shelf-shaded.png)

```R
Q <- 0.95 # quantile for slope cutoff
library(oce)
library(dod)
topoFile <- dod.topo(-67, -59, 43, 47.3, resolution = 0.5)
topo <- read.topo(topoFile)
x <- topo[["longitude"]]
y <- topo[["latitude"]]
z <- topo[["z"]]
land <- z > 1
asp <- 1 / cos(mean(y) * pi / 180)

g <- grad(z, x, y)
G <- asp * g$gx - g$gy # note the asp term
zlim <- quantile(abs(G), Q) * c(-1, 1)
G[land] <- NA
A <- 5.65 / 7 # from fiddling to remove whitespace
if (!interactive()) {
    png("topo_SS.png",
        width = 7, height = 7 * A, unit = "in", res = 400,
        type = "cairo", antialias = "none", family = "Arial"
    )
}
imagep(x, y, G,
    asp = asp, zlim = zlim,
    col = cmocean::cmocean("deep", direction = -1),
    decimate = FALSE,
    missingColor = "tan",
    mar = c(2.0, 2.0, 1.0, 1.0),
    drawPalette = FALSE
)
contour(x, y, z,
    levels = 0, drawlabels = FALSE,
    add = TRUE, lwd = 0.3
)
if (!interactive()) {
    dev.off()
}
```
