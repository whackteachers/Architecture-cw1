#include<stdio.h>
#include<stdlib.h>
#include<string.h>

//int len(char str[]);
int gcd(int a, int b);
int mod(int x, int y);
char* cw1(int flag, char key1[], char key2[]);

char text[] = "message";			//plain text Touanwu

void main() {
	char key1[] = "lock";			//private key 1
	char key2[] = "key";			//private key 2

	printf("%s\n", cw1(0, key1, key2));
}

//int len(char str[]) {
//	return sizeof(str) / sizeof(char);
//}

char* cw1(int flag, char key1[], char key2[]) {
	//Removes non alphabets from string
	int i = 0;
	int j = i, k = i;
	//for (int i = 0; text[i] != '\0'; ++i)
	//{
	//	while (!((text[i] >= 'a' && text[i] <= 'z') || (text[i] >= 'A' && text[i] <= 'Z') || text[i] == '\0'))
	//	{
	//		for (j = i; text[j] != '\0'; ++j)
	//		{
	//			text[j] = text[j + 1];
	//		}
	//		text[j] = '\0';
	//	}
	//}
	////To lowercase.
	//while (text[k] != '\0')
	//{
	//	if (text[k] >= 'A' && text[k] <= 'Z') {
	//		text[k] = text[k] + 32;
	//	}
	//	k++;
	//}

	//get the length of text, key1, key 2
	int text_size = strlen(text);
	int key1_size = strlen(key1);
	int key2_size = strlen(key2);

	//printf("%d %d %d", text_size, key1_size, key2_size);
	if (gcd(key1_size, key2_size) != 1) {
		return "Key lengths are not co-prime.";
	}
	char* str = (char*)calloc(text_size+1, sizeof(char));

	for (int i = 0; i < text_size ; i++) {
		// # all char can be treated as int/numbers, direct arithematic will be performed directly
		char str_letter;
		char letter = text[i] - 96;		//get the letter at position i
		if (key1[j] == 0)
			j = 0;
		if (key2[k] == 0)
			k = 0;
		//int j = mod(i, key1_size);
		//int k = mod(i, key2_size);
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
		//str_letter = str_letter % 26;
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

int gcd(int a, int b){

	while (a != b){
		if (a > b){
			a = a - b;
		}
		else{
			b = b - a;
		}
	}
	return a;
}
