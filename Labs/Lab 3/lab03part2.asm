.data
	start: .asciiz "\nx^y calculator\n"
	enterx: .asciiz "Please enter x: "
	entery: .asciiz "Please enter y: "
	nonegative: .asciiz "Integer must be nonnegative.\n"
	power: .asciiz "^"
	equals: .asciiz " = "

.text
	# s0 total
	# s1 x
	# s2 y
	# s3 count 1
	# s4 count 2

	addi $v0, $zero, 4	#Print start text
	la   $a0, start
	syscall
	
	j scanx
	
rescanx:
	addi $v0, $zero, 4	#Print enter x text
	la   $a0, nonegative
	syscall
	
scanx:
	addi $v0, $zero, 4	#Print enter x text
	la   $a0, enterx
	syscall
	
	addi $v0, $zero, 5	#Scanin x
	syscall
	add $s1, $zero, $v0	#Put x in register 1
	
	slt $s7, $s1, $zero	#Checks to see if the number is postive
	beq $s7, 1, rescanx	#If it is negative, it will ask to reenter the number
	
	j scany
	
rescany:
	addi $v0, $zero, 4	#Print enter x text
	la   $a0, nonegative
	syscall
	
scany:
	addi $v0, $zero, 4	#Print enter y text
	la   $a0, entery
	syscall
	
	addi $v0, $zero, 5	#Scanin y
	syscall
	add $s2, $zero, $v0	#Put y in register 2
	
	slt $s7, $s2, $zero	#Checks to see if the number is postive
	beq $s7, 1, rescany	#If it is negative, it will ask to reenter the number

setcounters:
	add  $s3, $zero, $s2	#sets first counter to y
	add  $s4, $zero, $s2	#sets second counter to y

powering:
	beq $s3, $zero, display	#if count is 0, goto display
	
	j multipy
	
	
	
	j powering
	
multiply:
	beq $s4, $zero, powering
	
	
	
	
	
	j multiply
	
display:
	addi $v0, $zero, 1	#Print x
	add  $a0, $zero, $s1
	syscall
	
	addi $v0, $zero, 4	#Print power
	la   $a0, power
	syscall
	
	addi $v0, $zero, 1	#Print y
	add  $a0, $zero, $s2
	syscall
	
	addi $v0, $zero, 4	#Print equals
	la   $a0, equals
	syscall
	
	addi $v0, $zero, 1	#Print total
	add  $a0, $zero, $s0
	syscall


done:
	addi $v0, $zero, 10	#Terminate Program
	syscall
