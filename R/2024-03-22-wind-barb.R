png("2024-03-22-wind-barb.png", unit = "in", width = 7, height = 5.5, res = 200)
library(oce)
data(coastlineWorldFine, package = "ocedata")
par(mar = rep(2, 4))
mapPlot(coastlineWorldFine,
    border = gray(0.7),
    col = grey(0.95),
    projection = "+proj=lcc +lat_1=40 +lat_2=60 +lon_0=-65",
    longitudelim = c(-80, -50), latitudelim = c(40, 50)
)
# fake a geostrophic wind field centred in lower Hudson's Bay
model <- function(x, y, latitude, R = 100e3, rho = 1.2,
                  highP = 101.5e3, lowP = 98e3) {
    E <- exp(-(x^2 + y^2) / R^2)
    deltaP <- highP - lowP
    P <- highP - deltaP * E
    dPdx <- 2 * deltaP * x / R^2 * E
    dPdy <- 2 * deltaP * y / R^2 * E
    f <- oce::coriolis(latitude)
    u <- -dPdy / rho / f
    v <- dPdx / rho / f
    list(P = P, dPdx = dPdx, dPdy = dPdy, u = u, v = v)
}

nlon <- 50
nlat <- nlon + 1
lon <- seq(-100, -30, length.out = nlon)
lat <- seq(30, 60, length.out = nlat)
g <- expand.grid(lon = lon, lat = lat)
xy <- lonlat2map(g$lon, g$lat)
xyc <- lonlat2map(-81.30, 53.01) # Akimiski Island (Hudson's Bay)
m <- model(xy$x - xyc$x, xy$y - xyc$y,
    latitude = g$lat, R = 1000e3, lowP = 97e3, highP = 101e3
)
mps2knot <- 1.94384 # 1 m/s is 1.94384 knots
u <- mps2knot * matrix(m$u, nrow = length(lon))
v <- mps2knot * matrix(m$v, nrow = length(lon))
P <- matrix(m$P, nrow = length(lon))
mapContour(lon, lat, P, drawlabels = FALSE, col = 2, lwd = 1)
lx <- seq(1, length(lon), 4)
ly <- seq(1, length(lat), 4)
mapDirectionFieldNEW(lon[lx], lat[ly], u[lx, ly], v[lx, ly],
    lwd = 1.4,
    code = "barb", scale = 2, length = 0.25
)
points(xyc$x, xyc$y, pch = 20, cex = 3, col = 2)
