#!/bin/bash
texto='Que me gusta la bash!!!!'
if [ "$#" -gt 0 ]; then
    texto=$1
fi

./1crearjerarquia.sh "$texto"
./2volcarymover.sh