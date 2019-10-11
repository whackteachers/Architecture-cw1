#include<stdio.h>
#include<stdlib.h>

int  len(char str[]);
char* encrypt(char key1[], char key2[]);
char* decrypt(char key1[], char key2[]);
char* cw1(int flag, char key1[], char key2[]);

char text[] = "message";			//plain text

void main() {
	char key1[] = "lock";			//private key 1
	char key2[] = "key";			//private key 2
	cw1(0, key1, key2);
	
}

int len(char str[]) {
	return sizeof(str) / sizeof(char);
}

char* encrypt(char key1[], char key2[]) {
	int text_size = sizeof(text) / sizeof(char);		//get the length of text, key1, key 2
	int key1_size = sizeof(key1) / sizeof(char);
	int key2_size = sizeof(key2) / sizeof(char) - 1;
	char* cipher = (char*)calloc(text_size, sizeof(char));

	//encrypt all characters 1 by 1 with for loop with respect to the text length
	for (int i = 0; i < text_size - 1; i++) {
		// # all char can be treated as int/numbers, direct arithematic will be performed directly
		
		char letter = text[i] - 96;		//get the letter at position i
		printf("%i\n", letter);
		int j = i % key1_size;
		int k = i % key2_size;
		char key1_letter = key1[j] - 96;
		char key2_letter = key2[k] - 96;
		int n = key1_letter + key2_letter;
		printf("%i   %i\n", key1_letter, key2_letter);
		printf("%i\n", n);
		n = n - 4;
		char cletter = letter - n;
		//cletter = letter - key1_letter - key2_letter + 4;
		//encrypt text-key1+2 mod 26

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
		cipher[i] = cletter + 96;
		printf("cipher letter: %c (%i)\n", cletter + 96, cletter);
		j++;
		k++;
		//printf("%i\n", letter+1);
	}
	return cipher;
}

char* decrypt(char key1[], char key2[]) {
	int text_size = sizeof(text) / sizeof(char);		//get the length of text, key1, key 2
	int key1_size = sizeof(key1) / sizeof(char);
	int key2_size = sizeof(key2) / sizeof(char) - 1;
	char* t = (char*)calloc(text_size, sizeof(char));
	printf("%i  %i\n", key1_size, key2_size);
	
	//encrypt all characters 1 by 1 with for loop with respect to the text length
	for (int i = 0; i < text_size - 1; i++) {
		// # all char can be treated as int/numbers, direct arithematic will be performed directly
		
		char cletter = text[i]-96;		//get the letter at position i
		int j = i % key1_size;
		int k = i % key2_size;
		char key1_letter = key1[j]-96;
		char key2_letter = key2[k] - 96;
		int n = key1_letter + key2_letter;
		n = n - 4;
		//encrypt text+key1-2 mod 26
		char letter = cletter + n;

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
		//printf("%i  %i\n", cletter, key1_letter);
		t[i] = letter + 96;
		
		printf("cipher letter: %c (%i)\n", letter + 96, letter);
		j++;
		k++;
	}

	return t;
}

char* cw1(int flag, char key1[], char key2[]) {
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
