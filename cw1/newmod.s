.data
.balign 4
print: .asciz "result = %d\n"
test: .asciz "%s %s\n"
a1: .skip 500
a2: .skip 500
@adr_a1: .word a1
@adr_a2: .word a2
.text
.global main
main:
	PUSH {r4, lr}
	MOV r3, r1
	LDR r1, [r3, #4]
	LDR r2, [r3, #8]
	@UDIV r2, r0, r1
	@MUL r1, r2, r1
	@SUB r0, r0 ,r1

	@MOV r1, r0
	LDR r0, =test
	BL printf

	LDR r1, [r3]
	LDR r4, [r2]
	STR r1, adr_a1
	STR r4, adr_a2

	LDR r0, =test
	LDR r1, =a1
	LDR r2, =a2
	BL printf

	POP {r4, lr}
	BX lr

adr_a1: .word a1
adr_a2: .word a2
