#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/reduce.h>
#include <thrust/functional.h>

#include <iostream>

int main(int argc, char *argv[]) {
	long n = atol(argv[1]);

	cudaEvent_t start;
  	cudaEvent_t stop;
  	cudaEventCreate(&start);
  	cudaEventCreate(&stop);

	thrust::host_vector<int> h_vec(n);
	for (long i = 0; i < n; i++) {
		h_vec[i] = 1;
	}

	thrust::device_vector<int> d_vec(h_vec.size());
	thrust::copy(h_vec.begin(), h_vec.end(), d_vec.begin());
	
	int init = 0;

	cudaEventRecord(start);
	int res = thrust::reduce(d_vec.begin(), d_vec.end(), init, thrust::plus<int>());
	cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float ms;
    cudaEventElapsedTime(&ms, start, stop);

    std::cout << res << std::endl;
    std::cout << ms << std::endl;

	return 0;
}