#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/scan.h>
#include <thrust/functional.h>

#include <iostream>

int main(int argc, char *argv[]) {
	int n = atoi(argv[1]);

	cudaEvent_t start;
  	cudaEvent_t stop;
  	cudaEventCreate(&start);
  	cudaEventCreate(&stop);

	thrust::host_vector<float> h_vec(n);
	for (int i = 0; i < n; i++) {
		h_vec[i] = 1.0;
	}

	thrust::device_vector<float> d_vec(h_vec.size());
	thrust::copy(h_vec.begin(), h_vec.end(), d_vec.begin());

	float init = 0.0;
	
	cudaEventRecord(start);
	thrust::exclusive_scan(d_vec.begin(), d_vec.end(), d_vec.begin(), init, thrust::plus<float>());
	cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float ms;
    cudaEventElapsedTime(&ms, start, stop);

    thrust::copy(d_vec.begin(), d_vec.end(), h_vec.begin());

    std::cout << h_vec[n-1] << std::endl;
    std::cout << ms << std::endl;

	return 0;
}