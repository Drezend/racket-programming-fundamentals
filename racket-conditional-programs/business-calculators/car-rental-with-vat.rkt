#lang racket

#|
Publication date: 26/02/2025
Publication time: 05:15 pm
Code version: 2.9
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program calculates the amount to be paid for car rental and the VAT tax value.
Caution: This program assumes non-negative values for kilometers driven. Results for negative values are not guaranteed.
|#


{define (CalculateRental)
  (printf "Este programa calcula el monto a pagar por el alquiler de un automóvil y el valor del impuesto IVA.\nLas tarifas son: $400.000 para los primeros 300 km, $15.000 por cada km adicional hasta 1000 km, y $10.000 por cada km que exceda los 1000 km.\nLos precios ya incluyen el 20% de IVA.")
  (printf "\nIngrese la cantidad de kilómetros recorridos: ")
  [define kilometers (read)] ; kilometers: Stores the kilometers driven entered by the user.
   
  [define totalAmount 
    [if (<= kilometers 300)
        400000
    ; else: Kilometers driven exceed 300
        [if (<= kilometers 1000)
            (+ 400000 (* (- kilometers 300) 15000))
        ; else: Kilometers driven exceed 1000
            (+ 400000 (* 700 15000) (* (- kilometers 1000) 10000))
        ] ; end if: checking if kilometers driven are less than or equal to 1000
    ] ; end if: checking if kilometers driven are less than or equal to 300
  ] ; totalAmount: Calculates the total amount to pay.
   
  [define amountWithoutVAT (/ totalAmount 1.2)] ; amountWithoutVAT: Calculates the amount without VAT.
  [define vatValue (- totalAmount amountWithoutVAT)] ; vatValue: Calculates the VAT value.
   
  (printf "\nKilómetros recorridos: ~a km\nMonto sin IVA: $~a\nValor del IVA (20%): $~a\nMonto total a pagar: $~a"
          kilometers amountWithoutVAT vatValue totalAmount)
} ; end function definition: CalculateRental

(CalculateRental)