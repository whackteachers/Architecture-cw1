.data
.balign 4
print: .asciz "result: %d\n"
.text
.balign 4
.global main

main:
  	PUSH {r4, lr}
	MOV r1, #-10
	MOV r2, #26
	g:
  	CMP r1, r2
	SUBGT r1, r1, r2
	BGT g

  	l:
  	CMP r1, #0
	ADDLT r1, r1, r2
	BLT l
@	SDIV r3, r1, r2
@	MUL r2, r3, r2
@	SUB r1, r1, r2
  	LDR r0, =print
	BL printf
  	POP {r4, lr}
  	BX lr
