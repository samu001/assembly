.text

main:
# Promt to enter a number (n)
la $a0,prompt   
li $v0,4
syscall

#Get number(n)
li $v0,5  
syscall

move $s0,$v0          #store n on $s0
addi $t3, $t3, 1      #store the result on $t3
jal outer_function    #call outer function 

la $a0,result   #Print "C_"
li $v0,4
syscall

move $a0,$s0    #Print "n"
li $v0,1
syscall

la $a0,result2  #Print "="
li $v0,4
syscall

#Print final rv 
li $v0,1
move $a0,$t3 
syscall

la $a0,endl #Print '\n'
li $v0,4
syscall

# End program
li $v0,10
syscall


outer_function:
	   addi $s1, $s1, 1   #$s1(i) = 1
	     
		outer_for:			
			slt $t0, $s1, $s0 #if i < n exit the outer loop
			beq $t0, $zero, outer_exit
			
			addi $sp, $sp, -4     #allocate space in stack
			sw $ra, 0($sp)       #save adress to the stack
                       
                       jal inner_function	#go to inner funtion
                                 
                       mul $s1, $s1, 2   #i *=2
                       
                       lw $ra, 0($sp)    #Restore stack and address
                       addi $sp, $sp, 4
                       
			j outer_for
		outer_exit:			
		jr $ra
			
			
inner_function:
		move $t1, $s1  # j = i
			
		inner_for:	 
			                                     
			 slt $t0, $t1, $zero     #if j < 0, stop the loop
		         bne $t0, $zero, inner_exit
                   	                                  	                 
                        #Find out if number is even or odd
                        li  $t0, 2
                        div $t1, $t0        #Divide j / 2 
        		 mfhi $t6            #Store the reminder
                        beq $t6, 1, odd     #if reminder is 1, branch to odd
                   	 j even              #else branch to even
                   	   
                   	    odd:
                   		mul $s3, $s1, 2     #2*i
                   		mul $s2, $t1, 3     #3*j
                   		sub $t4, $s3, $s2   #(2*i) - (3*j)
                   		add $t3, $t3, $t4   #rv = rv + ((2*i)-(3*j));
                   		j exit_if
                   		
                   	   even:                  		
                   		add $s3, $s1, $t1   #i + j
                   		add $t3, $t3, $s3   #rv = rv + (i+j);               		
                   	        j exit_if         
                   	
   			exit_if:
   		           li $t0, 1 
                          sub $t1, $t1, $t0        #j--                   
			   j inner_for
		
		inner_exit:
		jr $ra
		
.data
prompt: .asciiz "Enter a non-negative number less than 100: "
result: .asciiz "C_"
result2: .asciiz " = "
endl: .asciiz "\n"

