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
	add  $s4, $zero, $s1	#sets second counter to x
	j power2
powering:
	addi $s3, $s3, -1	#Counter 1 --
	add  $s4, $zero, $s1	#sets second counter to x
	addi $s5, $zero 0
	j done	
	
	#s1 = x 
	#s2 = y
	#s3 = y counter 
	#s4 = x counter 
	
power2:				#These statements are the body of the code, first multiplying, and then adding
	add  $s0, $zero, $s1	
	add  $s1, $zero, $s2
	addi $s2, $zero, 1
	add $s3, $zero, $zero
ploop:
	slt $s4, $s3, $s1
	beq $s4, $zero, display
	add $a0, $zero, $s2
	add $a1, $zero, $s0
	j reset
mul:	
	add $s2, $zero, $v0
	addi $s3, $s3, 1
	j ploop
reset:
	add $v0, $zero, $zero
	add $t0, $zero, $zero
loop:   
	slt $t1, $t0, $a1
	beq $t1, $zero, mul
	add $v0, $v0, $a0
	addi $t0, $t0, 1
	j loop
	
	
multiply:
	beq $s4, $zero, powering
	addi $s4, $s4, -1	#Counter 2 --
	add $s0, $s0, $s1	
	
	j multiply
	
display:
	addi $v0, $zero, 1	#Print x
	add  $a0, $zero, $s1
	syscall
	
	addi $v0, $zero, 4	#Print power
	la   $a0, power
	syscall
	
	addi $v0, $zero, 1	#Print y
	add  $a0, $zero, $s0
	syscall
	
	addi $v0, $zero, 4	#Print equals
	la   $a0, equals
	syscall
	
	addi $v0, $zero, 1	#Print total
	add  $a0, $zero, $s2
	syscall


done:
	addi $v0, $zero, 10	#Terminate Program
	syscall
