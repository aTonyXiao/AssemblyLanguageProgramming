# editDist.s
# editDist

# Created by Tony Xiao on 10/25/15.
# Copyright © 2015 TonyXiao. All rights reserved.


.global _start

.data

dividend:
    .long 0
 
divisor:
    .long 0

count:
	.long 31



.text




_start:
	movl $0, %eax
	movl $0, %edx

for_loop:
	cmp $0, count
	jl done

	shl $1, %edx

	## (remainder & ~0x01)
	and $0xFFFE, %edx 

	movl count, %ecx
	movl %ecx, %ebx
	# ((dividend >> (31-i)) & 0x01)
	movl dividend, %ecx

	#shrl %ebx, %ecx # ecx = dividend >> ebx



shift1:
		cmp $0, %ebx
		jz done1
		shr $1, %ecx
		sub $1, %ebx
		jmp shift1


done1:

	and $1, %ecx # ecx = ecx & 0x01

	# remainder = (remainder & ~0x01) | ((dividend >> (31-i)) & 0x01);
	or %ecx, %edx

	# if (remainder >= divisor)
	cmp divisor, %edx
	jl continue
	# quotient = quotient | (0x01 << (31-i));
	# remainder = remainder - divisor;
	sub divisor, %edx
	movl $1, %ecx
	movl count, %ebx # reset ebx
	#shl %ebx, %ecx


shift2:
		cmp $0, %ebx
		jz done2
		shl $1, %ecx
		sub $1, %ebx
		jmp shift2


done2:

	or %ecx, %eax

continue:
 	sub $1, count
	jmp for_loop


done:
	movl %eax, %eax
	