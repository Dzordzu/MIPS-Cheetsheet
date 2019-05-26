.data 
i_ADD: .asciiz "ADD"
i_ADDI: .asciiz "ADDI"
i_J: .asciiz "J"
i_NOOP: .asciiz "NOOP"
j_MULT: .asciiz "MULT"
j_JR: .asciiz "JR"
j_JAL: .asciiz "JAL"

buffer: .space 256
allocated_bytes: .word 0

###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################

.macro COMPARE_STR
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
.end_macro

.macro COMPARE_STR (%str1, %str2)
	la $a0, %str1
	la $a1, %str2
	COMPARE_STR
.end_macro

###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################

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
	lw $t0, 4($sp)
	addiu $sp, $sp, 8
.end_macro

###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################
###################################################################################

# v0 returns a name, v1 returns an offset (the length of a name)
.macro PARSE_NAME (%str)
	
.end_macro 

.macro ALLOCATE_STRING (%length)
.end_macro

.macro INPUT_STRING
.end_macro

.macro ALLOCATE_WORD
.end_macro

.macro ALLOCATE_STRING (%register)
.end_macro

.macro PARSE_INSTRUCTION (%name, %argsAmount)
.end_macro
