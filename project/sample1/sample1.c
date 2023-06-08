#include <stdio.h>
#include <string.h>

void copyString(const char* original, char* copied) {
    printf("Original string address: %p\n", (void*)original);
    printf("Copied string address: %p\n", (void*)copied);

    memcpy(copied, original, strlen(original) + 1);
}

int main() {
    char original[] = "Hello, World!";
    char copied[20];

    copyString(original, copied);

    printf("Copied string: %s\n", copied);

    return 0;
}