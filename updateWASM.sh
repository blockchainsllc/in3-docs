#!/bin/sh
PRE_DOC=$'# API Reference WASM\n\nThis page contains a list of all Datastructures and Classes used within the IN3 WASM-Client.\n'
IN3_PATH="../c/in3-core/src/bindings/wasm"
#IN3_EXAMPLES=`cat $IN3_PATH/examples.md`
PRE_DOC2=$'\n## Main Module\n\n Importing incubed is as easy as \n```ts\nimport Client from "in3-wasm"\n```\n\n While the In3Client-class is the default import, the following imports can be used: \n\n   '
cd "$IN3_PATH"
if [ ! -e node_modules/.bin/slockit-doxygen ]
then
   npm install --no-save slockit-generator typedoc
fi
echo "updating WASM - API"
node_modules/.bin/typedoc --includeDeclarations --ignoreCompilerErrors --readme none --target ES6 --mode 'modules' --excludeExternals --json doc.json in3.d.ts
cat  doc.json | node_modules/.bin/slockit-docu in3.d slockit/in3-c/blob/master/src/bindings/wasm "$PRE_DOC $IN3_EXAMPLES $PRE_DOC2" >  ../../../../../doc/docs/api-wasm.md

rm -rf doc.json node_modules
