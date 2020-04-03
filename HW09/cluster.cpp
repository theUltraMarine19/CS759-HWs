// Author: Lijing Yang

#include <cstdlib>
#include <iostream>
#include "cluster.h"

void cluster(const size_t n, const size_t t, const int *arr, const int *centers, int *dists) {
    // const int sharing = 16;
    #pragma omp parallel num_threads(t)
    {
    	unsigned int tid = omp_get_thread_num();
        #pragma omp for reduction(+:dists[:t])
        for (size_t i = 0; i < n; i++) {
            // dists[tid*sharing] += abs(arr[i] - centers[tid]);
            dists[tid] += abs(arr[i] - centers[tid]);
        }
    }
}

// Alternaative with similar(slightly lesser) runtime

// void cluster(const size_t n, const size_t t, const int *arr, const int *centers, int *dists) {
//     #pragma omp parallel num_threads(t)
//     {
//         unsigned int tid = omp_get_thread_num();
//         int sum = 0;
//         #pragma omp for nowait
//         for (size_t i = 0; i < n; i++) {
//             sum += abs(arr[i] - centers[tid]);
//         }
//         dists[tid] = sum; // False sharing only happens here
//     }
// }