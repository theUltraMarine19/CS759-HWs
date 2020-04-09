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

    int my_rank;
    // int p;

    float *arr, res, global_res;
    arr = new float[n];

    // for (int i = 0; i < n; i++) {
    //     arr[i] = static_cast<float>(rand()) / (static_cast<float>(RAND_MAX / 100));
    // }

    omp_set_num_threads(t);
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank); // get the rank of the process
    // MPI_Comm_size(MPI_COMM_WORLD, &p);    // no. of processes = 2 (-np 2)

    double time = 0.0;
    
    if (my_rank == 0) {
        for (int i = 0; i < n; i++) {
            arr[i] = static_cast<float>(rand()) / (static_cast<float>(RAND_MAX / 10));
            // arr[i] = i;
            // cout << arr[i] << " ";
        }
        // cout << endl;
        for (int i = 0; i < 3; i++)
            res = reduce(arr, 0, n);        
    }

    if (my_rank == 1) {
        for (int i = 0; i < n; i++) {
            arr[i] = static_cast<float>(rand()) / (static_cast<float>(RAND_MAX / 10));
            // arr[i] = n-i;
            // cout << arr[i] << " ";  
        }
        // cout << endl;
        for (int i = 0; i < 3; i++)
            res = reduce(arr, 0, n);      
    }

    MPI_Barrier(MPI_COMM_WORLD);
    
    if (my_rank == 0) {
        start = chrono::high_resolution_clock::now();
        for (int i = 0; i < 10; i++) {
            res = reduce(arr, 0, n);
        }
        end = chrono::high_resolution_clock::now();
        duration_sec = chrono::duration_cast<chrono::duration<double, std::milli>>(end - start);
        time = duration_sec.count()/10.0;
        // cout << "Rank 0 " << res << endl;

        start = chrono::high_resolution_clock::now();
        MPI_Reduce(&res, &global_res, 1, MPI_FLOAT, MPI_SUM, 0, MPI_COMM_WORLD);
        end = chrono::high_resolution_clock::now();
        duration_sec = chrono::duration_cast<chrono::duration<double, std::milli>>(end - start);    
        
        cout << global_res << endl;
        cout << duration_sec.count() + time << endl;
    }
    else if (my_rank == 1) {
        res = reduce(arr, 0, n);
        // cout << "Rank 1 " << res << endl; 
        MPI_Reduce(&res, &global_res, 1, MPI_FLOAT, MPI_SUM, 0, MPI_COMM_WORLD);
    }
    
    MPI_Finalize();
        
    delete[] arr;

    return 0;
}
