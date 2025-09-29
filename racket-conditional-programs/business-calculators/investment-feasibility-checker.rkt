#lang racket

#|
Publication date: 25/02/2025
Publication time: 04:47 pm
Code version: 1.8
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program reads interest rate and capital, and determines if the interest exceeds $7,000.
|#


{define (CheckInvestmentFeasibility)
  (printf "Este programa lee dos valores. Interés(%) y Capital. Si el dinero recibido por intereses es\nmayor que $7000, se le indicara al inversionista que invierta, de lo contrario se le indicara\nque no debe invertir\n")
  (printf "Entre el interés en %: ")
  [define interestRate (read)] ; interestRate: Stores the interest rate entered by the user.
  (printf "Entre el capital en $: ")
  [define investmentCapital (read)] ; investmentCapital: Stores the capital entered by the user.
  [define interest (* investmentCapital (/ interestRate 100.0))] ; interest: Calculates the interest generated.
  [if (> interest 7000)
      (printf "INVIERTA, SU SALDO SERA $~a" (+ investmentCapital interest))
  ; else
      (printf "NO INVIERTA")
  ] ; end if: checking if interest exceeds $7000
} ; end function definition: CheckInvestmentFeasibility

(CheckInvestmentFeasibility)