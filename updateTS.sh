#!/bin/sh
cd ../ts/in3
if [ ! -e node_modules/.bin/slockit-doxygen ]
then
   npm install slockit-generator
fi
echo "updating TS - API"
node_modules/.bin/typedoc  --exclude test --excludePrivate  --readme none --ignoreCompilerErrors --target ES6  --mode 'modules' --json doc.json src/index.ts

cat  doc.json | node_modules/.bin/slockit-docu index slockit/in3/blob/master/src $'# API Reference TS\n\nThis page contains a list of all Datastructures and Classes used within the TypeScript IN3 Client.\n' >  ../../doc/docs/api-ts.md
rm doc.json
