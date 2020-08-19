#!/bin/sh
cat ../c/in3-core/dotnet/docs/api-dotnet.md  ../c/in3-core/dotnet/docs/examples.md > docs/api-dotnet.md
echo "\n## Index\n" >> docs/api-dotnet.md
tail -n +5 ../c/in3-core/dotnet/In3/bin/Release/IN3.md | sed 's/| Name | Type.*//' | sed 's/| ----.*//' |  sed 's/| \(.*\) |\(.*\)|\(.*\)|/- \2 **\1** - \3/' | sed 's/##### Summary//' | sed 's/##### Namespace//' | sed 's/# /## /'  >> docs/api-dotnet.md
