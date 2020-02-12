#include <cstdio>
#define N 16
#define THREADS_PER_BLOCK 8
using namespace std;

__global__ void add(int *dA) {
  int idx = threadIdx.x + blockIdx.x * blockDim.x;
  dA[idx] = threadIdx.x + blockIdx.x;
}

int main() {
  int *dA;
  int size = N * sizeof(int);
  cudaMalloc((void **)&dA, size);

  int *hA;
  hA = new int[size];

  add<<<2, THREADS_PER_BLOCK>>>(dA);

  cudaMemcpy(hA, dA, size, cudaMemcpyDeviceToHost);

  for (int i = 0; i < N; i++)
    if (i == N - 1)
      printf("%d", hA[i]);
    else
      printf("%d ", hA[i]);

  free(hA);
  cudaFree(dA);
  return 0;
}
