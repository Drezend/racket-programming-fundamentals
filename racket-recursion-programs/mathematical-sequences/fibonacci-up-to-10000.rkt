#lang racket
#|
Publication date: 07/03/2025
Publication time: 12:15 pm
Code version: 1.3
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program displays the Fibonacci sequence starting with 0 and 1, 
                      adding progressively the last two elements of the series.
                      The sequence will continue until it reaches without exceeding 10,000.
Caution: This program is designed to display Fibonacci numbers up to 10,000. 
         Results for other ranges are not guaranteed.
|#

[ define ( FibonacciAux firstNumber secondNumber currentTerm )
  ; firstNumber: Stores the first number in the current Fibonacci calculation.
  ; secondNumber: Stores the second number in the current Fibonacci calculation.
  ; counter: Stores the current Fibonacci number to be displayed.
  ( if ( <= secondNumber 10000 )
      ( begin
        ( printf "~a, " currentTerm )
        ( FibonacciAux secondNumber ( + firstNumber secondNumber ) secondNumber )
      )
  ; else: We've reached the limit of 10,000
      ( printf "~a" currentTerm )
  ); end if: checking if we've reached the upper limit
]; end function definition: FibonacciAux

( define ( Fibonacci )
  ; Main function that initiates the Fibonacci sequence calculation
  ( FibonacciAux 0 1 0 )
); end function definition: Fibonacci

( printf "Este programa presenta la serie de Fibonacci como la serie que comienza con los dígitos 1 y 0 y va\nsumando progresivamente los dos últimos elementos de la serie, así: 0 1 1 2 3 5 8 13 21 34.......\nPara este programa, se presentará la serie de Fibonacci hasta llegar sin sobrepasar el número 10,000.\n" )
( Fibonacci )