#!/usr/bin/env bash
#SBATCH -p wacc -N 1 -c 20
#SBATCH -J task1
#SBATCH -o task1.out -e task1.err

g++ task1.cpp matmul.cpp -Wall -O3 -o task1 -fopenmp
for i in {1..20}
do
    ./task1 1024 $i
    echo '=========='
done