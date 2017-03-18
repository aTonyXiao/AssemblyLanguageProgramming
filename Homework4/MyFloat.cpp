//
//  main.cpp
//  MyFloat
//
//  Created by Tony Xiao on 11/30/15.
//  Copyright © 2015 TonyXiao. All rights reserved.
//

#include "MyFloat.h"

MyFloat::MyFloat()
{
    sign = 0;
    exponent = 0;
    mantissa = 0;
}

MyFloat::MyFloat(float f)
{
    unpackFloat(f);
}

MyFloat::MyFloat(const MyFloat & rhs)
{
    sign = rhs.sign;
    exponent = rhs.exponent;
    mantissa = rhs.mantissa;
}

ostream& operator<<(std::ostream &strm, const MyFloat &f)
{
    strm << f.packFloat();
    return strm;
}

MyFloat MyFloat::operator-(const MyFloat &rhs) const
{
    MyFloat tmp(rhs);
    if (tmp.sign == 1)
    { tmp.sign = 0;
    }else tmp.sign = 1;
    
    return *this + tmp;
}




bool MyFloat::operator>(const MyFloat &rhs) const
{
    if (sign == 0 && rhs.sign == 1) // this is + > -
    {
        return true;
    }
    else if(sign == 0 && rhs.sign == 0) // both are positive
    {
        if (exponent == rhs.exponent)
        {
            return mantissa > rhs.mantissa;
        }
        else
        {
            return exponent > rhs.exponent;
        }
    }
    else if (sign == 1 && rhs.sign == 1) // both are negative
    {
        if (exponent == rhs.exponent)
        {
            return mantissa < rhs.mantissa;
        }
        else
        {
            return exponent < rhs.exponent;
        }
    }
    else// rhs is + > this(-)
    {
        return false;
    }
    
}

bool MyFloat::operator==(const MyFloat & rhs) const
{
    if (sign != rhs.sign) {
        return false;
    }else if (exponent != rhs.exponent){
        return false;
    }else if (mantissa != rhs.mantissa)
        return false;
    
    
    return true;
}

void MyFloat::unpackFloat(float f)
{
    __asm__(
            "movl %%edx, %%ecx;"
            "shrl $31, %%ecx;"
            
            "movl %%edx, %%ebx;"
            // 111 1111 1000 0000 0000 0000 0000 0000
            "andl $2139095040, %%ebx;" 
            "shrl $23, %%ebx;"
            
            "movl %%edx, %%eax;"
            // 111 1111 1111
            "andl $8388607, %%eax;" 
            "movl %%eax, %%eax;"
            : "=c"(sign), "=b"(exponent), "=a"(mantissa)
            : "d"(f)
            : "cc"
            );
} // UnpackFloat

float MyFloat::packFloat() const
{
    float f = 0;
    
    __asm__(
            "movl $0, %%ecx;"
            "orl %%edx, %%ecx;"
            
            "shll $31, %%ebx;"
            "orl %%ebx, %%ecx;"
            
            "shll $23, %%eax;"
            "orl %%eax, %%ecx;"
            "movl %%eax, %%eax;"
            : "=c"(f)
            : "b"(sign), "a"(exponent), "d"(mantissa)
            : "cc"
            );
    return f;
} // PackFloat



bool MyFloat::willcarry(unsigned int a, unsigned int b)
{
    bool carry = false;
    
    __asm__(
            "addl %%ebx, %%eax;"
            "jnc false;"
            "movl $1, %%ecx;"
            "movl %%eax, %%eax;"
            "false:"
            :"=c"(carry)
            :"b"(a), "a"(b), "c"(carry)
            :"cc"
            );
    
    return carry;
}

void MyFloat::shifting()
{
    int i = 31;
    
    while (1)
    {
        if (mantissa & (1 << i))
            break;
        i--;
    }
    
    int lshift = i - 23;
    mantissa >>= lshift;
    exponent += lshift;
    mantissa &= ~(0xFF800000);
}

void MyFloat::initial(MyFloat &smaller)
{
    smaller.mantissa |= 0x800000;
    mantissa |= 0x800000;
}


MyFloat MyFloat::diffgreat8(MyFloat &smaller, int diff)
{
    this->initial(smaller);
    mantissa <<= 8;
    smaller.mantissa >>= diff - 8;
    smaller.exponent += diff - 8;
    
    if (smaller.mantissa >> 8 << 8)
        mantissa -= smaller.mantissa;
    
    mantissa >>= 8;
    this->shifting();
    return *this;
}


MyFloat MyFloat::bothposicase(MyFloat &smaller)
{
    
    int expDiff = exponent - smaller.exponent;
    
    if (expDiff >= 8)
    {
        this->initial(smaller);
        mantissa <<= 8;
        smaller.mantissa >>= expDiff - 8;
        smaller.exponent += expDiff - 8;
        bool checkcarry;
        checkcarry = willcarry(mantissa, smaller.mantissa);
        mantissa += smaller.mantissa;
        mantissa >>= 1;
        
        if (checkcarry)
            mantissa |= 0x80000000;
        mantissa >>= 7;
        shifting();
        return *this;
    }
    this->initial(smaller);
    
    mantissa <<= expDiff;
    bool checkCarry = willcarry(mantissa, smaller.mantissa);
    mantissa += smaller.mantissa;
    mantissa >>= expDiff;
    
    if (checkCarry)
        mantissa |= (1 << (32 - expDiff));
    this->shifting();
    return *this;
}


MyFloat MyFloat::operator+(const MyFloat& rhs) const
{
    if (sign == rhs.sign) // equal sign
    {
    }else if (exponent == rhs.exponent && mantissa == rhs.mantissa) {
        MyFloat empty;
        return empty;
    }
    MyFloat bigger;
    MyFloat smaller;
    MyFloat a(*this);
    MyFloat b(rhs);
    if (*this > rhs) {
        bigger = *this;
        smaller = rhs;
    }else{
        bigger = rhs;
        smaller = *this;
    }
    
    if (rhs.sign == 0 && sign == 0) // both positive
        return bigger.bothposicase(smaller);
    if (sign == 1 && rhs.sign == 1)// both negative
    {
        a.sign = 0;
        b.sign = 0;
        MyFloat final = a + b;
        final.sign = 1;
        return final;
    }else if (sign == 0 && rhs.sign == 1) //this + rhs -
    {
        if (rhs.exponent >= exponent)
        {
            if (rhs.mantissa >= mantissa)
            {
                a.sign = 1;
                b.sign = 0;
                MyFloat final;
                final = a + b;
                final.sign = 1;
                return final;
            }
            MyFloat final;
            return final;
        }
        int diff = bigger.exponent - smaller.exponent;
        if (diff >= 8)
            return bigger.diffgreat8(smaller,diff);
        bigger.initial(smaller);
        bigger.mantissa <<= diff;
        bigger.exponent -= diff;
        bigger.mantissa = bigger.mantissa - smaller.mantissa;
        bigger.shifting();
        return bigger;
    }
    MyFloat final = rhs+ *this;
    return final;
}

