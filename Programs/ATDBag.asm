# Node consists of two parts
#   - data: integer data (4 bytes)
#   - next: the address of the next node 0 for null (4 bytes)
# Use syscall 9 to allocate memory (number of bytes in $a0) address in $v0
# A bag consists of two parts
#   - numberOfEntries: number of entries in the bag (4 bytes)
#   - firstNode: address of the first node 0 for null (4 bytes)
# Operations:
#   - newNode(): Allocate a space for newNode
#   - add(aBag, newEntry): Add newEntry into aBag
#   - size(aBag): get the number of entry in aBag
#   - getReferenceTo(aBag, anEntry): Get the address of the node in aBag
#                                    containing anEntry
#   - print(aBag): Print the content of aBag
#   - remove(aBag): Remove an unspecific entry from aBag
#   - removeEntry(aBag, anEntry): Remove anEntry from aBag
.text
	addi $v0, $zero, 9
	addi $a0, $zero, 8
	syscall
	add  $s0, $zero, $v0	# $s0 - Address of myBag
	sw   $zero, 0($s0)
	sw   $zero, 4($s0)
	add  $a0, $zero, $s0
	addi $a1, $zero, 3
	jal  _add
	add  $a0, $zero, $s0
	addi $a1, $zero, 2
	jal  _add
	add  $a0, $zero, $s0
	addi $a1, $zero, 1
	jal  _add
	add  $a0, $zero, $s0
	jal  _printBag
	
	add  $a0, $zero, $s0
	jal  _getSize
	add  $a0, $zero, $v0
	addi $v0, $zero, 1
	syscall
	
	add  $a0, $zero, $s0
	jal  _remove
	add  $a0, $zero, $v0
	addi $v0, $zero, 1
	syscall
	
	add  $a0, $zero, $s0
	jal  _printBag
	
	
	
	addi $v0, $zero, 10
	syscall
	
# _remove
# Arguement
#   - $a0 : the address of aBag
# Return Value
#   - $v0 : unspecific entry
_remove:
	lw   $t0, 4($a0)	# $t0 is the address of the firstNode
	lw   $v0, 0($t0)	# $v0 is firstNode.data
	lw   $t1, 4($t0)	# $t1 is firstNode.next
	sw   $t1, 4($a0)	# firstNode = firstNode.next
	lw   $t2, 0($a0)	# $t2 is the numberOfEntries
	addi $t2, $t2, -1	# numberOfEntries--
	sw   $t2, 0($a0)	# Update numberOfEntries;
	jr   $ra
	
	
	
	
	
	
	
	
	
	
	
	
# _getSize
# Argument
#   - $a0: The address of aBag
# Return Value
#   - $v0: is the number of entries inside a bag
_getSize:
	lw   $v0, 0($a0)
	jr   $ra
	


# _printBag
# Arguments
#   - $a0: The address of aBag
# Return Values:
#   - None
_printBag:
	add  $t0, $zero, $a0
	lw   $t1, 4($t0)	# $t1 is currentNode
printLoop:
	beq  $t1, $zero, printDone
	lw   $t2, 0($t1)	# $t2 is currentNode.data
	addi $v0, $zero, 1	# Syscall 1: print integer
	add  $a0, $zero, $t2	# $a0 is the integer to be printed
	syscall
	lw   $t1, 4($t1)	# currentNode = currentNode.next
	j    printLoop
printDone:
	jr   $ra
	
	
	
	



# _add
# Arguments
#   - $a0: The address of aBag
#   - $a1: The data to be added to aBag
# Return Value:
#   - None
_add:
	addi $sp, $sp, -20
	sw   $s3, 16($sp)
	sw   $s2, 12($sp)
	sw   $s1, 8($sp)
	sw   $s0, 4($sp)
	sw   $ra, 0($sp)
	add  $s0, $zero, $a0	# $s0 - The address of aBag
	add  $s1, $zero, $a1	# $s1 - Data to badded
	jal  _newNode		# Construct a newNode
	add  $s2, $zero, $v0	# $s2 - The address of newNode
	sw   $s1, 0($s2)	# newNode.data = newEntry
	lw   $s3, 4($s0)	# $s3 is firstNode
	sw   $s3, 4($s2)	# newNode.next = firstNode
	sw   $s2, 4($s0)	# firstNode = newNode
	lw   $s3, 0($s0)	# numberOfEntries++
	addi $s3, $s3, 1	#
	sw   $s3, 0($s0)	#
	lw   $s3, 16($sp)
	lw   $s2, 12($sp)
	lw   $s1, 8($sp)
	lw   $s0, 4($sp)
	lw   $ra, 0($sp)
	addi $sp, $sp, 20
	jr   $ra

_newNode:
	addi $v0, $zero, 9
	addi $a0, $zero, 8
	syscall
	jr   $ra