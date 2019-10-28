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
.text
.global main
.balign 4
main:
        PUSH {r4, ip, lr}
	LDR r0, =string
	MOV r4, r1
        LDR r1, [r4, #4]
	LDR r2, [r4, #8]
	LDR r3, [r4, #12]
        BL printf

	@testing getchar and putchar
	LDR r0, =prompt
	BL printf

peek:
	CMP r0, #-1
	BEQ exit
	BL getchar
	@loop:
	MOV r0, r0
	CMP r0, #65
	BLT peek
	CMP r0, #90
	ADDLT r0, r0 ,#32
	BGT check_lower
	B continue
check_lower:
	CMP r0, #97
	BLT peek
	CMP r0, #122
	BGT peek
continue:
	@MOV r1, r0
	@LDRB r0, =char
	@LDR r1, =char
	@r0 = text letter
	@r1 = key1 letter
	@r2 = key2 letter
	BL putchar
	B peek
	@CMP r0, #0
	@BNE loop
exit:
	LDR r0, =input
	BL printf
        POP {r4, ip, pc}