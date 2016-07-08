#!/bin/sh

APPDIR=conf.builderscon.io 
if [[ ! -e "$APPDIR" ]]; then
    git clone git@github.com:builderscon/conf.builderscon.io.git $APPDIR
fi

if [[ ! -e $APPDIR/app.py ]]; then
    pushd $APPDIR
    ln -s app.wsgi app.py
    popd
fi

exec docker build -t octav/confweb .