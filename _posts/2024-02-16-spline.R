library(oce)
# Download a test (Argo) file and cache it locally.
url <- "https://github.com/dankelley/dek_blog/raw/main/docs/assets/data/D4901076_061.nc"
file <- gsub(".*/", "", url)
if (!file.exists(file)) {
    download.file(url, file)
}
# If run non-interactively, create a PNG file
if (!interactive()) {
    png("2024-02-16-spline.png", height = 7, width = 7, unit = "in", res = 200)
}
par(mfrow = c(1, 1), mar = c(3.5, 3.5, 1, 1), mgp = c(2, 0.7, 0), lwd = 1.4)
# Read the file, extract some data, and start plotting
a <- read.oce(file)
sig0 <- a[["sigma0"]]
pi0 <- a[["spiciness0"]]
plot(sig0, pi0,
    xlab = resizableLabel("sigma0"),
    ylab = resizableLabel("spiciness0"),
    ylim = rev(range(pi0)),
    cex = 0.8
)
# Smooth in 4 different ways
deltaSigma <- 0.01
n <- 9 # must be an odd number
df <- length(sig0) / 3
sig0out <- seq(min(sig0), max(sig0), deltaSigma)
a <- approx(sig0, pi0, sig0out)
lines(a$x, lowpass(a$y, n = n), col = 1, lwd = 2)
s1 <- smooth.spline(pi0 ~ sig0, df = df)
ps1 <- predict(s1, sig0out)
lines(ps1$x, ps1$y, col = 2)
s2 <- smooth.spline(a$y ~ a$x, df = df)
ps2 <- predict(s2, sig0out)
lines(ps2$x, ps2$y, col = 3)
s3 <- smooth.spline(a$y ~ a$x, df = df * 2)
ps3 <- predict(s3, sig0out)
lines(ps3$x, ps3$y, col = 4)

grid()
legend("bottomleft",
    lwd = 1, col = 1:4, bg = "white",
    legend = c(
        "lowpass",
        "smoothing spline on raw data",
        "smoothing spline on gridded data",
        "smoothing spline on gridded data (df doubled)"
    )
)
