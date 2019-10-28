.data
.balign 4
text: .asciz "message"
s1: .asciz "lock"
s2: .asciz "key"
adr_s1: .int s1
adr_s2: .int s2
print: .asciz "%c "
.text
.balign 4
.global main
main:
	@r11 = i, r5 = j, r6 = k
	MOV r11, #0	@i <- 0
	MOV r5, r11	@j <- i
	MOV r6, r11	@k <- i
loop:
	PUSH {r4, r5, r6, r7, r11, lr}
	LDR r0, =text		@r0 <- text
	LDR r1, =s1		@r1 <- s1
	LDR r2, =s2		@r2 <- s2

	LDRB r7, [r0, r11]      @r7 <- text[i]  get char from text depending on i
	CMP r7, #0
	BEQ exit
        SUBNE r7, r7, #96         @r7 <- r7 - 96 translate to logical letter value

	LDRB r3, [r1, r5]	@r3 <- s1[j]	get char from text depending on j

	CMP r5, #4		@if(r3 == 0)
	MOVEQ r5, #0		@r5 <- 0 reset j back to start
	LDREQB r3, [r1]		@r3 <- s1[0] load char again

	SUB r3, r3, #96		@r3 <- r3 - 96 translate to logical letter value
	@ADD r5, r5, #1  @j++
	LDRB r4, [r2, r6]	@r4 <- s2[k]  get char from text depending on k

	CMP r6, #3              @if(r4 == 0)
        MOVEQ r6, #0              @r6 <- 0 reset k back to start
        LDREQB r4, [r2]           @r4 <- s2[0] load char again

	SUB r4, r4, #96		@r4 <- r4 - 96 translate to logical letter value
	@ADD r6, r6, #1	@k++
	@LDRB r7, [r0, r11]	@r7 <- text[i]  get char from text depending on i
	@SUB r7, r7, #96		@r7 <- r7 - 96 translate to logical letter value
	@LDRB r3, [r1], #1
	@LDRB r4, [r2], #1
	@@@ calculation starts here @@@
	ADD r3, r3, r4		@r3 <- s1[j] + s2[k]  add the corresponding letters' value of key1 and key2 
	SUB r3, r3, #4		@r3 <- r3 - 4 
	SUB r0, r7, r3		@r0 <- r7 - r3	(encryption)minus value from the above from the original text letter value
	@loop to ensure the final result value bound between 1 to 26 
bound1to26:
	@ keep adding 26 until larger than 0
	CMP r0, #0
	ADDLT r0, r0, #26
	CMP r0, #0
	BLT bound1to26
	@ keep subtracting 26 until smaller than 26
	CMP r0, #26
	SUBGT r0, r0 , #26
	CMP r0, #26
	BGT bound1to26
	
	@prepare for output
	ADD r0, r0, #96		@r0 <- r0 + 96 translate the result letter value back to ascii value
	@MOV r1, r0		@move the value back to r1 for printing

	@LDR r0, =print		@load print pattern string
	BL putchar		@print
	@ADD r7, r7, #96		@r7 <- r7 + 96 translate the text letter value back to ascii value
	@CMP r7, #0		@check if we loop the text letter to null
        ADD r5, r5, #1  	@j++
	ADD r6, r6, #1  	@k++
	ADD r11, r11, #1      @i++
	B loop
exit:
	@MOVEQ r4, #0		@some restore the high registers
	@MOVEQ r5, #0
	@MOVEQ r6, #0
	@MOVEQ r11, #0

	POP {r4, r5, r6, r7, r11, lr}
	BX lr
