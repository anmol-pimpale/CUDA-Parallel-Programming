#include<stdio.h>
#include<device_launch_parameters.h>
#include<cuda_runtime.h>

__global__ void printThreadInfo(){
    int threadID=blockIdx.x * blockDim.x + threadIdx.x;
    printf("ThraedIdx:%d,blockIdx:%d,blockDim.x:%d,Efective Thread ID:%d\n",threadIdx.x,blockIdx.x,blockDim.x,threadID);

}
int main(){
      int numBlocks=5;
      int threadsPerBlock=3;


      printThreadInfo<<<numBlocks,threadsPerBlock>>>();
      cudaDeviceSynchronize();
      return 0;

}