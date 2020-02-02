#include "scan.h"
#include<cstdlib>
#include<iostream>
#include<chrono>
#include<ratio>

using namespace std;
// using cout;
// using chrono::high_resolution_clock;
// using chrono::duration;

int main(int argc, char *argv[]) {
	if (argc!= 2) {
		cout << "Incorrect no. of arguments\n";
		return 0;
	}
	size_t n = atoi(argv[1]);
	float* arr = new float[n];
	float* output = new float[n];
	for (size_t i = 0; i < n; i++)
		arr[i] = -1.0 + static_cast <float> (rand()) /( static_cast <float> (RAND_MAX/2.0));

	chrono::high_resolution_clock::time_point start;
    chrono::high_resolution_clock::time_point end;
	chrono::duration<double, milli> duration_sec;

	start = chrono::high_resolution_clock::now();
	Scan(arr, output, n);
	end = chrono::high_resolution_clock::now();

	duration_sec = chrono::duration_cast<chrono::duration<double, milli>>(end - start);

	cout << duration_sec.count() << "\n" << output[0] << "\n" << output[n-1] << "\n";
	return 0;

}