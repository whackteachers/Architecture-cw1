.data
.balign 4
text: .asciz "message"
string: .asciz "Argv: %s %s %s\n"
arg1: .word 1
arg2: .asciz "lock"
arg3: .asciz "key"
prompt: .asciz "Enter:"
input:  .asciz "\n"
char:	.byte 0
testlen: .asciz "%d %d"
number: .asciz "%d\n"
error: .asciz "Key lengths are not co-prime."
.text
.global main
.balign 4
main:
        PUSH {r4-r11, lr}
	LDR r0, =string		@load the scanf output string
	MOV r4, r1       	@store the r1 address to r4 
        LDR r1, [r4, #4] 	@load the first argument to r1

	LDR r2, [r4, #8]  	@load the second argument to r2 [r4, #8]
	MOV r8, r2
   	MOV r0, r2
 	BL stringlength
	MOV r10, r0
	LDR r0, =string

	LDR r3, [r4, #12]	@load the third argument to r3
	MOV r9, r3
	MOV r0, r3
	BL stringlength
	MOV r11, r0
	LDR r0, =string
@@@ for tessting @@@
	@LDR r1, [r4, #4]        @load the first argument to r1
        @LDR r2, [r4, #8]        @load the second argument to r2 [r4, #8]
	@LDR r3, [r4, #12]
        @BL printf    		@print all arguments

	@LDR r0, =testlen
	@MOV r1, r11
	@MOV r2, r10
	@BL printf

  	MOV r0, r10
	MOV r1, r11
  	BL gcd
  	CMP r0, #1
  @LDRNE r0, =error
  @BL printf
  	BNE keys_not_coprime

	@testing getchar and putchar
	@LDR r0, =prompt    	@load the prompt message for input
	@BL printf          	@print
   @MOV r0, #0            @ r0 = empty char
   	LDR r1, [r4, #4]  @load the flag to r1 [r4, #4]
	LDRB r10, [r1]
	SUB r10, r10, #48
	MOV r2, r8
	MOV r3, r9
   	MOV r4, #0	@j <- 0 
   	MOV r5, #0	@k <- 0
@starts looking into the file
peek:
  	BL getchar   		@getchar from STDIN
	CMP r0, #-1  		@check if it's EOF
	BEQ exit     		@exit the function if so

	@loop:
	CMP r0, #65  		@is the char < A?
	BLT peek     		@continue if so(go to next char)
	CMP r0, #90  		@is the char > Z?
	ADDLT r0, r0 ,#32  	@change upper to lower case if < Z (and > A)
	BGT check_lower  	@check lower case letter if 
	B continue  		@else go to output the char
check_lower:
	CMP r0, #97  		@is the char < a?
	BLT peek     		@continue if so(go to next char)
	CMP r0, #122  		@is the char > z?
	BGT peek  		@continue if so(go to next char)
continue:
	@@@ start @@@

 @@@ r0: message char (text[i] where i is the index)
 @@@ r1: flag
 @@@ r2: key1
 @@@ r3: key2
 @@@ r4: j (key1 counter)
 @@@ r5: k (key2 counter)
 @@@ r6: the char of key1
 @@@ r7: the char of key2
 @@@ r10: key1_size
 @@@ r11: key2_size



        SUB r0, r0, #96         @r0 <- r0 - 96 translate to logical letter value

	LDRB r6, [r8, r4]	@r2 <- s1[j]	get char from text depending on j
 	CMP r6, #0		@if(r4 == key1_size)
	MOVEQ r4, #0		@r4 <- 0 reset j back to start
	LDREQB r6, [r8]		@r6 <- s1[0] load char again
	@LDRB r6, [r8, r4]       @r2 <- s1[j]    get char from text depending on j

  	SUB r6, r6, #96		@r6 <- r6 - 96 translate to logical letter value

	LDRB r7, [r9, r5]	@r7 <- s2[k]  get char from text depending on k
	CMP r7, #0              @if(r5 == key2_size)
        MOVEQ r5, #0              @r5 <- 0 reset k back to start
        LDREQB r7, [r9]           @r7 <- s2[0] load char again
	@LDRB r7, [r9, r5]       @r7 <- s2[k]  get char from text depending on k

	SUB r7, r7, #96		@r7 <- r7 - 96 translate to logical letter value

	@@@ calculation starts here @@@
	ADD r6, r6, r7		@r6 <- s1[j] + s2[k] (n = key1_letter + key2_letter)
	@ADD r6, r6, #96
	SUB r6, r6, #4		@r6 <- r6 - 4        (n = n-4)

	CMP r10, #1        @ if(flag(in ascii value))
	ADDEQ r0, r0, r6	@r0 <- r0 + r6 (str_letter + n) (decryption)add value from the above from the original text
	SUBNE r0, r0, r6	@r0 <- r0 - r6 (str_letter - n)(encryption)minus value from the above from the original text
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

	B peek  		@go to next char
	@CMP r0, #0
	@BNE loop
keys_not_coprime:
  MOV r1, r0
  LDR r0, =error
  BL printf
exit:
	LDR r0, =input  	@make a newline when function ends
	BL printf
        POP {r4-r11, lr}
	BX lr
@ int stringlength(char* str)
stringlength:
	PUSH {lr}
@LDR r1, =string1 @load address of string1 into r1
@@@ your string length calculation starts here
@ note LDRB instruction - load register BYTE (not WORD which would be 4 bytes)
	LDRB r1, [r0] @loads first character of the string into r2
	MOV r3, #0  @load the stringlength address into r3
	MOV r2, #0
	B check		    @start by checking the loaded character
loop:
    ADD r3, r3, #1 @r1 <- r1 + 1 (add count)
    ADD r2, r2, #1   @loop index increment
    LDRB r1, [r0, r2]
    check:
    CMP r1, #0	    @check if it's on null character
    BNE loop	    @start the loop

@@@ your string length calculation ends here
@LDR r1, =stringlength load address of string1length into r1
@STR r0,[r1] @ store string length result in memory at string1length
@LDR r0, =print
@LDR r1, =string1
	MOV r0, r3
@BL printf
	POP {lr}
	BX lr @ return string length (in r0) to OS

@int gcd(int x, int y)
gcd:
        PUSH {lr}
gcd_loop:
        CMP      r0, r1
        SUBGT    r0, r0, r1
        SUBLE    r1, r1, r0
        BNE      gcd_loop
        POP {lr}
        BX lr
