#!/bin/sh
cd ../c/in3-core/python
./generate_docs.sh
cd ../../../doc
cp ../c/in3-core/python/docs/documentation.md docs/api-python.md
