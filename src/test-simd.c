#include <stdio.h>
#include <stdlib.h>
#include "rand0_1.h"

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: test-simd size\n");
        return 1;
    }

    int size;
    if (sscanf(argv[1], "%i\n", &size) != 1) {
        printf("Invalid size value: '%s'\n", argv[1]);
        return 1;
    }
    printf("size=%d\n", size);

    volatile double *a1;
    volatile double *r;
    a1 = malloc(size * 2 * sizeof(double));
    r = malloc(size * sizeof(double));

    // Initialize
    srand(1);
    for (int i = 0; i < size * 2; i++) {
        a1[i] = rand0_1();
    }

    // c = a * b;
    for (int i = 0; i < size; i += 2) {
        r[i] = a1[i] * a1[i+1];
    }

    // s += a * b;
    double sum = 0.0;
    for (int i = 0; i < size; i += 2) {
        sum += a1[i] * a1[i+1];
    }

    printf("sum = %f\n", sum);

    free((void*)a1);
    free((void*)r);

    return 0;
}
