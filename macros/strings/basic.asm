
# v0 - length
.macro LENGTH
	addiu $sp, $sp, -4
	sw $t0, 0($sp)

	li $v0, 0
counter:
	lb $t0, ($a0)
	beqz $t0, end
	add $a0, $a0, 1
	add $v0, $v0, 1
	j counter	
end:
	lw $t0, 0($sp)
	addiu $sp, $sp, 4
.end_macro 

# v0 - pointer
# v1 - position (if v1 already had value, it would be added there)
.macro FIND (%symbol) 
	addiu $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
loop:
	lb $t0, ($a0)
	
	seq $t1, $t0 $zero
	bnez $t1, end
	
	
	add $t1, $zero, %symbol
	seq $t1, $t0, $t1
	bnez $t1, end
	
	addiu $a0, $a0, 1
	addiu $v1, $v1, 1
	
	j loop
end:
	move $v0, $a0
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addiu $sp, $sp, 8
.end_macro
