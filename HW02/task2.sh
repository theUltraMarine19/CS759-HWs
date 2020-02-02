#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -J task2
#SBATCH -o task2.out -e task2.err

g++ convolution.cpp task2.cpp -Wall -O3 -o task2
./task2 4
