.data
	enter: .asciiz "\nPlease enter your integer: "
	output: .asciiz "Here is the output: "
.text 

prompt: 
	addi $v0, $zero, 4	#Displays the prompt
	la $a0, enter
	syscall
	
	j scanin
scanin: 
	addi $v0, $zero, 5	#Scans in the input, and stores it in s2
	syscall
	add $s2, $zero, $v0
	
	j loop
loop:				#Main loop of the program
	addi $t0,$zero, 7
	sra $s0, $s2,15
	and $s0, $s0, $t0
	
	j print
print: 				#Prints out the output
	addi $v0, $zero, 4
	la $a0, output
	syscall

	addi $v0, $zero, 1	
	add $a0, $zero, $s0
	syscall
	
	j done
done:				#Finishes program
	addi $v0, $zero, 10
	syscall 
