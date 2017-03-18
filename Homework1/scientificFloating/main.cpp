#include <iostream>
#include <bitset>
#include <stdlib.h>
#include <stdio.h>
#include <string>
#include <algorithm>
#include <math.h>

using namespace std;

string changeBase2(int base10)
{
    string nvar;
    int tmp = base10;
    int reminder = tmp % 2;
    if (reminder >= 10)
        nvar += (reminder - 10) + 'A';
    else
        nvar += reminder + '0';
    
    while ((tmp /= 2) != 0)
    {
        reminder = tmp % 2;
        if (reminder >= 10)
            nvar += (reminder - 10) + 'A';
        else
            nvar += reminder + '0';
    }
    reverse(nvar.begin(),nvar.end());
    return nvar;
}

int convertExpo(string expo){
    int fexpo = 0;
    for (int i = 0; i < 8; i++){
        
        fexpo += (int)((int)(expo[i] - '0') * pow(2, 7 - i));
        
    }
    return fexpo;
}

void outputfunction(int fexpo, string mantissa, int sign)
{
    int last = (int)mantissa.find_last_of('1');
    mantissa = mantissa.substr(0, last + 1);
    if (sign == 0)
        cout << "-1." << mantissa << 'E' << fexpo << endl;
    else
        cout << "1." << mantissa << 'E' << fexpo << endl;
}



int main()
{
    float num = 0.0;
    int sign = 1;
    cout << "Please enter a float: ";
    cin >> num;
    if (num < 0){
        sign = 0;
        num *= -1;
    }
    if (num == 0){
        cout << "0E0" << endl;
        return 0;
    }else if (num == 1){
        cout << "1E0" << endl;
        return 0;
    }
    
    
    unsigned int float_int = *((unsigned int*)&num);
    string nvar = changeBase2(float_int);
    string expo = nvar.substr(0,8);
    string mantissa = nvar.substr(8,23);
    int fexpo = convertExpo(expo) - 127;
    outputfunction(fexpo, mantissa, sign);
    return 0;
}








