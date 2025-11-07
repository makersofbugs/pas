#!/usr/bin/env bash

mkdir -p build/

clang src/main.c $(pkg-config --cflags --libs lua) -o build/pas
