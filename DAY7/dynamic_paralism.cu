#include <cuda.h>
#include <stdio.h>

__device__ int square(int a) {
    return a * a;
}

__global__ void doubleValues(int* data, int size) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < size) {
        int value = data[i];
        int squared_value = square(value);
        data[i] = squared_value * 2;
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

    int threadPerBlock = 256;
    doubleValues << <(size + threadPerBlock - 1) / threadPerBlock, threadPerBlock >> >(data_device, size);

    cudaDeviceSynchronize();
    cudaMemcpy(data_host, data_device, size * sizeof(int), cudaMemcpyDeviceToHost);

    for (int i = 0; i < size; ++i) {
        printf("data[%d]=%d\n", i, data_host[i]);
    }

    cudaFree(data_device);
    delete[] data_host;

    return 0;
}