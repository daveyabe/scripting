#!/bin/sh

#correct counts are two files per directory (2xdirectories)
#take initial argument 

LOCATION=$1
#loop testing
for item in $LOCATION
do
         FILECOUNT="$(find $LOCATION -maxdepth 1 -type f -printf x | wc -c)"
         DIRCOUNT="$(find $LOCATION -maxdepth 1 -type d -printf x | wc -c)"
done

DIRCOUNT=$((DIRCOUNT-1))
DOUBLEDIR=$((DIRCOUNT*2))

for dir in $LOCATION/*/ ; do
    FILECOUNT="$(find $dir -maxdepth 1 -type f -printf x | wc -c)"
    DIRCOUNT="$(find $dir -maxdepth 1 -type d -printf x | wc -c)"
    DIRCOUNT=$((DIRCOUNT-1))
    DOUBLEDIR=$((DIRCOUNT*2))
echo ""
echo "$dir"
echo "Directory count: " $DIRCOUNT
echo "File count: " $FILECOUNT
echo "Correct file: " $DOUBLEDIR
if [ "$FILECOUNT" -eq "$DOUBLEDIR" ]; then

        echo "ALL GOOD!"
        echo ""
else
        echo "REALLY NOT GOOD - check export"
        echo ""
fi

done
