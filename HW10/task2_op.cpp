#include <omp.h>
#include <iostream>
#include <cstdlib>
#include "mpi.h"

#include <chrono>
#include <ratio>

#include "reduce.h"
using namespace std;

int main(int argc, char* argv[]) {
    int n = atoi(argv[1]);
    int t = atoi(argv[2]);

    chrono::high_resolution_clock::time_point start;
    chrono::high_resolution_clock::time_point end;
    chrono::duration<double, std::milli> duration_sec;

    float *arr, res;
    arr = new float[n];

    for (int i = 0; i < n; i++) {
        arr[i] = static_cast<float>(rand()) / (static_cast<float>(RAND_MAX / 10));
    }

    omp_set_num_threads(t);
    
    start = chrono::high_resolution_clock::now();
    res = reduce(arr, 0, n);
    end = chrono::high_resolution_clock::now();
    duration_sec = chrono::duration_cast<chrono::duration<double, std::milli>>(end - start);    
    cout << res << endl;
    cout << duration_sec.count() << endl;
    
    delete[] arr;

    return 0;
}
