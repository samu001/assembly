.text
main:
# Prompt user to input non-negative number
la $a0,prompt   
li $v0,4
syscall

li $v0,5        #Read the number(n)
syscall
move $t2,$v0    #store n on $t2

move $a0,$t2    #move n to a0
move $v0,$t2
jal sum_odd_factorial    #call function

move $t3,$v0    #result is in $t3

la $a0,result   #Print C_
li $v0,4
syscall

move $a0,$t2    #Print n
li $v0,1
syscall

la $a0,result2  #Print =
li $v0,4
syscall

move $a0,$t3    #Print the answer
li $v0,1
syscall

la $a0,endl #Print '\n'
li $v0,4
syscall

# End program
li $v0,10
syscall


sum_odd_factorial:
	#Push $ra $s0, and $s1 to stack
	addi $sp,$sp,-16
	sw $ra,0($sp)   #storing return address in stack
	sw $s0,4($sp)   #storing n in stack
	sw $s1,8($sp)   #storing i in stack
	sw $s2,12($sp)  #storing sum in stack

	move $s0, $a0	     #s0(n)
	move $s2, $zero	     #s2(sum) = 0
	addi $s1, $zero, 1  #s1(i) = 1

	for: 
		slt $t0, $s0, $s1   #loop from s1(i) to s0(n)
		bne $t0, $zero, exit
	
			move $a0, $s1          #move i to $a0 and that's the n for factorial(n)
			jal factorial          
			add $s2, $s2, $v0	#sum = sum + factorial(n)
	
		addi $s1, $s1, 2
		j for
		
	exit:
		move $v0, $s2	  #returning sum
		lw $ra,0($sp)    #restoring return address
		lw $s0,4($sp)    #restoring n
		lw $s1,8($sp)    #restore i
		lw $s2,12($sp)   #restore sum
		addi $sp,$sp,16
		jr $ra

factorial:
	li $v0, 1    #rv
	li $t1, 1    #j (or i)
		fact_for: 		
		        #loop from j($t1) to n($a0)   #loop while j <= n
			slt $t0, $a0, $t1
			bne $t0, $zero, fact_exit
							
				mul $v0, $v0, $t1  #rv = rv * j
		
			addi, $t1, $t1, 1  #j++
			j fact_for
		fact_exit:
			jr $ra

.data
prompt: .asciiz "This program calculates the sum of odd factorials\nEnter a non-negative number less than 100: "
result: .asciiz "C_"
result2: .asciiz " = "
endl: .asciiz "\n"
