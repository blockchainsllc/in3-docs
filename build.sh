#!/bin/sh
docker run --rm -tv $(pwd):/src docker.slock.it/build-images/doc:readthedocs bash -c "cd /src/docs && make html && make latexpdf && make text"
#rst2man.py --title=Incubed -q --no-generator docs/api-cmd.rst > docs/in3.3