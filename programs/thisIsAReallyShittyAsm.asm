			.data
			welcomeMessage: .asciiz "Wybierz swoj symbol \no - kólko x - krzyrzyk \nWybor: "
			WiadomoscBlad: .asciiz "\nPomylka wybierz x lub o!!!"
			gamesAmount: .asciiz "\nIle gier? (1-5) "
			gamesValNotInRange: .asciiz "\nIlosc gier nie jest w podanym zakresie"
			PodajMiejsce: .asciiz "\nPodaj miejsce: "	
			krzyrzyk: .asciiz "x"
			kolko: .asciiz "o"
			tablica: .word 0:9	
			linia: .ascizz "-----------"	
			kreska: .asciiz " | "
			enter: .asciiz "\n"
			spacja: .asciiz " " 
			gamesAmountVal: .word 0
			gamesWon: .word 0

			.macro PRINT_4 (%x)
			la $a0, %x
			li $v0, 4
			syscall
			.end_macro

			.macro PRINT (%x)
			move $a0, %x
			li $v0, 4	
			syscall
			.end_macro

			.macro IN_12
			li $v0, 12
			syscall
			.end_macro

			.macro IN_5
			li $v0, 5
			syscall
			.end_macro
			
			
			.text

chooseYourSign: 
			PRINT_4  welcomeMessage
			IN_12
			beq $v0, 'o', oChosen
			nop
			 
			beq $v0, 'O', oChosen		
			nop
			
xChosen:
			j gamesAmountEnter
oChosen:
			li $t0, 'O'
			li $t1, 'X'
			
			sb $t0, x
			sb $t1, o

gamesAmountEnter:
			PRINT_4 gamesAmount
			IN_5
			
			bgt $v0, 5, notInRangeGamesAmount
			nop
			  
			blt $v0, 0, notInRangeGamesAmount
			nop
			
			sw $v0, gamesAmountVal
			
			j main
			
			
notInRangeGamesAmount:
			PRINT_4 gamesValNotInRange
			j gamesAmountEnter
			
			
			
			.globl main
main:
			lw $t1, gamesAmountVal
			beq $t1, $zero, thisIsTheEnd
			sub $t1, $t1, 1
			sw $t1, gamesAmountVal
			
			li $t1, 0
			li $t2, 0
			li $t3, 0
			li $t4, 0
			li $t5, 0
			li $t6, 0
			li $t7, 0
			li $t8, 0
			li $t9, 0

			li $s0, 0
			li $s5, 0

			la $s1, board
			la $s2, askMove
			la $s3, won

			lb $a1, clean
			sb $a1, 14($s1)
			sb $a1, 18($s1)
			sb $a1, 22($s1)
			sb $a1, 40($s1)
			sb $a1, 44($s1)
			sb $a1, 48($s1)
			sb $a1, 66($s1)
			sb $a1, 70($s1)
			sb $a1, 74($s1)

PrintBoard:
			li $v0, 4
			la $a0, board
			syscall

			beq $s5, 9, Tie

			add $s5, $s5, 1

			rem $t0, $s0, 2
			add $s0, $s0, 1
			
			bnez $t0, Player0

PlayerX:
			lb $a1, x
			sb $a1, 7($s2)
			sb $a1, 9($s3)
			j Play
Player0:
			lb $a1, o
			sb $a1, 7($s2)
			sb $a1, 9($s3)
			j Playy

Play:
			li $v0, 4
			la $a0, askMove
			syscall

			li $v0, 5
			syscall
			move $s6, $v0

			beq $s6, 1, J11
			beq $s6, 2, J21
			beq $s6, 3, J31
			beq $s6, 4, J12
			beq $s6, 5, J22
			beq $s6, 6, J32
			beq $s6, 7, J13
			beq $s6, 8, J23
			beq $s6, 9, J33

			li $v0, 4
			la $a0, invalidMove
			syscall
			j Play
			
Playy:
			

			beq $t1, $0, J11
			nop
			beq $t5, $0, J22
			nop
			beq $t9, $0, J33
			nop
			beq $t2, $0, J21
			nop
			beq $t6, $0, J32
			nop
			beq $t4, $0, J12
			nop
			beq $t7, $0, J13
			nop
			beq $t8, $0, J23
			nop
			beq $t3, $0, J31

			

J11:
			bnez $t1, Occupied
			bnez $t0, O11

			X11:
			li $t1, 1
			sb $a1, 14($s1)
			j CheckVictory

			O11:
			li $t1, 2
			sb $a1, 14($s1)
			j CheckVictory

