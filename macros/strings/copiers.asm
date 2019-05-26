
# Notation: 
# a0 - src
# a1 - target 

.macro COPY_ASCII (%size)

	addiu $sp, $sp, -8
	sw $t0, ($sp)
	sw $t1, 4($sp) 

	# Init iterations
	add $t0, $zero, %size
	

loop:
	# Check iterations
	add $t0, $t0, -1
	bltz $t0, end
	
	# Load value
	lb $t1, ($a0)
	beqz $t1, end
	sb $t1 ($a1)
	addiu $a0, $a0, 1
	addiu $a1, $a1, 1
	j loop
end:
	sb $zero, ($a1)
	lw $t1, 4($sp)
	lw $t0, ($sp)
	addiu $sp, $sp, 8
.end_macro

.macro COPY_ASCII (%src, %trg, %size)
	la $a0, %src
	la $a1, %trg
	COPY_ASCII %size
.end_macro

# Dependcies:
#	macros/strings/basic.asm (FIND sign)
.macro COPY_ASCII_TO_SIGN_EXCLUSIVE (%sign)
	addiu $sp, $sp, -4
	sw $t0, ($sp)

	move $t0, $a0
	FIND %sign 
	move $a0, $t0
	
	move $t0, $v1
	COPY_ASCII $t0

	lw $t0, ($sp)
	addiu $sp, $sp, 4
.end_macro

.macro COPY_ASCII_TO_SIGN_EXCLUSIVE (%src, %trg, %sign)
	la $a0, %src
	la $a1, %trg
	COPY_ASCII_TO_SIGN_EXCLUSIVE (%sign)
.end_macro 	
