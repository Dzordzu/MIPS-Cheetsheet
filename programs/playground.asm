# PLAYGROUND

.data
	newline: .asciiz "\n"
	space: .asciiz  " "
	arrow: .asciiz " -> "
	plus: .asciiz " + "
	minus: .asciiz " - "
	versus: .asciiz " vs "

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

.macro ALLOCATE_WORD(%var, %macro)
	addiu $sp, $sp, -4
	sw $v0, ($sp)
	
	%macro()
	
	lw $v0, ($sp)
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


# Prints message. Simply
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



.data
text: .asciiz "Some awesome text"
.text
	 # li $v0, 1
	 # li $a0, 12
	
	 # PRINT text

	 # syscall

	# Expected output: Some awesome text12
	
# Ctrl-c Ctrl-v...
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

# Check whether $a0 is in the range of (min, max)
# Returns 1 if yes, 0 if not
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

.data
imer_num1: .word 10
imer_num2: .word 98
imer_byte: .byte 'S'

.text
in_immediate_range_test:
	
	# li $t1 12

	 # lb $a0, imer_byte
	 
	 # IN_IMMEDIATE_EXCLUSIVE_RANGE(3, 77)
	 # IN_IMMEDIATE_EXCLUSIVE_RANGE(64, 91)
	 # move $a0, $v1
	 # li $v0, 1
	 # syscall
	
	# li $v0, 1
	# move $a0, $t1
	# syscall
	
	# Should print:
	# 112 for $a0
	# 012 for $a1
	
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

# !!!!!!!!!!! EXAMPLE !!!!!!!!!!!

# NH standds for numeric, big
# Starts with the address of the first one letter pointer ($a0 is iterator)
# Here it just prints characters
# Modification is required (in order to get something useful)

.macro NON_WHITE_LOOP_NH_ASCIIZ
	
	# Now $t1 is iterator (we need $a0)
	move $t1, $a0
	addiu $t1, $t1, -1 
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
	li $v0, 11
	syscall	
	j loop
end:
.end_macro

.data
nwlnha_text1: .asciiz "oAA"
nwlnha_text2: .asciiz "SoME awESOme text thAt is 1002345678 long    and havZ 	;;; *** 7878 nevermind..."

.text
	# la $a0, nwlnha_text1
	# NON_WHITE_LOOP_NH_ASCIIZ
	# PRINT newline
	# la $a0, nwlnha_text2
	# NON_WHITE_LOOP_NH_ASCIIZ
	


	# Expected output 
	#	AA
	#	SMEESOA1002345678Z7878




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

.text
upperc_test:
	# PRINT nwlnha_text2
	# PRINT newline
	# la $a0, nwlnha_text2
	# UPPERCASE 
	
	# PRINT nwlnha_text2
	
	# Expected: 
	#	SoME awESOme text thAt is 1002345678 long    and havZ 	;;; *** 7878 nevermind...
	#	SOME AWESOME TEXT THAT IS 1002345678 LONG    AND HAVZ 	;;; *** 7878 NEVERMIND...


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

# Normal cesar cipher
.macro CESAR_CIPHER (%difference)
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
	IN_IMMEDIATE_EXCLUSIVE_RANGE(47, 91)
	
	# If not in range loop again
	# not $t2, $t2
	beqz $v1, loop
funct:
	# Change to next
	addiu $a0, $a0, %difference 
	blt $a0, 91, inRange
	
	# Modulo
	div $a0, $a0, 43
	mfhi $a0
	addiu $a0, $a0, 48 
inRange:
	sb $a0, ($t1)
	j loop
end:
	lw $t1, ($sp)
	addiu, $sp, $sp, 4
.end_macro 

.data
cs_text: .asciiz "TESTSAKURWO"
	# "0DABDUPADEBOWA123ZZ0"

.text
# cs_test:
	# PRINT cs_text
	# PRINT newline
	# la $a0, cs_text
	# CESAR_CIPHER (11)
	# PRINT cs_text



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

# Normal cesar cipher
# $a0 text ptr
# $a1 key ptr

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
	div $a0, $a0, 43
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

.data
vin_enc_key: .asciiz "TEST"

.text
cs_test:
	#PRINT cs_text
	#PRINT newline
	#la $a0, cs_text
	#la $a1, vin_enc_key
	#ENCRYPT_VIGENERE
	#PRINT cs_text
	#PRINT newline
	
	# Expected
	# 	DABDUPADEBOWA123ZZ0
	# 	5PP7F4P5TPBHP@NB=ML


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

.text
vin_dec_test:
	  #la $a0, cs_text
	  #la $a1, vin_enc_key
	  #DECRYPT_VIGENERE
	  #PRINT cs_text

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

.macro COPY_ASCII (%src, %trg, %size)
	la $a0, %src
	la $a1, %trg
.end_macro

.data
ca_src: .asciiz "Test szmato"
ca_trg: .space 50
ca_trg2: .space 50

.text
	#la $a0, ca_src
	#la $a1, ca_trg
	#COPY_ASCII 87
	#PRINT ca_trg
	#
	#PRINT newline
	#
	#la $a0, ca_trg
	#la $a1, ca_trg2
	#COPY_ASCII 876
	#PRINT ca_trg2

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

.data
adat: .asciiz "Test"
bdat: .asciiz "Test"
cdat: .asciiz "Tests"
ddat: .asciiz "test"

.text
	la $a0, adat
	la $a1, adat
	COMPARE_STR
	move $t1 $v0
	PRINT_BYTE $t1

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




