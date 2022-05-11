#!/bin/sh

python -m SimpleHTTPServer $PORT &

while true; do
  psql $DATABASE_URL -c 'select now();'
  sleep 2
done
