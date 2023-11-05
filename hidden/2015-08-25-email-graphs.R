png("../docs/assets/images/2015-08-25-email-graphs.png",
    units = "in", res = 200, width = 7, height = 4, pointsize = 10
)

library(oce)
# Next two lines establish adjustable parameters
parameters <- list(
    space = 0.1, # controls width for strings
    size = 0.8, # controls size of text labels
    col = 4 # controls colour of lines and text
)
# Data: time,sender,recipient
data <- "
2015-08-24 16:14:17,blue,blue
2015-08-19 09:18:00,blue,red
2015-07-31 14:23:31,red,blue
2015-07-31 13:48:56,beige,blue
2015-07-31 12:17:00,brown,beige
2015-07-31 11:15:00,purple,beige
2015-07-30 19:59:00,green,yellow
2015-07-30 08:09:00,orange,blue
2015-07-30 08:09:00,blue,orange
2015-07-30 07:59:00,orange,green
2015-07-30 07:56:00,orange,blue
2015-07-30 07:59:00,green,yellow
2015-07-29 21:04:00,yellow,green
2015-07-29 11:07:00,green,yellow
2015-07-28 15:22:00,yellow,green
2015-04-11 10:19:00,blue,pink
2015-04-11 10:13:00,blue,red
2015-04-11 09:43:00,red,blue
2015-04-01 08:40:00,red,blue
"
d <- read.csv(text = data, header = FALSE)
t <- as.POSIXct(d$V1, tz = "UTC")
o <- order(t, decreasing = TRUE) # just in case
t <- t[o]
from <- d$V2[o]
to <- d$V3[o]
n <- length(from)
day <- 86400
par(mar = c(2, 2, 1, 1), mgp = c(2, 0.7, 0))
timeSpan <- as.numeric(max(t)) - as.numeric(min(t))
space <- parameters$space * parameters$size * timeSpan
plot(t, 1:n,
    type = "n", axes = FALSE,
    xlab = "", ylab = "", xlim = c(min(t), max(t) + 4 * space),
    ylim = c(0, n + 1)
)
oce.axis.POSIXct(1, drawTimeRange = FALSE)
box()
tl <- max(t) + space
cex <- parameters$size * par("cex")
col <- parameters$col
for (i in 1:n) {
    text(tl + 0.3 * space, i, paste(from[i], "-", to[i], sep = ""),
        pos = 4, cex = cex, col = col
    )
    lines(c(tl, t[i]), rep(i, 2), col = col)
    lines(c(t[i], t[i]), c(i, 0), col = col)
}

dev.off()
