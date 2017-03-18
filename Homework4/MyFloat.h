//
//  main.cpp
//  MyFloat
//
//  Created by Tony Xiao on 11/30/15.
//  Copyright © 2015 TonyXiao. All rights reserved.
//


#ifndef MY_FLOAT_H
  #define MY_FLOAT_H
  
  #include <iostream> 
  using namespace std;
  
  class MyFloat{
    public:
      //constructors
      MyFloat();
      MyFloat(float f);
      MyFloat(const MyFloat & rhs);
      virtual ~MyFloat() {};
      
      //output
      friend ostream& operator<<(std::ostream& strm, const MyFloat& f);
      
      //comparison
      bool operator==(const MyFloat& rhs) const;
      
      //addition
      MyFloat operator+(const MyFloat& rhs) const; 
      
      //subtraction
      MyFloat operator-(const MyFloat& rhs) const;
      
      //compare greater
      bool operator>(const MyFloat &rhs) const;
      void shifting ();
      void initial(MyFloat &smaller);//1000 0000 0000 0000 0000 0000 0000 0000
      MyFloat bothposicase(MyFloat &smaller);
      MyFloat diffgreat8(MyFloat &smaller, int diff);
    
    private:
      unsigned int sign;
      unsigned int exponent;
      unsigned int mantissa;
      
      
      void unpackFloat(float f);
      float packFloat() const;
      
          static bool willcarry(unsigned int a, unsigned int b);
  };
  
#endif
