#include <thrust/device_vector.h>
#include <thrust/sort.h>
#include <thrust/inner_product.h>
#include <thrust/reduce.h>

void count(const thrust::device_vector<int>& d_in, thrust::device_vector<int>& values, thrust::device_vector<int>& counts) {
	thrust::device_vector<int> d_temp(d_in.begin(), d_in.end()); // copy of input array
	thrust::device_vector<int> d_cnts(d_in.size(), 1); // array of 1's for reduce_by_key

	// sort the input array copy in-place
	thrust::sort(d_temp.begin(), d_temp.end());

	// compute the size of counts/values (thrust::unique returns the end pointer and modifies the array in-place)
	int num_unique = thrust::inner_product(d_temp.begin(), d_temp.end()-1, d_temp.begin()+1, 0, thrust::plus<int>(), thrust::not_equal_to<int>()) + 1;
	
	// resize the corr. vectors
	values.resize(num_unique);
	counts.resize(num_unique);

	// reduce_by_key to populate counts, values. Have their size so don't care about their end pointers in return value
	thrust::reduce_by_key(d_temp.begin(), d_temp.end(), d_cnts.begin(), values.begin(), counts.begin(), thrust::equal_to<int>(), thrust::plus<int>());
	
}