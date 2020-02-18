#include <iostream>
#include "stencil.cuh"
using namespace std;

int main(int argc, char* argv[]) {
	long n = atol(argv[1]);
	int R = atoi(argv[2]);
	int tpb = atoi(argv[3]);
	
	// int dev;
	// cudaDeviceProp prop;
	// cudaGetDevice(&dev);
	// cudaGetDeviceProperties(&prop, dev);
	// cout << prop.sharedMemPerBlock << endl;
	
	cudaEvent_t start;
	cudaEvent_t stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	float* img, *out, *mask;
	img = new float[n];
	out = new float[n];
	mask = new float[2*R+1];

	for (long i = 0; i < n; i++) {
		// img[i] = i;
		img[i] = 1.0;
		// out[i] = 0.0;
	}

	for (int i = 0; i < 2*R+1; i++) {
		// mask[i] = i+1;
		mask[i] = 1.0;
	}

	float *dimg, *dout, *dmask;
	cudaMallocManaged((void **)&dimg, n * sizeof(float));
  	cudaMallocManaged((void **)&dout, n * sizeof(float));
  	cudaMallocManaged((void **)&dmask, (2*R+1) * sizeof(float));

  	cudaMemcpy(dimg, img, n * sizeof(float), cudaMemcpyHostToDevice);
  	cudaMemcpy(dmask, mask, (2*R+1) * sizeof(float), cudaMemcpyHostToDevice);

  	cudaEventRecord(start);
  	stencil(dimg, dmask, dout, n, R, tpb);
  	cudaEventRecord(stop);
  	cudaEventSynchronize(stop);

  	cudaMemcpy(out, dout, n * sizeof(float), cudaMemcpyDeviceToHost);

  	float ms;
  	cudaEventElapsedTime(&ms, start, stop);

  	// for (int i = 0; i < n; i++)
  	// 	cout << out[i] << " ";
  	// cout << endl;	
  	cout << out[n-1] << endl;
  	cout << ms << endl;

  	cudaFree(dimg);
  	cudaFree(dout);
  	cudaFree(dmask);
  	free(img);
  	free(out);
  	free(mask);
  	
  	return 0;
}
