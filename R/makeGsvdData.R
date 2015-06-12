makeGsvdData <- function() {
    bwDir <- system.file("extdata", package = "gsvdData", mustWork = TRUE)
    bwFiles <- list.files(bwDir, pattern = "\\.bw", full = TRUE)
    names(bwFiles) <- sub("\\.bw", "", basename(bwFiles))
    ## FIXME: Bug in GenomicFiles
    bwFileList <- lapply(bwFiles, BigWigFile)
    gr <- unlist(tileGenome(seqlengths = c("chr22" = 51304566),
                            tilewidth = 10^7))
    colData <- DataFrame(sampleName = names(bwFiles))
    colData$Individual <- sapply(strsplit(colData$sampleName, "_"), "[", 1)
    colData$Histone <- sapply(strsplit(colData$sampleName, "_"), "[", 2)
    GF <- GenomicFiles(rowData = gr, files = bwFiles, colData = colData)
    GF
}
