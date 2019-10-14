# Architecture-cw1

<pre><code>demo Monday 4 Nov
demo Monday 4 Nov
name cw1
three command line arguments
	- int 1st: 0 = encryption, 1 = decryption 
	- string 2nd: first private key
	- string 3nd: second private key
	./cw1 0 keystring1 keystring2

# mod is the operation of finding the remainder when dividing 2 numbers
passed to the program using standard input
1. preprocessing
	1.1 ensure 2 keys' length are co-prime(GCD of keystring1 keystring2 = 1)
		(if not)error message: Key lengths are not co-prime. ->> exit
	1.2 upper case to lower case
	1.3 strip all non-English alphabet characters and whitespaces
2. encryption
	n = key1 + key2
	t = n - 4
	(x - key1 - key2 + 4) mod 26
	= (x - (key1 + key2) + 4) mod 26
	= (x - n + 4) mod 26
	= (x - (n - 4)) mod 26
	= (x - t) mod 26

3. decryption
	(x + key1 + key2 + 22) mod 26
	= (x + n + (26 - 4)) mod 26
	= (x + key1 + key2 - 4) mod 26
	= (x + n - 4) mod 26
	= (x + t) mod 26
	
strlen function eg.
.section .rodata       
.align 2                

 message:                        
    .string "Hello, world!" 

 print:
    .string "Length is : %d\n"

.text                   
.align 2
.global main            

strlen: 
    stmfd   sp!, {lr}
    ldrb    r2, [r0]
    cmp     r2, #0
    beq     out
    add     r1, r1, #1
    add     r0, r0, #1
    bl      strlen
    ldmfd   sp!, {lr}
    bx      lr
    .global main

main:                           
    stmfd   sp!, {lr}       
    ldr     r0, =message    
    mov     r1, #0
    bl      strlen
    ldmfd   sp!, {lr}
    bx      lr
out:

    stmfd   sp!, {lr}
    ldr     r0, =print
    mov     r3,  r1  
    bl      printf
    ldmfd   sp!, {lr}
    bx      lr

mod:
		sub     sp, sp, #16
        str     w0, [sp, 12]
        str     w1, [sp, 8]
        ldr     w0, [sp, 12]
        ldr     w1, [sp, 8]
        sdiv    w2, w0, w1
        ldr     w1, [sp, 8]
        mul     w1, w2, w1
        sub     w0, w0, w1
        add     sp, sp, 16
</code></pre>
