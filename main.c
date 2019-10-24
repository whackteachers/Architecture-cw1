#include<stdio.h>
#include<stdlib.h>
#include <string.h>

int  len(char str[]);

char* cw1(int flag, char key1[], char key2[]);

char text[] = "touanwu";			//plain text

void main() {
    char key1[] = "lock";			//private key 1
    char key2[] = "key";			//private key 2
    cw1(1, key1, key2);

}

int len(char str[]) {
    return sizeof(str) / sizeof(char);
}

char* cw1(int flag, char key1[], char key2[]) {
    //Removes non alphabets from string
    int j,k;
    for(int i = 0; text[i] != '\0'; ++i)
    {
        while (!( (text[i] >= 'a' && text[i] <= 'z') || (text[i] >= 'A' && text[i] <= 'Z') || text[i] == '\0') )
        {
            for(j = i; text[j] != '\0'; ++j)
            {
                text[j] = text[j+1];
            }
            text[j] = '\0';
        }
    }
    //To lowercase.
    while (text[k] != '\0')
    {
        if (text[k] >= 'A' && text[k] <= 'Z') {
            text[k] = text[k] + 32;
        }
        k++;
    }
    int text_size = sizeof(text) / sizeof(char);		//get the length of text, key1, key 2
    int key1_size = sizeof(key1) / sizeof(char);
    int key2_size = sizeof(key2) / sizeof(char) - 1;
    //if (gcd(key1_size, key2_size)) {
    //	return "Key lengths are not co-prime.";
    //}
    char* str = (char*)calloc(text_size, sizeof(char));

    for (int i = 0; i < text_size - 1; i++) {
        // # all char can be treated as int/numbers, direct arithematic will be performed directly
        char str_letter;
        char letter = text[i] - 96;		//get the letter at position i
        printf("%i\n", letter);
        int j = i % key1_size;
        int k = i % key2_size;
        char key1_letter = key1[j] - 96;
        char key2_letter = key2[k] - 96;
        int n = key1_letter + key2_letter;
        n = n - 4;

        if (flag) {
            str_letter = letter + n;
        }
        else {
            str_letter = letter - n;
        }
        //cletter = cletter % 26;
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
        //printf("%i\n", letter+1);
    }
    return str;
}

int gcd(int a, int b) {
    if (a == 0)
        return b;
    return gcd(b % a, a);
}