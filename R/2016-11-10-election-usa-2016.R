dir <- "https://raw.githubusercontent.com/dankelley/dek_blog/main/docs/assets/data"
ed <- paste0(dir, "/usa-election-2016-education.csv")
vo <- paste0(dir, "/usa-election-2016-votes.dat")

# Educational-level data, downloaded from
#   http://www.ers.usda.gov/webdocs/DataFiles/CountyLevel_Data_Sets_Download_Data__18026//Education.xls
# on Nov 10, 2016.
ee <- read.csv(ed, skip = 5, header = FALSE, encoding = "utf8", stringsAsFactors = FALSE)

# Use 'letters' to simplify lookup in CSV file.
l <- letters
e <- data.frame(
    state = ee[, 1],
    highschool = ee[, which(l == "t")],
    bachelor = ee[, which(l == "u")],
    advanced = ee[, which(l == "v")]
)
# Trim USA total, and some lines at bottom
education <- e[seq(2, nrow(e) - 2), ]

# Voting data, downloaded by cutting and pasting a table at
#   http://www.nbcnews.com/politics/2016-election/president
# downloaded as of 1611h AST on Nov 10, 2016. (NOTE: the
# text had '%' characters in several columns, but these
# were deleted.)
votes <- read.delim(vo,
    sep = "\t", header = FALSE,
    stringsAsFactors = FALSE,
    col.names = c(
        "state", "electoralVotes",
        "percentIn", "Clinton", "Trump"
    )
)
votes$ratio <- votes$Clinton / votes$Trump
votes$index <- ifelse(votes$ratio > 1, votes$ratio - 1, -1 / votes$ratio + 1)
votes$index <- (votes$Clinton - votes$Trump) / (votes$Clinton + votes$Trump)

# Check that tables are aligned
stopifnot(length(votes$state) == sum(votes$state == education$state))

png("2016-11-10-election-usa-2016.png")
par(mar = c(3, 3, 1, 1), mgp = c(2, 0.7, 0))

# what was the outlier?
subset(education, advanced > 20)
# Oh, DC...
DC <- which(education$advanced > 20)
# How did they vote in DC?
votes[DC, ]

division <- 10.2
H <- education$advanced > division # from visual inspection
Hdem <- votes$index[H] > 0
Hrep <- votes$index[H] < 0
Ldem <- votes$index[!H] > 0
Lrep <- votes$index[!H] < 0

plot(education$advanced, votes$index,
    ylim = c(-1, 1) * max(abs(votes$index)),
    pch = 21, cex = 1.4,
    bg = ifelse(votes$index > 0, "blue", "red"),
    xlab = "Percent of population with advanced degree",
    ylab = "Voting index"
)
abline(h = 0)
abline(v = division)
mtext(paste(sum(Hdem), "states"),
    side = 3, line = -3, adj = 0.7, font = 2, cex = 1.2, col = "blue"
)
mtext(paste(sum(Hrep), "states"),
    side = 1, line = -3, adj = 0.7, font = 2, cex = 1.2, col = "red"
)
mtext(paste(sum(Ldem), "states"),
    side = 3, line = -3, adj = 0.05, font = 2, cex = 1.2, col = "blue"
)
mtext(paste(sum(Lrep), "states"),
    side = 1, line = -3, adj = 0.05, font = 2, cex = 1.2, col = "red"
)
mtext(paste(division, "%"), side = 3, line = 0, at = 10.5)
