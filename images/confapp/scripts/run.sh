#!/bin/sh

# Run the app via gunicorn. Make sure you have a file name "app.py"

set -e

exec gunicorn \
  --bind 0.0.0.0:8080 \
  --workers 10 \
  --max-requests 2000 \
  --max-requests-jitter 200 \
  --access-logfile '-' \
  app:app