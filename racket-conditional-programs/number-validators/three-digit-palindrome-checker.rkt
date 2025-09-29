#lang racket

#|
Publication date: 26/02/2025
Publication time: 05:40 pm
Code version: 3.0
Author: Ing(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program determines if a three-digit positive integer is a palindrome.
Caution: This program only works for three-digit numbers. Results for values outside the range [100, 999] are not guaranteed.
|#


{define (DeterminePalindrome)
  (printf "Este programa determina si un número entero positivo de tres cifras es capicúa (se lee igual de izquierda a derecha que de derecha a izquierda).")
  (printf "\nIngrese un número entero positivo de tres cifras (entre 100 y 999): ")
  [define number (read)] ; number: Stores the number entered by the user.

  [define hundreds (quotient number 100)] ; hundreds: Extracts the hundreds digit from the number.
  [define units (remainder number 10)] ; units: Extracts the units digit from the number.
   
  [if (and (>= number 100) (<= number 999))
       [if (= hundreds units)
           (printf "El número ~a ES capicúa." number)
       ; else: The first and last digits are different
           (printf "El número ~a NO es capicúa." number)
       ] ; end if: checking if the number is a palindrome
  ; else: The number is not within the valid range
       (void)
  ] ; end if: checking if the number is within the valid range
} ; end function definition: DeterminePalindrome

(DeterminePalindrome)