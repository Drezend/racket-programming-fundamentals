#lang racket

#|
Publication date: 26/02/2025
Publication time: 02:45 pm
Code version: 2.3
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program calculates the final price of a product based on its code.
Caution: This program only works with code values 1 or 2. Results for other code values are not guaranteed.
|#

{define (CalculateFinalProductPriceWithCode)
  (printf "Este programa imprime de un artículo, su clave, precio original y su precio con descuento. El descuento lo hace en base a la clave, si la clave es 1 el descuento es del 10% y si la clave es 2 el descuento en del 20%.\n")
  (printf "Por favor ingrese el precio del producto: ")
  [define productPrice (read)] ; productPrice: Stores the product price entered by the user.
  (printf "Por favor ingrese la clave: ")
  [define code (read)] ; code: Stores the product code entered by the user.
  [if (= code 1)
      (printf "Precio original: ~a \nClave: ~a \nPrecio con descuento: ~a" 
              productPrice 
              code 
              (- productPrice (* productPrice (/ 10 100.0))))
  ; else: Code is not 1
      (begin
        [if (= code 2)
            (printf "Precio original: ~a \nClave: ~a \nPrecio con descuento: ~a" 
                    productPrice 
                    code 
                    (- productPrice (* productPrice (/ 20 100.0))))
        ; else: Code is neither 1 nor 2
            (void)
        ] ; end if: checking if code is 2
      ) ; end begin
  ] ; end if: checking if code is 1
} ; end function definition: CalculateFinalProductPriceWithCode

(CalculateFinalProductPriceWithCode)