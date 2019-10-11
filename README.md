# Architecture-cw1

demo Monday 4 Nov
name cw1
three command line arguments
	- [] int 1st: 0 = encryption, 1 = decryption 
	- [] string 2nd: first private key
	- [] string 3nd: second private key
	./cw1 0 keystring1 keystring2

	
passed to the program using standard input
1. preprocessing
	1.1 ensure 2 keys' length are co-prime(GCD of keystring1 keystring2 = 1)
		(if not)error message: Key lengths are not co-prime. ->> exit
	1.2 upper case to lower case
	1.3 strip all non-English alphabet characters and whitespaces
2. encryption


3. decryption
