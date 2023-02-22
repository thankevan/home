#!/bin/bash

if ! type jq &>/dev/null; then
  echo "Please install jq"
  exit 1
fi

if ! type qrencode &>/dev/null; then
  echo "Please install qrencode"
  exit 1
fi

url=`curl -s http://localhost:4040/api/tunnels/ | jq .tunnels[0].public_url | tr -d '"'`

if [ -z "$url" ]; then
  echo "Please run:"
  echo "   ngrok http <port>"
  exit
fi

echo "${url}:"
qrencode -t utf8 "$url"

