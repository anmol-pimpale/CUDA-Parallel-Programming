#include<iostream>
#include<cstdint>
#include<chrono>

#define SIZE 90000

int main(){
    const int size = SIZE;
    int a[size];
    int b[size];
    int c[size];

    // Initialize arrays a and b with some values
    for (int i = 0; i < size; i++) {
        a[i] = i;
        b[i] = i;
    }

    // Start timing CPU execution
    auto  start_time = std::chrono::high_resolution_clock::now();

    // Perform the computation on the CPU
    for (int i = 0; i < size; i++) {
        c[i] = a[i] + b[i];
    }

    // Stop timing CPU execution
    auto end_time = std::chrono::high_resolution_clock::now();

    // Calculate the time taken by the CPU
    auto cpu_time = std::chrono::duration_cast<std::chrono::nanoseconds>(end_time - start_time).count();
    double miliseconds= cpu_time / 1000000.0;


    // Print the time taken by the CPU
    std::cout << "Time taken by CPU: " << miliseconds << " miliseconds " << std::endl;

    
    return 0;
}