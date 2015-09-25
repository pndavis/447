.text

        
addi $t0, $zero, -123
nor  $t0, $t0, $zero
addi $t0, $t0, 1

addi $v0, $zero, 1
add  $a0, $zero, $t1
syscall