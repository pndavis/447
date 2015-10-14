.text

# $t0 - Opp 1
# $t1 - Opp 2
# $t2 - Opperator
# $t3 - Result
# $t8 - display
# $t9 - key pad

state0: #reset
	addi $t9, $zero, 0 #Set Keypad to 0
	addi $t8, $zero, 0 #Set Display to 0
	addi $t0, $zero, 0 #Operand 1
	addi $t1, $zero, 0 #Operand 2
	addi $t2, $zero, 0 #Opperator
	addi $t3, $zero, 0 #Result
	add $t8, $zero, $t1
wait:
	beq $t9, $zero, wait # Waits for a button to be pressed until continuing 
state1:
	sll $t9, $t9, 1 
	srl $t9, $t9, 1 # These two lines get rid of the 1 at the beginning of t9	
	slti $s1, $t9, 10 #if the values are 0-9 we will do different things that about 9
	beq $s1, $zero, opp1
num1:
	sll $t4, $t0, 1
	sll $t5, $t0, 3
	add $t0, $t4, $t5	# operand1 = (operand1 * 10) + Input
	add $t0, $t0, $t9	
	add $t8, $zero, $t0 	# Display operand1
	add $t9, $zero, $zero	
	j wait			# Go back to State 1
opp1:	
	beq $t9, 15, state0	# C restarts program
	beq $t9, 14, equals	#
	add $t2, $zero, $t9	# operator = Input
	add $t8, $zero, $t0	# Display operand1
	add $t9, $zero, $zero	# reset t9
	j wait2			# Go to State 2
equals:
	add $t3, $zero, $t0	# result = operand1
	add $t8, $zero, $t3	# Display result
	j state4		# Go to State 4	
			
wait2:
	beq $t9, $zero, wait2
state2:
	sll $t9, $t9, 1 
	srl $t9, $t9, 1 	# These two lines get rid of the 1 at the beginning of t9
	slti $s1, $t9, 10 	#if the values are 0-9 we will do different things that about 9
	beq $s1, $zero, opp2
num2:
	sll $t4, $t1, 1
	sll $t5, $t1, 3
	add $t1, $t4, $t5	# operand2 = (operand2 * 10) + Input
	add $t1, $t1, $t9	
	add $t8, $zero, $t1	# Display operand2
	add $t9, $zero, $zero	# Clear t9	
	j wait3
opp2:	
	beq $t9, 15, state0	# C restarts program
	beq $t9, 14, equals2
	add $t2, $zero, $t9	# operator = Input
	add $t8, $zero, $t0	# Display operand1
	add $t9, $zero, $zero	# reset t9
	j wait2			# Go to State 2
equals2:
	add $t3, $zero, $t0	# result = operand1
	add $t8, $zero, $t3	# Display result
	j state4		# Go to State 4

wait3:
	beq $t9, $zero, wait3
state3:
	sll $t9, $t9, 1 
	srl $t9, $t9, 1 	# These two lines get rid of the 1 at the beginning of t9
	slti $s1, $t9, 10 	#if the values are 0-9 we will do different things that about 9
	beq $s1, $zero, opp3
num3:
	sll $t4, $t1, 1
	sll $t5, $t1, 3
	add $t1, $t4, $t5	# operand2 = (operand2 * 10) + Input
	add $t1, $t1, $t9
	add $t8, $zero, $t1	# Display operand2
	add $t9, $zero, $zero	# Clear t9	
	j wait3
opp3:	
	beq $t9, 15, state0	# C restarts program
	addi $s5, $zero, 0	# Multiplication Counter
	addi $s6, $zero, 0	# Division Counter
	beq $t2, 10, addition
	beq $t2, 11, subtraction
	beq $t2, 12, multiplication
	beq $t2, 13, division
addition:
	add $t3, $t0, $t1
	j finishCalc
subtraction:
	sub $t3, $t0, $t1
	j finishCalc
multiplication:
	add $t3, $t3, $t0
	addi $s5, $s5, 1
	bne $s5, $t1, multiplication
	j finishCalc
division:
	slti $s7, $t0, 0
	beq $s7, 1, divisionNeg
divisionPos:
	sub $t0, $t0, $t1
	slti $s6, $t0, 0
	bne $s6, $zero, finishCalc
	addi $t3, $t3, 1
	slti $s6, $t0, 1
	bne $s6, $zero, finishCalc
	j divisionPos
divisionNeg:	
	addi $s7, $zero, -1
	add $t0, $t0, $t1
	slt $t6, $zero, $t0
	bne $s6, 0, finishCalc
	subi $t3, $t3, 1
	slt $s6, $s7, $t0
	bne $s6, 0, finishCalc
	j divisionNeg	

finishCalc:
	addi $s5, $zero, 0	# Multiplication Counter
	addi $s6, $zero, 0
	add $t8, $t3, $zero 	# Displays results
	beq $t9, 14, equals3
	addi $t0, $t3, 0
	add $t3, $zero, $zero	# Reset results
	add $t1, $zero, $zero	
	add $t2, $t9, $zero	# Operator = Input
	j state2
equals3:
	add $t8, $t3, $zero
	add $t2, $zero, $zero
	add $t1, $zero, $zero
	add $t9, $zero, $zero	
	j wait4

wait4:
	beq $t9, $zero, wait4
state4:
	sll $t9, $t9, 1 
	srl $t9, $t9, 1 # These two lines get rid of the 1 at the beginning of t9
	slti $s1, $t9, 10 #if the values are 0-9 we will do different things that about 9
	beq $s1, $zero, opp4
num4:
	add $t8, $zero, $zero
	add $t0, $t9, $t0	#operand1 = Input
	add $t8, $zero, $t0	#Display operand1
	add $t9, $zero, $zero
	j wait			#Go to State 1
opp4:
	beq $t9, 15, state0	# C restarts program
	beq $t9, 14, equals4
	
	add $t0, $zero, $t3	#operand1 = result
	add $t2, $zero, $t9	#operator = Input
	add $t9, $zero, $zero	# reset t9
	j wait2			# Go to State 2
equals4:
	add $t8, $t3, $zero
	add $t1, $zero, $zero
	add $t3, $zero, $zero
	add $t9, $zero, $zero
	j wait4
