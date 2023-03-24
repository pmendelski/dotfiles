#!/bin/bash

opts=""
input=""
for o; do
  if [ x"$o" != x"${o#-}" ]; then
    opts="${opts}${o#-}"
  else
    input="$input $o"
  fi
done
query=$(echo "$input" | sed 's@ *$@@; s@^ *@@; s@ @/@; s@ @+@g')

curl -s "https://cht.sh"/"$query" | less
