//second assignmet with two global function
#include <cuda.h>
#include <stdio.h>

__global__ void squareValues(int *a) {
int num=*a;
*a=num*num;

}

__global__ void doubleValues(int* data, int size) {
    // int threadPerBlock = 256;
    int i = blockIdx.x * blockDim.x + threadIdx.x;
   
    if (i < size) {

    int *num=data+i;
    squareValues<<< 1,1 >>>(num);
    cudaDeviceSynchronize();

    int doubleSquareValue=(*num)*2;
    printf(" %d * %d * 2 = %d\n",i,i,doubleSquareValue);
    }
}

int main() {
    int size = 10;
    int* data_host = new int[size];
    int* data_device;

    for (int i = 0; i < size; ++i) {
        data_host[i] = i;
    }

    cudaMalloc(&data_device, size * sizeof(int));
    cudaMemcpy(data_device, data_host, size * sizeof(int), cudaMemcpyHostToDevice);
    
    // Start timing GPU execution
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);
                 
    int threadPerBlock = 256;
    doubleValues << <(size + threadPerBlock - 1) / threadPerBlock, threadPerBlock >> >(data_device, size);

    cudaDeviceSynchronize();
    
     // Stop timing GPU execution
     cudaEventRecord(stop);
     cudaEventSynchronize(stop);
     float milliseconds = 0;
     cudaEventElapsedTime(&milliseconds, start, stop);
 
    cudaMemcpy(data_host, data_device, size * sizeof(int), cudaMemcpyDeviceToHost);

    // for (int i = 0; i < size; ++i) {
    //     // printf("data[%d]=%d\n", i, data_host[i]);
    // }
    printf("\nTime taken by GPU : %f milliseconds\n", milliseconds);
  
    cudaFree(data_device);
    delete[] data_host;

    return 0;
}

//OUTPUT: in above code with two global function code is execute but square of the value is not happend only double the value.