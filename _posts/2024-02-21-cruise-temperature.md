---
author: Dan Kelley
date: 2024-02-21
title: Ocean Temperatures for a Panama Cruise
---

A friend is planning a cruise to the Panama region in the next few weeks. Let's
see what the water temperature might be, based on today's temperature. Hm, the
waters near Panama are a wee bit warmer than those near Nova Scotia!

![panama](/dek_blog/docs/assets/images/2024-02-21-cruise-temperature-1.png)

![maritimes](/dek_blog/docs/assets/images/2024-02-21-cruise-temperature-2.png)


# Code

```R
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
```
