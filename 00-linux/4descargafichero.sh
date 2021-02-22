#!/bin/bash
nombrefichero=fichero.html

#command -v wget >/dev/null 2>&1 || { echo >&2 "wget requerido y no instalado."; exit 1; }
if ! command -v wget &> /dev/null
then
    echo "wget requerido y no instalado."
    exit
fi

wget --output-document=$nombrefichero -q https://lemoncode.net/

palabra='Lemoncode'
if [ "$#" -gt 0 ]; then
    palabra=$1
fi
grep -n $palabra $nombrefichero | awk -F: '{print $2" - Line number : "$1}'

rm $nombrefichero

exit 0