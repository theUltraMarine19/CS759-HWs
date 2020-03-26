#include "convolution.h"
using namespace std;

void Convolve(const float *image, float *output, size_t n, const float *mask, size_t m) {
  #pragma omp parallel for collapse(2)
  // schedule(static) by default since balanced loops
  // merge nested loops into 1 (no data dependencies)
  for (size_t x = 0; x < n; x++) {
    for (size_t y = 0; y < n; y++) {
      output[x * n + y] = 0;
      // #pragma omp simd
      for (size_t i = 0; i < m; i++) {
        for (size_t j = 0; j < m; j++) {
          if ((x + i - (m - 1) / 2) < n && (y + j - (m - 1) / 2) < n)
            output[x * n + y] += mask[i * m + j] * image[(x + i - (m - 1) / 2) * n + (y + j - (m - 1) / 2)];
        }
      }
    }
  }
}