#lang racket
#|
Publication date: 07/03/2025
Publication time: 12:45 pm
Code version: 1.4
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program displays the Fibonacci sequence starting with 0 and 1, 
                      adding progressively the last two elements of the series.
                      The sequence will continue until it reaches without exceeding 100.
                      Additionally, it calculates and displays the sum of all numbers in the sequence.
Caution: This program is designed to display Fibonacci numbers up to 100. 
         Results for other ranges are not guaranteed.
|#

[ define ( FibonacciAux firstNumber secondNumber currentTerm sumOfSeries )
  ; firstNumber: Stores the first number in the current Fibonacci calculation.
  ; secondNumber: Stores the second number in the current Fibonacci calculation.
  ; counter: Stores the current Fibonacci number to be displayed.
  ; sumOfSeries: Stores the running sum of all Fibonacci numbers in the sequence.
  ( if ( <= secondNumber 100 )
      ( begin
        ( printf "~a, " currentTerm )
        ( FibonacciAux secondNumber ( + firstNumber secondNumber ) secondNumber ( + sumOfSeries secondNumber ) )
      )
  ; else: We've reached the limit of 100
      ( printf "~a y su suma es: ~a" currentTerm sumOfSeries )
  ); end if: checking if we've reached the upper limit
]; end function definition: FibonacciAux

( define ( Fibonacci ) ; Main function that initiates the Fibonacci sequence calculation and sum
  ( FibonacciAux 0 1 0 0 )
); end function definition: Fibonacci

( printf "Este programa presenta la suma de los elementos de la serie de Fibonacci entre 0 y 100.\nLos números a sumar son: " )
( Fibonacci )