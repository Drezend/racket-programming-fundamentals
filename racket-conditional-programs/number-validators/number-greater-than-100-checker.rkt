#lang racket

#|
Publication date: 25/02/2025
Publication time: 03:26 pm
Code version: 1.5
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program reads a number and determines if it is greater than 100.
|#


{define (CheckIfGreaterThan100)
  (printf "Este programa, lee un número e imprime si es o no mayor que 100.\n")
  (printf "\nEntre un número: ")
  [define number (read)] ; number: Stores the number entered by the user.
  [if (> number 100)
      (printf "~a es mayor que 100" number)
  ; else
      (printf "~a no es mayor que 100" number)
  ] ; end if: checking if number is greater than 100
} ; end function definition: CheckIfGreaterThan100

(CheckIfGreaterThan100)