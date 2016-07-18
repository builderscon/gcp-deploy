#!/bin/sh

if [[ -z "$SECRET_NAME" ]]; then
  echo "Missing 'SECRET_NAME' variable"
  exit 1
fi

which jo >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Missing 'jo' executable. Please install 'jo' to proceed"
  exit 1
fi

exec jo -p \
    kind=Secret \
    apiVersion=v1 \
    metadata=$(jo name=$SECRET_NAME labels=$(jo name=$SECRET_NAME group=secrets)) \
    data[authmap.pl]=$(base64 authmap.pl)