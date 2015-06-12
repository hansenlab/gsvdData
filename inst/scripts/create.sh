#!/bin/bash
set -e -u

INDIR=/dcs01/hansen/hansen_lab1/chromVar/bw_non_peaks
OUTDIR=/dcs01/hansen/hansen_lab1/large_svd/example

SAMPLES="
GM12890
GM12891
GM18505
GM19240
GM19239"

HISTONES="
H3K27AC
H3K4ME1
H3K4ME3"

# for SAMP in ${SAMPLES}
# do
#   for HIST in ${HISTONES}
#   do
#     cp -v ${INDIR}/GSE50893_SNYDER_HG19_${SAMP}_${HIST}.norm5.rawsignal.bw ${OUTDIR}/genome
#     mv ${OUTDIR}/genome/GSE50893_SNYDER_HG19_${SAMP}_${HIST}.norm5.rawsignal.bw ${OUTDIR}/genome/${SAMP}_${HIST}.bw
#   done
# done

module load wiggletools
module load ucsctools
GENOME_FILES=$(/bin/ls ${OUTDIR}/genome)

## Below we use chrom.sizes
## We can get that from the original bw by
##  bigWigInfo -chroms $FILE1 |grep -P "\t" | cut -f1,3 -d" " > chrom.sizes

for FILE in ${GENOME_FILES}
do
  BASE=${FILE%.bw}
  echo "${BASE}"
  wiggletools write ${OUTDIR}/chr22/${BASE}.wig seek chr22 1 51304566 ${OUTDIR}/genome/${BASE}.bw
  wigToBigWig ${OUTDIR}/chr22/${BASE}.wig chrom.sizes ${OUTDIR}/chr22/${BASE}.bw
  rm ${BASE}.wig
done
