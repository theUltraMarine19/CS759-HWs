#include <omp.h>
#include <cstdlib>

using namespace std;

int montecarlo(const size_t n, const float *x, const float *y, const float radius) {
	int count = 0;
	#pragma omp parallel firstprivate(radius)
	{ 
		#pragma omp for simd reduction(+:count) 
		for (size_t i = 0; i < n; i++) {
			float x1 = x[i]*x[i];
			float x2 = y[i]*y[i];
			float d = x1 + x2;
			count += (int)(d < radius*radius); // simd doesn't vectorize with conditionals
			// if (d < radius*radius)
			// 	count++;
		}
	}
	return count;
}
