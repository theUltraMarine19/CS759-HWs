#include <chrono>
#include <cstdlib>
#include<ctime>
#include <iostream>
#include <ratio>  
#include "matmul.h"

using namespace std;

int main(int argc, char* argv[]) {
  if (argc != 1) {
    cout << "Incorrect no. of arguments\n";
    return 0;
  }

  srand ( time(NULL) );

  size_t n = 1024;
  double* A = new double[n*n];
  double* B = new double[n*n];
  double* C = new double[n*n];
  
  for (size_t i = 0; i < n*n; i++)
    A[i] = static_cast<double>(rand()) / (static_cast<double>(RAND_MAX / 50.0));

  for (size_t i = 0; i < n*n; i++)
    B[i] = static_cast<double>(rand()) / (static_cast<double>(RAND_MAX / 10.0));

  cout << n << endl;

  
  chrono::high_resolution_clock::time_point start;
  chrono::high_resolution_clock::time_point end;
  chrono::duration<double, milli> duration_sec;

  start = chrono::high_resolution_clock::now();
  mmul1(A, B, C, n);
  end = chrono::high_resolution_clock::now();

  duration_sec = chrono::duration_cast<chrono::duration<double, milli>>(end - start);

  cout << duration_sec.count() << "\n"
       << C[n*n - 1] << "\n";

  // for (size_t i = 0; i < n*n; i++)
  //   cout << C[i] << " ";
  // cout << endl;



  start = chrono::high_resolution_clock::now();
  mmul2(A, B, C, n);
  end = chrono::high_resolution_clock::now();

  duration_sec = chrono::duration_cast<chrono::duration<double, milli>>(end - start);

  cout << duration_sec.count() << "\n"
       << C[n*n - 1] << "\n";

  // for (size_t i = 0; i < n*n; i++)
  //   cout << C[i] << " ";
  // cout << endl;


  for (size_t i = 0; i < n; i++) {
    for (size_t j = 0; j < i; j++) {
      float tmp = B[i*n+j];
      B[i*n+j] = B[j*n+i];
      B[j*n+i] = tmp;
    }
  }

  start = chrono::high_resolution_clock::now();
  mmul3(A, B, C, n);
  end = chrono::high_resolution_clock::now();

  duration_sec = chrono::duration_cast<chrono::duration<double, milli>>(end - start);

  cout << duration_sec.count() << "\n"
       << C[n*n - 1] << "\n";

  // for (size_t i = 0; i < n*n; i++)
  //   cout << C[i] << " ";
  // cout << endl;

  for (size_t i = 0; i < n; i++) {
    for (size_t j = 0; j < i; j++) {
      float tmp = B[i*n+j];
      B[i*n+j] = B[j*n+i];
      B[j*n+i] = tmp;
      tmp = A[i*n+j];
      A[i*n+j] = A[j*n+i];
      A[j*n+i] = tmp;
    }
  }


  start = chrono::high_resolution_clock::now();
  mmul4(A, B, C, n);
  end = chrono::high_resolution_clock::now();

  duration_sec = chrono::duration_cast<chrono::duration<double, milli>>(end - start);

  cout << duration_sec.count() << "\n"
       << C[n*n - 1] << "\n";

  // for (size_t i = 0; i < n*n; i++)
  //   cout << C[i] << " ";
  // cout << endl;
  
  return 0;
}
