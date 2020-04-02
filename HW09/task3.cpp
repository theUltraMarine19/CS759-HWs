#include <iostream>
#include <cstdlib>
#include "mpi.h"

#include <chrono>
#include <ratio>

using namespace std;

int main(int argc, char* argv[]) {
	
	// size of the buffer from cmdline
	int n = atoi(argv[1]);
	chrono::high_resolution_clock::time_point start0;
    chrono::high_resolution_clock::time_point end0;
    chrono::duration<double, std::milli> duration_sec0;

    // chrono::high_resolution_clock::time_point start1;
    // chrono::high_resolution_clock::time_point end1;
    // chrono::duration<double, std::milli> duration_sec1;	

	int my_rank;
	// int p;
	MPI_Status  status;

	// Buffer messages
	float *msg1, *msg2;
	msg1 = new float[n];
	msg2 = new float[n];

	

	MPI_Init(&argc, &argv);
	MPI_Comm_rank(MPI_COMM_WORLD, &my_rank); // get the rank of the process
	// MPI_Comm_size(MPI_COMM_WORLD, &p); // no. of processes = 2 (-np 2)

	if (my_rank == 0) {
		
		for (int i = 0; i < n; i++) {
			msg1[i] = i;
		}
		
		// start timing t0
		start0 = chrono::high_resolution_clock::now();
		MPI_Send(msg1, n, MPI_FLOAT, 1, 0, MPI_COMM_WORLD);
		MPI_Recv(msg2, n, MPI_FLOAT, 1, 1, MPI_COMM_WORLD, &status);
		// end timing t0
		end0 = chrono::high_resolution_clock::now();

		duration_sec0 = chrono::duration_cast<chrono::duration<double, std::milli>>(end0 - start0);

		double val;
		MPI_Recv(&val, 1, MPI_DOUBLE, 1, 2, MPI_COMM_WORLD, &status);

		// cout << duration_sec0.count() + val << endl;

		cout << "Rank 0 " << duration_sec0.count() << endl;

		// cout << "Rank=0" << endl;
		// for (int i = 0; i < n; i++)
		// 	cout << msg2[i] << " ";
		// cout << endl;
	} 
	else if (my_rank == 1) {

		for (int i = 0; i < n; i++) {
			msg2[i] = n-i;
		}
		
		// start timing t1
		start0 = chrono::high_resolution_clock::now();
		MPI_Recv(msg1, n, MPI_FLOAT, 0, 0, MPI_COMM_WORLD, &status);
		MPI_Send(msg2, n, MPI_FLOAT, 0, 1, MPI_COMM_WORLD);
		// end timing t1
		end0 = chrono::high_resolution_clock::now();

		duration_sec0 = chrono::duration_cast<chrono::duration<double, std::milli>>(end0 - start0);
		double val = duration_sec0.count();

		MPI_Send(&val, 1, MPI_DOUBLE, 0, 2, MPI_COMM_WORLD);

		cout << "Rank 1 " << duration_sec0.count() << endl;

		// cout << "Rank=1" << endl;
		// for (int i = 0; i < n; i++)
		// 	cout << msg1[i] << " ";
		// cout << endl;
	}

	MPI_Finalize();
	// duration_sec0 = chrono::duration_cast<chrono::duration<double, std::milli>>(end0 - start0);
	// duration_sec1 = chrono::duration_cast<chrono::duration<double, std::milli>>(end1 - start1);

	// cout << duration_sec0.count() << " " << duration_sec1.count() << endl;

	delete[] msg1;
	delete[] msg2;

	return 0;
}