library(oce)
library(dod)
data(coastlineWorldFine, package="ocedata")
f <- dod.amsr()
a <- read.amsr(f)
png("2024-02-21-cruise-temperature-%d.png",
    unit = "in",
    width = 7, height = 4, res = 200, pointsize = 9
)
# Panama region
plot(a, xlim = c(-100, -50), ylim = c(12, 30), col = oceColorsTurbo)
lines(coastlineWorldFine[["longitude"]], coastlineWorldFine[["latitude"]])
# Halifax region
plot(a, xlim = c(-70, -40), ylim = c(35, 50), col = oceColorsTurbo)
lines(coastlineWorldFine[["longitude"]], coastlineWorldFine[["latitude"]])
