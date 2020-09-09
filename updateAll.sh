#!/bin/sh
if [ ! -e node_modules/.bin/slockit-doxygen ]
then
   npm install slockit-generator
fi
cd ../c/in3-core/build
rm -rf *
cmake -DTEST=false -DBUILD_DOC=true -DJAVA=true -DZKSYNC=true -DBTC=true -DIPFS=true -DCMAKE_BUILD_TYPE=DEBUG .. && make -j8
echo "generate python"
cd ../python
./generate_docs.sh || true

cd ../../../doc
echo "### updating C - API"
node_modules/.bin/slockit-doxygen ../c/in3-core/build/c/docs/doc_doxygen/xml "# API Reference C\n\n" | grep -v '{rust,ignore}'  >  docs/api-c.md
echo "### updating JAVA - API"
node_modules/.bin/slockit-doxygen ../c/in3-core/build/java/docs/doc_doxygen/xml "# API Reference Java\n\n" java >  docs/api-java.md
echo "### updating Dotnet - API"
cat ../c/in3-core/dotnet/docs/api-dotnet.md  ../c/in3-core/dotnet/docs/examples.md > docs/api-dotnet.md
echo "\n## Index\n" >> docs/api-dotnet.md
tail -n +5 ../c/in3-core/dotnet/In3/bin/Release/IN3.md | sed 's/| Name | Type.*//' | sed 's/| ----.*//' |  sed 's/| \(.*\) |\(.*\)|\(.*\)|/- \2 **\1** - \3/' | sed 's/##### Summary//' | sed 's/##### Namespace//' | sed 's/# /## /'  >> docs/api-dotnet.md
echo "### updating PYTHON - API"
cp ../c/in3-core/python/docs/documentation.md docs/api-python.md

cd ../c/in3-core/build
rm -rf *
source ~/ws/tools/emsdk/emsdk_env.sh > /dev/null
emcmake cmake -DWASM=true -DASMJS=false -DWASM_EMMALLOC=true -DIPFS=true -DZKSYNC=true -DBTC=true -DWASM_EMBED=false -DCMAKE_BUILD_TYPE=Release .. && make -j8 in3_wasm

PRE_DOC=`cat ../wasm/docs/*.md`
cd module
if [ ! -e node_modules/.bin/slockit-doxygen ]
then
   npm install --no-save slockit-generator typedoc
fi
echo "updating WASM - API"
node_modules/.bin/typedoc --includeDeclarations --ignoreCompilerErrors --readme none --target ES6 --mode 'modules' --excludeExternals --json doc.json index.d.ts
cat  doc.json | node_modules/.bin/slockit-docu index.d slockit/in3-c/blob/master/wasm/src "$PRE_DOC" >  ../../../../doc/docs/api-wasm.md

rm -rf doc.json node_modules
