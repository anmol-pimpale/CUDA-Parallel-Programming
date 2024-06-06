#include <stdio.h>
#include <stdlib.h>

#define N 2000

__global__ void add_matrix(int* d_C, int* d_A, int* d_B, int size) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int j = blockIdx.y * blockDim.y + threadIdx.y;

    if (i < size && j < size) {
        d_C[i * size + j] = d_A[i * size + j] + d_B[i * size + j];
    }
}

int main() {
    // Allocate memory for matrices A, B, C on host
    int** A = (int**)malloc(N * sizeof(int*));
    int** B = (int**)malloc(N * sizeof(int*));
    int** C = (int**)malloc(N * sizeof(int*));

    for (int i = 0; i < N; i++) {
        A[i] = (int*)malloc(N * sizeof(int));
        B[i] = (int*)malloc(N * sizeof(int));
        C[i] = (int*)malloc(N * sizeof(int));
    }

    // Initialize matrices A and B with random values
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i][j] = rand() % 10;
            B[i][j] = rand() % 10;
        }
    }

    // Allocate memory for matrices A, B, C on device
    int* d_A;
    int* d_B;
    int* d_C;
    cudaMalloc((void**)&d_A, N * N * sizeof(int)); //why we use N * N because integer size is 4 byte thats why provide N 8 N
    cudaMalloc((void**)&d_B, N * N * sizeof(int));
    cudaMalloc((void**)&d_C, N * N * sizeof(int));

    // Copy data from host to device
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            cudaMemcpy(&d_A[i * N + j], &A[i][j], sizeof(int), cudaMemcpyHostToDevice);
            cudaMemcpy(&d_B[i * N + j], &B[i][j], sizeof(int), cudaMemcpyHostToDevice);
        }
    }

    // Create events for timing
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Start timing GPU execution
    cudaEventRecord(start);

    // Launch the kernel with the calculated number of blocks and threads per block
    int blockSize = 16;
    int numBlocks = (N + blockSize - 1) / blockSize;
    dim3 threadsPerBlock(blockSize, blockSize);
    dim3 numBlocks2D(numBlocks, numBlocks);
    add_matrix<<<numBlocks2D, threadsPerBlock>>>(d_C, d_A, d_B, N);
    cudaDeviceSynchronize();

    // Stop timing GPU execution
    cudaEventRecord(stop);
    cudaEventSynchronize(stop);
    float miliseconds = 0;
    cudaEventElapsedTime(&miliseconds, start, stop);

    // Copy the result back from the device
    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            cudaMemcpy(&C[i][j], &d_C[i * N + j], sizeof(int), cudaMemcpyDeviceToHost);
        }
    }

    // // Print the result
    // for (int i = 0; i < N; i++) {
    //     for (int j = 0; j < N; j++) {
    //         printf("%d ", C[i][j]);
    //     }
    //     printf("\n");
    // }

    // Print time taken by GPU
    printf("Time taken by GPU: %f miliseconds\n", miliseconds);

    // Free memory
    for (int i = 0; i < N; i++) {
        free(A[i]);
        free(B[i]);
        free(C[i]);
    }
    free(A);
    free(B);
    free(C);
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    return 0;
}