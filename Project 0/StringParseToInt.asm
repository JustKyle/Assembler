# Kyle Rogers
# Assembler
# Dr. Hale
#
# Programming Assignment 0, Exercise 2.37
# Write a program in MIPS assembly language to convert an ASCII number string containing
# positive and negative integer decimal strings, to an integer. Your program should expect
# register $a0 to hold the address of a null-terminated string containing some combination 
# of the digits 0 through 9. Your program should compute the integer value equivalent to 
# this string of digits, then place the number in register $v0. If a non-digit character appears
# anywhere in the string, your program should stop with the value -1 in register $v0.

.data
buffer: .space 11
prompt: .asciiz "Enter a positive or negative integer: "
.text

getStr:	la $a0,prompt	# store the prompt into register $a0
	li $v0,4	# Load the syscall code to print a string
	syscall		# Print the prompt
	li $v0,8	# Load the syscall code to read a string from user
	la $a0,buffer	# ASSUME: Input will not exceed 11 characters, allcoate space for up to 10 characters
	li $a1,11	# ASSUME: Input will not exceed 11 characters, allcoate space for up to 10 characters
	syscall
	
	li $v0,0	# Clear $v0
	li $s1,0x2D	# Store the ASCII code for '-' for later comparison
	li $s2,0x30	# Store the ASCII code for '0' for later comparison
	li $s3,0x39	# Store the ASCII code for '9' for later comparison
	li $s4,0x1	# Store a 1 for later comparison for negative or positive numbers
	
	lbu $t0,0($a0)		# Load the first byte of the string into $t1
	beq $t0,$s1,negative	# If the first character is a '-' jump to the negative label
test:	blt $t0,$s2,error	# If $t1 has an ASCII code less than '0', then return an error
	bgt $t0,$s3,error	# If $t1 has an ASCII code greater than '9', then return an error
	sub $t0,$t0,$s2		# Find the integer that the ASCII code represents
	add $v0,$v0,$t0		# Add the integer to $v0
	addi $a0,$a0,1		# Increase the address offset by 1 byte
	lbu $t0,0($a0)		# Load the next byte
	beq $t0,10,final	# If it is the end of the string, jump to the end
	mul $v0,$v0,10		# Multiply the integer by 10
	j test		# Jump back to beginning
	
negative: addi $s4,$s4,-2	# Set as a negative 1 to make the integer negative at the end
	  addi $a0,$a0,1	# Increase the address offset by 1 byte
	  lbu $t0,0($a0)	# Load the next byte
	  beqz $t0,final	# If it is the end of the string, jump to the end
	  mul $v0,$v0,10	# Multiply the integer by 10
	  j test		# Jump back to test

error:
.data
message: .asciiz "There was an issue with your input, the program was terminated"
.text
	la $a0,message	# store the error message into $a0
	li $v0,4	# Load the sycall code to print the error
	syscall	
	j quit

setneg: mul $v0,$v0,-1 	# Set the integer as negative
	j final2

final:  beq $s4,-1,setneg
final2:	move $a0,$v0	# Move the integer from $v0 back to $a0 to be printed
	li $v0,1	# Load the code to print integers
	syscall
quit: