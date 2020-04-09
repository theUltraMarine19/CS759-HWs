#include <iostream>
#include <cstdlib>

#include <chrono>
#include <ratio>

#include "optimize.h"
using namespace std;

int main(int argc, char* argv[]) {
    int n = atoi(argv[1]);

    chrono::high_resolution_clock::time_point start;
    chrono::high_resolution_clock::time_point end;
    chrono::duration<double, std::milli> duration_sec;

    struct vec v(n);
    v.data = new data_t[n];

    for (int i = 0; i < n; i++) {
        v.data[i] = rand() % 10 + 1;
    }

    data_t dest;

    double time = 0.0;

    for (int iter = 0; iter < 13; iter++) {
        
        start = chrono::high_resolution_clock::now();
        optimize1(&v, &dest);
        end = chrono::high_resolution_clock::now();
        duration_sec = chrono::duration_cast<chrono::duration<double, std::milli>>(end - start);
        if (iter >= 3)
            time += duration_sec.count();
    }

    cout << dest << endl;
    cout << time/10 << endl;
    dest = -1;
    time = 0.0;

    for (int iter = 0; iter < 13; iter++) {
        
        start = chrono::high_resolution_clock::now();
        optimize2(&v, &dest);
        end = chrono::high_resolution_clock::now();
        duration_sec = chrono::duration_cast<chrono::duration<double, std::milli>>(end - start);
        if (iter >= 3)
            time += duration_sec.count();
    }

    cout << dest << endl;
    cout << time/10 << endl;
    dest = -1;
    time = 0.0;

    for (int iter = 0; iter < 13; iter++) {
        
        start = chrono::high_resolution_clock::now();
        optimize3(&v, &dest);
        end = chrono::high_resolution_clock::now();
        duration_sec = chrono::duration_cast<chrono::duration<double, std::milli>>(end - start);
        if (iter >= 3)
            time += duration_sec.count();
    }

    cout << dest << endl;
    cout << time/10 << endl;
    dest = -1;
    time = 0.0;

    for (int iter = 0; iter < 13; iter++) {
        
        start = chrono::high_resolution_clock::now();
        optimize4(&v, &dest);
        end = chrono::high_resolution_clock::now();
        duration_sec = chrono::duration_cast<chrono::duration<double, std::milli>>(end - start);
        if (iter >= 3)
            time += duration_sec.count();
    }

    cout << dest << endl;
    cout << time/10 << endl;
    dest = -1;
    time = 0.0;

    for (int iter = 0; iter < 13; iter++) {
        
        start = chrono::high_resolution_clock::now();
        optimize5(&v, &dest);
        end = chrono::high_resolution_clock::now();
        duration_sec = chrono::duration_cast<chrono::duration<double, std::milli>>(end - start);
        if (iter >= 3)
            time += duration_sec.count();
    }

    cout << dest << endl;
    cout << time/10 << endl;

    // for (int i = 0; i < n; i++)
    //        cout << v.data[i] << " ";
    // cout << endl;    

    delete[] v.data;

    return 0;
}
