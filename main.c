#include<stdio.h>
#include<stdlib.h>

int  len(char str[]);
char* encrypt(char key1[], char key2[]);
char* decrypt(char key1[], char key2[]);
char* shiftd(char key[]);
char* shifte(char key[]);
char* cw1(int flag, char key1[], char key2[]);

char text[] = "crrjqtd";			//plain text

void main() {
	char key1[] = "lock";			//private key 1
	char key2[] = "key";			//private key 2
	cw1(1, key1, key2);
	
}

int len(char str[]) {
	return sizeof(str) / sizeof(char);
}

char* encrypt(char key1[], char key2[]) {
	int text_size = sizeof(text) / sizeof(char);		//get the length of text, key1, key 2
	int key1_size = sizeof(key1) / sizeof(char);
	int key2_size = len(key2);
	char* cipher;

	//encrypt all characters 1 by 1 with for loop with respect to the text length
	for (int i = 0; i < text_size - 1; i++) {
		// # all char can be treated as int/numbers, direct arithematic will be performed directly
		char* hcipher;
		char letter = text[i];		//get the letter at position i
		int j = i % key1_size;
		char key1_letter = key1[j];
		//encrypt text-key1+2 mod 26

		char cletter = letter - key1_letter;
		cletter = cletter + 2;
		//cletter = cletter % 26;
		//carry out mod operation (ensure result ranged from 1 to 26)
		while (cletter < 1 || cletter > 26) {
			if (cletter < 1) {
				cletter = cletter + 26;
			}
			else if (cletter > 26) {
				cletter = cletter - 26;
			}
		}

		printf("cipher letter: %c (%i)\n", cletter + 96, cletter);
		j++;
		//printf("%i\n", letter+1);
	}
	return 0;
}

char* decrypt(char key1[], char key2[]) {
	int text_size = sizeof(text) / sizeof(char);		//get the length of text, key1, key 2
	int key1_size = sizeof(key1) / sizeof(char);
	int key2_size = len(key2);
	char* htext = shiftd(key1);
	char* text  = shiftd(key2);
	/*
	//encrypt all characters 1 by 1 with for loop with respect to the text length
	for (int i = 0; i < text_size - 1; i++) {
		// # all char can be treated as int/numbers, direct arithematic will be performed directly
		
		char cletter = text[i]-96, letter;		//get the letter at position i
		int j = i % key1_size;
		char key1_letter = key1[j]-96;
		//encrypt text+key1-2 mod 26
		letter = cletter + key1_letter;
		letter = letter - 2;
		//cletter = cletter % 26;
		//carry out mod operation (ensure result ranged from 1 to 26)
		while (letter < 1 || letter > 26) {
			if (letter < 1) {
				letter = letter + 26;
			}
			else if (letter > 26) {
				letter = letter - 26;
			}
		}
		printf("%i  %i\n", cletter, key1_letter);

		
		printf("cipher letter: %c (%i)\n", letter + 96, letter);
		j++;
	}*/

	return text;
}

char* shiftd(char key[]) {
	int text_size = sizeof(text) / sizeof(char);		//get the length of text, key1
	int key_size = sizeof(key) / sizeof(char);
	//char* result[8];
	//encrypt all characters 1 by 1 with for loop with respect to the text length
	for (int i = 0; i < text_size - 1; i++) {
		// # all char can be treated as int/numbers, direct arithematic will be performed directly

		char cletter = text[i] - 96, letter;		//get the letter at position i
		int j = i % key_size;
		char key_letter = key[j] - 96;
		//encrypt text+key1-2 mod 26
		letter = cletter + key_letter;
		letter = letter - 2;
		//cletter = cletter % 26;
		//carry out mod operation (ensure result ranged from 1 to 26)
		while (letter < 1 || letter > 26) {
			if (letter < 1) {
				letter = letter + 26;
			}
			else if (letter > 26) {
				letter = letter - 26;
			}
		}
		text[i] = letter;
		j++;
	}
	return text;
}

char* cw1(int flag, char key1[], char key2[]) {
	if (flag) {
		printf("%s",decrypt(key1, key2));
	}
	else {
		encrypt(key1, key2);
	}
	return 0;
}