#include <device_launch_parameters.h>
#include <cuda_runtime.h>
#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>
#include <math.h>
#include <stdlib.h>

int * gen_linked_list_1(int N);
int* gen_linked_list_2(int N);

__global__ void ListRank
(int* List, int size)
{
	int block = (blockIdx.y*gridDim.x) + blockIdx.x;
	int index = block * blockDim.x + threadIdx.x;

	if (index<size) {
		while (1) {
			int node = LIST[index];
			if (node >> 32 == -1) return;
			__syncthreads();

			int mask = 0xFFFFFFFF;
			ing temp = 0;
			int next = LIST[node >> 32];

			if (node >> 32 == -1) return;

			temp = node & mask;
			temp += next & mask;
			temp += (next >> 32) << 32;

			__syncthreads();
			LIST[index] = temp;
		}
	}
}


int main() {

	int N = 10;
	mem_size_list = N * sizeof(int);

	//get the array of values in list
	int* listptr = NULL;
	listptr = gen_linked_list_1(N);

	//array to store rank
	int* rank = NULL;
	rank = (int*)malloc(N * sizeof(int));

	cudaMalloc(&d_list, mem_size_list);
	cudaMemcpy(d_list, listptr, mem_size_list, cudaMemcpyHostToDevice);

	//setup the execution configuration
	int dimGrid = 10;
	int dimBlock = 1000;

	// Allocate CUDA events that we'll use for timing
	cudaEvent_t start;
	cudaEventCreate(&start);

	cudaEvent_t stop;
	cudaEventCreate(&stop);

	// Record the start event
	cudaEventRecord(start, NULL);

	ListRank << <dimGrid, dimBlock >> > (d_list, N);

	// Record the stop event
	cudaEventRecord(stop, NULL);

	// Wait for the stop event to complete
	cudaEventSynchronize(stop);

	float msecTotal = 0.0f;
	cudaEventElapsedTime(&msecTotal, start, stop);

	// Compute and print the performance
	printf("Time= %.3f msec\n", msecTotal);

	//Read C from device
	cudaMemcpy(rank, d_list, mem_size_list, cudaMemcpyDeviceToHost);

	cudaFree(d_list);
	return 0;
}

int * gen_linked_list_1(int N)
{

	int * list = NULL;
	if (NULL != list)
	{
		free(list);
		list = NULL;
	}

	if (0 == N)
	{
		printf("N is 0, exit\n");
		exit(-1);
	}

	list = (int*)malloc(N * sizeof(int));
	if (NULL == list)
	{
		printf("Can not allocate memory for output array\n");
		exit(-1);
	}

	int i;
	for (i = 0; i<N; i++)
		list[i] = i - 1;

	return list;
}

int* gen_linked_list_2(int N)
{
	int * list;

	list = gen_linked_list_1(N);

	int p = N / 5;

	int i, temp;

	for (i = 0; i<N; i += 2)
	{
		temp = list[i];
		list[i] = list[(i + (i + p)) % N];
		list[(i + (i + p)) % N] = temp;
	}

	return list;
}