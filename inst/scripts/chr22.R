## This code does it brute-force

library(rtracklayer)
library(lineprof)

line.out <- lineprof( {

    allfiles <- list.files("chr22", full.names = TRUE)
    rles <- lapply(allfiles, function(xx) {
        ## Reading in only chr22
        ## chrs <- GRanges(seqnames = "chr22", ranges = IRanges(start = 1, XX))
        ##   use which = chrs
        cat("Reading", xx, "\n")
        import(xx, as = "Rle", format = "bw")
    })
    cutoff <- min(sapply(rles, function(xx) runLength(xx$chr22)[1]))
    megaMatrix <- do.call(cbind, lapply(rles, function(xx) as.numeric(xx$chr22[-(1:cutoff)])))
    core <- crossprod(megaMatrix)
    core.svd <- svd(core)
    ## Check
    core.eigen <- eigen(core)
    all.equal(core.eigen$values, core.svd$d)
    ## all the sweep stuff is to fix sign differences.
    ss <- sign(core.svd$u[1,]) * sign(core.eigen$vectors[1,])
    all.equal(sweep(core.eigen$vectors, 2, FUN = "*", ss),
              core.svd$u)
    rightVectors <- core.svd$u  # U
    singularValues <- core.svd$d  # Sigma
    leftVectors <- megaMatrix %*% (rightVectors %*% diag(1/singularValues))  # V
    megaMatrix2 <- tcrossprod(leftVectors, rightVectors %*% diag(singularValues))
    all.equal(megaMatrix, megaMatrix2)
})

print(line.out)
save(line.out, file = "chr22.line.out.rda")

