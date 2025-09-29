#lang racket

#|
Publication date: 26/02/2025
Publication time: 04:25 pm
Code version: 2.7
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program calculates the cost of parking at a rate of $1,800 per hour or fraction.
Caution: This program assumes non-negative values for hours and minutes. Results for negative values are not guaranteed.
|#


{define (CalculateParkingCost)
  (printf "Este programa calcula el costo de estacionamiento a razón de $1.800 por hora o fracción.")
  (printf "\nIngrese el tiempo de estacionamiento en horas: ")
  [define hours (read)] ; hours: Stores the parking time in hours entered by the user.
  (printf "\nIngrese el tiempo adicional en minutos: ")
  [define minutes (read)] ; minutes: Stores the additional time in minutes entered by the user.
   
  [define totalTime (+ (* hours 60) minutes)] ; totalTime: Calculates the total parking time in minutes.
  [define hoursToCharge 
    [if (= (remainder totalTime 60) 0)
        (quotient totalTime 60)
    ; else: There is a fraction of an hour
        (+ (quotient totalTime 60) 1)
    ] ; end if: checking if there is a fraction of an hour
  ] ; hoursToCharge: Calculates the number of hours to charge.
   
  [define totalCost (* hoursToCharge 1800)] ; totalCost: Calculates the total cost of parking.
   
  (printf "\nTiempo de estacionamiento: ~a horas y ~a minutos\nTiempo total en minutos: ~a\nHoras o fracciones a cobrar: ~a\nCosto total a pagar: $~a"
          hours minutes totalTime hoursToCharge totalCost)
} ; end function definition: CalculateParkingCost

(CalculateParkingCost)