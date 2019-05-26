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
