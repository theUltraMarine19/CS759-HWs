__global__ void matmul_kernel(const float* A, const float* B, float* C, size_t n) {
	int idx = threadIdx.x + blockIdx.x * blockDim.x;
	if (idx < n*n) {
		C[idx] = 0;
		int row = idx/n;
		int col = idx%n;
		for (int k = 0; k < n; k++)
			C[idx] += A[row*n+k] * B[k*n+col];
	}
}

void matmul(const float* A, const float* B, float* C, size_t n, unsigned int threads_per_block) {
	int num_blocks = (n*n + threads_per_block - 1)/threads_per_block;

	matmul_kernel<<<num_blocks, threads_per_block>>>(A, B, C, n);
	cudaDeviceSynchronize();

}