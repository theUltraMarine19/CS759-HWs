#include <cstdlib>
#include <omp.h>

void mmul(const float* A, const float* B, float* C, const std::size_t n) {
	#pragma omp parallel for shared(A,B,C,n)
	// schedule(static) by default since balanced loops
	// collapse 2 nested loops into one since no data dependency among iteration counts - NO IMPROVEMENT
	// A, B, C are passed by reference so implicitly shared
	for (std::size_t i = 0; i < n; i++) {
		for (std::size_t j = 0; j < n; j++) {
			C[i*n+j] = 0.0;
			// innermost loop can't be collapsed with the others
			// no need of atomic/critical since only one thread is processing this
			for (std::size_t k = 0; k < n; k++) {
				C[i*n+j] += A[i*n+k] * B[j*n+k];
			}
		}
	}
}