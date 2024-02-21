library(oce)
library(dod)
f <- dod.amsr()
a <- read.amsr(f)
png("amsr-maritime.png",
    unit = "in",
    width = 7, height = 4, res = 200, pointsize = 9
)
plot(a, xlim = c(-70, -40), ylim = c(35, 50), col = oceColorsTurbo)
data(coastlineWorldFine, package="ocedata")
lines(coastlineWorldFine[["longitude"]], coastlineWorldFine[["latitude"]])
dev.off()
