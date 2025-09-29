#lang racket

#|
Publication date: 24/02/2025
Publication time: 01:00 pm
Code version: 1.0
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program reads a number between 1 and 5 and determines if it is prime or not.
Caution: For values outside this range, results are not guaranteed.
|#

{define (CheckPrimeOneToFive)
  (printf "Este programa, lee un número entre uno(1) y cinco(5), e\nimprime si es primo o no.\nSalvedad: Para valores fuera de este rango, no\ngarantizamos los resultados.\n")
  (printf "Entre un número: ")
  [define number (read)] ; number: Stores the number entered by the user.
  [if (or (= number 1) (= number 4))
      (printf "El número no es primo")
  ; else
      (printf "El número es primo")
  ] ; end if: checking if number is 1 or 4
} ; end function definition: CheckPrimeOneToFive

(CheckPrimeOneToFive)