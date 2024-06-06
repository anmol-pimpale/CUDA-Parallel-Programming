//using manged memory function both CPU and GPU access the managed memory

#include<cuda_runtime.h>
#include "device_launch_parameters.h"
#include<stdio.h>

__global__ void printValue(int* data){
    int tid=threadIdx.x + blockIdx.x * blockDim.x;


    //access managed memory directlty from GPU
    printf("Gpu thread %d:value=%d\n",tid,data[tid]);

}

int main(){

    const int N=10;

    //allocate manages memory
    int* data;
    cudaMallocManaged(&data ,N * sizeof(int) );

    //initialise data on CPU
    for(int i=0;i<N;++i){
        data[i]= i *2;
    }
    
   // Start timing GPU execution
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    //launch GPU kernel  to print value
    printValue<<<1,N>>>(data);
    cudaDeviceSynchronize();

    // Stop timing GPU execution
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);


    //access managed memory directly from cpu
    for(int i=0;i<N;++i){
        printf("CPU : value =%d\n",data[i]);

    }

    printf("\nTime taken by GPU : %f milliseconds\n", milliseconds);


    //free  managed memoroy
    cudaFree(data );


    return 0;
}