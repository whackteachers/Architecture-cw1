#include<stdio.h>
#include<stdlib.h>
#include<string.h>

//Function for getting the GCD using Euclid's Algo
int gcd(int a, int b) {
    while (a != b) {
        if (a > b) {
            a = a - b;
        }
        else {
            b = b - a;
        }
    }
    return a;
}

char* cw1(int flag, char key1[], char key2[]);

char text[] = "Touanwu";			            //plain text

void main(){
    char key1[] = "lock";			            //private key 1
    char key2[] = "key";			            //private key 2
    printf("%s\n", cw1(1, key1, key2));
}

char* cw1(int flag, char key1[], char key2[]){
    //Removes non alphabets from string
    int j, k = 0;
    for (int i = 0; text[i] != '\0'; ++i){
        while (!((text[i] >= 'a' && text[i] <= 'z') || (text[i] >= 'A' && text[i] <= 'Z') || text[i] == '\0')){
            for (int j = i; text[j] != '\0'; ++j){
                text[j] = text[j + 1];
            }
            text[j] = '\0';
        }
    }
    //To lowercase.
    while (text[k] != '\0'){
        if (text[k] >= 'A' && text[k] <= 'Z'){
            text[k] = text[k] + 32;
        }
        k++;
    }

    //get the length of text, key1, key 2
    int text_size = strlen(text);
    int key1_size = strlen(key1);
    int key2_size = strlen(key2);

    //Print key sizes for testing
    //printf("%d %d %d", text_size, key1_size, key2_size);

    //Check if keys are co-prime using Euclid's Algo
    if (gcd(key1_size, key2_size) != 1) {
        return "Key lengths are not co-prime.";
    }

    //Allocating memory space for the output string
    char* str = (char*)calloc(text_size + 1, sizeof(char));

    for (int i = 0; i < text_size; i++) {
        // # all char can be treated as int/numbers, direct arithmetic is performed directly
        char str_letter;
        char letter = text[i] - 96;		        //get the letter at position i and convert it from ACSII to the 1-26 range
        int j = i % key1_size;
        int k = i % key2_size;
        char key1_letter = key1[j] - 96;
        char key2_letter = key2[k] - 96;
        int n = key1_letter + key2_letter;      //setting the amount to add/subtract to n
        n = n - 4;

        //Adding/subtracting based on encrypt/decrypt depending on flag input
        if (flag) {
            str_letter = letter + n;
        }
        else {
            str_letter = letter - n;
        }

        //str_letter = str_letter % 26;
        //removing use of modulo for Assembly implementation
        //carry out mod operation (ensure result ranged from 1 to 26)
        while (str_letter < 1 || str_letter > 26) {
            if (str_letter < 1) {
                str_letter = str_letter + 26;
            }
            else if (str_letter > 26) {
                str_letter = str_letter - 26;
            }
        }
        str[i] = str_letter + 96;
        printf("cipher letter: %c (%i)\n", str_letter + 96, str_letter);
        j++;
        k++;
    }
    return str;
}
