#include<stdio.h>
#include<stdlib.h>
#include<cuda_runtime.h>

// Global function for CUDA
__global__ void vectorAddition_kernel(int* d_a, int* d_b, int* d_c, int N) {
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    if (tid < N) {
        d_c[tid] = d_a[tid] + d_b[tid];
    }
}

int main() {

    int N = 8;
    int* h_a, * h_b, * h_c;  // Host Variables
    int* d_a, * d_b, * d_c;  // Device Variables

    // Allocate memory for host variables
    h_a = (int*)malloc(N * sizeof(int));
    h_b = (int*)malloc(N * sizeof(int));
    h_c = (int*)malloc(N * sizeof(int));

    // Allocate memory for device variables
    cudaMalloc((void**)&d_a, N * sizeof(int));
    cudaMalloc((void**)&d_b, N * sizeof(int));
    cudaMalloc((void**)&d_c, N * sizeof(int));

    // Initialize host variables
    for (int i = 0; i < N; i++) {
        h_a[i] = 2;
        h_b[i] = 2;
        h_c[i] = 0;
    }

    // Copy host variables to device
    cudaMemcpy(d_a, h_a, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, N * sizeof(int), cudaMemcpyHostToDevice);

    // Launch the kernel function
    int blocksize = 1;
    int numThreads = 4; // Calculate the number of blocks
    vectorAddition_kernel<<<blocksize, numThreads>>>(d_a, d_b, d_c, N);

    // Copy result back to host
    cudaMemcpy(h_c, d_c, N * sizeof(int), cudaMemcpyDeviceToHost);

    // Display the result
    printf("Result: ");
    for (int i = 0; i < N; i++) {
        printf("%d ", h_c[i]);
    }
    printf("\n");

    // Free device and host memory
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    free(h_a);
    free(h_b);
    free(h_c);

    return 0;
}