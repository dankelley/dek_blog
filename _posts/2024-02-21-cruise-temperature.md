---
author: Dan Kelley
date: 2024-02-21
title: Ocean Temperatures for a Panama Cruise
---

A friend is planning a cruise to the Panama region in the next few weeks.
Let's see what the water temperature might be, based on today's temperature...

![panama](/dek_blog/docs/assets/images/2024-02-21-cruise-temperature.png)


# Code

```R
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
```
