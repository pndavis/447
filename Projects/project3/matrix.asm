.text
	la $t0, 0xffff8000		# Start value of terminal
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
	blt $t0, 0xffffb200, fill	#Fills until the end of the terminal has been reached

reset:
	move $t0, $zero
	move $t1, $zero
	move $a0, $zero
	move $a1, $zero
#Test
	addi $a0, $zero, 10

# $a0 = column 
_iterate:
	mul $t0, $a0, 4
	add $t0, $t0, 0xffff8000
	#
	lw $t1, ($t0)
	lw $t2, ($t0)
	andi $t1, $t1, 0x0000ff00
	addi $t1, $t1, 0x0000dd00
	andi $t2, $t2, 0xff000000
	or $t1, $t1, $t2
	sw $t1, ($t0)
	#
iterateLoop:
	bgt $t0, 0xffffb200, return
	lw $t1, ($t0)
	lw $t2, ($t0)
	andi $t1, $t1, 0x0000ff00
	andi $t2, $t2, 0xff000000
	addi $t0, $t0, 320
	blt $t1, 0x00003300, iterateLoop	# if the value is normal, branch
	subi $t0, $t0, 320
	beq $t1, 0x0000ff00, iterateFF
	subi $t1, $t1, 0x00001100
	or $t1, $t1, $t2
	sw $t1, ($t0)
	addi $t0, $t0, 320
	j iterateLoop
iterateFF:	
	subi $t1, $t1, 0x00001100
	or $t1, $t1, $t2
	sw $t1, ($t0)
	addi $t0, $t0, 320
	lw $t1, ($t0)
	lw $t2, ($t0)
	andi $t1, $t1, 0x0000ff00
	andi $t2, $t2, 0xff000000
	addi $t1, $t1, 0x0000dd00
	or $t1, $t1, $t2
	sw $t1, ($t0)
	addi $t0, $t0, 320
	j iterateLoop
return:
	j iterateLoop