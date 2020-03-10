#define CUB_STDERR // print CUDA runtime errors to console
#include <iostream>
#include <cub/util_allocator.cuh>
#include <cub/device/device_scan.cuh>
// #include "test/test_util.h"
using namespace cub;
CachingDeviceAllocator  g_allocator(true);  // Caching allocator for device memory

int main(int argc, char *argv[]) {
    long n = atol(argv[1]);

    cudaEvent_t start;
    cudaEvent_t stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Set up host arrays
    float* h_in;
    h_in = new float[n];
    for (long i = 0; i < n; i++) {
        h_in[i] = 1.0;
    }

    // Set up device arrays
    float* d_in = NULL;
    CubDebugExit(g_allocator.DeviceAllocate((void**)& d_in, sizeof(float) * n));
    
    // Initialize device input
    CubDebugExit(cudaMemcpy(d_in, h_in, sizeof(float) * n, cudaMemcpyHostToDevice));
    
    // Setup device output array
    float* d_out = NULL;
    CubDebugExit(g_allocator.DeviceAllocate((void**)& d_out, sizeof(float) * n));
    
    float init = 0.0;

    // Request and allocate temporary storage
    void* d_temp_storage = NULL;
    size_t temp_storage_bytes = 0;
    CubDebugExit(DeviceScan::ExclusiveScan(d_temp_storage, temp_storage_bytes, d_in, d_out, Sum(), init, n));
    CubDebugExit(g_allocator.DeviceAllocate(&d_temp_storage, temp_storage_bytes));

    // Do the actual reduce operation
    cudaEventRecord(start);
    CubDebugExit(DeviceScan::ExclusiveScan(d_temp_storage, temp_storage_bytes, d_in, d_out, Sum(), init, n));
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float ms;
    cudaEventElapsedTime(&ms, start, stop);
    
    float* h_out;
    h_out = new float[n];
    CubDebugExit(cudaMemcpy(h_out, d_out, sizeof(float) * n, cudaMemcpyDeviceToHost));
    
    // Check for correctness
    // printf("\t%s\n", (gpu_sum == sum ? "Test passed." : "Test falied."));
    // printf("\tSum is: %d\n", gpu_sum);
    
    //for (long i = 0; i < n; i++) {
    //	    std::cout << h_out[i] << " ";
    //}
    //std::cout << std::endl;

    std::cout << h_out[n-1] << std::endl;
    std::cout << ms << std::endl;

    // Cleanup
    if (d_in) CubDebugExit(g_allocator.DeviceFree(d_in));
    if (d_out) CubDebugExit(g_allocator.DeviceFree(d_out));
    if (d_temp_storage) CubDebugExit(g_allocator.DeviceFree(d_temp_storage));

    delete[] h_in;
    delete[] h_out;
    
    return 0;
}
    
