.data
.balign 4
print: .asciz "result= %d\n"

.text
.balign 4
.global main
main:
	PUSH {lr}
	MOV r1, #87
        MOV r2, #102
	gcd:
        CMP      r1, r2
        SUBGT    r1, r1, r2
        SUBLE    r2, r2, r1
        BNE      gcd
	LDR r0, =print
	MOV r1, r1
	BL printf
	POP {lr}
	BX lr
@gcd:
@        CMP      r1, r2
@        SUBGT    r1, r1, r2
@        SUBLE    r2, r2, r1
@        BNE      gcd
