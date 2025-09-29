#lang racket

#|
Publication date: 26/02/2025
Publication time: 01:26 pm
Code version: 2.0
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program applies a 20% discount if the purchase exceeds $100,000.
Caution: This program assumes purchase values are positive. Results for negative values are not guaranteed.
|#


{define (ApplyDiscountIfEligible)
  (printf "Este programa determina la cantidad que pagará una persona por su compra, en un almacén que hace un 20% de descuento a los clientes cuya compra supere los $100,000.\n")
  (printf "\nIngrese el valor de la compra: ")
  [define purchaseValue (read)] ; purchaseValue: Stores the purchase value entered by the user.
  [if (> purchaseValue 100000)
      (printf "El valor a pagar será de: ~a" (- purchaseValue (* purchaseValue (/ 20 100.0))))
  ; else: Purchase value is less than or equal to $100,000
      (printf "El valor a pagar será de: ~a" purchaseValue)
  ] ; end if: checking if purchase value exceeds $100,000
} ; end function definition: ApplyDiscountIfEligible

(ApplyDiscountIfEligible)