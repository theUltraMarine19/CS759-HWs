#include <iostream>
#include "matmul.cuh"
using namespace std;

int main(int argc, char* argv[]) {
	int n = atoi(argv[1]);
	int block_dim = atoi(argv[2]);
	
	cudaEvent_t start;
	cudaEvent_t stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	float* A, *B, *C;
	cudaMallocManaged(&A, n * n * sizeof(float));
  	cudaMallocManaged(&B, n * n * sizeof(float));
  	cudaMallocManaged(&C, n * n * sizeof(float));

	for (long i = 0; i < n*n; i++) {
		A[i] = 1.0;
		B[i] = 1.0;
		C[i] = -1.0;
	}

  	cudaEventRecord(start);
  	matmul(A, B, C, n, block_dim);
  	cudaEventRecord(stop);
  	cudaEventSynchronize(stop);

  	float ms;
  	cudaEventElapsedTime(&ms, start, stop);

  	// for (int i = 0; i < n; i++)
  	// 	cout << out[i] << " ";
  	// cout << endl;	
  	cout << C[0] << endl;
  	cout << C[n*n-1] << endl;
  	cout << ms << endl;

  	cudaFree(A);
  	cudaFree(B);
  	cudaFree(C);
  	
  	return 0;
}
