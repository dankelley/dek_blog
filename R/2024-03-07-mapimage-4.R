png("2024-03-07-mapimage-4.png", type = "cairo", antialias = "none", family = "Arial")
library(oce)
data(coastlineWorld)
data(topoWorld)

# Northern polar region, with color-coded bathymetry
par(mfrow = c(1, 1), mar = c(2, 2, 1, 1))
cm <- colormap(zlim = c(-5000, 0), col = oceColorsGebco)
drawPalette(colormap = cm)
mapPlot(coastlineWorld,
    projection = "+proj=stere +lat_0=90",
    longitudelim = c(-180, 180), latitudelim = c(70, 110)
)

# Method 1: the default, using polygons for lon-lat patches
#mapImage(topoWorld, colormap = cm)
# Method 2: filled contours, with ugly missing-data traces
#mapImage(topoWorld, colormap = cm, filledContour = TRUE)
# Method 3: filled contours, with a double-sized grid cells
#mapImage(topoWorld, colormap = cm, filledContour = 2)
# Method 4: filled contours, with a gap-filling gridder)
g <- function(...) binMean2D(..., fill = TRUE, fillgap = 2)
mapImage(topoWorld, colormap = cm, filledContour = TRUE, gridder = g)

mapGrid(15, 15, polarCircle = 1, col = gray(0.2))
mapPolygon(coastlineWorld[["longitude"]],
    coastlineWorld[["latitude"]],
    col = "tan"
)
