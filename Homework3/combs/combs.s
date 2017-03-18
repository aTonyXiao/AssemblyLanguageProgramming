# comb.s
# comb

# Created by Tony Xiao on 11/15/15.
# Copyright © 2015 TonyXiao. All rights reserved.

.global get_combs

.equ wordsize, 4
.equ pitem, 2
.equ k, 3
.equ len, 4
.data
    i:
        .long 5
.text

get_combs:

# prelogue
  push %ebp

    movl %esp, %ebp

  push %ebx

# int ret[][] = malloc(sizeof(int *) * num_combs(len, k));
  movl k * wordsize(%ebp), %eax

  push %eax
  movl len * wordsize(%ebp), %eax

  push %eax

  call num_combs
  addl $(pitem * wordsize), %esp

  movl %eax, %edx # edx is num of combs

# num of combs * 4
  push %edx

  movl $4, %ebx
  mull %ebx
  
  pop %edx

  push %edx
  push %eax

  call malloc
  addl $(wordsize), %esp

  pop %edx

  push %eax

  movl $0, %ebx # i

# for (i = 0; i < num_combs(len, k); i++)
# {
#   ret[i] = malloc(sizeof(int) * k);
# }

  mallocfun:
    cmp %ebx, %edx
    jnz notend
    
# counter = 0;
  movl $4, %eax
  push %eax
  call malloc
  addl $(wordsize), %esp
  movl $0, (%eax)
  push %eax

# inner_ret[k]
  movl k * wordsize(%ebp), %eax #k
  push %eax
  call malloc

    addl $(wordsize), %esp

  push %eax

  movl 2 * wordsize(%esp), %eax

  push %eax # ret

  movl 2 * wordsize(%ebp), %eax

    push %eax # itemz

# combs_helper(0, 0, len, k);
    movl 3* wordsize(%ebp), %ecx #k
  push %ecx

  movl len * wordsize(%ebp), %ecx #len
    push %ecx

  movl $0, %ebx
  push %ebx

  push %ebx

  call combs_helper

  addl $(8 * wordsize), %esp
  pop %eax

  addl $(wordsize), %esp

  pop %ebx

    movl %ebp, %esp
    pop %ebp
  ret


notend:
    push %ebx
#pop %ebx
    push %edx
    movl k * wordsize(%ebp), %eax
# check here
    movl $4, %ebx
    mull %ebx
    push %eax
#call malloc
    call malloc
#add to esp

    addl $(wordsize), %esp

    pop %edx
    pop %ebx
    
    movl 0(%esp), %ecx

    movl %eax, (%ecx, %ebx, wordsize)

    incl %ebx
    jmp mallocfun



combs_helper:

# stack


.equ count, 9
.equ innerret, 8
# ret
.equ itemz, 6
.equ maxchos, 5
.equ maxdigit, 4
.equ chos,3
.equ digit, 2
# ret
# ebp
#prelogue
  push %ebp
  movl %esp, %ebp

  push %ebx
# if (chooses == max_chooses)
  movl chos * wordsize(%ebp), %eax

  movl maxchos * wordsize(%ebp), %ebx

  cmp %eax, %ebx
  jnz notbasecase

    jmp basecase

notbasecase:
    movl $0, i
    movl digit * wordsize(%ebp), %ebx
    jmp for2

basecase:

  movl $0, %ecx # this is i
    # for (i = 0; i < max_chooses; i++)
    # ret[counter][i] = array[i];
    outerfor:

       movl maxchos * wordsize(%ebp), %ebx

      cmp %ecx, %ebx
      jnz countincl

      
    movl count * wordsize(%ebp), %edx

    movl (%edx), %eax

    incl %eax
    movl %eax, (%edx)
    jmp end

countincl:

      movl innerret * wordsize(%ebp), %eax

      movl (%eax, %ecx, wordsize), %eax

      movl count * wordsize(%ebp), %edx

      movl (%edx), %edx

      movl 7 * wordsize(%ebp), %ebx

      movl (%ebx, %edx, wordsize), %ebx
      movl %eax, (%ebx, %ecx, wordsize)

      incl %ecx
    jmp outerfor



#for (i = digit; i < max_digit; i++)
# {
#   inner_ret[chooses] = itemz[i];
#   comb(i + 1, chooses + 1, max_digit, max_chooses);
# }



for2:
    movl maxdigit * wordsize(%ebp), %eax

    cmp %eax, %ebx

    jnz continue

 end:
# prologue

  pop %ebx

  movl %ebp, %esp
  pop %ebp
  ret

    continue:

        movl itemz * wordsize(%ebp), %ecx

        movl (%ecx, %ebx, wordsize), %ecx

        movl chos * wordsize(%ebp), %edx

        movl innerret * wordsize(%ebp), %eax

        movl %ecx, (%eax, %edx, wordsize)

    movl count * wordsize(%ebp), %eax
      push %eax

      movl innerret * wordsize(%ebp), %eax
    push %eax

      movl 7 * wordsize(%ebp), %eax
      push %eax
    
    movl itemz * wordsize(%ebp), %eax

    push %eax
    
    movl maxchos * wordsize(%ebp), %eax

        push %eax
    
    movl maxdigit * wordsize(%ebp), %eax

      push %eax

        movl chos * wordsize(%ebp), %eax

    incl %eax

        push %eax
    
      movl %ebx, %eax

        incl %eax
    push %eax
    
        call combs_helper

        addl $(innerret * wordsize), %esp
    
      incl %ebx
jmp for2 # go back


  