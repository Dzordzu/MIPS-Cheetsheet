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


