// Author: Lijing Yang

#ifndef CLUSTER4_H
#define CLUSTER4_H

#include <cstddef>
#include <omp.h>

// this function does a parallel for loop that calculates the total
// distance between a thread's local center and the data points in its
// corresponding partition.

// it takes a sorted array "arr" of length n, and uses static scheduling
// so that each thread works on its own partition of data.

// t - number of threads.
// "centers" - an array of local center positions; it has length t.
// "dists" - an array that stores the calculated distances; it has length t.
// the length of "centers" and "dists" can be changed if padding is used.

// Example input: arr = [0, 1, 3, 4, 6, 6, 7, 8], n = 8, t = 2.
// centers = [2, 6] (this is calculated in task1.cpp).
// Expected results: dists = [6, 3].
// 6 = |0-2| + |1-2| + |3-2| + |4-2|; 3 = |6-6| + |6-6| + |7-6| + |8-6|.

void cluster4(const size_t n, const size_t t, const int *arr, const int *centers, int *dists);

#endif