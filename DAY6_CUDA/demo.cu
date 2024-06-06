#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include<stdio.h>
int main(){
    int deviceCount;
    cudaGetDeviceCount( &deviceCount);
    if(deviceCount==0){
        printf("NO CUDA DEVICE FOUND.\n");
        return 1;

    }
    for(int device=0;device<deviceCount;++device){
        cudaDeviceProp deviceProp;
        cudaGetDeviceProperties( &deviceProp,device );

        printf("device %d :%s\n",device,deviceProp.name);
        printf("compute compatibility:%d.%d\n",deviceProp.major,deviceProp.minor);
        printf("total global meory:%lu bytes\n",(unsigned long)deviceProp.sharedMemPerBlock);
        printf("warp size:%d\n",deviceProp.warpSize);
        printf("max threads per block :%d\n",deviceProp.maxThreadsPerBlock);
        printf("max threads dimenstion:(%d %d %d)\n",deviceProp.maxThreadsDim[0],deviceProp.maxThreadsDim[1],deviceProp.maxThreadsDim[2]);
        printf("max grid size:(%d %d %d)\n",deviceProp.maxGridSize[0],deviceProp.maxGridSize[1],deviceProp.maxGridSize[2]);
        printf("clock rate:%d kHz\n",deviceProp.clockRate);
        printf("memory clock rate:%d kHz\n",deviceProp.memoryClockRate);
        printf("memory bus width:%d bits\n",deviceProp.memoryBusWidth);
        printf("L2 cache size:%d bytes\n",deviceProp.l2CacheSize);
        printf("constant memory size:%lu bytes\n",(unsigned long)deviceProp.totalConstMem);
        printf("texture aligment:%lu bytes\n",(unsigned long)deviceProp.textureAlignment);
        printf("\n");

    }
    return 0;
}
