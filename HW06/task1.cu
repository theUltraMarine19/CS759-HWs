#include <cublas_v2.h>
#include <iostream>
#include "mmul.h"
using namespace std;

int main(int argc, char* argv[]) {
  int n = atoi(argv[1]);
  int n_tests = atoi(argv[2]);

  cudaEvent_t start;
  cudaEvent_t stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cublasHandle_t handle;
  cublasCreate(&handle);

  float *A, *B, *C;
  cudaMallocManaged(&A, n * n * sizeof(float));
  cudaMallocManaged(&B, n * n * sizeof(float));
  cudaMallocManaged(&C, n * n * sizeof(float));

  // these are column-major
  for (long i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
    // B[i] = (i+1)*0.1;
    // A[i] = (n*n-i-1)*0.1;
      A[j*n+i] = i*n+j;
      B[j*n+i] = (n-i-1)*n + (n-j-1);
      C[j*n+i] = -1.0;
    }
  }

  cudaEventRecord(start);

  for (int i = 0; i < n_tests; i++) {
    // cublasSetMathMode(handle, CUBLAS TENSOR OP MATH);
    mmul(handle, A, B, C, n);
  }

  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  float ms;
  cudaEventElapsedTime(&ms, start, stop);

  for (int i = 0; i < n; i++)
    for (int j = 0; j < n; j++)
   	  cout << C[j*n+i] << " ";
  cout << endl;
  cout << ms / n_tests << endl;

  cudaFree(A);
  cudaFree(B);
  cudaFree(C);
  cublasDestroy(handle);

  return 0;
}
