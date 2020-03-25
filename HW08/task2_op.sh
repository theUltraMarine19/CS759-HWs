#!/usr/bin/env bash
#SBATCH -p wacc -N 1 -c 20
#SBATCH -J task2_op
#SBATCH -o task2_op.out -e task2_op.err

g++ task2_op.cpp convolution.cpp -Wall -O3 -o task2_op -fopenmp
export OMP_PROC_BIND=$1
export OMP_PLACES=$2
for i in {1..20}
do
    ./task2_op 1024 $i
    echo '=========='
done
