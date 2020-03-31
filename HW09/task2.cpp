#include <omp.h>
#include <iostream>
#include <cstdlib>

#include <chrono>
#include <ratio>
// #include <ctime>

#include "montecarlo.h"
using namespace std;

int main(int argc, char* argv[]) {
    int n = atoi(argv[1]);
    int t = atoi(argv[2]);

    float r = 1.0;

    chrono::high_resolution_clock::time_point start;
    chrono::high_resolution_clock::time_point end;
    chrono::duration<double, std::milli> duration_sec;

    float *x, *y;
    x = new float[n];
    y = new float[n];

    srand(1968);

    for (int i = 0; i < n; i++) {
        x[i] = static_cast<float>(rand()) / (static_cast<float>(RAND_MAX / (2*r))) - r;
        y[i] = static_cast<float>(rand()) / (static_cast<float>(RAND_MAX / (2*r))) - r;
    }

    // float A[] = {9,8,6,4,3,2,0,8,3,4,5,6,7,1,2,0,9,8,7,6,5,4,3,2,1};
    // float B[] = {1,9,3,7,2,3,0,1,6,1,4,8,2,5,5,5,6,0,4,6,7,4,8,3,7};

    omp_set_num_threads(t);
    int ret;
    double time = 0.0;

    for (int iter = 0; iter < 13; iter++) {
        
        start = chrono::high_resolution_clock::now();
        ret = montecarlo(n, x, y, r);
        end = chrono::high_resolution_clock::now();
        duration_sec = chrono::duration_cast<chrono::duration<double, std::milli>>(end - start);
        if (iter >= 3)
            time += duration_sec.count();
    }
    
    // for (int i = 0; i < n; i++) {
    //     cout << x[i] << " ";
    // }
    // cout << endl;
    // for (int j = 0; j < n; j++)
    //  	cout << y[j] << " ";
    // cout << endl;

    cout << (4*(float)ret)/(float)n << endl;
    cout << time/10 << endl;

    delete[] x;
    delete[] y;

    return 0;
}
