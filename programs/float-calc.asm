.data
	# Useful for debugging and logging
	newline: .asciiz "\n"
	ascii_space: .asciiz  " "
	
	ascii_arrow: .asciiz " -> "
	ascii_long_arrow: .asciiz " ---> "
	
	ascii_plus: .asciiz " + "
	ascii_minus: .asciiz " - "
	ascii_multipicate: .asciiz " * "
	ascii_divide: .asciiz " / "
	ascii_power: .asciiz "^"
	
	ascii_equals: .asciiz " = "
	ascii_less: .asciiz " < "
	ascii_less_eq: .asciiz " <= "
	ascii_greater: .asciiz " > "
	ascii_greater_eq: .asciiz " >= "
	
	ascii_versus: .asciiz " vs "
	ascii_and: .asciiz " and "
	ascii_or: .asciiz " or "


.data
main_menu: .asciiz "Choose operation:\n1 Addition\n2 Substraction\n3 Multiplication\n4 Division\nYour choice: "
range_exceeded_error: .asciiz "Number out of range"
nan_error: .asciiz "Not a number error"
zero_div_error: .asciiz "Division by zero is not allowed"
result: .asciiz "Result: "
operation_choice: .word 0
arg1_ascii: .asciiz "Enter a: "
arg2_ascii: .asciiz "Enter b: "
repeat_ascii: .asciiz "Repeat?\n0 no\n1(default) yes\nYour choice: "

arg1: .space 32
arg2: .space 32
d_arg1: .double 0
d_arg2: .double 0
zero_double: .double 0
buffer_d_dec: .double 0
buffer_d_frac: .double 0
d_result: .double 0

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

.macro PRINT (%message)
        addiu $sp, $sp, -8
        sw $v0, 4($sp)
        sw $a0, 0($sp)

        li $v0, 4
        la $a0, %message
        syscall

        lw $a0, 0($sp)
        lw $v0, 4($sp)
        addiu $sp, $sp, 8
.end_macro

.macro base_numeric_PRINT (%code, %value)
        addiu $sp, $sp, -8
        sw $v0, 4($sp)
        sw $a0, 0($sp)

        li $v0, %code 
        addu $a0, $zero, %value
        syscall

        lw $a0, 0($sp)
        lw $v0, 4($sp)
        addiu $sp, $sp, 8
.end_macro

.macro PRINT_REG (%message)
	base_numeric_PRINT (4, %message)
.end_macro

.macro PRINT_WORD (%message)
	base_numeric_PRINT (1, %message)
.end_macro

.macro PRINT_CHAR (%message)
	base_numeric_PRINT (11, %message)
.end_macro

.macro PRINT_BYTE (%message)
	base_numeric_PRINT (1, %message)
.end_macro

.macro PRINT_DOUBLE (%message)
	li $v0, 3
	l.d $f12, %message
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

.macro INPUT (%buffer, %maxSize)

        addiu $sp, $sp, -8
        sw $a0, 4($sp)
        sw $a1, 0($sp)

	li $v0, 8
        la $a0, %buffer
        addu $a1, $zero, %maxSize
        syscall
        
        lw $a1, 0($sp)
        lw $a0, 4($sp)
        addiu $sp, $sp, 8

.end_macro

.macro INPUT_WORD
	li $v0, 5
        syscall
.end_macro


# Notation:
# a0 - src

# Returns
# 	v0 - length
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

.macro LENGTH (%str)
	la $a0, %str
	LENGTH
.end_macro

# Returns
# 	v0 - pointer
# 	v1 - position (relative to the a0 pointer)
.macro FIND (%symbol) 
	addiu $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	li $v1, 0
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

.macro IS_LETTER
	addiu $sp, $sp, -4
	sw $t0, ($sp)
	
	IN_IMMEDIATE_EXCLUSIVE_RANGE(96, 123)
	move $t0, $v1
	IN_IMMEDIATE_EXCLUSIVE_RANGE(64, 91)
	or $v0, $v1, $t0
	
	lw $t0, ($sp)
	addiu $sp, $sp, 4
.end_macro

.macro IS_LETTER (%code)
	lb $a0, %code
	IS_LETTER
.end_macro 


.macro IS_NUMBER
	IN_IMMEDIATE_EXCLUSIVE_RANGE(47, 58)
	move $v0, $v1
.end_macro

.macro IS_NUMBER (%code)
	lb $a0, %code
	IS_NUMBER
.end_macro 



.macro VALIDATE_DOUBLE ()
	addiu $sp, $sp, -4
	sw $t1, ($sp)
	
	move $t1, $a0
	li $v0, 1

