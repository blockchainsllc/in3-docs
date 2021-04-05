#!/bin/sh
cd ../c/in3-core/swift
swift doc generate . --module-name In3
rm -rf .build/documentation/_* .build/documentation/Home.md ".build/documentation/allTests().md"
cat docs/*.md > ../../../doc/docs/api-swift.md
for f in `ls .build/documentation/*.md | sort -V`; do 
   sed 's/^## .*//' $f | sed 's/^### /#### /' | sed 's/^# /### /' >> ../../../doc/docs/api-swift.md          
done;
cd ../../../doc
