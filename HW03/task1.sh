#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -J task1
#SBATCH -o task1.out -e task1.err
#SBATCH --gres=gpu:1

module load cuda
nvcc task1.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -o task1
./task1