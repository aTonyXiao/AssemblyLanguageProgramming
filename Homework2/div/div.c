#include <stdio.h>
#include <stdlib.h>

void divi(unsigned long dividend, unsigned long divisor)
{
	unsigned long remainder = 0 ;
	unsigned long quotient  = 0 ;
	
	long i;

	for(i = 0 ; i < 32 ; i++ )
    {	
    	remainder = remainder << 1;
        // printf("remainder: %u  dividend: %u\n",(remainder & ~0x01) ,   ((dividendremainder = (remainder & ~0x01) | ((dividend >> (31-i)) & 0x01); >> (31-i)) & 0x01) );
    	remainder = remainder | ((dividend >> (31-i)) & 0x01);
        // printf("remainder: %u\n",  remainder  );
    	if (remainder >= divisor)
    	{
    		quotient = quotient | (0x01 << (31-i));
    		remainder = remainder - divisor;
    	}
    }

    printf("%u / %u = %u R %u\n", dividend, divisor, quotient, remainder);
	return ;
}

int main(long argc, char * argv[]) 
{
	divi(atoll(argv[1]), atoll(argv[2]));
	return 0;
}