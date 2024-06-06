#include <iostream>
#include <chrono>
#include <cmath>
#define size 90000

bool isPrime(int num) {
    if (num <= 1) return false;
    if (num == 2) return true;
    if (num % 2 == 0) return false;

    for (int i = 3; i <= sqrt(num); i += 2) {
        if (num % i == 0) {
            return false;
        }
    }

    return true;
}

int main() {
    const int a = 2;
    const int b = size;

    auto start_time = std::chrono::high_resolution_clock::now();

    // for (int i = a; i <= b; i++) {
    //     if (isPrime(i)) {
    //         std::cout << i << " is a prime number" << std::endl;
    //     }
    // }

    auto end_time = std::chrono::high_resolution_clock::now();

    auto duration_ns = std::chrono::duration_cast<std::chrono::nanoseconds>(end_time - start_time).count();
    double milliseconds = duration_ns / 1000000.0; // convert nanoseconds to milliseconds
    std::cout << "Time taken by CPU: " << milliseconds << " milliseconds" << std::endl;
    printf("\n");

    return 0;
}