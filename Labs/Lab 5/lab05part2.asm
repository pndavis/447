.data 
	prompt: .asciiz "Enter a nonnegative integer: "
	middle: .asciiz "! = "
	invalid: .asciiz "Invalid integer; try again.\n"

.text

start:
	addi $v0, $zero, 4
	la $a0, prompt
	syscall					#Print inital prompt

	addi $v0,$zero,5
	syscall

	add $s0, $zero, $v0
	slti $t0,$s0,0
	bne $t0, $zero, failed	#Tests the numbers validity

	add $a0, $zero, $s0
	jal _Factorial			#Jump to factorial funtion

	add $s1, $zero, $v0
	div $s1, $s1, $s0
	addi $v0, $zero, 1
	add $a0, $zero, $s0
	syscall

	addi $v0, $zero, 4
	la $a0, middle
	syscall

	addi $v0, $zero, 1
	add $a0, $zero, $s1
	syscall
	
	j end

_Factorial:
	addi $sp, $sp, -8
	sw $ra, 4($sp) 
	sw $a0, 0($sp)
	ble $a0, $zero, return
	addi $a0, $a0, -1
	jal _Factorial
	lw $a0, 0($sp)
	mul $v0, $v0, $a0
return:
	lw $ra 4($sp)
    addi $sp, $sp, 8
	jr $ra

failed:
	addi $v0, $zero, 4
	la $a0, invalid
	syscall					#Says the number is invalid and restarts the program
	j start

end:
	addi $v0, $zero, 10
	syscall