firstIt:	
	lb $a0, 0($t1)
	beqz $a0, notok
	bne $a0, '-', checkNum
	addiu $t1, $t1, 1
	lb $a0, 0($t1)
checkNum:
	IS_NUMBER
	beqz $v0, notok
loopToDot:
	addiu $t1, $t1, 1
	lb $a0, 0($t1)
	beqz $a0, end
	beq $a0, '\n' end
	beq $a0, ' ', end
	beq $a0, '.', loopFromDot
	IS_NUMBER
	beqz $v0, notok
	j loopToDot
loopFromDot:
	addiu $t1, $t1, 1
	lb $a0, 0($t1)
	beqz $a0, end
	beq $a0, '\n' end
	beq $a0, ' ', end
	IS_NUMBER
	beqz $v0, notok	
	j loopFromDot
notok:
	li $v0, 0
end:
	lw $t1, ($sp)
	addiu $sp, $sp, 4	
.end_macro


.macro VALIDATE_DOUBLE(%str)
	la $a0, %str
	VALIDATE_DOUBLE
.end_macro 

.macro SAVE_DOUBLE (%str, %double) #t1, t2, t0, t3
	la $t0, %str
	li $t2, 1

checkForSign:

	li $t1, 1
	mtc1.d $t1, $f22
	cvt.d.w $f22, $f22
	
	lb $a0, 0($t0)
	bne $a0, '-', prepare
	addiu $t0, $t0, 1
	
	li $t1, -1
	mtc1.d $t1, $f22
	cvt.d.w $f22, $f22
	
prepare:
	li $t1, 0
	mtc1.d $t1, $f12
	cvt.d.w $f12, $f12
	
	
toDot:
	lb $a0, 0($t0)
	beq $a0, '.', afterDot
	IS_NUMBER
	beqz $v0, end
	
	# Multiply by 10
	li $t1, 10
	mtc1.d $t1, $f2
	cvt.d.w $f2, $f2
	mul.d $f12, $f12, $f2
	
	# Add number
	sub $a0, $a0, 48
	mtc1.d $a0, $f2
	cvt.d.w $f2, $f2
	add.d $f12, $f12, $f2
	
	addiu $t0, $t0, 1
	j toDot
	
	
afterDot:
	# Load sign
	addiu $t0, $t0, 1
	lb $a0, 0($t0)
	IS_NUMBER
	beqz $v0, end
	subiu $a0, $a0, 48
	mtc1.d $a0, $f2
	cvt.d.w $f2, $f2
	
	move $t3, $t2
loop:
	beqz $t3, loopEnded
	# Divide by 10
	li $t1, 10
	mtc1.d $t1, $f0
	cvt.d.w $f0, $f0
	div.d $f2, $f2, $f0
	subiu $t3, $t3, 1
	j loop
loopEnded:
	add.d $f12, $f12, $f2
	addiu $t2, $t2 1
	j afterDot
	
end:
	mul.d $f12, $f12, $f22
	s.d $f12, %double
.end_macro

.text

loop: 
	PRINT newline
	PRINT newline
	PRINT newline
	PRINT newline
	PRINT main_menu
	INPUT_WORD
	sw $v0, operation_choice

	PRINT arg1_ascii
	INPUT(arg1, 31)
	VALIDATE_DOUBLE arg1
	beqz $v0, nanError
	SAVE_DOUBLE arg1, d_arg1

	PRINT arg2_ascii
	INPUT(arg2, 31)
	VALIDATE_DOUBLE arg2
	beqz $v0, nanError
	SAVE_DOUBLE arg2, d_arg2
	
	l.d $f20, d_arg1
	l.d $f22, d_arg2
	
	lw $t1, operation_choice
	beq $t1, 1, op_add
	beq $t1, 2, op_sub
	beq $t1, 3, op_mul
	beq $t1, 4, op_div

op_add:
	add.d $f20, $f20, $f22
	s.d $f20, d_result
	j result_print
op_sub:
	sub.d $f20, $f20, $f22
	s.d $f20, d_result
	j result_print
op_mul:
	mul.d $f20, $f20, $f22
	s.d $f20, d_result
	j result_print
op_div:
	li $t1, 0
	mtc1.d $t1, $f0
	cvt.d.w $f0, $f0
	c.eq.d $f0, $f22
	bc1t zeroError
	
	div.d $f20, $f20, $f22
	s.d $f20, d_result
	j result_print
result_print: 
	PRINT result
	PRINT_DOUBLE d_result
	PRINT newline
	j repeat
nanError:
	PRINT nan_error
	PRINT newline
	j repeat
zeroError:
	PRINT zero_div_error
	PRINT newline
	j repeat
repeat: 
	PRINT newline
	PRINT repeat_ascii
	INPUT_WORD
	bnez $v0, loop


