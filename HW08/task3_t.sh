#!/usr/bin/env bash
#SBATCH -p wacc -N 1 -c 20
#SBATCH -J task3_t
#SBATCH -o task3_t.out -e task3_t.err

g++ task3.cpp msort.cpp -Wall -O3 -o task3 -fopenmp
n=2
for i in {1..20}
do
    let p=( $n**7 )
	./task3 1000000 $i $p
    echo '=========='
done
