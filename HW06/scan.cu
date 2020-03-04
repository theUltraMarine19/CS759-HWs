#include <cstdio>
using namespace std;

__global__ void adder(float* arr, float* block_incrs, int n) {
  // int tid = threadIdx.x;
  int gtid = blockIdx.x * blockDim.x + threadIdx.x;

  float add_val = block_incrs[blockIdx.x];

  if (gtid < n) arr[gtid] += add_val;
}

__global__ void hillis_steele(float* g_idata, float* g_odata, int n,
                              float* block_sums) {
  // all memory writes to be serviced immediately
  extern volatile __shared__ float temp[];

  int tid = threadIdx.x;
  int gtid = blockIdx.x * blockDim.x + threadIdx.x;
  int block_size = blockDim.x;

  int pout = 0, pin = 1;
  float last_element;

  // load input into shared memory
  if (tid == 0 || gtid >= n)
    temp[tid] = 0;
  else
    temp[tid] = g_idata[gtid - 1];

  if (tid == block_size - 1)
    if (gtid < n)
      last_element = g_idata[gtid];
    else
      last_element = 0.0;

  // entire temp should've gotten populated
  __syncthreads();

  // if (gtid == 5) {
  // 	std::printf("global : %f===============\n", g_idata[gtid]);
  //    	std::printf("temp : %f===============\n", temp[tid]);
  // }

  for (int offset = 1; offset < block_size; offset *= 2) {
    pout = 1 - pout;  // swap double buffer indices
    pin = 1 - pout;

    if (tid >= offset)
      temp[pout * block_size + tid] =
          temp[pin * block_size + tid] + temp[pin * block_size + tid - offset];
    else
      temp[pout * block_size + tid] = temp[pin * block_size + tid];

    __syncthreads();  // I need this here before I start next iteration
  }

  if (gtid < n) g_odata[gtid] = temp[pout * block_size + tid];

  if (tid == block_size - 1)
    block_sums[blockIdx.x] = last_element + temp[pout * block_size + tid];
}

__host__ void scan(const float* in, float* out, unsigned int n,
                   unsigned int threads_per_block) {
  int num_blocks = (n + threads_per_block - 1) / threads_per_block;
  // printf("num blocks : %d\n", num_blocks);

  float *din, *dout, *block_sums, *block_incrs, *dummy;
  cudaMalloc((void**)&din, n * sizeof(float));
  cudaMalloc((void**)&dout, n * sizeof(float));
  cudaMallocManaged((void**)&block_sums, num_blocks * sizeof(float));
  cudaMallocManaged((void**)&block_incrs, num_blocks * sizeof(float));
  cudaMallocManaged((void**)&dummy, sizeof(float));

  cudaMemcpy(din, in, n * sizeof(float), cudaMemcpyHostToHost);

  // // Only applicable if threads_per_block is a power of 2
  // reduce_kernel<<<num_blocks, threads_per_block, sizeof(float) *
  // threads_per_block>>>(din, block_sums, n);

  hillis_steele<<<num_blocks, threads_per_block,
                  2 * threads_per_block * sizeof(float)>>>(din, dout, n,
                                                           block_sums);
  cudaDeviceSynchronize();

  // get the block increments (scan it once because of assumption)
  int new_num_blocks = (num_blocks + threads_per_block - 1) /
                       threads_per_block;  // will always be 1
  hillis_steele<<<new_num_blocks, threads_per_block,
                  2 * threads_per_block * sizeof(float)>>>(
      block_sums, block_incrs, num_blocks, dummy);
  cudaDeviceSynchronize();

  // for (int i = 0; i < num_blocks; i++)
  // 	printf("%f ", block_incrs[i]);
  // printf("\n");

  // add each block increment to each block
  adder<<<num_blocks, threads_per_block>>>(dout, block_incrs, n);
  cudaDeviceSynchronize();

  cudaMemcpy(out, dout, n * sizeof(float), cudaMemcpyDeviceToHost);

  cudaFree(din);
  cudaFree(dout);
  cudaFree(block_sums);
  cudaFree(block_incrs);
  cudaFree(dummy);
}