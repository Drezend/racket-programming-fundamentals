#lang racket
#|
Publication date: 26/02/2025
Publication time: 03:10 pm
Code version: 2.4
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program calculates the total payment for a shirt purchase with discounts.
Caution: This program assumes the number of shirts and price per shirt are positive. Results for negative values are not guaranteed.
|#


{define (CalculateShirtPrice)
  (printf "Este programa calcula el total a pagar por la compra de camisas. Si se compran tres camisas o más se aplica un descuento del 20% sobre el total de la compra y si son menos de tres camisas un descuento del 10%.")
  (printf "\nIngrese el número de camisas: ")
  [define numberOfShirts (read)] ; numberOfShirts: Stores the number of shirts entered by the user.
  (printf "\nIngrese el precio por camisa: ")
  [define pricePerShirt (read)] ; pricePerShirt: Stores the price per shirt entered by the user.
  
  [define totalWithoutDiscount (* numberOfShirts pricePerShirt)] ; totalWithoutDiscount: Calculates the total price without discount.
   
  [if (>= numberOfShirts 3) 
      (printf "El precio original es: ~a\nSe aplicó un descuento del 20%\nEl total a pagar es: ~a" 
              totalWithoutDiscount 
              (- totalWithoutDiscount (* totalWithoutDiscount (/ 20 100.0))))
  ; else: Number of shirts is less than 3
      (printf "El precio original es: ~a\nSe aplicó un descuento del 10%\nEl total a pagar es: ~a" 
              totalWithoutDiscount 
              (- totalWithoutDiscount (* totalWithoutDiscount (/ 10 100.0))))
  ] ; end if: checking if number of shirts is greater than or equal to 3
} ; end function definition: CalculateShirtPrice

(CalculateShirtPrice)