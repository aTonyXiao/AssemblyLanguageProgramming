//
//  main.cpp
//  changeOfBase
//
//  Created by Bohan Xiao on 9/28/15.
//  Copyright © 2015 Tony Xiao. All rights reserved.
//

#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <math.h>
#include <string>
#include <algorithm>
#include <cstring>
using namespace std;


string changeNewBase(int base10, int nbase)
{
    string nvar;
    int tmp = base10;
    int reminder = tmp % nbase;
    if (reminder >= 10)
        nvar += (reminder - 10) + 'A';
    else
        nvar += reminder + '0';
    
    while ((tmp /= nbase) != 0)
    {
        reminder = tmp % nbase;
        if (reminder >= 10)
            nvar += (reminder - 10) + 'A';
        else
            nvar += reminder + '0';
    }
    return nvar;
}

void changeBase10(string var, int base, int* base10){
    int len = (int)var.size();
    for (int i = 0; i < len; i++)
    {
        if (isdigit(var[i]))
        {
            int num = var[i] - '0';
            (*base10) += num * pow(base, len - i - 1);
        }
        else
        {
            int num = var[i]- 'A' + 10;
            (*base10) += num * pow(base, len - i - 1);
        }
    }
}


int main(int argc, const char * argv[]) {
    string var;
    int base = 0;
    int base10 = 0;
    int nbase = 0;
    string nvar;
    cout << "Please enter the number's base: ";
    cin >> base;
    cout << "Please enter the number: ";
    cin >> var;
    changeBase10(var, base, &base10);
    cout << "Please enter the new base: ";
    cin >> nbase;
    nvar = changeNewBase(base10, nbase);
    reverse(nvar.begin(),nvar.end());
    cout << var << " base " << base << " is " << nvar << " base " << nbase;
    return 0;
}