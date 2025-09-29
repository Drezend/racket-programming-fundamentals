#lang racket
#|
Publication date: 08/03/2025
Publication time: 5:00 pm
Code version: 1.0
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program generates the following triplets of integers using nested recursion:
                     1 1 1
                     2 1 2
                     3 1 3
                     4 2 1
                     5 2 2
                     6 2 3
                     7 3 1
                     8 3 2
                     9 3 3
Caution: This program is designed to display exactly 9 triplets of integers following the pattern above.
|#

( define ( GenerateTripletsAux number1 number2 number3 )
  ; number1: First number in the triplet
  ; number2: Second number in the triplet
  ; number3: Third number in the triplet
  ( if ( < number1 10 )
      ( begin
        ( printf "~a ~a ~a\n" number1 number2 number3 )
        ( if ( = number3 3 )
            ( GenerateTripletsAux ( + number1 1 ) ( + number2 1 ) 1 ) ; Reset number3 and increment number2
        ; else
            ( GenerateTripletsAux ( + number1 1 ) number2 (+ number3 1 ) ) ; Increment number3
        ) ; end if: (= number3 3)
      ); end begin
      (void) ; Stop recursion when number1 reaches 10
  ); end if: (< number1 10)
); end function definition: GenerateTripletsAux

( define ( GenerateTriplets )
  ; Main function that initiates triplet generation
  ( GenerateTripletsAux 1 1 1 )
); end function definition: GenerateTriplets

(printf "Este programa genera las siguientes ternas de enteros utilizando ciclos anidados:\n")
( GenerateTriplets )