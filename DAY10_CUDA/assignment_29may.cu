#include <stdio.h>
#include <cuda_runtime.h>
#include<time.h>

__global__ void kernel2(float *A, int n) {
  int idx = blockDim.x * blockIdx.x + threadIdx.x;
  if (idx < n) {
    A[idx] = A[idx] * A[idx];
  }
}

__global__ void kernel1(float *A, float *B, int n) {
  int idx = blockDim.x * blockIdx.x + threadIdx.x;
  if (idx < n) {
    A[idx] = A[idx] + B[idx];
  }
  __syncthreads();
  kernel2<<<1,1>>>(A, n);
  // __syncthreads();
}

int main() {
  int n = 100000;
  float* A = (float*)malloc(n * sizeof(float));
  float* B = (float*)malloc(n * sizeof(float));

  float* dev_a;
  float* dev_b;

  cudaMalloc((void **)&dev_a, n * sizeof(float));
  cudaMalloc((void **)&dev_b, n * sizeof(float));

  // Initialize arrays A and B on the host (CPU)
  for (int i = 0; i < n; ++i) {
    A[i] = i * 0.1f;
    B[i] = i * 0.1f;
  }

  // Start timing
  clock_t start_time = clock();


  // Copy data from host to device
  cudaMemcpy(dev_a, A, n * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(dev_b, B, n * sizeof(float), cudaMemcpyHostToDevice);

  // Launch kernel 1: calculate element-wise sum (A+B) on device
  int blockSize = 256;
  int numBlocks = (n + blockSize - 1) / blockSize;
  kernel1<<<numBlocks, blockSize>>>(dev_a, dev_b, n);

  // Copy final result in A back to host
  cudaMemcpy(A, dev_a, n * sizeof(float), cudaMemcpyDeviceToHost);

   // Stop timing
   clock_t end_time = clock();
   double execution_time = (double)(end_time - start_time) / CLOCKS_PER_SEC;
 

  // Launch kernel 2: square each element of A on device
  // kernel2<<<numBlocks, blockSize>>>(dev_a, n);

  // // Copy final result in A back to host
  // cudaMemcpy(A, A, n * sizeof(float), cudaMemcpyDeviceToHost);

  // // Print final results (now accessible on the host)
  // printf("Square elements of (A+B):\n");
  // for (int i = 0; i < n; ++i) {
  //   printf("%f ", A[i]);
  // }
  // printf("\n");
  
  // Print execution time
  printf("Execution time: %f seconds\n", execution_time);


  free(A);
  free(B);
  cudaFree(dev_a);
  cudaFree(dev_b);

  return 0;
}