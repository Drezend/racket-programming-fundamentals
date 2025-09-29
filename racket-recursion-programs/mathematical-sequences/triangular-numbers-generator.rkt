#lang racket
#|
Publication date: 08/03/2025
Publication time: 12:00 pm
Code version: 1.4
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program calculates and displays triangular numbers up to a user-specified number of terms.
                      Triangular numbers represent the number of dots that form an equilateral triangle.
Caution: This program is designed to work with positive integers.
         Results for negative or non-integer values are not guaranteed.
|#

[ define ( generateTriangularSequence currentNumber currentSum remainingTerms )
  ; currentNumber: Current integer in sequence
  ; currentSum: Accumulated triangular number
  ; remainingTerms: Terms left to display
  ( if ( > remainingTerms 0 ) ; Check remaining terms
      ( begin
        ( printf "~a " currentSum )
        ( generateTriangularSequence 
            ( + currentNumber 1 ) 
            ( + currentSum currentNumber 1 ) 
            ( - remainingTerms 1 ) )
      ) ; end begin: display current term and iterate
  ; else: Terminate
      ( void )
  ); end if: checking if we've displayed all requested terms
]; end function definition: generateTriangularSequence

[ define ( displayTriangularNumbers )
  ; Main function that begins triangular number sequence calculation and display
  ( printf "Este programa presenta la serie de números triangulares.\nEl programa solicitará la cantidad de términos a mostrar.\n" )
  ( printf "Ingresa el número de términos a mostrar: " )
  ( define requestedTerms ( read ) )
  ( printf "\nLos primeros (~a) números triangulares son: " requestedTerms )
  ( generateTriangularSequence 1 1 requestedTerms )
]; end function definition: displayTriangularNumbers

( displayTriangularNumbers )