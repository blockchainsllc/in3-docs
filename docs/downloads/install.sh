#!/bin/sh
BASE_URL=https://in3.readthedocs.io/en/develop/_downloads/in3_
NAME=x86
BIN_PATH=/opt/local/bin
if [[ "$OSTYPE" == "linux-gnu" ]]; then
    BIN_PATH=/usr/bin
    NAME=x64

    case $(uname -m) in
        i386)   NAME="x86" ;;
        i686)   NAME="x64" ;;
        x86_64) NAME="x64" ;;
        arm)    NAME="armv7" ;;
    esac

elif [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac OSX
    BIN_PATH=/opt/local/bin
    NAME=osx
elif [[ "$OSTYPE" == "cygwin" ]]; then
        # POSIX compatibility layer and Linux environment emulation for Windows
    NAME=x64
elif [[ "$OSTYPE" == "msys" ]]; then
        # Lightweight shell and GNU utilities compiled for Windows (part of MinGW)
    NAME=x64
elif [[ "$OSTYPE" == "win32" ]]; then
        # I'm not sure this can happen.
    NAME=x64
elif [[ "$OSTYPE" == "freebsd"* ]]; then
        # ...
    NAME=x64
else
    BIN_PATH=/usr/bin
    NAME=x64
fi

echo "installing in3 to $BIN_PATH/in3 ... "
curl $BASE_URL$NAME > $BIN_PATH/in3
chmod 755 $BIN_PATH/in3
echo "done"