.data
.balign 4
text: .asciz "message"
string: .asciz "Argv: %s %s %s\n"
arg1: .word 0
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
   	MOV r0, r2 
 	BL stringlength
	MOV r11, r0
	LDR r0, =string

	LDR r3, [r4, #12]	@load the third argument to r3
	MOV r0, r3
	BL stringlength
	MOV r10, r0
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
 
  MOV r0, r11
	MOV r1, r10
  BL gcd
  CMP r0, #1
  @LDRNE r0, =error
  @BL printf
  BNE exit
	@testing getchar and putchar
	LDR r0, =prompt    	@load the prompt message for input
	BL printf          	@print
@starts looking into the file
peek:
	CMP r0, #-1  		@check if it's EOF
	BEQ exit     		@exit the function if so
	BL getchar   		@getchar from STDIN
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
  
   
	BL putchar  		@print letter
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
        CMP      r0, r1
        SUBGT    r0, r0, r1
        SUBLE    r1, r1, r0
        BNE      gcd
        @CMP r0, #1
        @BNE keys_not_coprime
        POP {lr}
        BX lr
