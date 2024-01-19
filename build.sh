#!/bin/sh

CURRENT_DIR=$PWD
# locate
if [ -z "$BASH_SOURCE" ]; then
    SCRIPT_DIR=`dirname "$(readlink -f $0)"`
elif [ -e '/bin/zsh' ]; then
    F=`/bin/zsh -c "print -lr -- $BASH_SOURCE(:A)"`
    SCRIPT_DIR=`dirname $F`
elif [ -e '/usr/bin/realpath' ]; then
    F=`/usr/bin/realpath $BASH_SOURCE`
    SCRIPT_DIR=`dirname $F`
else
    F=$BASH_SOURCE
    while [ -h "$F" ]; do F="$(readlink $F)"; done
    SCRIPT_DIR=`dirname $F`
fi
# change pwd
cd $SCRIPT_DIR

CODEC_TYPE=AES256
[ -n "$1" ] && CODEC_TYPE=$1

OUT_DIR="target/$CODEC_TYPE"
mkdir -p target

mkdir $OUT_DIR || { echo "Remove $OUT_DIR/ dir to proceed with build."; exit 1; }

cd $OUT_DIR && \
cmake -GNinja \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
-DCODEC_TYPE=$CODEC_TYPE ../.. && \
ninja
