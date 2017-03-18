# editDist.s
# editDist

# Created by Tony Xiao on 10/25/15.
# Copyright © 2015 TonyXiao. All rights reserved.


.data #start of data section

#size of a word
.equ wordsize, 4

#size of distance matrix
.equ matrixSize, 10201

#dimension of the matrix
matrixDim: 
					.long 101

#first comparison string, given 100 bytes of space
string1:
					.space 100
		
#second comparison string, given 100 bytes of space
string2:
					.space 100
			
#length of first string, intitialized to 0
stringLength1:
					.long 0
					
#length of second string, initialized to 0
stringLength2:
					.long 0
					
#matrix of edit distances used to obtain final distance
distanceMatrix:
					.rept matrixSize
						.long 0
					.endr
					
#row we are at in the distance matrix
row:
					.long 1
					
#column we are at in the distance matrix
col:
					.long 1
					
#result of calculation
editDistance:
					.long 0
					
#three variables to store three potential minimum distances for a loop iteration
a:					.long 0					
b:					.long 0
c:					.long 0

.text #start of code section

.global _start
_start:
		movl $string1, %ebx
		call getStringLenInEDX
		movl %edx, stringLength1
		
		movl $string2, %ebx
		call getStringLenInEDX
		movl %edx, stringLength2
		
		#All registers are now free
		
		call buildDistanceMatrix 
		movl editDistance, %eax
		
done:   movl %eax, %eax
		
		
getStringLenInEDX:
		#EDX stores string length (result)
		#EBX stores address of string
		
		movl $0, %edx #initialize length to 0
		decl %ebx
stringLenLoop:
		incl %edx
		incl %ebx
		
		cmpb $0, (%ebx)
		jnz stringLenLoop
		
		decl %edx #undoes last increment to make correct value
		
		ret


buildDistanceMatrix:
		#EAX utilized for general storage needs
		#EBX utilized for general storage needs
		#EDX utilized for general storage needs
		#ESI stores the current address in string1
		#EDI stores the current address in string2
		
		
		
		call initDistanceMatrix #prepare the matrix for building
		
		#initialize EDI
		movl $string2, %edi
		
matrixRowLoop:
		movl $1, col
		movl $string1, %esi
		movl row, %ecx
		cmpl %ecx, stringLength2
		jl endFunction
		
		matrixColLoop:
				movl col, %ecx
				cmpl %ecx, stringLength1
				jl exitMatrixRowLoop
		
				movb (%esi), %cl
				cmpb %cl, (%edi)
				jz   ifCharMatch
				jmp  elseCharMatch
				
				#EAX free
				#EBX free
				#ECX free
				#EDX free
				ifCharMatch:
						movl $distanceMatrix, %ecx
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
				
				#EAX free
				#EBX free
				#ECX free
				#EDX free
				elseCharMatch:
						movl $distanceMatrix, %ecx
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
								movl $distanceMatrix, %ecx
								movl %ebx, (%ecx, %eax, wordsize)
								movl %ebx, editDistance
								jmp exitMatrixColLoop
							
						bIsMin:
								movl $distanceMatrix, %ebx
								movl %ecx, (%ebx, %eax, wordsize)
								movl %ecx, editDistance
								jmp exitMatrixColLoop
							
						cIsMin:
								movl $distanceMatrix, %ecx
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

endFunction:
		ret
		

initDistanceMatrix:
		#EAX stores the current address in the array
		#EBX  stores the current row or column
		#ECX  stores the length of the string
		
		
		
		movl $distanceMatrix, %eax  #get address of array
		movl $0, %ebx				 #init EBX to zero
		
initColLoop:
		movl %ebx, (%eax)
		addl $wordsize, %eax
		incl %ebx
		
		cmpl %ebx, stringLength1
		jge   initColLoop
		
#endInitColLoop

		movl $distanceMatrix, %eax  #get address of array
		movl $0, %ebx				 #init EBX to zero
		
initRowLoop:
		movl %ebx, (%eax)
		addl $404, %eax
		incl %ebx
		
		cmpl %ebx, stringLength2
		jge initRowLoop
		
#endInitRowLoop
		
		ret