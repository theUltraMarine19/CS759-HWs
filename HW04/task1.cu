#include <iostream>
#include "matmul.cuh"
using namespace std;

int main(int argc, char* argv[]) {
	int n = atoi(argv[1]);
	int tpb = atoi(argv[2]);

	cudaEvent_t start;
	cudaEvent_t stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	float* a = new float[n*n];
	float* b = new float[n*n];

	for (int i = 0; i < n*n; i++) {
		a[i] = 1.0;
		b[i] = 1.0;
	}

	float* c = new float[n*n];

	float* dA, *dB, *dC;
	cudaMallocManaged((void **)&dA, n*n * sizeof(float));
  	cudaMallocManaged((void **)&dB, n*n * sizeof(float));
  	cudaMallocManaged((void **)&dC, n*n * sizeof(float));

  	cudaMemcpy(dA, a, n*n * sizeof(float), cudaMemcpyHostToDevice);
  	cudaMemcpy(dB, b, n*n * sizeof(float), cudaMemcpyHostToDevice);

  	cudaEventRecord(start);
  	matmul(dA, dB, dC, n, tpb);
  	cudaEventRecord(stop);
  	cudaEventSynchronize(stop);

  	cudaMemcpy(c, dC, n*n * sizeof(float), cudaMemcpyDeviceToHost);

  	float ms;
  	cudaEventElapsedTime(&ms, start, stop);
  	
  	cout << c[n*n-1] << endl;
  	cout << ms << endl;

  	cudaFree(dA);
  	cudaFree(dB);
  	cudaFree(dC);
  	free(a);
  	free(b);
  	free(c);
  	
  	return 0;

}