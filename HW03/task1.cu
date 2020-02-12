#include<cstdio>
using namespace std;

__global__ void printThread(void) {
	printf("Hello World! I am thread %d", threadIdx.x);
}

int main() {
	printThread<<<1,4>>>();
	cudaDeviceSynchronize();
	return 0;
}