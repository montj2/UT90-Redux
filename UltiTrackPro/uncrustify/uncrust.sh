#!/bin/bash
FILES=$(find ../ -type f -name *.m)
for f in $FILES
do
  echo "Processing $f file..."
  uncrustify -c uncrustify.cfg --no-backup $f
done

FILES1=$(find ../ -type f -name *.h)
for f in $FILES1
do
  echo "Processing $f file..."
  uncrustify -c uncrustify.cfg --no-backup $f
done

FILES2=$(find ../ -type f -name *unc-backup*)
for f in $FILES2
do
	rm -fv $f
done
