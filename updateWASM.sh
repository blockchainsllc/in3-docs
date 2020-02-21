#!/bin/sh

IN3_PATH="../c/in3-core/wasm/src"
PRE_DOC=`cat $IN3_PATH/../docs/*.md`
cd "$IN3_PATH"
ls -ltr
if [ ! -e node_modules/.bin/slockit-doxygen ]
then
   npm install --no-save slockit-generator typedoc
fi
echo "updating WASM - API"
node_modules/.bin/typedoc --includeDeclarations --ignoreCompilerErrors --readme none --target ES6 --mode 'modules' --excludeExternals --json doc.json in3.d.ts
cat  doc.json | node_modules/.bin/slockit-docu in3.d slockit/in3-c/blob/master/wasm/src "$PRE_DOC" >  ../../../../doc/docs/api-wasm.md

rm -rf doc.json node_modules
