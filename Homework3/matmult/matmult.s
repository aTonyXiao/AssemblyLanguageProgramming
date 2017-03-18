# matmult.s
# matmult

# Created by Tony Xiao on 11/15/15.
# Copyright © 2015 TonyXiao. All rights reserved.



.equ wordsize, 4
.equ matrixa, 2
.equ num_rows_a, 3
.equ num_cols_a, 4
.equ matrixb, 5
.equ num_rows_b, 6
.equ num_cols_b, 7
.text


.globl matMult
matMult:
prelogue:

push %ebp
movl %esp, %ebp

    subl $wordsize, %esp

    push %edi
    push %ebx
    push %esi

# int **c = (int **)malloc(sizeof(int *) * num_rows_a);
    movl num_rows_a * wordsize(%ebp), %eax
shll $2, %eax
    push %eax
    call malloc
    addl $wordsize, %esp
    movl %eax, %edi # edi is c**


    # ebx = 0;
    movl $0, %ebx
        movl $0, %ecx
    movl $0, %edx

# while (1)
# {
# 	if (ebx >= num_rows_a)
# 		break;

bloop:
	movl 3 * wordsize(%ebp), %eax
	cmp %eax, %ebx
	jb continueloop


done:
    movl %edi, %eax
    prologue:
    pop %esi
    pop %ebx
    pop %edi

movl %ebp, %esp
pop %ebp
ret



continueloop:
# 	c[ebx] = malloc(sizeof(int) * num_cols_b);
        movl 7 * wordsize(%ebp), %eax
	shll $2, %eax
	push %eax
        movl %edx, -wordsize(%ebp)
	call malloc
        movl -wordsize(%ebp), %edx
        addl $wordsize, %esp
	movl %eax, (%edi, %ebx, wordsize)

# 	ecx = 0;
	movl $0, %ecx

	cloop:
		movl num_cols_b * wordsize(%ebp), %eax
		cmp %eax, %ecx
		jb continue_cloop
        
	inc %ebx
        jmp bloop

continue_cloop:

# 		edx = 0;
		movl (%edi, %ebx, wordsize), %esi
            movl $0, (%esi, %ecx, wordsize)

            movl $0, %edx

# 		while (1)
# 		{
# 			if (edx >= num_cols_a)
# 				break;
		dloop:
			movl num_cols_a * wordsize(%ebp), %eax
			cmp %eax, %edx
			jb continue_dloop
        # c[ebx][ecx] += a[ebx][edx] * b[edx][ecx];

                
		inc %ecx
		jmp cloop


continue_dloop:
			movl matrixa * wordsize(%ebp), %eax
			movl (%eax, %ebx, wordsize), %eax # a[ebx][edx]
			movl (%eax, %edx, wordsize), %eax 

			movl matrixb * wordsize(%ebp), %esi
			movl (%esi, %edx, wordsize), %esi # b[edx][ecx]
			movl (%esi, %ecx, wordsize), %esi

			# movl %edx, dtemp
			push %edx
			imull %esi
			pop %edx
			# movl dtemp, %edx

			movl (%edi, %ebx, wordsize), %esi # edi is c**
			addl %eax, (%esi, %ecx, wordsize) # c[ebx][ecx]

        inc %edx
        jmp dloop
