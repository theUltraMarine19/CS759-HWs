#!/usr/bin/env bash
#SBATCH -p wacc --nodes=1 --cpus-per-task=20
#SBATCH -J task22
#SBATCH -o task22.out -e task22.err

g++ task2_op.cpp reduce.cpp -Wall -O3 -o task2 -fopenmp -fno-tree-vectorize -march=native -fopt-info-vec
for i in {1..20}
do
    ./task2 2000000 $i
    echo '=========='
done
