@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@file name: 	cw1
@description: 	ARMv7 assembly program that encrypt or decrypt text from STDIN
@		using simple add and subtract with 2 given private keys
@authors:	Hoi Ming Pong, Nigel Ng
@version:	1.0
@last updated:	01/11/2019
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
.data
.balign 4
new_line:  .asciz "\n"
testlen: .asciz "%d %d"
error: .asciz "Key lengths are not co-prime."
.text
.global main
.balign 4
@ main body of the program
@void main(int argc, char *argv[]){
@int flag = argv[1] - 48;
@char* key1 = argv[2];
@char* key2 = argv[3];
@
@key1_size = stringlegth(key1);
@key2_size = stringlegth(key2);
@
@if (gcd(key1_size, key2_size) != 1) {
@	printf("Key lengths are not co-prime.");
@	exit(0);
@}
@
@int j = 0;
@int k = 0;
@
main:
        PUSH {r4-r11, lr}
	MOV r4, r1       	@store the r1 address to r4
        LDR r1, [r4, #4] 	@load the flag to r1
	@LDRB r10, [r1]
        @SUB r10, r10, #48

	LDR r2, [r4, #8]  	@load key1 to r2 [r4, #8]
	MOV r8, r2		@save the address value to r8

   	MOV r0, r2		@get the length of key1
 	BL stringlength
	MOV r10, r0		@ save the value to r10

	LDR r3, [r4, #12]	@load the third argument to r3
	MOV r9, r3		@save the address value to r9

	MOV r0, r3		@get the length of key2
	BL stringlength
	MOV r11, r0		@save the value to r11


  	MOV r0, r10		@load the keys' length to gcd function
	MOV r1, r11
  	BL gcd			@ get gcd
  	CMP r0, #1
  	BNE keys_not_coprime	@ go to print error message if key lengths aren't coprime

   	LDR r1, [r4, #4]  	@load the flag to r1 [r4, #4]
	LDRB r10, [r1]	  	@load the char from flag
	SUB r10, r10, #48  	@turn it back to int value
	MOV r2, r8		@restore key1 to r2
	MOV r3, r9		@restore key2 to r3
   	MOV r4, #0		@j <- 0
   	MOV r5, #0		@k <- 0
@starts looking into the file
@ cipher algorithm: (x-n)mod26 for encryption
@		    (x+n)mod26 for decryption
@ where x = the letter of the text
@	n = letter of key1 + letter of key2 - 4
@for(char str_letter = getchar(); str_letter != -1; ){
@    if (str_letter == -1)
@	break;
@
@    if (str_letter < 'A' &&  str_letter > 'Z') {
@	str_letter = str_letter + 32;
@    }
@    if(str_letter >= 'a' && str_letter <= 'z') {
@
@
@    str_letter = str_letter - 96;
@    if (key1[j] == 0)
@	j = 0;
@    if (key2[k] == 0)
@	k = 0;
@    char key1_letter = key1[j] - 96;
@    char key2_letter = key2[k] - 96;
@    int n = key1_letter + key2_letter;
@    n = n - 4;
@
@    if (flag)
@        str_letter = letter + n;
@    else
@        str_letter = letter - n;
@
@    while (str_letter < 1 || str_letter > 26) {
@        if (str_letter < 1)
@            str_letter = str_letter + 26;
@        else if (str_letter > 26)
@	     str_letter = str_letter - 26;
@    }
@
@    str_letter = str_letter + 96;
@    putchar(str_letter);
@    j++;
@    k++;
@}
read_text:
  	BL getchar   		@getchar from STDIN
	CMP r0, #-1  		@check if it's EOF
	BEQ exit     		@exit the function if so

	CMP r0, #65  		@is the char < A?
	BLT read_text     	@continue if so(go to next char)
	CMP r0, #90  		@is the char > Z?
	ADDLT r0, r0 ,#32  	@change upper to lower case if < Z (and > A)
	BGT check_lower  	@check lower case letter if
	B continue  		@else go to output the char
check_lower:
	CMP r0, #97  		@is the char < a?
	BLT read_text     	@continue if so(go to next char)
	CMP r0, #122  		@is the char > z?
	BGT read_text  		@continue if so(go to next char)
continue:
	@@@ start @@@

 @@@ r0: message char (text[i] where i is the index)
 @@@ r1: flag
 @@@ r8: key1
 @@@ r9: key2
 @@@ r4: j (key1 counter)
 @@@ r5: k (key2 counter)
 @@@ r6: the char of key1
 @@@ r7: the char of key2
 @@@ r10: key1_size
 @@@ r11: key2_size

        SUB r0, r0, #96         @r0 = r0 - 96 translate to logical letter value

	LDRB r6, [r8, r4]	@r2 = key1[j]	get char from text depending on j
 	CMP r6, #0		@if(r4 == key1_size)
	MOVEQ r4, #0		@r4 = 0 reset j back to start
	LDREQB r6, [r8]		@r6 = key1[0] load char again

  	SUB r6, r6, #96		@r6 = r6 - 96 translate to logical letter value

	LDRB r7, [r9, r5]	@r7 = s2[k]  get char from text depending on k
	CMP r7, #0              @if(r5 == key2_size)
        MOVEQ r5, #0            @r5 = 0 reset k back to start
        LDREQB r7, [r9]         @r7 = s2[0] load char again

	SUB r7, r7, #96		@r7 = r7 - 96 translate to logical letter value

	@@@ calculation starts here @@@
	ADD r6, r6, r7		@r6 = s1[j] + s2[k] (n = key1_letter + key2_letter)
	SUB r6, r6, #4		@r6 = r6 - 4        (n = n-4)

	@@@ here will branch base on the flag to carry out encryption or decryption
	CMP r10, #1        	@if(flag)
	ADDEQ r0, r0, r6	@r0 = r0 + r6 (str_letter + n) (decryption)add value from the above from the original text
	SUBNE r0, r0, r6	@r0 = r0 - r6 (str_letter - n)(encryption)minus value from the above from the original text

@loop to ensure the final result value bound between 1 to 26
bound1to26:
	@ keep adding 26 until larger than 1
	CMP r0, #1
	ADDLT r0, r0, #26
	CMP r0, #1
	BLT bound1to26
	@ keep subtracting 26 until smaller than 26
	CMP r0, #26
	SUBGT r0, r0 , #26
	CMP r0, #26
	BGT bound1to26

	@prepare for output
	ADD r0, r0, #96		@r0 <- r0 + 96 translate the result letter value back to ascii value

	BL putchar  		@print letter
 @@@Incrementing the key counters
  	ADD r4, r4, #1  @j++
 	ADD r5, r5, #1  @k++

	B read_text  		@go to next char

@ called to print error message only when the private keys length are not coprime
keys_not_coprime:
  	MOV r1, r0
  	LDR r0, =error		@load the error message string
  	BL printf		@print it to console
@ mark the end of all processes
exit:
	LDR r0, =new_line  	@make a newline when function ends
	BL printf
        POP {r4-r11, lr}	@restore all the registers
	BX lr	@ end of program

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@ A function that takes a string and loop through all characters to count length
@ and return its stringlength
@ int stringlength(char* text){
@	int count = 0;
@ 	for(int i=0; text[i] != 0; i++)
@	    count++;
@	return count;

stringlength:
	PUSH {lr}

	LDRB r1, [r0]	    	@loads first character of the string into r1
	MOV r3, #0  	    	@load the stringlength address into r3
	B check		    	@start by checking the loaded character
loop:
    	ADD r3, r3, #1 	    	@r1 <- r1 + 1 (add count)
    	LDRB r1, [r0], #1	@get the current char and increase loop index
    	check:
    	CMP r1, #0	    	@check if it's on null character
    	BNE loop	    	@start the loop

@ break loop when null character is reached
@ and put the count to r0 for return
	MOV r0, r3

	POP {lr}
	BX lr @ return string length (in r0) to main
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@ function takes in 2 integers and get the greatest common divisor(GCD) of them through repeating cross subtraction
@int gcd(int x, int y)
@	while (a != b) {
@	    if (a > b){
@	        a = a - b;
@	    }
@	    else{
@	        b = b - a;
@	    }
@	}
@	return a;
@}
gcd:
        PUSH {lr}
gcd_loop:
        CMP      r0, r1    	@check r0 to r1
        SUBGT    r0, r0, r1	@if r0 > r1 then r0 = r0 - r1
        SUBLE    r1, r1, r0	@else r1 = r1 - r0
        BNE      gcd_loop	@loop if r0 != r1
        POP {lr}
        BX lr @ return the gcd to main
