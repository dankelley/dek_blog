library(oce)
library(dod)
f <- dod.amsr()
a <- read.amsr(f)
png("2024-02-21-cruise-temperature.png",
    unit = "in",
    width = 7, height = 4, res = 200, pointsize = 9
)
plot(a, xlim = c(-100, -50), ylim = c(12, 30), col = oceColorsTurbo)
dev.off()
