.text
	addi $t9, $zero, 40		# NUMBER OF LINES. Change only this value to change the number of lines. Max is 78
	
	la $t0, 0xffff8000		# Start value of terminal
	li $s0, 0x00002200		# Color value of the dark green
fill:
	li $a0, 10
	li $a1, 93			#change 93 to 2 for 1s and 0s
	li $v0, 42
	syscall				# Generate random number
	addi $a0, $a0, 33		# change 33 to 48 for 1s and 0s
	sll $a0, $a0, 24
	or $t1, $s0, $a0
	sw $t1, ($t0)			# Add to terminal
	addi $t0, $t0, 4		# Increment a word
	blt $t0, 0xffffb200, fill	# Fills until the end of the terminal has been reached
	move $v0, $zero
	subi $sp, $zero, 160
	move $t8, $sp
	addi $s6, $zero, 5
headInitialize:				# Initialize t9 number of runners
	beq $t4, $t9, main
	jal _newColumn
	addi $t4, $t4, 1
	addi $sp, $sp, 2
	j headInitialize
	
main:
	move $t4, $zero
	move $sp, $t8
	beq $s6, 0, _resetSwitch
	addi $s6, $s6, -1
	j mainLoop
	
	
mainLoop:
	#t4 - counter
	#t9 - Total columns
	#s1 - column
	#s2 - speed
	
	bgt $t4, $t9, main
	
	lb $s1, ($sp)
	addi $sp, $sp, 1
	lb $s2, ($sp)
	addi $sp, $sp, -1
	
	bgt $s2, $s6, skip
	jal _iterate
	beq $v0, 1, skip
	#move $s5, $sp
	jal _newColumn
	#move $sp, $s5
skip:
	addi $t4, $t4, 1
	
	la $t0, 0xffff8000
	move $v0, $zero
	addi $sp, $sp, 2
	j mainLoop
_resetSwitch:
	addi $s6, $zero, 5
	jr $ra

_newColumn:
	li $a0, 10
	li $a1, 4			#0-5
	li $v0, 42
	syscall
	addi $s2, $a0, 1			#Store speed in s1

	li $a0, 10
	li $a1, 80			#0-80
	li $v0, 42
	syscall				# Generate random number
	move $t2, $ra
	move $s7, $sp
	move $sp, $t8			# set sp to -160
	jal _isValid
	move $sp, $s7
	move $ra, $t2
	beq $a1, 1, _newColumn
	move $s1, $a0			#Store column in s1
	sb $s1, ($sp)
	addi $sp, $sp, 1
	sb $s2, ($sp)
	addi $sp, $sp, -1
	mul $t0, $s1, 4
	add $t0, $t0, 0xffff8000
	lw $t1, ($t0)
	lw $t2, ($t0)
	andi $t1, $t1, 0x0000ff00
	addi $t1, $t1, 0x0000dd00
	andi $t2, $t2, 0xff000000
	or $t1, $t1, $t2
	sw $t1, ($t0)
	jr $ra
	
_isValid:
	addi $a1, $zero, 0
	lb $s1, ($sp)
	beq $s1, $a0, vFound		#if found, return with a0 = 0
	beq $t3, $t9, vReturn		#t9 is number of lines
	addi $sp, $sp, 2
	addi $t3, $t3, 1
	j _isValid
vFound:
	addi $a1, $zero, 1
vReturn:
	mul $t3, $t3, 2
	sub $sp, $sp, $t3
	move $t3, $zero
	jr $ra
	
# $a0 = column 
_iterate:
	lb $s1, ($sp)
	mul $t0, $s1, 4
	add $t0, $t0, 0xffff8000
iterateLoop:
	bgt $t0, 0xffffb1ff, iReturn
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
	bgt $t0, 0xffffb1ff, iReturn
	lw $t1, ($t0)
	lw $t2, ($t0)
	andi $t1, $t1, 0x0000ff00
	andi $t2, $t2, 0xff000000
	addi $t1, $t1, 0x0000dd00
	or $t1, $t1, $t2
	sw $t1, ($t0)
	jr $ra
iReturn:
	jr $ra
