.data

menu_message: .asciiz "Your message: "
menu_key: .asciiz "Your key: "
menu_option: .asciiz "Choose option: S - Cypher, D - Decypher\n"

message: .ascii "Message: "
inp_message: .space 50
term_message: .asciiz ""

key: .ascii "Key: "
inp_key: .space 8
term_key: .asciiz ""


result: .ascii "Result: "
inp_result: .space 50
term_result: .asciiz ""

option: .ascii "Option: "
inp_option: .space 2
term_option: .asciiz ""

newline: .asciiz "\n"

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

##################################### Macros #####################################


.macro IN_IMMEDIATE_EXCLUSIVE_RANGE(%min, %max)

	# Ensure $t1 is safe
	addiu $sp, $sp -4
	sw $t1, ($sp)

	# Check if greater than
	li $t1, %min
	slt $v1,$t1, $a0
	
	# Check if smaller than
	li $t1 %max
	slt $t1, $a0, $t1
	
	# Make it works
	and $v1, $v1, $t1
	
	# Reload original $t1 value
	lw $t1, ($sp)
	addiu $sp, $sp, 4
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

.macro TERMINATE (%termination_value)
	li $a0, %termination_value
	li $v0, 17
	syscall
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

--------------------------------11112222*



aaaa

.macro PRINT (%message)
	addiu $sp, $sp, -8
	sw $a0, 0($sp)
	sw $v0, 4($sp)

	
	li $v0, 4
	la $a0, %message
	syscall
	
	lw $a0, 0($sp)
	lw $v0, 4($sp)
	addiu $sp, $sp, 8
.end_macro

.macro PRINT_WORD (%word)
	addiu $sp, $sp, -8
	sw $v0, 4($sp)
	sw $a0, 0($sp)
	
	li $v0, 1
	add $a0, $zero, %word
	syscall
	
	lw $a0, 0($sp)
	lw $v0, 4($sp)
	addiu $sp, $sp, 8
.end_macro

.macro PRINT_CHAR (%char)
	addiu $sp, $sp, -8
	sw $v0, 4($sp)
	sw $a0, 0($sp)
	
	li $v0, 11
	add $a0, $zero, %char
	syscall
	
	lw $a0, 0($sp)
	lw $v0, 4($sp)
	addiu $sp, $sp, 8
.end_macro

.macro PRINT_BYTE (%byte)
	addiu $sp, $sp, -8
	sw $v0, 4($sp)
	sw $a0, 0($sp)
	
	li $v0, 1
	add $a0, $zero, %byte
	syscall
	
	lw $a0, 0($sp)
	lw $v0, 4($sp)
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

.macro INPUT (%target, %maxSize)
	li $v0, 8
	la $a0, %target
	li $a1, %maxSize
	syscall
.end_macro

.macro INPUT_BYTE (%target)
	INPUT %target, 2
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

.macro COPY_ASCIIZ (%size)

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
	sb $t1 ($a1)
	addiu $a0, $a0, 1
	addiu $a1, $a1, 1
	j loop
end:
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

.macro NON_WHITE_LOOP_NH_ASCIIZ (%target)

	addiu $sp, $sp, -12
	sw $t1, 0($sp)
	sw $t2, 4($sp)
	sw $t3, 8($sp)
	
	# Now $t1 is iterator (we need $a0)
	move $t1, $a0
	addiu $t1, $t1, -1 
	
	la $t3, %target
loop:
	#Move by 1 and load value to $a0
	addiu $t1, $t1, 1 
	lb $a0, ($t1)
	
	beqz $a0, end
	
	# Get if it's in ranges
	IN_IMMEDIATE_EXCLUSIVE_RANGE(47, 58)
	move $t2 $v1
	
	IN_IMMEDIATE_EXCLUSIVE_RANGE(64, 91)
	or $t2, $t2, $v1
	
	# If not in range go loop...
	# not $t2, $t2
	beqz $t2, loop
funct:
	sb $a0, ($t3)
	addiu $t3, $t3, 1
	j loop
end:
	lw $t3, 12($sp)
	lw $t2, 8($sp)
	lw $t1, 0($sp)
	addiu $sp, $sp, 12
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


.macro UPPERCASE

	addiu, $sp, $sp, -4
	sw $t1, ($sp)
	
	# Now $t1 is iterator (we need $a0)
	move $t1, $a0
	addiu $t1, $t1, -1 
loop:
	#Move by 1 and load value to $a0
	addiu $t1, $t1, 1 
	lb $a0, ($t1)
	
	beqz $a0, end
	
	# Get if it's in ranges
	IN_IMMEDIATE_EXCLUSIVE_RANGE(96, 123)
	
	# If not in range loop again
	# not $t2, $t2
	beqz $v1, loop
