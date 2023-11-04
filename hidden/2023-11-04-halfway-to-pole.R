# Show that the halfway point is at 45.14432 N
library(oce)
L <- geodDist(0, 0, 0, 90)
r <- uniroot(\(lat) geodDist(0, 0, 0, lat) - L/2, c(0, 90))$root
offset <- 111*(r-45)
official <- 45 + (8 + 40/60)/60
cat(sprintf("halfway point is %.5f, which is %.1f km from 45N\n", r, offset))
cat(sprintf("official location: %.5f\n", official))
cat(sprintf("misfit (old to new): %.3f km\n", 111*(official - r)))
