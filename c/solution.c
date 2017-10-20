#include <stdio.h>

/* Debug levels
 * 0 = off
 * 1 = light, print important variables
 * 2 = medium, print intermediate variables
 * 3 = heavy, print everything: counters etc
 */
const int DEBUG = 0;

int denoms[6] = {2, 10, 20, 5, 2, 1};
//int denoms[7] = {1000, 2, 10, 20, 5, 2, 1}; // test array to check that alg works correctly when a coin doesn't fit the amount
int number_of_denoms = sizeof(denoms) / sizeof(int);

int findMinCoins(int amount) {
    int coins = 0;

    for (int i=0; i<number_of_denoms; i++) {
        int nr_fit_inside = amount / denoms[i];

        if (DEBUG > 1) printf("%d can fit %d coins of value %d\n", amount, nr_fit_inside, denoms[i]);

        if (nr_fit_inside) {
            coins += nr_fit_inside;

            amount = amount - (denoms[i] * nr_fit_inside);

            if (amount == 0) break;
        }
    }

    return coins;
}

void print_array(int* array, int size) {
    printf("-->\n");
    for (int i=0; i < size; i++) {
        printf("%d\n", array[i]);
    }
    printf("<--\n");
}

int main() {
    int amounts[7] = {46, 41, 20, 73, 91, 78, 1200000};
    int number_of_amounts = sizeof(amounts) / sizeof(int);

    if (DEBUG) {
        printf("Amounts:\n");
        print_array(amounts, number_of_amounts);
    }

    if (DEBUG) {
        printf("Original:\n");
        print_array(denoms, number_of_denoms);
    }

    for (int i=0; i < number_of_denoms; i++) {
        if (DEBUG > 2) printf("i==%d\n", i);

        // sorted from the bottom (ascending)
        int intermediate;
        for (int k=(i+1); k < number_of_denoms; k++) {
            if (DEBUG > 2) printf("k==%d\n", k);

            if (denoms[i] < denoms[k]) {
                if (DEBUG > 2) {
                    printf("OLD\ndenoms[%d] == %d\n", i, denoms[i]);
                    printf("denoms[%d] == %d\n", i+k, denoms[k]);
                }

                intermediate = denoms[k];
                denoms[k] = denoms[i];
                denoms[i] = intermediate;

                if (DEBUG > 2) {
                    printf("NEW\ndenoms[%d] == %d\n", i, denoms[i]);
                    printf("denoms[%d] == %d\n", k, denoms[k]);
                }
            }
        }
    }

    if (DEBUG) {
        printf("Sorted:\n");
        print_array(denoms, number_of_denoms);
    }

    for (int i=0; i < number_of_amounts; i++) {
//   for (int i=0; i == 0; i++) {
        printf("%d can be paid with %d coins\n",
                amounts[i], findMinCoins(amounts[i]) );
    }

    return 0;
}
