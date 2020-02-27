__global__ void reduce_kernel(const int* g_idata, int* g_odata,
                              unsigned int n) {
  extern __shared__ int arr[];
  long tid = threadIdx.x;
  long idx = (long)blockIdx.x * (long)blockDim.x + tid;
  if (idx < n)
    arr[tid] = g_idata[idx];
  else
    arr[tid] = 0;

  __syncthreads();

  for (long i = blockDim.x / 2; i > 0; i >>= 1) {
    if (tid < i) {
      if (tid + i < n)  // Not needed
        arr[tid] += arr[tid + i];
    }

    __syncthreads();
  }

  if (tid == 0) g_odata[blockIdx.x] = arr[0];
}

__host__ int reduce(const int* arr, unsigned int N,
                    unsigned int threads_per_block) {
  int num_blocks = (N + threads_per_block - 1) / threads_per_block;
  int *darr, *dout;
  cudaMalloc((void**)&darr, N * sizeof(int));
  cudaMalloc((void**)&dout, num_blocks * sizeof(int));

  // int* tmp = new int[num_blocks];
  int* tmp = new int[1];
  cudaMemcpy(darr, arr, N * sizeof(int), cudaMemcpyHostToDevice);

  while (num_blocks > 1) {
    reduce_kernel<<<num_blocks, threads_per_block,
                    sizeof(int) * threads_per_block>>>(darr, dout, N);
    cudaDeviceSynchronize();
    // cudaMemcpy(tmp, dout, num_blocks * sizeof(int), cudaMemcpyDeviceToHost);
    cudaMemcpy(darr, dout, num_blocks * sizeof(int), cudaMemcpyDeviceToDevice);
    N = num_blocks;
    num_blocks = (num_blocks + threads_per_block - 1) / threads_per_block;
    // cudaMemcpy(darr, tmp, N * sizeof(int), cudaMemcpyHostToDevice);
  }

  reduce_kernel<<<num_blocks, threads_per_block,
                  sizeof(int) * threads_per_block>>>(darr, dout, N);
  cudaDeviceSynchronize();
  cudaMemcpy(tmp, dout, num_blocks * sizeof(int), cudaMemcpyDeviceToHost);

  cudaFree(darr);
  cudaFree(dout);

  int ret = tmp[0];
  delete[] tmp;

  // return tmp[0];
  return ret;
}
