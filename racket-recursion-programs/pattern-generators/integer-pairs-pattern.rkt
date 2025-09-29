#lang racket
#|
Publication date: 08/03/2025
Publication time: 4:50 pm
Code version: 1.0
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program generates the following pairs of integers using nested recursion:
                     0 1
                     1 1
                     2 2
                     3 2
                     4 3
                     5 3
                     6 4
                     7 4
                     8 5
                     9 5
Caution: This program is designed to display exactly 10 pairs of integers following the pattern above.
|#

(define (generatePairsAux number1 number2)
  ; number1: First number in the pair
  ; number2: Second number in the pair
  (if (< number1 10)
      (begin
        (printf "~a ~a\n" number1 number2)
        (if (= (remainder number1 2) 0)
            (generatePairsAux (+ number1 1) number2)
        ; else
            (generatePairsAux (+ number1 1) (+ number2 1))
        ) ; end if: checks if we're on an even count
      ) ; end begin
      (void) ; else: we've displayed 10 pairs
  ) ; end if: checks if we've reached the limit
) ; end function: generatePairsAux

(define (generatePairs)
  ; Main function that initiates pair generation
  (generatePairsAux 0 1)
) ; end function: generatePairs

(printf "Este programa genera las siguientes parejas de enteros utilizando ciclos anidados:\n")
(generatePairs)