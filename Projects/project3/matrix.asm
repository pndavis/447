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
	blt $t0, 0xffffb200, fill	# Fills until the end of the terminal has been reached
	move $v0, $zero

main:
	beq $v0, 1, old 
	jal _newColumn
old:
	la $t0, 0xffff8000
	move $v0, $zero
	jal _iterate
	j main

_newColumn:
	li $a0, 10
	li $a1, 79			#0-79
	li $v0, 42
	syscall				# Generate random number
	addi $a0, $a0, 1		#1-80
	mul $t0, $a0, 4
	add $t0, $t0, 0xffff8000
	lw $t1, ($t0)
	lw $t2, ($t0)
	andi $t1, $t1, 0x0000ff00
	addi $t1, $t1, 0x0000dd00
	andi $t2, $t2, 0xff000000
	or $t1, $t1, $t2
	sw $t1, ($t0)
	jr $ra
	
# $a0 = column 
_iterate:
	mul $t0, $a0, 4
	add $t0, $t0, 0xffff8000
iterateLoop:
	bgt $t0, 0xffffb200, return
	lw $t1, ($t0)
	lw $t2, ($t0)
	andi $t1, $t1, 0x0000ff00
	andi $t2, $t2, 0xff000000
	addi $t0, $t0, 320
	blt $t1, 0x00003300, iterateLoop	# if the value is normal, branch
	subi $t0, $t0, 320
	addi $v0, $zero, 1
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
	jr $ra
return:
	jr $ra
