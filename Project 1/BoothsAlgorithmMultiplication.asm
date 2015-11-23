# Kyle Rogers
# CS 2033 - Assembler
# Dr. Hale
#
# Implement Booth's algorithm for 32 bit integers in MIPS. Your program should accept keyboard string input (up to 12 characters) 
# and interpret them as ints (hint: adapt your program 0 assignment) and present the results exactly as described in the following way:
#
# Your program will need to ‘show its work’ by printing out inputs, intermediate computations through each iteration and results as described below. 
# Print out the multiplication problem as follows (the example below is for a four-bit multiplication, yours will be 32 bit).
#
# It should, as in the previous assignment, check for non-numeric inputs and be able to accept negative numbers.
#
# After the multiplicand and multiplier have been entered as strings and interpreted as integers... print to the console the multiplicand, 
# the multiplier, the intermediate value of the results register at each iteration (there will be 32) and the final result, all as below:


.data
buffer: .space 13
prompt: .asciiz "Enter a positive integer to be the multiplicand: "
nLine: .asciiz "\n"
.text

Mcand:	   la $a0,prompt	# store the prompt into register $a0
	   li $v0,4		# Load the syscall code to print a string
	   syscall		# Print the prompt
           li $v0,5		# Load the syscall code to read an integer from user
	   la $a0,buffer	# ASSUME: Input will not exceed 12 characters, allcoate space for up to 12 characters
	   li $a1,12		# ASSUME: Input will not exceed 12 characters, allcoate space for up to 12 characters
	   syscall
	   add $s0,$v0,$zero	# Store the Multiplicand in the $s0 register
	   
.data
prompt2: .asciiz "Enter a positive integer to be the multiplier: "
.text

Mplier:	  la $a0,prompt2	# store the prompt into register $a0
	  li $v0,4		# Load the syscall code to print a string
	  syscall		# Print the prompt
          li $v0,5		# Load the syscall code to read an integer from user
	  la $a0,buffer		# ASSUME: Input will not exceed 12 characters, allcoate space for up to 12 characters
	  li $a1,12		# ASSUME: Input will not exceed 12 characters, allcoate space for up to 12 characters
	  syscall
	  add $s1,$v0,$zero	# Store the Multiplier in the $s1 register
	  li $s5,0		# Initialize 32-bit left half of product in $s5
	  
	  li $s3,0		# Store 0 in $s3 to be the overflow bit starting out
	  li $s4,0		# Store 0 for an incremental value to tell when to end the multiplication
	  
.data
lines: "----------------------------------------------------------------\n"
space: "  "
spacex: "x "
.text

initPrint:la $a0,space
          li $v0,4
          syscall		# Print two spaces before the multiplier
	  li $v0,35
	  li $a0,0
          add $a0,$s0,$zero
          syscall		# Print Multiplier in binary
          la $a0,nLine
          li $v0,4
          syscall		# Print a a new line
          la $a0,spacex
          syscall		# Print a multiplication sign before the multiplicand
          li $v0,35
          li $a0,0
          add $a0,$s1,$zero
          syscall		# Print Multiplicand
          la $a0,nLine
          li $v0,4
          syscall		# Print a new line
          la $a0,lines
          syscall		# Print a separator line
           
	  
getStep:  li $t0,0		# Ensure $t0 is empty prior to receiving lsb
	  andi $t0,$s1,1	# Get the least Significant bit of the product
	  and $t1,$s3,$t0	# Determine if they are different or both 0
	  beqz $t1,eqZero	# If they are different or both 0, go to eqZero label
	  beq $t1,1,eqOne	# If the overflow bit and last bit of product are equal then go to eqOne label

eqZero:   li $t1,0
	  add $t1,$s3,$t0	# Add the two bits together
	  beq $t1,1,whichBit	# Jump to whichBit if $t1 = 1

eqOne:    li $s3,0		# Clear the overflow bit
	  move $s3,$t0		# Move the lsb of product to overflow bit
	  srl $s1,$s1,1		# Shift the product right by 1 bit
	  li $t0,0		# Clear $t0
	  andi $t0,$s5,1	# get lsb of left side product
	  sra $s5,$s5,1		# Shift the left side right by 1 bit
	  addi $s4,$s4,1	# Increment the counter by 1
	  beq $t0,1,addOne	# Move lsb of 1 to msb of $s1
	  j inter		# Print intermediate values

whichBit: beq $s3,1,zeroOne	# Go to zeroOne if the lsb of the product is 0 and overflow is 1
	  beq $t0,1,oneZero	# Go to oneZero if the lsb of the product is 1 and overflow is 0

zeroOne:  add $s5,$s5,$s0	# Add the Multiplicand to the left side product
	  j eqOne		# Jump back to eqOne to do the shifting

oneZero:  sub $s5,$s5,$s0	# Subtract the Multiplicand fromt he left side product
	  j eqOne		# Jump back to eqOne to do the shifting

addOne:   addi $s1,$s1,2147483648 # Add 1 to msb of $s1
	  j inter		  # Print intermediate values

inter:    li $a0,0
	  li $v0,35
          add $a0,$s5,$zero
          syscall		# Print left half of product
          li $a0,0
          add $a0,$s1,$zero
          syscall		# Print right half of product
          la $a0,nLine
          li $v0,4
          syscall
          beq $s4,32,exit	# Exit the program and print final answer
          j getStep
          
exit:	  li $v0,4
          la $a0,lines
          syscall		# Print a separator line
          li $a0,0
	  li $v0,35
          add $a0,$s5,$zero
          syscall		# Print left half of product
          li $a0,0
          add $a0,$s1,$zero
          syscall		# Print right half of product