#include <chrono>
#include <cstdlib>
#include <iostream>
#include <ratio>

#include <omp.h>
#include "convolution.h"

using namespace std;

int main(int argc, char* argv[]) {
  if (argc != 3) {
    cout << "Incorrect no. of arguments\n";
    return 0;
  }

  size_t n = atoi(argv[1]);
  int t = atoi(argv[2]);

  float* image = new float[n * n];
  float* output = new float[n * n];
  float* mask = new float[3 * 3];

  for (size_t i = 0; i < n * n; i++) {
    // image[i] = static_cast<float>(rand()) / (static_cast<float>(RAND_MAX / 50.0));
    image[i] = 1.0;
  }

  for (size_t i = 0; i < 3 * 3; i++) {
    // mask[i] = static_cast<float>(rand()) / (static_cast<float>(RAND_MAX / 10.0));
    mask[i] = 1.0;
  }

  // float image[n*n] = {1, 3, 4, 8, 6, 5, 2, 4, 3, 4, 6, 8, 1, 4, 5, 2};
  // float mask[3*3] = {0, 0, 1, 0, 1, 0, 1, 0, 0};

  chrono::high_resolution_clock::time_point start;
  chrono::high_resolution_clock::time_point end;
  chrono::duration<double, milli> duration_sec;

  omp_set_num_threads(t);
  start = chrono::high_resolution_clock::now();
  Convolve(image, output, n, mask, 3);
  end = chrono::high_resolution_clock::now();

  duration_sec = chrono::duration_cast<chrono::duration<double, milli>>(end - start);

  cout << output[0] << "\n"
       << output[n * n - 1] << "\n" 
       << duration_sec.count() << "\n";
       

  for (size_t i = 0; i < n*n; i++)
    cout << output[i] << " ";
  cout << endl;

  return 0;
}