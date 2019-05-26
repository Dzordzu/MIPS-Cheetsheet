
# dependencies:
#	macros/string/basic.asm (IS_NUMBER %code)
#
# a0 - string
#
# Results:
# v0 - number
# v1 - completeness (whole string was a number)
.macro STRING_TO_INT
	addiu $sp, $sp, -12
	sw $t0, ($sp)
	sw $t1, 4($sp)
	sw $t9, 8($sp)
	
	move $a1, $a0
	
	li $t9, 0
loop:
	lb $a0, ($a1)
	beqz $a0, complete
	IS_NUMBER
	beqz $v0, not_complete
	addi $a0, $a0, -48
	mul $t9, $t9, 10
	add $t9, $t9, $a0
	addiu $a1, $a1, 1
	j loop
not_complete:
	li $v1, 0
	j end
complete:
	li $v1, 1
	j end
end:
 	move $v0, $t9
 	
 	lw $t9, 8($sp)
	lw $t1, 4($sp)
	lw $t0, ($sp)
	addiu $sp, $sp, 12
.end_macro

.macro STRING_TO_INT (%string)
	la $a0, %string
	STRING_TO_INT
.end_macro 