#!/bin/bash
END=96

read -p "Enter sequence (like seq00009): " sequence

DORADO=/home/sequencing/dorado-0.5.2/bin
SMODEL=/home/sequencing/dorado-0.5.2/bin/dna_r10.4.1_e8.2_400bps_sup@v4.3.0
SMODEL2=dna_r10.4.1_e8.2_400bps_sup@v4.3.0_5mC_5hmC@v1
DMODEL=/home/sequencing/dorado-0.5.2/bin/dna_r10.4.1_e8.2_400bps_hac@v4.3.0
DMODEL2=dna_r10.4.1_e8.2_400bps_hac@v4.3.0_5mC_5hmC@v1

cd /home/sequencing/ONT/$sequence
cd "$(find . -name pod5_pass)"
echo ""
#ls
INPUT=$(pwd)

barcodedirs=$(du -h barcode*|wc -l)

cd /home/sequencing/ONT/$sequence

if [ ! -d "/home/sequencing/ONT/$sequence/basecall" ]; then
#  mkdir basecall && cd "$_"
  mkdir -p basecall/simplex && cd "$_" && mkdir -p ./barcode{01..96}
  cd /home/sequencing/ONT/$sequence
  echo ""
  echo "Creating Empty Simplex Basecalling Directories!"
  echo ""
  mkdir -p basecall/duplex && cd "$_" && mkdir -p ./barcode{01..96}
  echo ""
  echo "Creating Empty Duplex Basecalling Directories!"
  echo ""
  cd /home/sequencing/ONT/$sequence/basecall
else
  cd /home/sequencing/ONT/$sequence/basecall
fi
OUTPUT=$(pwd)

echo ""
echo ""
echo "There are $barcodedirs barcode directories!"
echo ""
echo ""
echo "The pod5_pass directory is at $INPUT"
echo ""
echo ""
echo "The basecalling directory is at $OUTPUT"
echo ""
echo ""

echo "Now running SIMPLEX Basecalling for $barcodedirs barcodes in $sequence"
for i in {01..96}; do if [ -d "$INPUT/barcode$i" ]; then $DORADO/dorado basecaller $SMODEL --emit-fastq "$INPUT/barcode$i" > $DORADO/calls.fastq ; mv $DORADO/calls.fastq "$OUTPUT/simplex/barcode$i/"; fi; done
rmdir $OUTPUT/simplex/*

echo ""
echo ""

echo "Now running DUPLEX Basecalling for $barcodedirs barcodes in $sequence"
for i in {01..96}; do if [ -d "$INPUT/barcode$i" ]; then $DORADO/dorado basecaller $DMODEL --emit-fastq "$INPUT/barcode$i" > $DORADO/calls.fastq ; mv $DORADO/calls.fastq "$OUTPUT/duplex/barcode$i/"; fi; done
rmdir $OUTPUT/duplex/*

#for i in {01..96}; do $DORADO/dorado basecaller --emit-fastq dna_r10.4.1_e8.2_400bps_hac@v4.2.0 "$INPUT/barcode$i" > $DORADO/calls.fastq ; mv $DORADO/calls.fastq "$OUTPUT/duplex/barcode$i/"
#done

echo ""
echo ""
echo "ALL DONE! CYA!"
