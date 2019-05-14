#include <iostream>
#include <list>
using namespace std;

int * gen_linked_list_1(int N);
int* gen_linked_list_2(int N);
void wyllie_list_rank(int* S, int N);
struct node {
	node(int v, node* n) {
		value = v;
		next = n;
	}
	int value;
	node* next;
};

int main() {
	int N = 10;

	//get the array of values in list
	int* listptr = NULL;
	listptr=gen_linked_list_1(N);
	
	/*
	int* qq = NULL;
	qq = gen_linked_list_1(N);
	int i;
	printf("\nhere is the list\n");
	for (i = 0; i<N; i++)
		printf("%3d ", qq[i]);
	printf("\n");
	free(qq);
	qq = gen_linked_list_2(N);
	printf("\nhere is the new list\n");
	for (i = 0; i<N; i++)
		printf("%3d ", qq[i]);
	printf("\n");
	*/

	cout << "This is the given array representing list!" << endl;
	for (int i = 0; i < N; i++) {
		cout << listptr[i] << " ";
	}
	cout << endl;

	wyllie_list_rank(listptr, N);

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
		list[i] = i-1;

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



void wyllie_list_rank(int* S, int N) {
	//R -array to store ranks
	//length = N-1
	//set value to 1 everywhere except at the tails
	int* R;
	R = (int*)malloc((N-1) * sizeof(int));
	for (int i = 0; i < N; i++) {
		if (i != 0) {
			R[i] = 1;
		}
		else {
			R[i] = 0;
		}
	}

	for (int i = 0; i < N-1; i++) {
		while (!(S[i]==-1||S[S[i]]==-1)){
			R[i] += R[S[i]];
			S[i] = S[S[i]];
		}
	}

	//print result
	cout << "Here is the array of ranks:" << endl;
	for (int i = 0; i < N-1; i++) {
		cout << (N-2)-R[i] << " ";
	}
	cout << endl;

	return;
}