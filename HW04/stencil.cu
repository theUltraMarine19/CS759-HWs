#include <cstdio>
#include "stencil.cuh"
using namespace std;

__global__ void stencil_kernel(const float* image, const float* mask, float* output, unsigned int n, unsigned int R) {
	int tidx = threadIdx.x;
	int bidx = blockIdx.x;
	int block_size = blockDim.x;

	

	extern __shared__ float arr[];
	float* img = &arr[0]; // block_size + 2*R 
	float* msk = &arr[2*R + block_size]; 
	float* out = &arr[block_size + 4*R + 1]; // block_size

	// if (tidx == 1 && bidx == 0)
	// printf("Hello %d %d\n", bidx, tidx);

	long idx = tidx + block_size * bidx;
	int curr = tidx + R;


	img[curr] = image[idx];

	if (tidx < 2*R+1)
		msk[tidx] = mask[tidx];

	if (tidx < R) {
		if (idx >= R)
			img[curr-R] = image[idx-R];
		else
			img[curr-R] = 0;
		if (idx + block_size < n)
			img[curr + block_size] = image[idx + block_size];
		else
			img[curr + block_size] = 0;
	}

	__syncthreads();

	// if (tidx == 0 && bidx == 0) {
	// 	printf("------\n"); 
	// 	for (int i = 0; i < block_size; i++)
	// 		printf("%f ", img[i]);
	// 	printf("\n----------\n");
	// }

	out[tidx] = 0;
	for (int i = 0; i <= 2*R; i++) {
		// printf("%d ", i);
		// if (tidx == 1 && bidx == 0) {
		// 	printf("%f %f %f \n", img[curr+i-R], msk[i], out[tidx]);
		// }
		out[tidx] += img[curr+i-R] * msk[i];
	}

	__syncthreads();

	output[idx] = out[tidx];

}

__host__ void stencil(const float* image, const float* mask, float* output, unsigned int n, unsigned int R, unsigned int threads_per_block) {

	int num_blocks = (n+threads_per_block-1)/threads_per_block;
	stencil_kernel<<<num_blocks, threads_per_block, sizeof(float)*(threads_per_block + 2*R) + sizeof(float)*(2*R+1) + sizeof(float)*(threads_per_block)>>>(image, mask, output, n, R);
	cudaDeviceSynchronize();

}