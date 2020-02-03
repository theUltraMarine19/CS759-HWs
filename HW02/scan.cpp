#include "scan.h"
using namespace std;

void Scan(const float *arr, float *output, size_t n) {
  float sum = 0.0;
  for (size_t i = 0; i < n; i++) {
    *(output + i) = sum;
    sum += *(arr + i);
  }
}