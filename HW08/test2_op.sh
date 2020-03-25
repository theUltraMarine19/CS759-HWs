#!/usr/bin/env bash
#SBATCH -p wacc -N 1 -c 20
#SBATCH -J test2_op
#SBATCH -o test2_op.out -e test2_op.err

export OMP_PLACES=$2
export OMP_PROC_BIND=$1
g++ task2_op.cpp convolution.cpp -Wall -O3 -o task2_op -fopenmp
#export OMP_PROC_BIND=close
./task2_op 3 19
