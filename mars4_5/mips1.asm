.text

        
	add  $t0, $t1, $t2
	sub  $t0, $t1, $t2
	beq  $t0, $t1, aLabel
	and  $t0, $t1, $t2
	or   $t0, $t1, $t2
	nor  $t0, $t1, $t2
aLabel: 
	xor  $t0, $t1, $t2
	addi $t0, $t1, 1
