.macro COMPARE_STR
	
	addiu $sp, $sp, -8
	sw $t0, ($sp)
	sw $t1, 4($sp) 

	li $v0, 1
	addiu $a0, $a0, -1
	addiu $a1, $a1, -1		
loop:
	# ptr[a0]++ ptr[a1]++
	addiu $a0, $a0, 1
	addiu $a1, $a1, 1
	
	lb $t0, ($a0)
	lb $t1, ($a1)
	
	# if(a0 == 0 || a1 == 0) goto equalZero
	seq $t0, $t0, $zero
	seq $t1, $t1, $zero
	or $t0, $t0, $t1
	bne $t0, $zero, equalZero
	
	lb $t0, ($a0)
	lb $t1, ($a1)
	
	# if(a0 != a1)
	bne $t0, $t1, notEqual
	# else goto loop
	j loop
	
equalZero:
	lb $t0, ($a0)
	lb $t1, ($a1)
	
	# if(a0 == 0 && a1 == 0) OK
	# else NOT OK	
	seq $t0, $t0, $zero
	seq $t1, $t1, $zero
	and $t0, $t0, $t1
	bne $t0, $zero, end
notEqual:
	li $v0, 0
end:
	lw $t1, 4($sp)
	lw $t0, 4($sp)
	addiu $sp, $sp, 8
.end_macro

.macro COMPARE_STR (%str1, %str2)
	la $a0, %str1
	la $a1, %str2
	COMPARE_STR
.end_macro
