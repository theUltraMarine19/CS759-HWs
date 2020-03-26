#include <chrono>
#include <cstdlib>
#include <iostream>
#include <ratio>

#include <omp.h>
#include "msort.h"

using namespace std;

int main(int argc, char* argv[]) {
  if (argc != 4) {
    cout << "Incorrect no. of arguments\n";
    return 0;
  }

  size_t n = atoi(argv[1]);
  int t = atoi(argv[2]);
  int ts = atoi(argv[3]);

  int* arr = new int[n];
  for (size_t i = 0; i < n; i++) {
    arr[i] = rand();
  }

  // int arr[] = {6, 8, 3, 0, 2, 5, 1, 8, 2, 4, 9, 8, 8, 3, 1};

  chrono::high_resolution_clock::time_point start;
  chrono::high_resolution_clock::time_point end;
  chrono::duration<double, milli> duration_sec;

  omp_set_num_threads(t);
  start = chrono::high_resolution_clock::now();
  msort(arr, n, ts);
  end = chrono::high_resolution_clock::now();

  duration_sec = chrono::duration_cast<chrono::duration<double, milli>>(end - start);

  cout << arr[0] << "\n"
       << arr[n - 1] << "\n" 
       << duration_sec.count() << "\n";
       

  // for (size_t i = 0; i < n; i++)
  //   cout << arr[i] << " ";
  // cout << endl;

  delete[] arr;

  return 0;
}