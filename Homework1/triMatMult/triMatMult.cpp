//
//  main.cpp
//  triMatMult
//
//  Created by Bohan Xiao on 10/8/15.
//  Copyright © 2015 Tony Xiao. All rights reserved.
//

#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <cstring>
#include <math.h>
#include <fstream>

using namespace std;

void matrixMult(int matrix1[], int matrix2[], int dim, int result[]);

int main(int argc, const char * argv[]) {
    ifstream inf(argv[1]);
    int size;
    int dim;
    inf >> dim;
    size = (dim + 1) * (dim) / 2;
    int matrixA[size];
    int i = 0;
    while (inf)
    {
        inf >> matrixA[i];
        i++;
    }
    i = 0;
    ifstream inf2(argv[2]);
    int sizeB;
    inf2 >> sizeB;
    int matrixB[size];
    while (inf2)
    {
        inf2 >> matrixB[i];
        i++;
    }

    int matrixC[size];
    for (int i = 0; i < size; i++)
    {
        matrixC[i] = 0;
    }

    matrixMult(matrixA, matrixB, dim, matrixC);

    for (int i = 0; i < size; i++)
    {
        cout << matrixC[i] << " ";
    }

    cout << endl;
    return 0;
}

int findIndx(int N, int J)
{
    return (J +(J - N + 1))* N /2;
}

void matrixMult(int matrix1[], int matrix2[], int dim, int matrix3[])
{
    for (int row1 = 0; row1 < dim; row1++)
    {
        int idex1 = findIndx(row1, dim);
        for (int row2 = row1; row2 < dim; row2++)
        {
            for(int idx2 = 0; idx2 < dim - row2; idx2++)
            {
                matrix3[findIndx(row1, dim) + idx2 + row2 - row1]
                        += matrix1[idex1] * matrix2[findIndx(row2, dim)+ idx2];
            }
            idex1++;
        }
    }
}








