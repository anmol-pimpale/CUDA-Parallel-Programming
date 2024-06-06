#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <chrono>
#include <iostream>

#define NUM_CLASSES 3

int main() {

    //read the csv file
    FILE *file = fopen("extracted.csv", "r");

    if (file == NULL) {
        fprintf(stderr, "Error opening file.\n");
        return 1;
    }
    printf("File opened successfully.\n");

    int numRecords = 0;

    // Count the number of records
    while (!feof(file)) {
        char buffer[265];
        if (fgets(buffer, sizeof(buffer), file) == NULL) break;
        numRecords++;
    }

    printf("Number of Records :%d\n", numRecords);

    // Allocate memory on CPU
    int *classArray = (int *) malloc(numRecords * sizeof(int));
    float *seatComfortArray = (float *) malloc(numRecords * sizeof(float));

    // Reset the file pointer to the beginning
    rewind(file);

    int i = 0;
    char line[256];
    while (fgets(line, sizeof(line), file) != NULL) {
        char *token = strtok(line, ",");
        if (strcmp(token, "Business") == 0) {
            classArray[i] = 0; // business class
        } else if (strcmp(token, "Economy") == 0) {
            classArray[i] = 1; // economy class
        } else if (strcmp(token, "Economy Plus") == 0) {
            classArray[i] = 2; // economy plus class
        }

        token = strtok(NULL, ",");
        seatComfortArray[i] = atof(token);
        i++;
    }

    fclose(file);

    // Allocate arrays for total and counts
    float totalSeatComfort[NUM_CLASSES] = {0.0, 0.0, 0.0};
    int classCounts[NUM_CLASSES] = {0, 0, 0};

    auto start_time = std::chrono::high_resolution_clock::now();

    // Calculate total seat comfort and counts for each class
    for (int i = 0; i < numRecords; i++) {
        int ClassIndex = classArray[i];
        float seatComfort = seatComfortArray[i];

        if (ClassIndex < NUM_CLASSES) {
            totalSeatComfort[ClassIndex] += seatComfort;
            classCounts[ClassIndex]++;
        }
    }

    auto end_time = std::chrono::high_resolution_clock::now();
    auto duration_ns = std::chrono::duration_cast<std::chrono::nanoseconds>(end_time - start_time).count();

    double seconds_cpu = duration_ns / 1000000000.0;

    std::cout << "Time taken by CPU: " << seconds_cpu << " second" << std::endl;

    // Calculate and display average seat comfort for each class
    printf("Total seat comfort:\n");
    printf("Business class:%.2f\n", totalSeatComfort[0]);
    printf("Economy class:%.2f\n", totalSeatComfort[1]);
    printf("Economy Plus class:%.2f\n", totalSeatComfort[2]);

    printf("Average seat comfort:\n");
    if (classCounts[0] > 0) {
        printf("Business class: %.2f\n", totalSeatComfort[0] / classCounts[0]);
    } else {
        printf("Business class: N/A\n");
    }

    if (classCounts[1] > 0) {
        printf("Economy class: %.2f\n", totalSeatComfort[1] / classCounts[1]);
    } else {
        printf("Economy class: N/A\n");
    }

    if (classCounts[2] > 0) {
        printf("Economy Plus class: %.2f\n", totalSeatComfort[2] / classCounts[2]);
    } else {
        printf("Economy Plus class: N/A\n");
    }

    // Free the allocated memory
    free(classArray);
    free(seatComfortArray);

    return 0;
}