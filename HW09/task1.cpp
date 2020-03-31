#include <omp.h>
#include <iostream>
#include <cstdlib>
#include <climits>
#include <algorithm>

#include <chrono>
#include <ratio>

#include "cluster.h"
using namespace std;

// const int sharing = 16;

int main(int argc, char* argv[]) {
    int n = atoi(argv[1]);
    int t = atoi(argv[2]);

    chrono::high_resolution_clock::time_point start;
    chrono::high_resolution_clock::time_point end;
    chrono::duration<double, std::milli> duration_sec;

    int *arr, *centers, *dists;
    arr = new int[n];
    centers = new int[t];
    // int *dists;
    // dists = new int[t*sharing]; // Each thread has entire cache line of 64 bytes to itself
    dists = new int[t];

    for (int i = 0; i < n; i++) {
        arr[i] = rand() % (n+1);
    }

    sort(arr, arr+n);

    for (int i = 0; i < t; i++) {
        centers[i] = n/(2*t) * (2*i+1);
    }

    // for (int i = 0; i < sharing*t; i++) {
    //     dists[i] = 0;
    // }

    

    // int arr[] = {0, 1, 3, 4, 6, 6, 7, 8};
    // int centers[] = {2, 6};

    double time = 0.0;

    for (int iter = 0; iter < 13; iter++) {
        
        for (int i = 0; i < t; i++) {
            dists[i] = 0;
        }
        start = chrono::high_resolution_clock::now();
        cluster(n, t, arr, centers, dists);
        end = chrono::high_resolution_clock::now();
        duration_sec = chrono::duration_cast<chrono::duration<double, std::milli>>(end - start);
        if (iter >= 3)
            time += duration_sec.count();
    }

    int maxm = INT_MIN;
    int partition = -1; // No need to initialize though
    #pragma omp parallel num_threads(t)
    {
        int idx = -1;
        int maxval = INT_MIN;
        #pragma omp for nowait
        // for (int i = 0; i < sharing * t; i++) {
        for (int i = 0; i < t; i++) {
            if (dists[i] > maxval) {
                maxval = dists[i];
                idx = omp_get_thread_num();
            }
        }
        #pragma omp critical
        {
            if (maxval > maxm) {
                maxm = maxval;
                partition = idx;
            }
        }
    }
    

    

    // for (int i = 0; i < t*sharing; i++)
    //  	  cout << dists[i] << " ";
    // cout << endl;

    // for (int i = 0; i < n; i++)
    //        cout << arr[i] << " ";
    // cout << endl;

    // for (int i = 0; i < t; i++)
    //        cout << centers[i] << " ";
    // cout << endl;

    // for (int i = 0; i < t; i++)
    //        cout << dists[i] << " ";
    // cout << endl;    

    cout << maxm << endl;
    cout << partition << endl;
    cout << time/10 << endl;

    delete[] arr;
    delete[] centers;
    delete[] dists;

    return 0;
}
