__global__ void matmul_kernel(const float* A, const float* B, float* C, unsigned int n) {
	extern __shared__ float arr[];
	float *sA = &arr[0];
	float* sB = &arr[blockDim.x*blockDim.y];
	
	int bx = blockIdx.x;
	int by = blockIdx.y;

	int tx = threadIdx.x;
	int ty = threadIdx.y;

	int aBegin = n*blockDim.x*by;
	int aEnd = aBegin+n-1;

	int aStep = blockDim.x;

	int bBegin = blockDim.x * bx;

	int bStep = blockDim.x * n;

	float Cval = 0;
	for (int a = aBegin, b = bBegin; a <= aEnd; a+= aStep, b+= bStep) {
		int rowA = (a+n*ty + tx)/n;
		int colA = (a+n*ty + tx)%n;
		
		if (rowA < n && colA < n)
			sA[ty*blockDim.x + tx] = A[a+n*ty + tx];
		else
			sA[ty*blockDim.x + tx] = 0;

		int rowB = (b+n*ty+tx)/n;
		int colB = (b+n*ty+tx)%n;
		
		if (rowB < n && colB < n)
			sB[ty*blockDim.x + tx] = B[b+n*ty+tx];
		else
			sB[ty*blockDim.x + tx] = 0;

		__syncthreads();

		// safe because out-of-bounds entries are 0
		for (int k = 0; k < blockDim.x; k++) {
			Cval += sA[ty*blockDim.x + k] * sB[k*blockDim.x+tx];
		}

		__syncthreads();
	}

	int idx = n*blockDim.x*by + blockDim.x*bx;
	int rowC = (idx + n*ty+tx)/n;
	int colC = (idx + n*ty+tx)%n;
	if (rowC < n && colC < n)
		C[idx + n*ty+tx] = Cval;
}

__host__ void matmul(const float* A, const float* B, float* C, unsigned int n, unsigned int block_dim) {
	dim3 block(block_dim, block_dim);
	dim3 grid((n+block.x-1)/block.x, (n+block.y-1)/block.y);
	matmul_kernel<<<grid, block, 2*sizeof(float)*block_dim*block_dim>>>(A, B, C, n);
	cudaDeviceSynchronize();
}