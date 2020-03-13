#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include "count.cuh"

#include <iostream>

int main(int argc, char *argv[]) {
	long n = atol(argv[1]);

	cudaEvent_t start;
  	cudaEvent_t stop;
  	cudaEventCreate(&start);
  	cudaEventCreate(&stop);

	thrust::host_vector<int> h_vec(n);
	// Empty output vectors
	thrust::host_vector<int> h_vals;
	thrust::host_vector<int> h_cnts;

	for (long i = 0; i < n; i++) {
		h_vec[i] = 1;
	}

	// int arr[] = {3,5,1,2,3,1};
	// h_vec = std::vector<int>(arr, arr+n);

	// for (int i = 0; i < n; i++)
	//  	std::cout << h_vec[i] << " ";
	// std::cout << std::endl;

	thrust::device_vector<int> d_vec(h_vec.size());
	thrust::copy(h_vec.begin(), h_vec.end(), d_vec.begin());
	// Empty device vectors
	thrust::device_vector<int> d_vals;
	thrust::device_vector<int> d_cnts;

	cudaEventRecord(start);
	count(d_vec, d_vals, d_cnts);
	cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float ms;
    cudaEventElapsedTime(&ms, start, stop);

    // Empty host vectors will resize automatically
    h_vals = d_vals;
    // thrust::copy(d_vals.begin(), d_vals.end(), h_vals.begin());
    h_cnts = d_cnts;
    // thrust::copy(d_cnts.begin(), d_cnts.end(), h_cnts.begin());

	// for (size_t i = 0; i < h_vals.size(); i++)
	//	std::cout << h_vals[i] << " ";
	// std::cout << std::endl;

	// for (size_t i = 0; i < h_cnts.size(); i++)
	// 	std::cout << h_cnts[i] << " ";
	// std::cout << std::endl;    

    std::cout << h_vals.back() << std::endl;
    std::cout << h_cnts.back() << std::endl;
    std::cout << ms << std::endl;

	return 0;
}
