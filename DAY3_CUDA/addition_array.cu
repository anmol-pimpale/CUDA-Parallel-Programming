#include<stdio.h>
#include<device_launch_parameters.h>
#include<cuda_runtime.h>
#define SIZE 90000

__global__ void add_array(int *c,const int*a,const int *b,int size){
    int i=blockIdx.x * blockDim.x + threadIdx.x;
    if (i<size){
        c[i]=a[i]+b[i];
    }
}

int main(){
    const int size = SIZE;
    int a[size];
    int b[size];
    int *d_c;

    // Initialize arrays a and b with some values
    for (int i = 0; i < size; i++) {
        a[i] = i;
        b[i] = i;
    }

    // Allocate memory on the device or GPU
    cudaMalloc((void**)&d_c,size * sizeof(int));

    // Copy array a and b to the device
    int *d_a,*d_b;
    cudaMalloc((void**)&d_a,size * sizeof(int));
    cudaMalloc((void**)&d_b,size * sizeof(int));

    cudaMemcpy(d_a ,a ,size * sizeof(int) , cudaMemcpyHostToDevice);
    cudaMemcpy(d_b ,b ,size * sizeof(int) , cudaMemcpyHostToDevice);

    // Calculate the number of blocks and threads per block
    int threadsPerBlock = 256;
    int blocks = (size + threadsPerBlock - 1) / threadsPerBlock;


    //tart timing GPU execution
    cudaEvent_t start,stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);
    cudaEventRecord(start);

    // Launch the kernel with the calculated number of blocks and threads per block
    add_array<<<blocks, threadsPerBlock>>>(d_c,d_a,d_b,size);
    cudaDeviceSynchronize();
  

    // stop timing gpu execution
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float miliseconds=0;
    cudaEventElapsedTime(&miliseconds,start,stop);


    // Copy the result back from the device
    int *c= (int*)malloc(size * sizeof(int));
    cudaMemcpy(c ,d_c ,size * sizeof(int) , cudaMemcpyDeviceToHost);

    // Print the result
    for(int i=0;i<size;i++){
        printf("%d :",c[i]);
    }
    printf("\n");

    //pritn time taken by GPU 
    printf("time taken by Gpu :%f miliseconds\n",miliseconds);

    // Calculate the sum of all elements in array c
    int sum = 0;
    for (int i = 0; i < size; i++) {
        sum += c[i];
    }
    printf("Sum of all elements: %d\n", sum);

    // Free memory
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    free(c);

    return 0;
}