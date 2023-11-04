# halfway_to_pole.R

# Show that the halfway point is at 45.14432 N
library(oce)
L <- geodDist(0, 0, 0, 90)
uniroot(\(lat) geodDist(0, 0, 0, lat) - L/2, c(0, 90))$root
