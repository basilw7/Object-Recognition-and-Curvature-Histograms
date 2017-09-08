#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 100001L

void isort(int a[]){
clock_t start, finish;
double duration;
int data[N];
long i;

srand(time(NULL));
for(i=1;i<=N-1;i++)
data[i] = rand();

printf("start of sort\n");
//Measure the duration of an event
start = clock();
/*timed operation*/
/*++++++++++++++++*/
isort(data);
/*++++++++++++++++*/
finish = clock();

printf("end of sort %4i ",data[1]);
printf("\n");
duration = (double)(finish - start)/ CLOCKS_PRE_SEC;
printf("Timetor sort %ld numbers is ", N-1);
printf("%8.4f seconds\n", duration);
}

