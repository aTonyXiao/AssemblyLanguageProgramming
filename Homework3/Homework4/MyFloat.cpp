#include "MyFloat.h"

#define MAX_DIFFERENCE 8

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

MyFloat MyFloat::operator+(const MyFloat& rhs) const
{
  if (this->sign != rhs.sign && this->mantissa == rhs.mantissa && this->exponent == rhs.exponent) // two are opposite
  {
    MyFloat result;
    return result;
  }

  MyFloat big = *this > rhs ? *this : rhs;
  MyFloat small = *this > rhs ? rhs : *this;

  if (this->sign == 0 && rhs.sign == 0) // case 1
  {
    int exponentDifference = (big.exponent - 127) - (small.exponent-127);
    if (exponentDifference >= MAX_DIFFERENCE)
    {
      big.mantissa |= 0x800000; // 1000 0000 0000 0000 0000 0000 0000 0000
      small.mantissa |= 0x800000; // 1000 0000 0000 0000 0000 0000 0000 0000

      big.mantissa <<= MAX_DIFFERENCE;

      small.mantissa >>= exponentDifference - MAX_DIFFERENCE;
      small.exponent += exponentDifference - MAX_DIFFERENCE;

      bool carry = carryWouldHappen(big.mantissa, small.mantissa);
      big.mantissa += small.mantissa;

      big.mantissa >>= 1;

      if (carry)
      {
        big.mantissa |= 0x80000000;
      }

      big.mantissa >>= MAX_DIFFERENCE - 1;

      int i = 0;
      for (i = 32; i--;)
      {
        if (big.mantissa & (1 << i))
        {
          break;
        }
      }
      int shiftLeft = i - 23;

      big.exponent += shiftLeft;
      big.mantissa >>= shiftLeft;

      big.mantissa &= ~(0xFF800000);

      return big;
    }

    big.mantissa |= 0x800000;
    small.mantissa |= 0x800000;
    big.mantissa <<= exponentDifference;

    bool hasCarry = carryWouldHappen(big.mantissa, small.mantissa);
    big.mantissa += small.mantissa;

    big.mantissa >>= exponentDifference;

    if (hasCarry)
      big.mantissa |= (1 << (31 - exponentDifference + 1));

    int i = 0;
    for (i = 32; i--;)
    {
      if (big.mantissa & (1 << i))
      {
        break;
      }
    }

    int shiftLeft = i-23;

    big.exponent += shiftLeft;
    big.mantissa >>= shiftLeft;

    big.mantissa &= ~0xFF800000;

    return big;
  }
  else if (this->sign == 1 && rhs.sign == 1) // case 2
  {
    MyFloat a(*this);
    a.sign = 0;
    MyFloat b(rhs);
    b.sign = 0;

    MyFloat result = a + b;
    result.sign = 1;

    return result;
  }
  else if (this->sign == 0 && rhs.sign == 1) // case 3
  {
    if (rhs.exponent >= this->exponent)
    {
      MyFloat result;
      if (rhs.mantissa >= this->mantissa)
      {
        MyFloat a(rhs);
        MyFloat b(*this);

        a.sign = 0;
        b.sign = 1;

        result = a + b;
        result.sign = 1;
      }
      return result;
    }
    int difference = (big.exponent - 127) - (small.exponent - 127);

    if (difference >= MAX_DIFFERENCE)
    {
      big.mantissa |= 0x800000;
      small.mantissa |= 0x800000;

      big.mantissa <<= MAX_DIFFERENCE;

      small.mantissa >>= difference - MAX_DIFFERENCE;
      small.exponent += difference - MAX_DIFFERENCE;

      if (small.mantissa >> MAX_DIFFERENCE << MAX_DIFFERENCE)
      {
        big.mantissa -= small.mantissa;
      }

      big.mantissa >>= MAX_DIFFERENCE;

      int i = 0;
      for (i = 32; i--;)
      {
        if (big.mantissa & (1 << i))
        {
          break;
        }
      }

      int left = i - 23;

      big.exponent += left;
      big.mantissa >>= left;

      big.mantissa &= ~(0xFF800000);

      return big;
    }

    big.mantissa |= 0x800000;
    small.mantissa |= 0x800000;

    big.mantissa <<= difference;
    big.exponent -= difference;

    big.mantissa = big.mantissa - small.mantissa;

    int i = 0;
    for (i = 32; i--;)
    {
      if (big.mantissa & (1 << i))
      {
        break;
      }
    }

    int left = i - 23;

    big.exponent += left;
    big.mantissa >>= left;

    big.mantissa &= ~(0xFF800000);
    return big;
  }

  return rhs + *this;
}

MyFloat MyFloat::operator-(const MyFloat &rhs) const
{
  MyFloat otherValue(rhs);

  otherValue.sign = !(otherValue.sign == 1);

  return *this + otherValue; // a - b is equal to a + (-b)
}

bool MyFloat::operator>(const MyFloat &rhs) const
{
  if (this->sign == 0 && rhs.sign == 1) // only this is positive
  {
    return true;
  }
  else if (this->sign == 1 && rhs.sign == 0) // only rhs is positive
  {
    return false;
  }
  else if (this->sign == 1 && rhs.sign == 1) // both are negative
  {
    if (this->exponent == rhs.exponent)
    {
      return this->mantissa < rhs.mantissa; // with same exponent, value with smaller mantissa wins
    }
    else
    {
      return this->exponent < rhs.exponent; // otherwise, smaller exponent wins
    }
  }
  else // both are positive
  {
    if (this->exponent == rhs.exponent)
    {
      return this->mantissa > rhs.mantissa; // with same exponent, value with bigger mantissa wins
    }
    else
    {
      return this->exponent > rhs.exponent; // otherwise, bigger exponent wins
    }
  }
}

int MyFloat::absi(const int rhs)
{
  return rhs > 0 ? rhs : -rhs;
}

MyFloat MyFloat::abs(const MyFloat &rhs)
{
  MyFloat result(rhs);
  result.sign = 0;
  return result;
}

bool MyFloat::operator==(const MyFloat & rhs) const
{
  return sign == rhs.sign && exponent == rhs.exponent && mantissa == rhs.mantissa;
}

void MyFloat::unpackFloat(float f)
{
  __asm__(
          "movl %%edx, %%eax;"
          "shrl $31, %%eax;"

          "movl %%edx, %%ebx;"
          "andl $2139095040, %%ebx;" // 111 1111 1000 0000 0000 0000 0000 0000
          "shrl $23, %%ebx;"

          "movl %%edx, %%ecx;"
          "andl $8388607, %%ecx;" // 111 1111 1111

          : "=a"(sign), "=b"(exponent), "=c"(mantissa)
          : "d"(f)
          : "cc"
          );
} // UnpackFloat

float MyFloat::packFloat() const
{
  float f = 0;

  __asm__(
          "movl $0, %%eax;"
          "orl %%edx, %%eax;"

          "shll $31, %%ebx;"
          "orl %%ebx, %%eax;"

          "shll $23, %%ecx;"
          "orl %%ecx, %%eax;"

          : "=a"(f)
          : "b"(sign), "c"(exponent), "d"(mantissa)
          : "cc"
          );

  return f;
} // PackFloat


bool MyFloat::carryWouldHappen(unsigned int a, unsigned int b)
{
  bool carry = false;

  __asm__(
          "addl %%eax, %%ebx;"
          "jnc false;"
          "movl $1, %%ecx;"
          "false:"
          :"=c"(carry)
          :"a"(a), "b"(b), "c"(carry)
          :"cc"
          );

  return carry;
} // CarryWouldHappen