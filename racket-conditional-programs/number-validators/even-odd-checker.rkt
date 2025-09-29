 #lang racket

#|
Publication date: 24/02/2025
Publication time: 01:26 pm
Code version: 1.1
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program reads a number and determines if it is even or odd.
|#


{define (CheckIfEvenOrOdd)
  (printf "Este programa, lee un número e imprime si es par o\nimpar.")
  (printf "\nEntre un número: ")
  [define number (read)] ; number: Stores the number entered by the user.
  [if (= (remainder number 2) 0)
      (printf "El número es par")
  ; else
      (printf "El número es impar")
  ] ; end if: checking if number is divisible by 2
} ; end function definition: CheckIfEvenOrOdd

(CheckIfEvenOrOdd)