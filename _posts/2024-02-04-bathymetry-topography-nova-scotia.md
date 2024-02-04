---
title: Bathymetry and Topography near Nova Scotia
author: Dan Kelley
date: 2013-12-20
---

This is a followup to the two previous posts, dealing with representing the
shape of the earth surface with a shaded scheme.  Blue hues represent the ocean,
and golden hues represent the land.

There is a lot to see here.  The Annapolis Valley, to the south of the Bay of
Fundy, is particularly prominent as a flat area bounded by high land to the
north and soutrh.  Cape Breton has a complex pattern of relief that is will be
well known to those who have travelled there. An important fault line running
from east to west at about 45.5N is visible both above and below sealevel; for
more on this, and much of the geology of the region, see Pe-piper and Piper
(2003) and references therein.

![Bathymetry and topography in the region of Nova Scotia.](/dek_blog/docs/assets/images/2024-02-04-bathymetry-topography-nova-scotia.png)

```R
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
cmwater <- colormap(zlim = zlim, col = cmocean::cmocean("deep", direction = -1))
imagep(x, y, water, asp = asp,
    colormap = cmwater,
    decimate = FALSE,
    missingColor = "tan",
    mar = c(2.0, 2.0, 1.0, 1.0),
    drawPalette = FALSE
)
# Land
land <- G0
land[z < 0] <- NA
cmland <- colormap(zlim = zlim, col = cmocean::cmocean("solar"))
imagep(x, y, land, asp = asp,
    colormap = cmland,
    decimate = FALSE,
    add = TRUE,
    drawPalette = FALSE
)
if (!interactive()) {
    dev.off()
}
```

# References

1. George Pe-piper, David J.W. Piper, "A synopsis of the geology of the
   Cobequid Highlands, Nova Scotia", Atlantic Geology, 2003
   https://journals.lib.unb.ca/index.php/ag/article/view/1259/1652
