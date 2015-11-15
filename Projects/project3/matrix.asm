.text
	la $t0, 0xFFFF8000		# Start value of terminal
	li $s0, 0x00002200		# Color value of the dark green
fill:
	li $a0, 10
	li $a1, 93
	li $v0, 42
	syscall				# Generate random number
	addi $a0, $a0, 33
	sll $a0, $a0, 24
	or $t1, $s0, $a0
	sw $t1, ($t0)			# Add to terminal
	addi $t0, $t0, 4		# Increment a word
	blt $t0, 0xFFFFB200, fill	#Fills until the end of the terminal has been reached



# $a0 = column 
_iterate: