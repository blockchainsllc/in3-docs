#!/bin/sh
if [ ! -e node_modules/.bin/slockit-doxygen ]
then
   npm install slockit-generator
fi
echo "updating Java - API"
node_modules/.bin/slockit-doxygen ../c/in3-core/build/docs/doc_doxygen/xml "# API Reference Java\n\n" java >  docs/api-java.md
