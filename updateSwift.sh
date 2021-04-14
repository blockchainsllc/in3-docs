#!/bin/sh
cd ../c/in3-swift
rm -rf .build/documentation/* 
swift doc generate . --module-name In3
rm -rf .build/documentation/_* .build/documentation/Home.md ".build/documentation/allTests().md"
res=../../doc/docs/api-swift.md 
cat docs/*.md > $res
for type in class struct enum protocol ; do
   echo "## $type" | sed s/class/Classes/ | sed s/struct/Structs/  | sed s/enum/Enums/  | sed s/protocol/Interfaces/  >> $res
   for f in `ls .build/documentation/*.md | sort -V`; do 
      if grep -q "public $type " $f; then
         sed 's/^## .*//' $f | sed 's/^#### \(.*\)/**\1**/' | sed 's/^### \`\(.*\)\`/### \1/' | sed 's/^### /#### /' | sed 's/^# /### /' >> $res
      fi
   done;
done;
cd ../../doc
