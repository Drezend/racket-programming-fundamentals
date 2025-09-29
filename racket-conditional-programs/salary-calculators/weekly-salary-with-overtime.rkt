#lang racket

#|
Publication date: 26/02/2025
Publication time: 01:53 pm
Code version: 2.1
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program calculates the weekly salary of a worker based on hours worked.
Caution: This program assumes the number of hours worked is non-negative. Results for negative values are not guaranteed.
|#


{define (CalculateWeeklySalary)
  (printf "Este programa calcula el sueldo semanal de un obrero, el cual se obtiene de la siguiente manera: \n- Si trabaja 40 horas o menos se le paga $16 por hora.\n- Si trabaja más de 40 horas se le paga $16 por cada una de las primeras 40 horas y $20 por cada hora extra.\n")
  (printf "\nIngrese el número de horas trabajadas: ")
  [define hoursWorked (read)] ; hoursWorked: Stores the hours worked entered by the user.
  [if (<= hoursWorked 40)
      (printf "El salario de esta semana para el obrero será de: $~a" (* 16 hoursWorked))
  ; else: Worker has worked more than 40 hours
      (printf "El salario de esta semana para el obrero será de: $~a" (+ (* 16 40) (* 20 (- hoursWorked 40))))
  ] ; end if: checking if hours worked are less than or equal to 40
} ; end function definition: CalculateWeeklySalary

(CalculateWeeklySalary)