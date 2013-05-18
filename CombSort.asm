##  void comb_sort(T* input, int size, bool ascending)
##	t* input = $a0
##	int size = $a1
##	bool ascending = $a3
########################################################
##	temp = $s0
##	i = $s1
##	gap = $s2
##	bool swapped = $s3
########################################################

	.data
comb_gap:
	.double 1.3


	.text
comb_sort:
	add $s2, $a1, $zero	#	gap = size
	li $s3, 0		#	swapped = false
	
	j comb_while_bottom

comb_while_top:
	
	ble $s2, 1, if_continue	# if gap > 1 do following, else continue
	mtc1 $s2, $f1		#	convert (int)gap to single prec. floating point
	cvt.s.w $f1, $f1	#	convert (int)gap to single prec. floating point	now $f1 = (double)gap

	l.s $f2, comb_gap	#	loads gap ( = 1.3 ) on to $f2
	
	div.s $f3, $f1, $f2	# 	$f3 = (double)(gap / 1.3)
	
	cvt.w.s $f3, $f3	#	
	mfc1 $s2, $f3		#	gap = (int)((double)gap/ 1.3)
	
	
if_continue:			# not if, continues
	li $s3, 0		#	swapped = false
	
	#	starting of for loop
	add $s1, $zero, $zero	#	i = 0
	j comb_for_bottom

comb_for_top:
########## if else part (inside of the for loop)
	bne $a3, 1, comb_for_not_asc	# branch if not ascending ( != 1 )
	#ascending part
	#	if (input[i] - input[i + gap] > 0)
	sll $t2, $s1, 2		#	$t2 = i*4
	add $t2, $a0, $t2	#	$t2 = input[i]'s address
	
	add $t3, $s1, $s2	#	$t3 = i + gap
	sll $t3, $t3, 2		#	$t3 = (i+gap) * 4
	add $t3, $a0, $t3	#	$t3 = input[i+gap]'s address
	
	lw $t5, 0($t2)		# 	get the value of input[i]
	lw $t6, 0($t3)		#	get the value of input[i + gap]
	sub $t4, $t5, $t6	#	$t4 = input[i] - input[i + gap]
	ble $t4, 0, comb_for_update	#	if $t4 is NOT >0 then go to increment
	
        add $s0, $t5, $zero	#	temp = input[i]
        sw $t3, 0($t2)		#	input[i] = input[i + gap];
        sw $s0, 0($t3)		#	input[i + gap] = temp;
        li $s3, 1		#	swapped = true;
        
comb_for_not_asc:
	#	if (input[i] - input[i + gap] < 0)
        sll $t2, $s1, 2		#	$t2 = i*4
	add $t2, $a0, $t2	#	$t2 = input[i]'s address
	
	add $t3, $s1, $s2	#	$t3 = i + gap
	sll $t3, $t3, 2		#	$t3 = (i+gap) * 4
	add $t3, $a0, $t3	#	$t3 = input[i+gap]'s address
	
	lw $t5, 0($t2)		# 	get the value of input[i]
	lw $t6, 0($t3)		#	get the value of input[i + gap]
	sub $t4, $t5, $t6	#	$t4 = input[i] - input[i + gap]
	bge $t4, 0, comb_for_update	#	if $t4 is NOT <0 then go to increment
	
        add $s0, $t6, $zero	#	temp = input[i + gap];
        sw $t2, 0($t3)		#	input[i + gap] = input[i];
        sw $s0, 0($t2)		#	input[i] = temp;
        li $s3, 1		#	swapped = true;
        
comb_for_update:
	addi $s1, $s1, 1	#	i++
##########
comb_for_bottom:		#	for loop testing
	add $t0, $s2, $s1	#	$t0 = gap + i
	blt $t0, $a1, comb_for_top	# gap + i < size
		
	
comb_while_bottom:		#	while loop testing
	sgt $t1, $s2, 1		#	gap > 1 => $t1=1
	or $t1, $t1, $s3	#	$t1=1 if (gap>1 || swapped)
	beq $t1, 1, comb_while_top
	
	#jr $ra
