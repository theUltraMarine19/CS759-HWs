// Author: Lijing Yang

#include <cstdlib>
#include <iostream>
#include "cluster.h"

void cluster(const size_t n, const size_t t, const int *arr, const int *centers, int *dists) {
    // const int sharing = 16;
    #pragma omp parallel num_threads(t)
    {
    	// No reduction needed as not accumulating across num_threads
        unsigned int tid = omp_get_thread_num();
        int sum = 0;
        #pragma omp for nowait
        for (size_t i = 0; i < n; i++) {
            // dists[tid*sharing] += abs(arr[i] - centers[tid]);
            sum += abs(arr[i] - centers[tid]);
        }
        dists[tid] = sum; // False sharing only happens here
    }
}