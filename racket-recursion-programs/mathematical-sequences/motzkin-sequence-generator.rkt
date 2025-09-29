#lang racket
#|
Publication date: 07/03/2025
Publication time: 4:30 pm
Code version: 1.7
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program calculates and displays the Motzkin sequence, which counts the number of non-crossing paths of length n in a three-dimensional lattice.
                     The sequence starts with the numbers 1, 1, and the following terms are calculated as the sum of the previous terms and the sum of the previous terms minus the third previous term.
                     The formula for the nth Motzkin number is M(n) = M(n-1) + Σ (k=0, n-2) M(k)M(n-2-k), where M(0) = 1 and M(1) = 1.
                     The first nine (9) numbers of the Motzkin series are: 1, 1, 2, 4, 9, 21, 51, 127, 323.
                     The program will prompt the user for the number of terms to display.
Caution: This program is designed to work with positive integers. 
         Results for invalid inputs are not guaranteed.
|#

( define ( CalculateMotzkinNumber number )
  ; number: The position in the Motzkin sequence to calculate.
  ( if ( <= number 1 )
      1
  ; else
      ( + ( CalculateMotzkinNumber ( - number 1 ) )
          ( CalculateSumMotzkin 0 ( - number 2 ) )
      )
  ); end if
); end function definition: CalculateMotzkinNumber

( define ( CalculateSumMotzkin sumIndex number )
  ; sumIndex : Current index in the summation.
  ; number : Upper limit for the summation.
  ( if ( > sumIndex number )
      0
  ; else
      ( + ( * ( CalculateMotzkinNumber sumIndex ) ( CalculateMotzkinNumber ( - number sumIndex ) ) )
          ( CalculateSumMotzkin ( + sumIndex 1 ) number )
      )
  ); end if
); end function definition: CalculateSumMotzkin

( define ( MotzkinSeriesAux currentTerm maxTerms )
  ; currentTerm: Current term being calculated and displayed.
  ; maxTerms: Maximum number of terms to display.
  ( if ( <= currentTerm maxTerms )
      ( begin
        ( printf "~a " ( CalculateMotzkinNumber currentTerm ) )
        ( MotzkinSeriesAux ( + currentTerm 1 ) maxTerms )
      ); end begin
  ; else
      ( void )
  ); end if
); end function definition: MotzkinSeriesAux

( define ( MotzkinSeries )
  ; Main function that begins Motzkin number sequence calculation and display.
  ( printf "Por favor ingrese el número de términos deseados: " )
  ( define desiredTerms ( read ) )
  ( printf "\nLos primeros (~a) números de la serie de Motzkin son: " desiredTerms )
  ( MotzkinSeriesAux 0 ( - desiredTerms 1 ) )
); end function definition: MotzkinSeries

( printf "Este programa presenta la serie de Motzkin, que cuenta el número de caminos no cruzados\nde longitud n en una retícula tridimensional.\nLa serie comienza con los números 1, 1 y los siguientes términos se calculan como la suma\nde los términos anteriores y la suma de los términos anteriores menos el tercer término anterior.\nLa fórmula para el enésimo número de Motzkin es\nM(n) = M(n-1) + Σ (k=0, n-2) M(k)M(n-2-k), donde M(0) = 1 y M(1) = 1.\nLos primeros nueve(9) números de la serie de Motzkin son: 1, 1, 2, 4, 9, 21, 51, 127, 323.\nEl programa solicitará la cantidad de términos a mostrar.\n" )
( MotzkinSeries )