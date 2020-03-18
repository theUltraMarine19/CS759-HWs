#include <cstdlib>
#include <cstring>
#include <omp.h>
using namespace std;

void ins_sort(int* arr, const size_t n) {
	for (size_t i = 0; i < n; i++) {
		int key = arr[i];
		int j = i-1;

		while (j >= 0 && arr[j] > key) {
			arr[j+1] = arr[j];
			j--;
		}
		arr[j+1] = key;
	}
}

void msort(int* arr, const size_t n, const size_t threshold) {
	if (n < threshold) {
		ins_sort(arr, n);
		return;
	}

	// post these tasks and other threads will take care of them
	#pragma omp task firstprivate(arr, n)
	msort(arr, n/2, threshold);

	#pragma omp task firstprivate(arr, n)
	msort(arr+n/2, (n+1)/2, threshold);

	#pragma omp taskwait
	// wait for both the halves to be invidiually sorted
	// Don't want other threads not executing tasks to wait so don't use barrier

	// Merge these halves
	int* temp = new int[n];
	size_t l = 0, r = n/2, idx = 0;
	while (l < n/2 && r < n) {
		if (arr[l] < arr[r]) {
			temp[idx] = arr[l];
			l++;
		}
		else {
			temp[idx] = arr[r];
			r++;
		}
		idx++;
	}
	while (l < n/2) {
		temp[idx] = arr[l];
		l++;
		idx++;
	}
	while (r < n) {
		temp[idx] = arr[r];
		r++;
		idx++;
	}
	memcpy(arr, temp, n*sizeof(int));
	delete[] temp;
}