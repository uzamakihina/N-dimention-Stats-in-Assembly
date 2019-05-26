


.text

### cubestats function

CubeStats:


	addi $t0, $zero, 1		#  temporary 1 used to test if the call is at 1 dimention


	addi $sp, $sp, -4 		# grow stack for fp
	sw $fp, 0($sp) 			# save fp
	move $fp, $sp 	 		# move fp	save fp
	addi $sp, $sp, -24		# grow stack for 5 saved registers


	sw $s0, -4($fp)			# save all saves registers in stack
	sw $s1, -8($fp)
	sw $s2, -12($fp)
	sw $s3, -16($fp)
	sw $ra, -20($fp)
	sw $s5, -24($fp)

	# moves parameter into saved registers

	addi $s0, $a0, 0 		# $s0 = dimentions
	addi $s1, $a1, 0 		# $s1 = gridlength
	addi $s2, $a2, 0 		# $s2 = address of first element
	addi $s3, $a3, 0 		# $s3 = size of grid being added



	# set all t 1-4  registers to 0 incase they are effected by previous calls

	addi $t1, $zero,0		# $t1 will be total positives
	addi $t2, $zero,0		# $t2 will be total negatives
	addi $t3, $zero,0		# $t3 number of positive values
	addi $t4, $zero,0		# $t4 number of negative value



	beq $s0, $t0, count_line	# if dim = 1 count traverse the line
					# else recursive call the dimentions




	addi $sp, $sp, -8		# grow stack
	sw $a0, -28($fp)		# save parameter a0
	sw $a2, -32($fp)		# save parameter a2

	addi $a0, $a0, -1		# reduce dimention for lower calls
	j ultra				# ultra calculate the gridlength ^ (dim -1) which is used to move to next section of cube
got_pow:				# $s5 is returned as the dim range



	sll $s5, $s5, 2 		# mult by 4 to get the word move size

traverse:
	# This section does a loop edge amount of times, each time one section further down the count edge.



	jal CubeStats			# call itself with dim-1 at current address
	addi $s3, $s3, -1		# 1 less grid size to add
	add $a2, $a2, $s5 		# add adress by dimention traverse size
	bne $s3, $zero, traverse	# if size of grid being added is 0 stop

	lw $a0, -28($fp)		# restore dimention for parent calls
	lw $a2, -32($fp)		# restore address to origonal address
	addi $sp, $sp, 8

	addi $t1, $zero,0		# restore temp registers to 0 since there this is not base case
	addi $t2, $zero,0		# restore $t2 $t1
	addi $t3, $zero,0		# rstore $t3
	addi $t4, $zero,0		# restore $t4

	j cont				# continue to leaving call step


	# This section is used to calculate the jump from its current sector to the next.
	# The algorithm schemat is current addrress + (base_edge)^(dimention -1)

ultra:
	addi $s5, $zero, 1		# s5 holds the jump size
	move $s4, $a0		  	# s4 keeps track  how many times to multiply
kep_mul:				# multiply edge by dimention -1 amount of times
	beq $s4, $zero, got_pow		# if done multiplying go back
	mult $s5, $s1			# multiply by base_edge
	mflo $s5  			# restore back value from lo register
	addi $s4, $s4, -1 		# update times to multiply
	j kep_mul			# loop if power not complete




cont:

		# This section loads the added values to the total value
		# if its not a 1 dimention call then it does nothing to the total values

	la $t0, totalNeg		# load negative counter
	lw $t5, 0($t0)			# t5 total neg value
	add $t5, $t5, $t2		# add with this calls negative
	sw $t5, 0($t0)			# update negative counter

	move $t2, $t5			# t2 is total neg

	la $t0, totalPos		# load address total positive
	lw $t5, 0($t0)			# load value into t5
	add $t5, $t5, $t1		# add $t5 by this calls positive value
	sw $t5, 0($t0)			# store it back to total positive

	move $t1, $t5 			# saves totalpositive this value for return register

	la $t0, countNeg		# load negative address and
	lw $t5, 0($t0)			# stores it in $t5
	add $t5, $t5, $t4		# add its to this calls negative
	sw $t5, 0($t0)			# updates total negative

	move $t4, $t5			# saves total neg for return register

	la $t0, countPos		# loads address of count positive
	lw $t5, 0($t0)			# loads the value to t5
	add $t5, $t5, $t3		# add its to this calls positives
	sw $t5, 0($t0)			# updates value

	move $t3 , $t5 			# saves t3 for return calculation


	beq $t3, $zero, zero_pos	# dont divide if divisor is 0

	div $t1, $t3			# divide positives
	mflo $t1			# moves round down number to $t1


zero_pos:

	move $v1, $t1			# move positive to v1


	beq $t4, $zero, neg_done	# dont divide if divisor is 0

	div $t2, $t4			# divide negative total
	mflo $t2			# $t1 is the divided negative number
	mfhi $t3 			# move remainder to $t3
	bne $t3, $zero, round  		# if remiander not zero minus round down




neg_done:
	move $v0, $t2 			# move  negative to v0 register


	j exit


round:
	addi $t2, $t2, -1		# rounds down the negative value
	j neg_done			# finish adding negative






exit:



	lw $s0, -4($fp)			# restore all registers in stack
	lw $s1, -8($fp)			# from s0 to s5 and return address
	lw $s2, -12($fp)
	lw $s3, -16($fp)
	lw $ra, -20($fp)
	lw $s5, -24($fp)
	addi $sp, $sp, 24		# shrink the stack from previous amount
	lw $fp, 0($sp)			# restore frame pointer
	addi $sp, $sp, 4		# shrink stack pointer
	jr $ra				# return




count_line:				# counts the 1d array edge amount of times


        # stores the values in temp registers then places the sum in the total memory address
	# since accessing the memory every time it counts looses too much performance.

	addi $t1, $zero,0		# $t1 will be total positives
	addi $t2, $zero,0		# $t2 will be total negatives
	addi $t3, $zero,0		# $t3 number of positive values
	addi $t4, $zero,0		# $t4 number of negative value


					# $s2 = first address $s3 = times to move forward

loop2:
	lw $t5, 0($s2)			# load value at memory






	bgtz $t5, add_pos		# add if greater than 0
	bltz $t5, add_neg		# go to negative if less than 0
back:	addi $s3, $s3, -1		# reduce numbers neede to add
	addi $s2, $s2, 4		# move memory by 1 word
	bne $s3, $zero, loop2		# if more numbers to add loop

	j cont				# jump to leaving function call procedure



add_pos:				# process for adding if its a positive number
	add $t1, $t1, $t5		# add positive by number in array
	addi $t3, $t3, 1		# add positive count by 1
	j back				# finish

add_neg:				# process for adding if its a negative number
	add $t2, $t2, $t5		# adds total negative by new digit
	addi $t4, $t4, 1		# add 1 to temperary total
	j back
