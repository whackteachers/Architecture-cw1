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
@	int flag = argv[1] - 48;
@	char* key1 = argv[2];
@	char* key2 = argv[3];
@
@	key1_size = stringlegth(key1);
@	key2_size = stringlegth(key2);
@
@	if (gcd(key1_size, key2_size) != 1) {
@	    printf("Key lengths are not co-prime.\n");
@	    exit(0);
@	}
@
@	cipher(flag, key1, key2);
@
@	printf("\n");
@}
main:
        PUSH {r4-r11, lr}
	MOV r4, r1       	@store the r1 address to r4
        LDR r1, [r4, #4] 	@load the flag to r1
	LDRB r7, [r1]		@load the char from flag
        SUB r7, r7, #48		@turn it back to int value

	LDR r2, [r4, #8]  	@load key1 to r2 [r4, #8]
	MOV r8, r2		@save the address value to r8

   	MOV r0, r2		@get the length of key1
 	BL  stringlength
	MOV r10, r0		@ save the value to r10

	LDR r3, [r4, #12]	@load the third argument to r3
	MOV r9, r3		@save the address value to r9

	MOV r0, r3		@get the length of key2
	BL  stringlength
	MOV r11, r0		@save the value to r11


  	MOV r0, r10		@load the keys' length to gcd function
	MOV r1, r11
  	BL  gcd			@ get gcd
  	CMP r0, #1
  	BNE keys_not_coprime	@ go to print error message if key lengths aren't coprime

   	@LDR r1, [r4, #4]  	@load the flag to r1 [r4, #4]
	@LDRB r10, [r1]	  	@load the char from flag
	MOV r0, r7  		@load the flag 
	MOV r1, r8		@restore key1 to r2
	MOV r2, r9		@restore key2 to r3
	BL  cipher		@start ciphering the text
	B   exit

@ called to print error message only when the private keys length are not coprime
keys_not_coprime:
        LDR r0, =error          @load the error message string
        BL printf               @print it to console
@ mark the end of all processes
exit:
        LDR r0, =new_line       @make a newline when function ends
        BL printf
        POP {r4-r11, lr}        @restore all the registers
        BX lr   @ end of program


@ cipher function for both encrypt and decrypt
@ cipher algorithm: (x-n)mod26 for encryption
@		    (x+n)mod26 for decryption
@ where x = the letter of the text
@	n = letter of key1 + letter of key2 - 4
@void cipher(int flag, char* key1, char* key2){
@    for(char str_letter = getchar(); str_letter != -1; ){
@        if (str_letter == -1)
@	    break;
@
@        if (str_letter < 'A' &&  str_letter > 'Z') {
@	    str_letter = str_letter + 32;
@        }
@        if(str_letter >= 'a' && str_letter <= 'z') {
@
@
@        str_letter = str_letter - 96;
@        if (key1[j] == 0)
@	    j = 0;
@        if (key2[k] == 0)
@	    k = 0;
@        char key1_letter = key1[j] - 96;
@        char key2_letter = key2[k] - 96;
@        int n = key1_letter + key2_letter;
@        n = n - 4;
@
@        if (flag)
@            str_letter = letter + n;
@        else
@            str_letter = letter - n;
@
@        while (str_letter < 1 || str_letter > 26) {
@            if (str_letter < 1)
@                str_letter = str_letter + 26;
@            else if (str_letter > 26)
@	         str_letter = str_letter - 26;
@        }
@
@        str_letter = str_letter + 96;
@        putchar(str_letter);
@        j++;
@        k++;
@    }
@}
 @@@ r0: flag	(argument 1)
 @@@ r1: key1   (argument 2)
 @@@ r2: key2   (argument 3)
 @@@ r3: -
 @@@ r4: j (key1 counter)
 @@@ r5: k (key2 counter)
 @@@ r6: the char of key1
 @@@ r7: the char of key2
 @@@ r8: key1
 @@@ r9: key2
 @@@ r10: key1_size

cipher:
	PUSH {r4-r10, lr}
	MOV r10, r0		@save the flag to r10
	MOV r8, r1		@save key1 to r8
	MOV r9, r2		@save key2 to r9
	MOV r4, #0              @j = 0
        MOV r5, #0              @k = 0
	B isEOF			@go into the loop check

read_text:
	CMP r0, #65  		@is the char < A?
	BLT isEOF     		@continue if so(go to next char)
	CMP r0, #90  		@is the char > Z?
	ADDLT r0, r0 ,#32  	@change upper to lower case if < Z (and > A)
	BGT check_lower  	@check lower case letter if
	B continue  		@else go to output the char
check_lower:
	CMP r0, #97  		@is the char < a?
	BLT isEOF     		@continue if so(go to next char)
	CMP r0, #122  		@is the char > z?
	BGT isEOF  		@continue if so(go to next char)
continue:
	@@@ start ciphering after validation @@@

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

	@@@ cipher algorithm starts here @@@
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

isEOF:
	BL getchar              @getchar from STDIN
	CMP r0, #-1             @check if it's EOF
	BNE read_text           @if not go to next char

@return back to main after reaching null
	POP {r4-r10, lr}
	BX lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@ A function that takes a string and loop through all characters to count length
@ and return its stringlength
@ int stringlength(char* text){
@	int count = 0;
@ 	for(int i=0; text[i] != 0; i++)
@	    count++;
@	return count;
@ r0: text
@ r1: characther of text
@ r3: count 
stringlength:
	PUSH {lr}

	MOV r3, #0  	    	@count = 0;
	B check		    	@start by checking the loaded character
loop:
    	ADD r3, r3, #1 	    	@r1 <- r1 + 1 (add count)
	check:
    	LDRB r1, [r0], #1	@get the current char and increase loop index
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
@ r0: a
@ r1: b
gcd:
        PUSH {lr}
gcd_loop:
        CMP      r0, r1    	@check r0 to r1
        SUBGT    r0, r0, r1	@if r0 > r1 then r0 = r0 - r1
        SUBLE    r1, r1, r0	@else r1 = r1 - r0
        BNE      gcd_loop	@loop if r0 != r1
        POP {lr}
        BX lr @ return the gcd to main
