#include <cstdio>
#include "vadd.cuh"
#define THREADS_PER_BLOCK 512
using namespace std;

int main(int argc, char *argv[]) {
  int n = atoi(argv[1]);

  cudaEvent_t start;
  cudaEvent_t stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  float *ha, *hb;
  ha = new float[n];
  hb = new float[n];

  for (int i = 0; i < n; i++) {
    ha[i] = 1.0 * (i + 1);
    hb[i] = 1.0 * (i + 1);
  }

  float *da, *db;
  cudaMalloc((void **)&da, n * sizeof(float));
  cudaMalloc((void **)&db, n * sizeof(float));

  cudaMemcpy(da, ha, n * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(db, hb, n * sizeof(float), cudaMemcpyHostToDevice);

  int num_blocks = (n - 1) / THREADS_PER_BLOCK + 1;

  cudaEventRecord(start);
  vadd<<<num_blocks, THREADS_PER_BLOCK>>>(da, db, n);
  cudaDeviceSynchronize();
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  float ms;
  cudaEventElapsedTime(&ms, start, stop);

  printf("%f\n", ms / 1000.0);

  cudaMemcpy(hb, db, n * sizeof(float), cudaMemcpyDeviceToHost);

  printf("%f\n%f\n", hb[0], hb[n - 1]);

  free(ha);
  free(hb);
  cudaFree(da);
  cudaFree(db);

  return 0;
}
