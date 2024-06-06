#include<stdio.h>
#include<device_launch_parameters.h>
#include<cuda_runtime.h>

int main()
{
    const int arraySize = 5;

    //host(cpu) data
    float hostArray[arraySize] = {1.0, 2.0, 3.0, 4.0, 5.0};
    float resultArray[arraySize];

    // Device (gpu) data
    float* deviceArray;
    cudaMalloc((void**)&deviceArray, arraySize * sizeof(float));

    //copy data grom cpu to gpu 
    cudaMemcpy(deviceArray, hostArray, arraySize * sizeof(float) , cudaMemcpyHostToDevice);

    //copy data back from gpu to cpu for result display
    cudaMemcpy(resultArray ,deviceArray ,arraySize * sizeof(float) , cudaMemcpyDeviceToHost);

    //display result using printf
    printf(" Host Array : ");
    for (int i =0 ; i< arraySize ; ++i)
    {
        printf("%f", hostArray[i]);
    }
    printf("\n");
printf("Original Array array:");
    for (int i =0 ; i< arraySize ; ++i)
    {
        printf("%f", resultArray[i]);
    }
    
    printf("\n");

    // free allocate memory on gpu
    cudaFree(deviceArray);
    return 0;

}