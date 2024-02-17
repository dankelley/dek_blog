debug <- FALSE
dmsg <- function(...) if (debug) message(...)

createRDA <- function(rdaName = "results.rda", empty = FALSE) {
    if (empty || !file.exists(rdaName)) {
        dmsg("creating RDA file \"", rdaName, "\"")
        results <- list()
        save(results, file = rdaName)
    } else {
        warning("RDA file \"", rdaName, "\" already exists, so will not be recreated")
    }
}

readRDA <- function(name = NULL, rdaName = "results.rda") {
    if (!file.exists(rdaName)) {
        stop("RDA file \"", rdaName, "\" does not exist yet; use createRDA()")
    }
    get(load(rdaName))[[name]]
}

writeRDA <- function(name = NULL, value = NULL, replace = FALSE, rdaName = "results.rda") {
    if (!file.exists(rdaName)) {
        stop("RDA file \"", rdaName, "\" does not exist yet; use createRDA()")
    }
    load(rdaName)
    names <- names(results)
    if (!replace && name %in% names(results)) {
        stop("use replace=TRUE to replace an existing value")
    }
    results[[name]] <- value
    save(results, file = rdaName)
}

# demo
createRDA(empty = TRUE)
stopifnot(0 != length("test"))
writeRDA("test", 999, replace = TRUE)
stopifnot(999 == readRDA("test")) # expect 999
writeRDA("test", list(A = 1, B = 2), replace = TRUE)
stopifnot(identical(list(A = 1, B = 2), readRDA("test"))) # expect a list
