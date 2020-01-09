#!/bin/sh
PRE_DOC=$'# API Reference TS\n\nThis page contains a list of all Datastructures and Classes used within the TypeScript IN3 Client.\n'
IN3_PATH="../ts/in3"
IN3_EXAMPLES=`cat $IN3_PATH/examples.md`
PRE_DOC2=$'\n## Main Module\n\n Importing incubed is as easy as \n```ts\nimport Client,{util} from "in3"\n```\n\n While the In3Client-class is the default import, the following imports can be used: \n\n   '
cd "$IN3_PATH"
if [ ! -e node_modules/.bin/slockit-doxygen ]
then
   npm install slockit-generator
fi
echo "updating TS - API"
node_modules/.bin/typedoc  --exclude test --excludePrivate  --readme none --ignoreCompilerErrors --target ES6  --mode 'modules' --json doc.json src/index.ts
cat  doc.json | node_modules/.bin/slockit-docu index slockit/in3/blob/master/src "$PRE_DOC $IN3_EXAMPLES $PRE_DOC2" >  ../../doc/docs/api-ts.md
cd "../in3-common"
if [ ! -e node_modules/.bin/slockit-doxygen ]
then
   npm install slockit-generator
fi
echo "updating TS-common - API"
node_modules/.bin/typedoc  --exclude test --excludePrivate  --readme none --ignoreCompilerErrors --target ES6  --mode 'modules' --json doc.json src/index.ts

cat  doc.json | node_modules/.bin/slockit-docu index slockit/in3-common/blob/master/src $'## Common Module\n\nThe common module (in3-common) contains all the typedefs used in the node and server.\n\n' >>  ../../doc/docs/api-ts.md
rm doc.json
