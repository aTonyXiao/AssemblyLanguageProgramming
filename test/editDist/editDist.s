# editDist.s
# editDist

# Created by Tony Xiao on 10/25/15.
# Copyright � 2015 TonyXiao. All rights reserved.

.global _start
.data

.equ wordsize, 4 #size of a word

.equ matSize, 10201 #size of distance matrix

matrixDim: #dimension of the matrix
	.long 101

string1: #first comparison string, given 100 bytes of space
	.space 100
		
string2: #second comparison string, given 100 bytes of space
	.space 100
			
strlen1: #length of first string, intitialized to 0
	.long 0
					
strlen2: #length of second string, initialized to 0
	.long 0
					
disMatrix: #matrix of edit distances used to obtain final distance
	.rept matSize
		.long 0
	.endr
					
row: #row we are at in the distance matrix
	.long 1
					
col: #column we are at in the distance matrix
	.long 1
					
editDistance: #result of calculation
	.long 0
					
#three variables to store three potential minimum distances for a loop iteration
a:	.long 0					
b:	.long 0
c:	.long 0

.text

getStrIndex:

	#EDX stores string length (result)
	#EBX stores address of string
		
	movl $0, %edx #initialize length to 0
	decl %ebx

strLen:

	incl %edx
	incl %ebx	
	cmpb $0, (%ebx)
	jnz strLen	
	decl %edx #undoes last increment to make correct value	
	ret

formDisMat:

	#EAX EBX EDX utilized for general storage needs
	#ESI stores the current address in string1
	#EDI stores the current address in string2
		
	call iniDisMat #prepare the matrix for building
		
	#initialize EDI
	movl $string2, %edi
		
matrixRowLoop:

	movl $1, col
	movl $string1, %esi
	movl row, %ecx
	cmpl %ecx, strlen2
	jl retfunc
		
	matrixColLoop:
		movl col, %ecx
		cmpl %ecx, strlen1
		jl exitMatrixRowLoop
		
		movb (%esi), %cl
		cmpb %cl, (%edi)
		jz   ifCharMatch
		jmp  notMatch
				
		# free EAX EBX ECX EDX

ifCharMatch:

	movl $disMatrix, %ecx
	movl row, %eax
	decl %eax
	mull matrixDim
	addl col, %eax
	decl %eax						
	movl (%ecx, %eax, wordsize), %ebx					
	movl row, %eax
	mull matrixDim
	addl col, %eax				
	movl %ebx, (%ecx, %eax, wordsize)
	movl %ebx, editDistance
						
	jmp exitMatrixColLoop
				
notMatch:

	movl $disMatrix, %ecx
	movl row, %eax
	decl %eax
	mull matrixDim
	addl col, %eax					
	movl (%ecx, %eax, wordsize), %edx
	incl %edx
	movl %edx, a					
	movl row, %eax
	mull matrixDim
	addl col, %eax
	decl %eax					
	movl (%ecx, %eax, wordsize), %edx
	incl %edx
	movl %edx, b						
	movl row, %eax
	decl %eax
	mull matrixDim
	addl col, %eax
	decl %eax						
	movl (%ecx, %eax, wordsize), %edx
	incl %edx
	movl %edx, c						
	movl row, %eax
	mull matrixDim
	addl col, %eax
						
	#EAX stores current matrix index
	#EBX will be a
	#ECX will be b
	#EDX will be c

	movl a, %ebx
	movl b, %ecx
	movl c, %edx
						
	cmp %ebx, %ecx
	jg aOrC
	jmp bOrC
						
aOrC:
	cmp %ebx, %edx
	jg  aIsMin
	jmp cIsMin
						
bOrC:
	cmp %ecx, %edx
	jg  bIsMin
	jmp cIsMin
				
						
aIsMin:
	movl $disMatrix, %ecx
	movl %ebx, (%ecx, %eax, wordsize)
	movl %ebx, editDistance
	jmp exitMatrixColLoop
							
bIsMin:
	movl $disMatrix, %ebx
	movl %ecx, (%ebx, %eax, wordsize)
	movl %ecx, editDistance
	jmp exitMatrixColLoop
							
cIsMin:
	movl $disMatrix, %ecx
	movl %edx, (%ecx, %eax, wordsize)
	movl %edx, editDistance
	jmp exitMatrixColLoop
										
exitMatrixColLoop:
		
	incl col
	incl %esi
	jmp matrixColLoop
				
exitMatrixRowLoop:

	incl row
	incl %edi
	jmp matrixRowLoop

retfunc:
	ret
		
iniDisMat:
	#EAX stores the current address in the array
	#EBX  stores the current row or column
	#ECX  stores the length of the string
		
	movl $disMatrix, %eax  #get address of array
	movl $0, %ebx				 #init EBX to zero
		
initColLoop:
	movl %ebx, (%eax)
	addl $wordsize, %eax
	incl %ebx
		
	cmpl %ebx, strlen1
	jge   initColLoop
		
#endInitColLoop

	movl $disMatrix, %eax  #get address of array
	movl $0, %ebx				 #init EBX to zero
		
initRowLoop:
	movl %ebx, (%eax)
	addl $404, %eax
	incl %ebx
		
	cmpl %ebx, strlen2
	jge initRowLoop
		
#endInitRowLoop
	ret

_start:
	movl $string1, %ebx
	call getStrIndex
	movl %edx, strlen1

	movl $string2, %ebx
	call getStrIndex
	movl %edx, strlen2  

	#All registers are now free
		
	call formDisMat 
	movl editDistance, %eax
		
done:   
	movl %eax, %eax
		
