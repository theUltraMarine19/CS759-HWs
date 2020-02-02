#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -J task3
#SBATCH -o task3.out -e task3.err

g++ task3.cpp matmul.cpp -Wall -O3 -o task3
./task3
