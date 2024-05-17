#!/bin/bash

data=$(vault read -format=raw secrets/data/immutable-os/common)

export AUTH=$(echo -n "${GHCR_AUTH}" | base64 -w0)

temploc=$(mktemp -d)

while read -r line
do
  if [[ -z "${line}" ]]
  then
    continue
  fi
  file=$(echo $line | cut -d' ' -f1)
  cat ${file} | envsubst "$(echo $line | cut -d' ' -f2-)" > ${temploc}/file
  mv ${temploc}/file ${file}
done < $(dirname -- $0)/files_to_update