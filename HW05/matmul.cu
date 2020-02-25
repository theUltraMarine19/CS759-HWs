#include <cstdio>
using namespace std;

__global__ void matmul_kernel(const float* A, const float* B, float* C,
                              unsigned int n) {
  extern __shared__ float arr[];
  float* sA = &arr[0];
  float* sB = &arr[blockDim.x * blockDim.y];

  int bx = blockIdx.x;
  int by = blockIdx.y;

  int tx = threadIdx.x;
  int ty = threadIdx.y;

  int aBegin = n * blockDim.x * by;
  int aEnd = aBegin + n - 1;

  int aStep = blockDim.x;

  int bBegin = blockDim.x * bx;

  int bStep = blockDim.x * n;

  float Cval = 0;
  for (int a = aBegin, b = bBegin, brow = 0; a <= aEnd;
       a += aStep, b += bStep, brow += blockDim.y) {
    int rowA = blockDim.y * by + ty;
    int colA = a + tx - blockDim.y * by * n;

    if (rowA < n && colA < n)
      sA[ty * blockDim.x + tx] = A[a + n * ty + tx];
    else
      sA[ty * blockDim.x + tx] = 0;

    int colB = blockDim.x * bx + tx;
    int rowB = brow + ty;

    if (rowB < n && colB < n)
      sB[ty * blockDim.x + tx] = B[b + n * ty + tx];
    else
      sB[ty * blockDim.x + tx] = 0;

    __syncthreads();

    // if (tx == 0 && ty == 0 && bx == 0 && by == 0) {
    // 	for (int i = 0; i < blockDim.y; i++) {
    // 		for (int j = 0; j < blockDim.x; j++) {
    // 			printf("%f ", sA[i*blockDim.x + j]);
    // 		}
    // 		printf("\n");
    // 	}
    // 	printf("---------\n");

    // 	for (int i = 0; i < blockDim.y; i++) {
    // 		for (int j = 0; j < blockDim.x; j++) {
    // 			printf("%f ", sB[i*blockDim.x + j]);
    // 		}
    // 		printf("\n");
    // 	}
    // }

    // safe because out-of-bounds entries are 0
    for (int k = 0; k < blockDim.x; k++) {
      Cval += sA[ty * blockDim.x + k] * sB[k * blockDim.x + tx];
    }

    // if (tx == 1 && ty == 1)
    // 	printf("%f\n", Cval);

    __syncthreads();
  }

  int idx = n * blockDim.x * by + blockDim.x * bx;
  int rowC = blockDim.y * by + ty;
  int colC = blockDim.x * bx + tx;
  if (rowC < n && colC < n) C[idx + n * ty + tx] = Cval;
}

__host__ void matmul(const float* A, const float* B, float* C, unsigned int n,
                     unsigned int block_dim) {
  dim3 block(block_dim, block_dim);
  dim3 grid((n + block.x - 1) / block.x, (n + block.y - 1) / block.y);
  matmul_kernel<<<grid, block, 2 * sizeof(float) * block_dim * block_dim>>>(
      A, B, C, n);
  cudaDeviceSynchronize();
}