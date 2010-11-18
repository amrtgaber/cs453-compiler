#!/bin/bash

./compile < test.c-- > test.s
spim -f test.s