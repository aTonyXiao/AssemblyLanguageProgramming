// div.c
// div

// Created by Tony Xiao on 11/01/15.
// Copyright © 2015 TonyXiao. All rights reserved.

#include <stdio.h>
#include <stdlib.h>


void divide(unsigned long dividend, unsigned long divisor);

int main(int argc, char * argv[]) 
{
  char* first = argv[1];
  char* second = argv[2];
  unsigned long dividend;
  unsigned long divisor;

  sscanf(first, "%lu", &dividend);
  sscanf(second, "%lu", &divisor);
  divide(dividend, divisor);
  
  return 0;
}

void divide(unsigned long dividend, unsigned long divisor)
{
	unsigned long quotient  = 0;
  unsigned long remainder = 0;
	
	int i;

	for(i = 0 ; i < 32 ; i++ )
  {	
    	remainder = remainder << 1;
    	remainder = remainder | ((dividend >> (31-i)) & 0x01);

    	if (remainder >= divisor)
    	{
    		quotient = quotient | (0x01 << (31-i));
    		remainder = remainder - divisor;
    	}else {} // else do nothing
      
  } // end of for 32 times

    printf("%lu / %lu = %lu R %lu\n", dividend, divisor, quotient, remainder);
} // end of func divide

