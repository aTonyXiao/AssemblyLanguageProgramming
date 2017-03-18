#ifndef MY_FLOAT_H
#define MY_FLOAT_H

#include <iostream>
using namespace std;

class MyFloat
{
public:
  // Constructors
  MyFloat();
  MyFloat(float f);
  MyFloat(const MyFloat & rhs);

  virtual ~MyFloat() {};

  // Output
  friend ostream& operator<<(std::ostream& strm, const MyFloat& f);

  // Addition
  MyFloat operator+(const MyFloat& rhs) const;

  // Subtraction
  MyFloat operator-(const MyFloat& rhs) const;

  // Comparation
  bool operator==(const MyFloat & rhs) const;
  bool operator>(const MyFloat &rhs) const;

private:
  unsigned int sign;
  unsigned int exponent;
  unsigned int mantissa;

  void unpackFloat(float f);
  float packFloat() const;

  static bool carryWouldHappen(unsigned int a, unsigned int b);

  // Absolute value
  static int absi(const int rhs);
  static MyFloat abs(const MyFloat &rhs);
};

#endif