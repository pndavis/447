.data 
	hello: .asciiz "\nEnter a string: "
	
	str1: .asciiz "This string has "
	str2: .asciiz " characters.\n"
	
	start: .asciiz "Specify start index: "
	end: .asciiz "Specify end index: "
	sub: .asciiz "Your substring is: "

	buffer: .space 64
	substring: .space 64
.text 
	Hello:
		addi $v0, $zero, 4 #Print beginning prompt
		la $a0, hello
		syscall
	Main:
		#$a0 = address of an input buffer
		#$a1 = maximum number of characters to read into the buffer
		la $a0, buffer
		li $a1, 64
		jal _readString		#Jump to readstring
		addi $s0, $v0, 0	#Length of the string
		
		addi $v0, $zero, 4
		la $a0, str1
		syscall
		
		addi $v0, $zero, 1
		add $a0, $zero, $s0
		syscall
		
		addi $v0, $zero, 4
		la $a0, str2
		syscall
		
		addi $v0, $zero, 4
		la $a0, start		#Prompt for start of substring
		syscall
		
		addi $v0, $zero, 5
		syscall
		add $s1, $zero, $v0 #Get value for start bounds
		
		addi $v0, $zero, 4
		la $a0, end
		syscall
		
		addi $v0, $zero, 5
		syscall
		add $s2, $zero, $v0 #Get value for end bounds
		
		addi $v0,$zero,4
		la $a0, sub
		syscall


		
		#a0 = address of an input string
		#$a1 = address of an output buffer
		#$a2 = start index for the input string (inclusive)
		#$a3 = end index for the input string (exclusive)
		la $a0, buffer
		la $a1, substring
		addi $a2,$s1,0
		addi $a3,$s2,0
		jal _subString
		
		addi $v0,$zero,4
		la $a0, substring
		syscall
		
		addi $v0,$zero,10
		syscall


	_readString:
		addi $t9, $ra, 0	# Save location jumped from
		addi $v0, $zero, 8	# Readin string
		syscall
	resetcounter:
		addi $t0, $zero, 0	# Set counter to zero
	removeLoop:
		lb $t1, buffer($t0)	# Set t1 equal to the t0 char of string
		addi $t0, $t0, 1	# counter++
		bne $t1, $zero, removeLoop # Restart loop until null is reached
		beq $a1, $s0, skip
		subi $t0, $t0, 2
		sb $zero, buffer($t0)
	skip:
		jal _strLength
		addi $ra, $t9, 0
		jr $ra


	_strLength:
		li $t0, 0 			# initialize the count to zero
	loop:
		lb $t1, 0($a0) 		# load next character into t1
		beq $t1, 0, exit	# check for null character
		addi $a0, $a0, 1 	# increment string pointer
		addi $t0, $t0, 1 	# count++
		j loop 				# loop
	exit:
		addi $v0, $t0, 0	
		jr $ra				# return



		#a0 = address of an input string
		#$a1 = address of an output buffer
		#$a2 = start index for the input string (inclusive)
		#$a3 = end index for the input string (exclusive)
	_subString:
		addi $t9, $ra, 0
		addi $t8, $a1, 0
		addi $t7, $zero, 0	#Counter for substring
		addi $t6, $a2, 0	#Counter for string
		slti $t0, $a2, 0	
		bne $t0, $zero, null
		slti $t0, $a3, 0
		bne $t0, $zero, null
		slt $t0, $a2, $s0
		beq $t0, $zero, null
		slt $t0, $a3, $s0
		beq $t0, $zero, higherBound #If counter is 0, goto higher bound
	returnHB:
		slt $t0, $a2, $a3
		beq $t0, $zero, null
		j subloop
		
	higherBound:
		addi $a3, $s0, 0
		j returnHB	
	subloop:
		lb $t1, buffer($t6)
		sb $t1, substring($t7)
		addi $t6, $t6, 1
		addi $t7, $t7, 1
		beq $t6, $a3, null
		j subloop
	null:
		sb $zero substring($t7)
		j ending
								
	ending:
		addi $ra, $t9, 0
		addi $v0, $t8, 0
		jr $ra