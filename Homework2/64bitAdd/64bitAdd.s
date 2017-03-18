# 64bitAdd.s
# 64bitAdd

# Created by Tony Xiao on 10/25/15.
# Copyright © 2015 TonyXiao. All rights reserved.

.global _start
.data
num1:
        .long 0                         #initial num1 for upper
        .long 0                         #initial num1 for lower
num2:
        .long 0                         #initial num2 for upper
        .long 0                         #initial num2 for lower

.text                                   #text


_start:
                                        #upper 32 bits will be in EDX
                                        #lower 32 bits will be in EAX

        movl $num1, %ecx                #ecx as pointer point to begining of num1/ $num1 mean the address of num1
        movl (%ecx), %edx               #()means the value of pointer"ecx", move the value of ecx into edx which store the upper of num1
        addl $4, %ecx                   #move the index of ecx to the next 32 bytes
        movl (%ecx), %eax               #move the value of ecx(lower 32) into eax
        movl $num2, %ebx                #same as previous
        addl (%ebx), %edx               #add two upper 32 byte together
        addl $4, %ebx                   #move the pointer to next 32 bytes of num2
        addl (%ebx), %eax               #add two lower 32 byte togerther
        jc carry                        #check the carry flag
        jmp done                        #end of jump
carry:
        addl $1, %edx                   #if carry flag mean add 1 to the upper
done:
        movl %eax, %eax                 #done

