#include <iostream>
#include "reduce.cuh"
using namespace std;

int main(int argc, char* argv[]) {
  int N = atoi(argv[1]);
  int tpb = atoi(argv[2]);

  cudaEvent_t start;
  cudaEvent_t stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  int* arr;
  arr = new int[N];
  for (int i = 0; i < N; i++) arr[i] = 1;

  cudaEventRecord(start);
  int res = reduce(arr, N, tpb);
  cudaEventRecord(stop);
  cudaEventSynchronize(stop);

  float ms;
  cudaEventElapsedTime(&ms, start, stop);

  // for (int i = 0; i < N; i++)
  //  	cout << out[i] << " ";
  // cout << endl;
  cout << res << endl;
  cout << ms << endl;

  free(arr);

  return 0;
}
