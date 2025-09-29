#lang racket
#|
Publication date: 08/03/2025
Publication time: 4:02 pm
Code version: 1.2
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program computes the factorial of a number N, where factorial is defined as:
                     N! = 1 x 2 x 3 x 4 x...N
                     N! = 1 if N = 0
                     Factorial is only defined for non-negative integers.
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

( define ( Factorial )
  ; Main function that handles user input and displays result
  ( printf "Por favor ingrese un número entero no negativo: " )
  ( define number (read) )
  ( printf "\nEl factorial de ~a es: ~a\n" number ( FactorialAux number ) )
); end function definition: Factorial

( printf "Este programa calcula el factorial de un número entero no negativo.\nEl factorial está definido como: N! = 1 x 2 x 3 x 4 x...N, siendo N! = 1 si N = 0\n" )
( Factorial )