funct:
	# Change to uppercase
	addiu $a0, $a0, -32 
	sb $a0, ($t1)
	j loop
end:
	lw $t1, ($sp)
	addiu, $sp, $sp, 4
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

.macro ENCRYPT_VIGENERE
	addiu, $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	
	# Now $t1 is iterator (we need $a0 and $a1)
	move $t0, $a0
	move $t1, $a1
	move $t2, $a1
	
	addiu $t0, $t0, -1 
	addiu $t1, $t1, -1 
loop:
	#Move by 1 and load value to $a0
	addiu $t0, $t0, 1
	addiu $t1, $t1, 1
	
	# Load text data and validate
	lb $a0, ($t0)
	beqz $a0, end
	
	# Load key data and validate
	lb $a1, ($t1)
	bgtu $a1, $zero, rangeCheck
	
	move $t1, $t2
	lb $a1, ($t1)

rangeCheck:
	
	# Change if it's in ranges
	IN_IMMEDIATE_EXCLUSIVE_RANGE(47, 91)
	
	# If not in range loop again
	beqz $v1, loop
	
	# PRINT_CHAR $a0
	# PRINT plus
	# PRINT_CHAR $a1
	# PRINT arrow
funct:
	subiu $a0, $a0, 48
	addu $a0, $a0, $a1
	
	# Modulo
	divu $a0, $a0, 43
	mfhi $a0
	addiu $a0, $a0, 48 
inRange:
	# PRINT_CHAR $a0
	# PRINT newline
	sb $a0, ($t0)
	j loop
end:
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addiu, $sp, $sp, 12
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

.macro DECRYPT_VIGENERE
	addiu, $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	
	# Now $t1 is iterator (we need $a0 and $a1)
	move $t0, $a0
	move $t1, $a1
	move $t2, $a1
	
	addiu $t0, $t0, -1 
	addiu $t1, $t1, -1 
loop:
	#Move by 1 and load value to $a0
	addiu $t0, $t0, 1
	addiu $t1, $t1, 1
	
	# Load text data and validate
	lb $a0, ($t0)
	beqz $a0, end
	
	# Load key data and validate
	lb $a1, ($t1)
	bgtu $a1, $zero, rangeCheck
	
	move $t1, $t2
	lb $a1, ($t1)

rangeCheck:
	
	# Change if it's in ranges
	IN_IMMEDIATE_EXCLUSIVE_RANGE(47, 91)
	
	# If not in range loop again
	beqz $v1, loop
	
	#PRINT_CHAR $a0
	#PRINT minus
	#PRINT_CHAR $a1
	#PRINT arrow
funct:
	subiu $a0, $a0, 48 # Reduce symbol (in orfer to be between 0 and 43 inclusive)
	
	# Modulo our key
	div $a1, $a1, 43
	mfhi $a1
	
	sub $a0, $a0, $a1 # Reduce by our key
	bge $a0, $zero, inRange
	# PRINT_BYTE $a0
	# PRINT space
	
	addu $a0, $a0, 43
inRange:
	addiu $a0, $a0, 48
	# PRINT_BYTE $a0
	# PRINT newline
	sb $a0, ($t0)
	j loop
end:
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addiu, $sp, $sp, 12
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



.text
main:
	PRINT menu_message
	INPUT inp_message, 51 # 50 + null terminator 
	
	PRINT menu_key
	INPUT inp_key, 9
	
	PRINT menu_option
	PRINT option
	INPUT inp_option, 2
	PRINT newline
	
	lb $t1, inp_option
	subi $t1, $t1 70
	
	
	bgezal $t1 encode
	bltzal $t1  decode
	
	jal fun_result
	TERMINATE(0)
	
.data


.text
fun_result:
	PRINT message
	PRINT newline
	PRINT key
	PRINT result
	
	jr $ra
encode:
	la $a0, inp_message
	UPPERCASE 
	la $a0, inp_message
	NON_WHITE_LOOP_NH_ASCIIZ inp_result
	
	la $a0, inp_result
	la $a1, inp_message
	COPY_ASCIIZ 50
	
	la $a0, inp_result
	la $a1 inp_key
	ENCRYPT_VIGENERE
	jr $ra
	
decode:
	la $a0, inp_message
	la $a1, inp_result 
	COPY_ASCIIZ 50
	la $a0, inp_result
	la $a1 inp_key
	DECRYPT_VIGENERE
	jr $ra
