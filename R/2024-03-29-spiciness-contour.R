png("2024-03-29-spiciness-contour.png", unit = "in", width = 7, height = 7, pointsize = 10, res = 200)
library(oce)
data(ctd)
plotTS(ctd)

usr <- par("usr")
n <- 100
SAgrid <- seq(usr[1], usr[2], length.out = n)
CTgrid <- seq(usr[3], usr[4], length.out = n)
g <- expand.grid(SA = SAgrid, CT = CTgrid)
spiciness <- matrix(gsw::gsw_spiciness0(g$SA, g$CT), nrow = n)
contour(SAgrid, CTgrid, spiciness,
    col = 2, add = TRUE, labelcontours = TRUE,
    labcex = 1, nlevel = 8
)
