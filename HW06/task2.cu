#include <iostream>
#include "scan.cuh"
using namespace std;

int main(int argc, char* argv[]) {
  long N = atol(argv[1]);
  // int tpb = atoi(argv[2]);
  int tpb = 1024;

  cudaEvent_t start;
  cudaEvent_t stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  float* arr;
  arr = new float[N];
  float* out;
  out = new float[N];
  for (long i = 0; i < N; i++) {
	  arr[i] = 1.0;
	  out[i] = 0.0;
  }

  cudaEventRecord(start);
  scan(arr, out, N, tpb);
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  float ms;
  cudaEventElapsedTime(&ms, start, stop);

  //for (int i = 0; i < N; i++)
  //  	cout << out[i] << " ";
  //cout << endl;

  cout << out[N - 1] << endl;
  cout << ms << endl;

  delete[] arr;
  delete[] out;

  return 0;
}
