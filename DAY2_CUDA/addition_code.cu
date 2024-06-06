#include<stdio.h>
#include<device_launch_parameters.h>
#include<cuda_runtime.h>

__global__ void addInteger(int* a,int* b,int* result){
    *result = *a + *b;
    printf("In GPU ......sum is %d\n",*result);
}


int main(){
//Hoat variable
  int host_a=5;
  int host_b=7;
  int host_result=0;


  //device variable

  int* device_a,* device_b, * device_result;

  //allocate memory ont the device

  cudaMalloc((void**)&device_a,sizeof(int));
  cudaMalloc((void**)&device_b,sizeof(int));
  cudaMalloc((void**)&device_result,sizeof(int));

  //copy data from host to device
  cudaMemcpy(device_a,  &host_a ,sizeof(int) , cudaMemcpyHostToDevice);
  cudaMemcpy(device_b,  &host_b ,sizeof(int) , cudaMemcpyHostToDevice);

  //lauch the kernel with one block and one thraed
  addInteger <<<1,1024>>> (device_a,device_b,device_result);

  //copy the result from device to host
  cudaMemcpy(&host_result ,device_result ,sizeof(int) , cudaMemcpyDeviceToHost);

  //display the result
  printf("sum of %d and %d is %d\n",host_a,host_b,host_result);

  //free allocated memory
  cudaFree( device_a);
  cudaFree( device_b);
  cudaFree(device_result );

  return 0;
}


