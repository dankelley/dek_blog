png("2024-02-19-co2.png", unit = "in", width = 7, height = 6, res = 200)
par(mar = c(2, 3, 1, 1), mgp = c(2, 0.7, 0))
# Compare built-in co2 dataset, which ends in 1979.917,
# with a new dataset that starts in 1979
data(co2)
old <- data.frame(year = as.numeric(time(co2), co2 = as.vector(co2)))
tail(old, 1) # 1979.917

# Citation for data:
#
# Lan, X., Tans, P. and K.W. Thoning: Trends in globally-averaged CO2
# determined from NOAA Global Monitoring Laboratory measurements. Version
# 2024-02 https://doi.org/10.15138/9N0H-ZH07
url <- "https://gml.noaa.gov/webdata/ccgg/trends/co2/co2_mm_gl.csv"
file <- gsub(".*/", "", url)
message("downloading \"", file, "\" from \"", url, "\"")
download.file(url, file)
data <- read.csv(file, comment = "#")
new <- data.frame(year = data$decimal, co2 = data$average)
head(new, 1)
with(
    old,
    plot(year, co2, type = "l", xlim = c(1959, 2024), ylim = c(310, 430))
)
with(new, lines(year, co2, col = 2))
grid()
