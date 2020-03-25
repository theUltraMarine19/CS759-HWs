#!/usr/bin/env bash
#SBATCH -p wacc -N 1 -c 20
#SBATCH -J task3_ts
#SBATCH -o task3_ts.out -e task3_ts.err

g++ task3.cpp msort.cpp -Wall -O3 -o task3 -fopenmp
n=2
for i in {1..10}
do
    let p=( $n**$i )
	./task3 1000000 8 $p
    echo '=========='
done