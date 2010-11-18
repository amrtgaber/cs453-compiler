#!/bin/bash

make clean
make
./compile < test.c-- > test.s
spim -f test.s