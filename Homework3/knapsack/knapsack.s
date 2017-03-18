# knapsack.s
# knapsack

# Created by Tony Xiao on 11/18/15.
# Copyright © 2015 TonyXiao. All rights reserved.



.globl knapsack
# on the stack the value
.equ wordsize, 4
.equ weights, 2
.equ values, 3
.equ num_items, 4
.equ capacity, 5
.equ cur_value, 6

.text

knapsack:
# start
    prelogue:

    push %ebp

    movl %esp, %ebp

    push %edi

    push %ecx # ecx is i
    push %esi

    movl $0, %ecx # i = 0
    movl cur_value * wordsize(%ebp), %esi

outloop:

        movl num_items * wordsize(%ebp), %eax # num_items
        cmpl %eax, %ecx # check if (i < num_items)

    jb contioutloop #blow then
        movl %esi, %eax #end

        jmp prologue

    contioutloop:# i >= num_items
# reminder = capacity - weights[i];

    movl weights * wordsize(%ebp), %edi # weight

    movl (%edi, %ecx, wordsize), %edi # weight[i]

    movl capacity * wordsize(%ebp), %edx # capacity
    subl %edi, %edx # reminder

    cmp $0, %edx # if (remainer > 0 )

    jge continue # continue

    incl %ecx # break here

    jmp outloop

continue:
  # new_cur_value = cur_value + values[i];

        movl values * wordsize(%ebp), %edi # value

        movl (%edi, %ecx, wordsize), %edi # get value[i]

        movl cur_value * wordsize(%ebp), %ebx   #cur_v
        addl %edi, %ebx

        push %ebx

  # new_capacity = capacity - weights[i];
        movl weights * wordsize(%ebp), %edi

    #leal wordsize(%edi, %ecx, wordsize), %edi # weight[i]

        movl (%edi, %ecx, 4), %edi
    movl capacity * wordsize(%ebp), %ebx   #capacity

    subl %edi, %ebx

    push %ebx

  # new_num_items = num_items - i - 1;
        movl num_items * wordsize(%ebp), %ebx
        decl %ebx # i - 1

        subl %ecx, %ebx

  push %ebx

  # new_values = values + i + 1;
  movl values * wordsize(%ebp), %eax

  leal 4(%eax,%ecx,4), %eax

  push %eax

  # *new_weight = weights + i + 1;
    movl weights * wordsize(%ebp), %eax

  leal 4(%eax,%ecx,4), %eax

    push %eax

  #int knap = knapsack(new_weight, new_values, new_num_items, new_capacity, new_cur_value);
  call prelogue #recusive calls

    addl $(capacity * wordsize), %esp

    cmpl %eax, %esi

    jb ifsmaller

    incl %ecx

    jmp outloop # back the the outloop

        ifsmaller:
            movl %eax, %esi
            incl %ecx
            jmp outloop

prologue:
pop %esi

pop %ecx

pop %edi

movl %ebp, %esp
pop %ebp
ret




