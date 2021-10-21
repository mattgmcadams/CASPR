#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <cstdlib>

int main() {

    srand(0);
	int sz = 4;
    int matrix_A[sz][sz], matrix_B[sz][sz], matrix_C[sz][sz];
    int i=0, j=0, k=0;
    int randA, randB;

    for (i=0; i<sz; i++) {
        for (int j=0; j<sz; j++) {
            //init matrix_A (assign rand vals)
			randA = (rand() % 2);
            matrix_A[i][j] = randA;
			//init matrix_B (assign rand vals)
			randB = (rand() % 2);
			matrix_B[i][j] = randB;
			//init matrix_C
			matrix_C[i][j] = 0;
        }
    }

    // print matrix_A
    printf("MATRIX A: \n");
    for (i=0; i<sz; i++) {
        printf("[ ");
        for (j=0; j<sz; j++) {
            if (j<sz-1) { printf("%d, ", matrix_A[i][j]); }
            else { printf("%d", matrix_A[i][j]); }
        }
        printf(" ]\n");
    }

    // print matrix_B
    printf("\nMATRIX B: \n");
    for (i=0; i<sz; i++) {
        printf("[ ");
        for (j=0; j<sz; j++) {
            if (j<sz-1) { printf("%d, ", matrix_B[i][j]); }
            else { printf("%d", matrix_B[i][j]); }
        }
        printf(" ]\n");
    }

	// multiply the matrices
    for(i = 0; i < sz; i++) {
        for(j = 0; j < sz; j++) {
            for(k = 0; k < sz; k++) {
                matrix_C[i][j] += matrix_A[i][k] * matrix_B[k][j];
            }
		}
	}
	printf("\n");

	// print matrix_C
    printf("\nMATRIX C: \n");
    for (i=0; i<sz; i++) {
        printf("[ ");
        for (j=0; j<sz; j++) {
            if (j<sz-1) { printf("%d, ", matrix_C[i][j]); }
            else { printf("%d", matrix_C[i][j]); }
        }
        printf(" ]\n");
    }
    

    return 0;
}