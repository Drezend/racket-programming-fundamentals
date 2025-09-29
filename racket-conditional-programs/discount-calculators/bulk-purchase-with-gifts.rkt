#lang racket

#|
;; Publication date: 26/02/2025
;; Publication time: 04:50 pm
;; Code version: 2.8
;; Author: Eng(c) Andres David Rincon Salazar
;; Programming language: Racket
;; Language version: 8.15
;; Presented to: Doctor Ricardo Moreno Laverde
;; Universidad Tecnológica de Pereira
;; Programa de Ingeniería de Sistemas y Computación
;; Course: IS105 Programación I
;; Program description: This program calculates the amount, discount, final payment, and gifts for the purchase of a product with special offers.
;; Caution: This program assumes positive values for unit price and quantity of dozens. Results for negative values are not guaranteed.
|#


{define (CalculatePurchase)
  (printf "Este programa calcula el monto, descuento, pago final y obsequios para la compra de un producto con ofertas especiales.\nLas condiciones son: 15% de descuento por más de 3 docenas, 10% en caso contrario.\nAdemás, se obsequia una unidad por cada docena que exceda las 3 docenas.")
  (printf "\nIngrese el precio por unidad del producto: ")
  [define unitPrice (read)] ; unitPrice: Stores the unit price entered by the user.
  (printf "\nIngrese la cantidad de docenas a comprar: ")
  [define quantityDozens (read)] ; quantityDozens: Stores the quantity of dozens entered by the user.
   
  [define dozenPrice (* unitPrice 12)] ; dozenPrice: Calculates the price per dozen.
  [define purchaseAmount (* quantityDozens dozenPrice)] ; purchaseAmount: Calculates the total purchase amount.
   
  [define discountPercentage
    [if (> quantityDozens 3)
        15
    ; else: Quantity of dozens is less than or equal to 3
        10
    ] ; end if: checking if quantity of dozens is greater than 3
  ] ; discountPercentage: Calculates the discount percentage.
   
  [define discountAmount (* purchaseAmount (/ discountPercentage 100))] ; discountAmount: Calculates the discount amount.
  [define amountToPay (- purchaseAmount discountAmount)] ; amountToPay: Calculates the final amount to pay.
   
  [define giftUnits
    [if (> quantityDozens 3)
        (- quantityDozens 3)
    ; else: Quantity of dozens is less than or equal to 3
        0
    ] ; end if: checking if quantity of dozens is greater than 3
  ] ; giftUnits: Calculates the number of gift units.
   
  (printf "\n--- Resultados de la compra ---\nCantidad de docenas compradas: ~a\nPrecio por unidad: $~a\nPrecio por docena: $~a\nMonto de la compra: $~a\nPorcentaje de descuento aplicado: ~a%\nMonto del descuento: $~a\nMonto a pagar: $~a\nUnidades de obsequio: ~a"
          quantityDozens unitPrice dozenPrice purchaseAmount discountPercentage discountAmount amountToPay giftUnits)
} ; end function definition: CalculatePurchase

(CalculatePurchase)