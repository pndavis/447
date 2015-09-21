.data
	enter: .asciiz "\nEnter a number between 0 and 9: "
	low: .asciiz "That number is too low"
	high: .asciiz "That number is too high"
	right: .asciiz "\nCorrect, the answer is "
	wrong: .asciiz "\n\nOut of tries. The correct answer is "


.text
	# s0 count
	# s1 Random number 
	# s2 User entered number

	addi $v0, $zero, 42	#Generate random number between 0 and 10 and store it in $s1
	add $a0, $zero, $zero
	addi $a1, $zero, 10
	syscall
	add $s1, $zero, $a0
	
	addi $s0, $zero, 3	#sets counter to 3
	
	j loop			#jump to main loop
	
loop:
	beq $s0, $zero, no	#if count is 0, end program
	addi $v0, $zero, 4	#Print text
	la   $a0, enter
	syscall

	addi $v0, $zero, 5	#Scanin
	syscall
	add $s2, $zero, $v0	#Sets users entered number to s2

	
	beq $s1, $s2, yes	#if the number are the same, correct
	
	
	slt $s7, $s2, $s1	#Compares users entered and rng
	beq $s7, 1, bottom	#if the user value is less than the rgn, goto bottom. If it isn't, it will just contiue to top

top:	
	addi $v0, $zero, 4	#Print text
	la   $a0, high
	syscall
	addi $s0, $s0, -1	#count--
	j loop
bottom:
	addi $v0, $zero, 4	#Print text
	la   $a0, low
	syscall
	addi $s0, $s0, -1	#count--
	j loop
yes:
	addi $v0, $zero, 4	#Print text
	la   $a0, right
	syscall
	
	addi $v0, $zero, 1	#Print number
	add  $a0, $zero, $s1
	syscall
	j done
no:
	addi $v0, $zero, 4	#Print text
	la   $a0, wrong
	syscall
	
	addi $v0, $zero, 1	#Print number
	add  $a0, $zero, $s1
	syscall
	j done
	
done:
	addi $v0, $zero, 10	#Terminate Program
	syscall
