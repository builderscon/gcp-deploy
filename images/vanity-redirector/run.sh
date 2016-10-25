#!/bin/sh
exec \
    plackup -s Gazelle \
        --port=$APP_PORT \
        --max-workers=10 \
        --max-reqs-per-child=1000 \
        --max-reqs-per-child=500
