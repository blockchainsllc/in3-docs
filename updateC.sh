#!/bin/sh
if [ ! -e node_modules/.bin/slockit-doxygen ]
then
   npm install slockit-generator
fi
echo "updating C - API"
node_modules/.bin/slockit-doxygen ../c/in3-core/build/c/docs/doc_doxygen/xml "# API Reference C\n\n" | grep -v '{rust,ignore}'  >  docs/api-c.md
