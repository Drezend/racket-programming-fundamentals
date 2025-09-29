#lang racket
#|
Publication date: 07/03/2025
Publication time: 4:00 pm
Code version: 1.4
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program calculates and displays Bell numbers up to a user-specified number of terms.
                      Bell numbers count the number of ways to partition a set with n elements.
Caution: This program is designed to display Bell numbers for a user-specified number of terms.
         Precision is limited to summation index ≤ 1000. Results for very large numbers of terms may be approximate.
|#

( define ( calculateFactorial number )
  ; number: Input number to calculate factorial.
  ( if ( = number 0 )
      1
  ; else: multiply number by factorial of (number - 1)
      ( * number ( calculateFactorial ( - number 1 ) ) )
  ); end if: checking if number equals 0
); end function definition: calculateFactorial

( define ( calculateBellNumberAux currentTermIndex summationIndex partialSum summationLimit )
  ; currentTermIndex: Term position in sequence (n).
  ; summationIndex: Current summation index (k).
  ; partialSum: Accumulated sum value.
  ; summationLimit: Precision control parameter.
  ( if ( <= summationIndex summationLimit )
  ; continue summing terms
      ( calculateBellNumberAux currentTermIndex ( + summationIndex 1 ) ( + partialSum ( / ( expt summationIndex currentTermIndex ) ( calculateFactorial summationIndex ) ) ) summationLimit )
  ; else: Apply Dobinski's formula
      ( * ( / 1 ( exp 1 ) ) partialSum )
  ); end if: checking if we've reached the summation limit
); end function definition: calculateBellNumberAux

( define ( DisplayTermsAux currentTerm maxTerms )
  ; currentTerm: Current term being calculated and displayed.
  ; maxTerms: Maximum number of terms to display.
  ( if ( <= currentTerm maxTerms )
      ( begin
        ; Display 1 for the first two terms (Bell(0) and Bell(1))
        ( if ( = currentTerm 1 )
            ( printf "1 " )
        ; else: Calculate and display Bell numbers for terms > 2
            ( printf "~a " ( exact-round ( calculateBellNumberAux currentTerm 0 0 100 ) ) ) )
        ( DisplayTermsAux ( + currentTerm 1 ) maxTerms )
      ); end begin
  ; else: Base case - done displaying all terms
      ( void )
  ); end if: checking if we've displayed all requested terms
); end function definition: DisplayTermsAux

( define ( DisplayBellSequence )
  ; Main function that begins Bell number sequence calculation and display.
  ( printf "Por favor ingrese el número de términos que requiere: " )
  ( define requestedTerms ( read ) )
  ( printf "\nLos primeros ~a números de la serie de Bell son:\n" requestedTerms )
  ( DisplayTermsAux 0 ( - requestedTerms 1 ) )
); end function definition: DisplayBellSequence

( printf "Este programa muestra por pantalla la serie de Bell:\nEsta serie cuenta el número de particiones no vacías de un conjunto de elementos.\nComienza con los números 1, 1 y los siguientes términos se calculan como la suma\nde los términos anteriores multiplicados por los números naturales consecutivos.\n" )
( DisplayBellSequence )