#!/usr/bin/env bash
#SBATCH -p wacc -N 1 -c 20
#SBATCH -J task2
#SBATCH -o task2.out -e task2.err

g++ task2.cpp convolution.cpp -Wall -O3 -o task2 -fopenmp
for i in {1..20}
do
    ./task2 1024 $i
    echo '=========='
done