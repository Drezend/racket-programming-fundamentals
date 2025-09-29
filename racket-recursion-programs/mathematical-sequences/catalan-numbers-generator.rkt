#lang racket
#|
Publication date: 07/03/2025
Publication time: 3:35 pm
Code version: 1.9
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program calculates Catalan numbers using the formula C(n) = (2n)! / (n!(n+1)!).
                      The program will ask the user for the number of terms to display.
Caution: This program is designed to display Catalan numbers for a user-specified number of terms. 
         Factorial calculations may be computationally intensive for large numbers.
         This program is designed to work with positive integers. Results for negative or non-integer values are not guaranteed.
|#

[ define ( CalculateFactorial number )
  ; Calculates the factorial of a number.
  ( if ( <= number 0 )
      1
  ; else
      ( * number ( CalculateFactorial ( - number 1 ) ) )
  )
]; end function definition: CalculateFactorial

[ define ( CalculateCatalanNumber number )
  ; Calculates the nth Catalan number using the formula C(n) = (2n)! / (n!(n+1)!).
  ( / ( CalculateFactorial ( * 2 number ) )
       ( * ( CalculateFactorial number ) ( CalculateFactorial ( + number 1 ) ) )
  )
]; end function definition: CalculateCatalanNumber

[ define ( CatalanSeriesAux position counter )
  ; position: Current position in the Catalan sequence.
  ; counter: Keeps track of how many terms are left to be displayed.
  ( if ( > counter 1 )
      ( begin
        ( printf "~a, " ( CalculateCatalanNumber position ) )
        ( CatalanSeriesAux ( + position 1 ) ( - counter 1 ) )
      ); end begin
  ; else: We've reached the last term to display
      ( printf "~a" ( CalculateCatalanNumber position ) )
  ); end if: checking if we've reached the requested number of terms
]; end function definition: CatalanSeriesAux

( define ( CatalanSeries )
  ; Main function that initiates the Catalan sequence calculation
  ( printf "Por favor ingrese el número de términos deseados: " )
  ( define desiredTerms (read) )
  ( printf "\nLos primeros (~a) números de la serie de Catalán son: " desiredTerms )
  ( CatalanSeriesAux 0 desiredTerms )
); end function definition: CatalanSeries

( printf "Este programa presenta la serie de Catalán que comienza con 1, 1 y los siguientes términos\nse calculan mediante la fórmula C(n) = (2n)! / (n!(n+1)!), donde C(0) = 1.\nAsí: 1, 1, 2, 5, 14, 42, 132, 429, 1430...\nEl programa solicitará la cantidad de términos a mostrar.\n" )
( CatalanSeries )