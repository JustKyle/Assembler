# Kyle Rogers
# Assembler
# Dr. Hale
#
# Programming Assignment 0, Exercise 2.39
# Write the MIPS assembly code that creates the 32-bit constant 0010 0000 0000 0001 0100 1001 0010 0100 and stores that value to register $t1

li	$t1, 0x20014294		# Load the hex value for the constant into register $t1

li	$v0, 35			# Load the syscall code for print to binary into register $v0
addi	$a0, $t1,$zero		# Store the value in $t1 to $a0 so it gets printed when syscall runs
syscall