#lang racket
#|
;; Publication date: 25/02/2025
;; Publication time: 04:20 pm
;; Code version: 1.7
;; Author: Eng(c) Andres David Rincon Salazar
;; Programming language: Racket
;; Language version: 8.15
;; Presented to: Doctor Ricardo Moreno Laverde
;; Universidad Tecnológica de Pereira
;; Programa de Ingeniería de Sistemas y Computación
;; Course: IS105 Programación I
;; Program description: This program reads three numbers and determines if the product of the first two equals the third.
|#


{define (CheckIfProductEqualsThird)
  (printf "Este programa, lee 3 números e imprime si la multiplicación de los 2 primeros es igual al tercero.\n")
  (printf "\nEntre el primer número: ")
  [define firstNumber (read)] ; firstNumber: Stores the first number entered by the user.
  (printf "\nEntre el segundo número: ")
  [define secondNumber (read)] ; secondNumber: Stores the second number entered by the user.
  (printf "\nEntre el tercer número: ")
  [define thirdNumber (read)] ; thirdNumber: Stores the third number entered by the user.
  [if (= (* firstNumber secondNumber) thirdNumber)
      (printf "La multiplicación de los 2 primeros números es igual al tercero.")
  ; else
      (printf "La multiplicación de los 2 primeros números no es igual al tercero.")
  ] ; end if: checking if product of first two numbers equals the third
} ; end function definition: CheckIfProductEqualsThird

(CheckIfProductEqualsThird)