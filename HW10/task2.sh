#!/usr/bin/env bash
#SBATCH -p wacc --nodes=2 --cpus-per-task=20 --ntasks-per-node=1
#SBATCH -J task2
#SBATCH -o task2.out -e task2.err

module purge
module load mpi/openmpi
mpicxx task2.cpp reduce.cpp -Wall -O3 -o task2 -fopenmp -fno-tree-vectorize -march=native -fopt-info-vec
for i in {1..20}
do
    mpirun -np 2 --bind-to none ./task2 1000000 $i
    echo '=========='
done
