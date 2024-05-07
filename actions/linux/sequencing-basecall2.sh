#!/bin/bash

#if [ "$EUID" -ne 0 ]
#  then echo "Please run using sudo - try again"
#  exit
#fi

read -p "Enter sequence (like seq00009): " sequence

DORADO=/home/sequencing/dorado/bin
SMODEL=/home/sequencing/dorado/bin/dna_r10.4.1_e8.2_400bps_sup@v4.3.0
SMODEL2=dna_r10.4.1_e8.2_400bps_sup@v4.3.0_5mC_5hmC@v1
DMODEL=/home/sequencing/dorado/bin/dna_r10.4.1_e8.2_400bps_hac@v4.3.0
DMODEL2=dna_r10.4.1_e8.2_400bps_hac@v4.3.0_5mC_5hmC@v1

cd /home/sequencing/ONT/$sequence
cd "$(find . -name pod5)"
echo ""
INPUT=$(pwd)

cd /home/sequencing/ONT/$sequence

if [ ! -d "/home/sequencing/ONT/$sequence/basecall" ]; then
  mkdir -p basecall/simplex
  cd /home/sequencing/ONT/$sequence
  echo ""
  cd /home/sequencing/ONT/$sequence/basecall
else
  cd /home/sequencing/ONT/$sequence/basecall
fi
OUTPUT=$(pwd)

echo ""
echo ""
echo "The pod5 directory is at $INPUT"
echo ""
echo ""
echo "The basecalling directory is at $OUTPUT"
echo ""
echo ""

echo "Now running SIMPLEX Basecalling for CUSTOM barcodes in $sequence"
echo ""
echo ""
$DORADO/dorado basecaller $SMODEL --emit-fastq "$INPUT" > /home/sequencing/${sequence}_calls.fastq
mv /home/sequencing/${sequence}_calls.fastq "$OUTPUT/simplex/"
sleep 20
echo "Moving ${sequence}_calls.fastq to $OUTPUT/simplex"

echo ""
echo "ALL DONE! CYA!"
