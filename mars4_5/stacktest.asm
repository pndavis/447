.text
	addi $t1, $zero, 45
	addi $sp, $sp, -1
	
	sb, $t1 ($sp)
	lb $t1 ($sp)