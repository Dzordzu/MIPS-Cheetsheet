.data
name: .asciiz "Ex3 (5pt)\n"
menu: .asciiz "Choose option\n1 x^n\n2 x!\n Your choice: "
factorialChoice: .asciiz "Factorial has been chosen\n"
powerChoice: .asciiz "Power has been chosen\n"
enter_x: .asciiz "x="
enter_n: .asciiz "n="
newline: .asciiz "\n"
wrong_inp: .asciiz "Wrong input\n"
repeat_question: .asciiz "Repeat?\n0 no\n1 yes\n"

.macro print_newline
	li $v0, 4
	la $a0, newline
	syscall
.end_macro



.macro terminate (%termination_value)
	li $a0, %termination_value
	li $v0, 17
	syscall
.end_macro



.macro print_str (%message)
	li $v0, 4
	la $a0, %message
	syscall
.end_macro



.macro inp_word (%register)
	li $v0, 5
	syscall
	add %register, $v0, 0
.end_macro



.macro for (%regIterator, %start, %end, %bodyMacro)
	add %regIterator, $zero, %start
loop:
	%bodyMacro ()
	add %regIterator, %regIterator, 1
	ble %regIterator, %end, loop
.end_macro



.macro factorialMacro
	mult $t2, $t3
	mflo $t2
.end_macro



.macro powerMacro
	mult $t4, $t2
	mflo $t4
.end_macro



.text
	print_str name
main:
	print_str menu
	li $v0, 5
	syscall
	
	beq $v0, 1, power
	beq $v0, 2, factorial
	print_str wrong_inp
	j main
power:
	print_str powerChoice
	print_str enter_x
	inp_word $t2 # power base
	print_str enter_n
	inp_word $t5 # power exponent
	li $t4, 1 # result
	for($t3, 1, $t5, powerMacro) # do a whole magic
	
	# print our result
	li $v0, 1
	add $a0, $zero, $t4
	syscall
	print_newline
	
	j repeat
factorial:
	print_str factorialChoice
	print_str enter_x
	li $t2, 1 # result
	inp_word $t4 # iterations amount
	
	for($t3, 1, $t4, factorialMacro)
	
	li $v0, 1
	add $a0, $zero, $t2
	syscall
	print_newline
	
	j repeat
repeat:
	print_str repeat_question
	inp_word $t1
	beq $v0, 1, main
	terminate 0
