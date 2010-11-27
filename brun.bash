#!/bin/bash

make clean
make
./compile < test.c-- > test.s
if [ $? -eq 0 ]; then
	spim -f test.s
fi