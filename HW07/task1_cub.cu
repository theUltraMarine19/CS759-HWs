#define CUB_STDERR // print CUDA runtime errors to console
#include <iostream>
#include <cub/util_allocator.cuh>
#include <cub/device/device_reduce.cuh>
// #include "test/test_util.h"
using namespace cub;
CachingDeviceAllocator  g_allocator(true);  // Caching allocator for device memory

int main(int argc, char *argv[]) {
    int n = atoi(argv[1]);

    cudaEvent_t start;
    cudaEvent_t stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Set up host arrays
    int h_in[n];
    for (int i = 0; i < n; i++) {
        h_in[i] = 1;
    }

    int  sum = 0;
    for (int i = 0; i < n; i++)
        sum += h_in[i];

    // Set up device arrays
    int* d_in = NULL;
    CubDebugExit(g_allocator.DeviceAllocate((void**)& d_in, sizeof(int) * n));
    
    // Initialize device input
    CubDebugExit(cudaMemcpy(d_in, h_in, sizeof(int) * n, cudaMemcpyHostToDevice));
    
    // Setup device output array
    int* d_sum = NULL;
    CubDebugExit(g_allocator.DeviceAllocate((void**)& d_sum, sizeof(int) * 1));
    
    // Request and allocate temporary storage
    void* d_temp_storage = NULL;
    size_t temp_storage_bytes = 0;
    CubDebugExit(DeviceReduce::Sum(d_temp_storage, temp_storage_bytes, d_in, d_sum, n));
    CubDebugExit(g_allocator.DeviceAllocate(&d_temp_storage, temp_storage_bytes));

    // Do the actual reduce operation
    cudaEventRecord(start);
    CubDebugExit(DeviceReduce::Sum(d_temp_storage, temp_storage_bytes, d_in, d_sum, n));
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float ms;
    cudaEventElapsedTime(&ms, start, stop);
    
    int gpu_sum;
    CubDebugExit(cudaMemcpy(&gpu_sum, d_sum, sizeof(int) * 1, cudaMemcpyDeviceToHost));
    
    // Check for correctness
    // printf("\t%s\n", (gpu_sum == sum ? "Test passed." : "Test falied."));
    // printf("\tSum is: %d\n", gpu_sum);

    std::cout << gpu_sum << std::endl;
    std::cout << ms << std::endl;

    // Cleanup
    if (d_in) CubDebugExit(g_allocator.DeviceFree(d_in));
    if (d_sum) CubDebugExit(g_allocator.DeviceFree(d_sum));
    if (d_temp_storage) CubDebugExit(g_allocator.DeviceFree(d_temp_storage));
    
    return 0;
}
    