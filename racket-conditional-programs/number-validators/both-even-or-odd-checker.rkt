#lang racket

#|
;; Publication date: 25/02/2025
;; Publication time: 03:53 pm
;; Code version: 1.6
;; Author: Eng(c) Andres David Rincon Salazar
;; Programming language: Racket
;; Language version: 8.15
;; Presented to: Doctor Ricardo Moreno Laverde
;; Universidad Tecnológica de Pereira
;; Programa de Ingeniería de Sistemas y Computación
;; Course: IS105 Programación I
;; Program description: This program reads two numbers and determines if both are even or both are odd.
|#


{define (CheckIfBothEvenOrOdd)
  (printf "Este programa, lee 2 números e imprime si ambos son pares o impares\n")
  (printf "\nEntre el primer número: ")
  [define N1 (read)] ; firstNumber: Stores the first number entered by the user.
  (printf "\nEntre el segundo número: ")
  [define N2 (read)] ; secondNumber: Stores the second number entered by the user.
  [if (and (= (remainder N1 2) 0) (= (remainder N2 2) 0))
      (printf "Ambos números son pares")
  ; else
      {begin
        [if (and (= (remainder N1 2) 1) (= (remainder N2 2) 1))
            (printf "Ambos números son impares")
        ; else
            (printf " ")
        ] ; end if: checking if both numbers are odd
      } ; end begin
  ] ; end if: checking if both numbers are even
} ; end function definition: CheckIfBothEvenOrOdd

(CheckIfBothEvenOrOdd)