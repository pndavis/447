.data 

.text


hello:  .asciiz  "Hello World!!!"
	li   $s0, 0xffff8000
	li   $s1, 0x00ffffff
	la   $s2, hello
loop:
	lb   $s3, 0($s2)
	beq  $s3, $zero, done
	sll  $s3, $s3, 24
	or   $s3, $s3, $s1
	sw   $s3, 0($s0)
	addi $s2, $s2, 1
	addi $s0, $s0, 4
	j    loop
done:
	addi $v0, $zero, 10
	syscall
# $s0 - Base address of the terminal
# $s1 - Color of character (white)
# $s2 - Address of the string hello
# Load a character
# Encounter the null-character, done
# Move ascii value to the top 8-bit
# Put color to the bottom 24-bit
# Put character on the terminal
# Go to the next character (string hello)
# Go to the next word (terminal)
# Syscall 10: terminate program
# Terminate program