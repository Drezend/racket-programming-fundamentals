#lang racket
#|
Publication date: 08/03/2025
Publication time: 4:20 pm
Code version: 1.4
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program reads a non-negative integer N and shows the sum of 
                     the factorials of all numbers from 0 to N.
                     For example, if N = 5:
                     = 0! + 1! + 2! + 3! + 4! + 5!
                     = 1 + 1 + 2 + 6 + 24 + 120 = 154
Caution: This program is designed to work with non-negative integers.
         Results for negative or non-integer values are not guaranteed.
|#

[ define ( FactorialAux number )
  ; number: Current number for factorial calculation
  ( if ( = number 0 )
      1  ; Base case: 0! = 1
  ; else
      ( * number ( FactorialAux ( - number 1 ) ) )
  ); end if: checking if n is zero
]; end function definition: FactorialAux

[ define ( SumFactorialsAux current number sum )
  ; current: Current number in summation
  ; number: Target number for summation
  ; sum: Running sum of factorials
  ( if ( > current number )
      sum  ; Base case: completed all terms
  ; else
      ( SumFactorialsAux ( + current 1 ) number ( + sum ( FactorialAux current ) ) )
  ); end if: checking if we've reached target
]; end function definition: SumFactorialsAux

( define ( SumFactorials )
  ; Main function that handles user input and displays result
  ( printf "Por favor ingrese un número entero no negativo N: " )
  ( define number (read) )
  ( if ( < number 0 )
      ( printf "\nError: El número debe ser no negativo.\n" )
  ; else
      ( printf "\nLa suma de los factoriales desde 0 hasta ~a es: ~a\n" number ( SumFactorialsAux 0 number 0 ) )
  ); end if: validating user input
); end function definition: SumFactorials

( printf "Este programa muestra la suma de los factoriales de todos los números desde 0 hasta N.\nEjemplo: Si N = 5, la suma sería 0! + 1! + 2! + 3! + 4! + 5! = 1 + 1 + 2 + 6 + 24 + 120 = 154\n" )
( SumFactorials )