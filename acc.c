#include <stdio.h>

int main() {

    int acc = 0;

    for (int i=1; i<=10000; i++) {
        acc += i;
    }

    printf("0x%x\n", acc);
    printf("%d\n", acc);

    return 0;
}