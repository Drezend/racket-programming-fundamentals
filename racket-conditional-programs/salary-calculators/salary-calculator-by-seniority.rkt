#lang racket

#|
Publication date: 25/02/2025
Publication time: 03:00 pm
Code version: 1.4
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program calculates the monthly salary of a worker based on years of employment.
|#


{define (CalculateMonthlySalaryBySeniority)
  (printf "Este programa leyendo por teclado la antigüedad en años, calcula el sueldo mensual que le corresponde al\ntrabajador de una empresa que cobra 40.000 euros anuales, el programa\ndebe realizar los cálculos en función de los siguientes criterios:\na. Si lleva más de 10 años en la empresa se le aplica un aumento del 10%.\nb. Si lleva menos de 10 años pero más que 5 se le aplica un aumento del 7%.\nc. Si lleva menos de 5 años pero más que 3 se le aplica un aumento del 5%.\nd. Si lleva menos de 3 años se le aplica un aumento del 3%.\n")
  (printf "\nEntre el número de años de antigüedad del trabajador: ")
  [define Ant (read)] ; Ant : Stores the years of employment entered by the user.
  [if (> Ant 10)
      (printf "El sueldo mensual es de ~a euros." (/ (* 40000 1.10) 12))
  ; else
      {begin
        [if (and (<= Ant 10) (> Ant 5))
            (printf "El sueldo mensual es de ~a euros." (/ (* 40000 1.07) 12))
        ; else
            {begin
              [if (and (<= Ant 5) (> Ant 3))
                  (printf "El sueldo mensual es de ~a euros." (/ (* 40000 1.05) 12))
              ; else
                  (printf "El sueldo mensual es de ~a euros." (/ (* 40000 1.03) 12))
              ] ; end if: checking if years in company is between 3 and 5
            } ; end begin
        ] ; end if: checking if years in company is between 5 and 10
      } ; end begin
  ] ; end if: checking if years in company is greater than 10
} ; end function definition: CalculateMonthlySalaryBySeniority

(CalculateMonthlySalaryBySeniority)