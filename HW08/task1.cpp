#include <omp.h>
#include <iostream>

#include <chrono>
#include <ratio>

#include "matmul.h"
using namespace std;

int main(int argc, char* argv[]) {
  int n = atoi(argv[1]);
  int t = atoi(argv[2]);

  chrono::high_resolution_clock::time_point start;
  chrono::high_resolution_clock::time_point end;
  chrono::duration<double, std::milli> duration_sec;

  float *A, *B, *C;
  A = new float[n*n];
  B = new float[n*n];
  C = new float[n*n];

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      A[i*n+j] = 1.0; // row-major
      B[j*n+i] = 1.0; // column-major
      // A[i*n+j] = i*n+j+1;
      // B[j*n+i] = (n-i-1)*n + (n-j-1);
    }
  }

  // float A[] = {9,8,6,4,3,2,0,8,3,4,5,6,7,1,2,0,9,8,7,6,5,4,3,2,1};
  // float B[] = {1,9,3,7,2,3,0,1,6,1,4,8,2,5,5,5,6,0,4,6,7,4,8,3,7};

  omp_set_num_threads(t);
  start = chrono::high_resolution_clock::now();
  mmul(A, B, C, n);
  end = chrono::high_resolution_clock::now();

  duration_sec = chrono::duration_cast<chrono::duration<double, std::milli>>(end - start);

  // for (int i = 0; i < n; i++)
  //   for (int j = 0; j < n; j++)
  //  	  cout << C[i*n+j] << " ";
  // cout << endl;
  cout << C[0] << endl;
  cout << C[n*n-1] << endl;
  cout << duration_sec.count() << endl;

  delete[] A;
  delete[] B;
  delete[] C;

  return 0;
}