J21:
			bnez $t2, Occupied
			bnez $t0, O21

			X21:
			li $t2, 1
			sb $a1, 18($s1)
			j CheckVictory

			O21:
			li $t2, 2
			sb $a1, 18($s1)
			j CheckVictory

J31:
			bnez $t3, Occupied
			bnez $t0, O31

			X31:
			li $t3, 1
			sb $a1, 22($s1)
			j CheckVictory

			O31:
			li $t3, 2
			sb $a1, 22($s1)
			j CheckVictory

J12:
			bnez $t4, Occupied
			bnez $t0, O12

			X12:
			li $t4, 1
			sb $a1, 40($s1)
			j CheckVictory

			O12:
			li $t4, 2
			sb $a1, 40($s1)
			j CheckVictory

J22:
			bnez $t5, Occupied
			bnez $t0, O22

			X22:
			li $t5, 1
			sb $a1, 44($s1)
			j CheckVictory

			O22:
			li $t5, 2
			sb $a1, 44($s1)
			j CheckVictory

J32:
			bnez $t6, Occupied
			bnez $t0, O32

			X32:
			li $t6, 1
			sb $a1, 48($s1)
			j CheckVictory

			O32:
			li $t6, 2
			sb $a1, 48($s1)
			j CheckVictory

J13:
			bnez $t7, Occupied
			bnez $t0, O13

			X13:
			li $t7, 1
			sb $a1, 66($s1)
			j CheckVictory

			O13:
			li $t7, 2
			sb $a1, 66($s1)
			j CheckVictory

J23:
			bnez $t8, Occupied
			bnez $t0, O23

			X23:
			li $t8, 1
			sb $a1, 70($s1)
			j CheckVictory

			O23:
			li $t8, 2
			sb $a1, 70($s1)
			j CheckVictory

J33:
			bnez $t9, Occupied
			bnez $t0, O33

			X33:
			li $t9, 1
			sb $a1, 74($s1)
			j CheckVictory

			O33:
			li $t9, 2
			sb $a1, 74($s1)
			j CheckVictory

Occupied:
			li $v0, 4
			la $a0, occupiedSpace
			syscall
			j Play

CheckVictory:
			and $s7, $t1, $t2
			and $s7, $s7, $t3
			bnez $s7, Victory

			and $s7, $t4, $t5
			and $s7, $s7, $t6
			bnez $s7, Victory

			and $s7, $t7, $t8
			and $s7, $s7, $t9
			bnez $s7, Victory

			and $s7, $t1, $t4
			and $s7, $s7, $t7
			bnez $s7, Victory

			and $s7, $t2, $t5
			and $s7, $s7, $t8
			bnez $s7, Victory

			and $s7, $t3, $t6
			and $s7, $s7, $t9
			bnez $s7, Victory

			and $s7, $t1, $t5
			and $s7, $s7, $t9
			bnez $s7, Victory

			and $s7, $t7, $t5
			and $s7, $s7, $t3
			bnez $s7, Victory
			j PrintBoard

Victory:
			li $v0, 4
			la $a0, board
			syscall
			
			
			lb $t0, x
			lb $t1, won+9
			
			bne $t0, $t1, resultPrinter
			nop
			
			lw $t1, gamesWon
			addiu $t1, $t1, 1
			sw $t1, gamesWon
			
resultPrinter:
			li $v0, 4
			la $a0, won
			syscall
			j MenuNewGame

Tie:
			li $v0, 4
			la $a0, tie
			syscall

MenuNewGame:

			PRINT_4 currentResult
			
			li $v0, 1
			lw $a0, gamesWon
			syscall
			
			li $v0,4
			la $a0, gameMenu
			syscall

			li $v0,5
			syscall
			bne $v0, 0, main

			li $v0, 10
			syscall
thisIsTheEnd:
			PRINT_4 finalResult
			
			li $v0, 1
			lw $a0, gamesWon
			syscall


			.data
			currentResult: .asciiz "\nObecny wynik (wygrane): "
			finalResult: .asciiz "\nWynik koncowy (wygrane): "
			board: .asciiz "           \n    |   |   \n ---+---+---\n    |   |   \n ---+---+---\n    |   |   \n"
			askMove: .asciiz "Wstaw    (podaj numer od 1 do 9) "
			invalidMove: .asciiz "** Ruch niepoprawny **"
			occupiedSpace: .asciiz "** Komorka zajeta. Wybierz inna **\n"
			x: .asciiz "X"
			o: .asciiz "O"
			won: .asciiz "\nWygrywa  \n"
			tie: .asciiz  "\nRemis!"
			gameMenu: .asciiz "\n\nZagrac ponownie? \nJeszcze jak -  1 \t To ja podziekuje - 0\nTwoj wybor: "
			clean: .byte ' '
