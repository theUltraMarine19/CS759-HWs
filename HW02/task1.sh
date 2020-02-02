#!/usr/bin/env bash
#SBATCH -p wacc
#SBATCH -J task1
#SBATCH -o task1.out -e task1.err

g++ scan.cpp task1.cpp -Wall -O3 -o task1
n=2
for i in {10..30}
do
        let p=( $n**$i )
	./task1 $p
        echo '=========='
done
