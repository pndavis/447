
.data
	names: .asciiz "steve", "john", "chelsea", "julia", "ryan" 
	ages: .byte 20, 25, 22, 21, 23
	prompt: .asciiz "Please enter a name: "
	input: .space 64
	notFound: .asciiz "Not found!\n"
	age: .asciiz "Age is: "

.text
	addi $v0, $zero, 4
	la $a0, prompt
	syscall					#Asks users to enter a name

	la $a0, input
	addi $a1, $zero, 64
	#jal _readString

	la $s0, input			
	add $s1, $zero, $zero		
	la $s2, names	





_readString: