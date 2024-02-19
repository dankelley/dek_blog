png("2014-01-11-inferring-halocline-depth.png", unit = "in", width = 7, height = 5, res = 200)
library(oce)
findHalocline <- function(ctd, deltap = 5, plot = TRUE) {
    S <- ctd[["salinity"]]
    p <- ctd[["pressure"]]
    n <- length(p)
    ## trim df to be no larger than n/2 and no smaller than 3.
    N <- deltap / median(diff(p))
    df <- min(n / 2, max(3, n / N))
    spline <- smooth.spline(S ~ p, df = df)
    SS <- predict(spline, p)
    dSSdp <- predict(spline, p, deriv = 1)
    H <- p[which.max(dSSdp$y)]
    if (plot) {
        par(mar = c(3, 3, 1, 1), mgp = c(2, 0.7, 0))
        plotProfile(ctd, xtype = "salinity")
        lines(SS$y, SS$x, col = "red")
        abline(h = H, col = "blue")
        mtext(sprintf("%.2f m", H), side = 4, at = H, cex = 3 / 4, col = "blue")
        mtext(sprintf(" deltap: %.0f, N: %.0f, df: %.0f", deltap, N, df),
            side = 1, line = -1, adj = 0, cex = 3 / 4
        )
    }
    H
}
# Plot two panels to see influence of deltap.
par(mfrow = c(1, 2))
data(ctd)
findHalocline(ctd)
findHalocline(ctd, 1)
