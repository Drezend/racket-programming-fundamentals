#lang racket
#|
Publication date: 26/02/2025
Publication time: 03:35 pm
Code version: 2.5
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program calculates payment distribution for a company's purchase of parts.
Caution: This program assumes positive values for cost per piece and number of pieces. Results for negative values are not guaranteed.
|#


{define (CalculatePaymentDistribution)
  (printf "Este programa calcula la distribución de pagos para una compra empresarial de piezas de refacción.\nDepende del monto total para determinar las cantidades a invertir, solicitar como préstamo y pagar a crédito.")
  (printf "\nIngrese el costo por pieza: ")
  [define costPerPiece (read)] ; costPerPiece: Stores the cost per piece entered by the user.
  (printf "\nIngrese el número de piezas a comprar: ")
  [define numberOfPieces (read)] ; numberOfPieces: Stores the number of pieces entered by the user.
   
  [define totalAmount (* costPerPiece numberOfPieces)] ; totalAmount: Calculates the total purchase amount.
   
  [define investedAmount
    [if (> totalAmount 500000)
        (* totalAmount 0.55) ; 55% of total amount
    ; else: Total amount is less than or equal to 500000
        (* totalAmount 0.70) ; 70% of total amount
    ] ; end if: checking if total amount exceeds 500000
  ] ; investedAmount: Amount invested by the company.
   
  [define bankLoanValue
    [if (> totalAmount 500000)
        (* totalAmount 0.30) ; 30% of total amount
    ; else: Total amount is less than or equal to 500000
        0 ; No bank loan
    ] ; end if: checking if total amount exceeds 500000
  ] ; bankLoanValue: Value of the bank loan.
   
  [define manufacturerCreditValue
    [if (> totalAmount 500000)
        (* totalAmount 0.15) ; 15% of total amount
    ; else: Total amount is less than or equal to 500000
        (* totalAmount 0.30) ; 30% of total amount
    ] ; end if: checking if total amount exceeds 500000
  ] ; manufacturerCreditValue: Value of the credit to the manufacturer.
   
  [define interestChargedByManufacturer (* manufacturerCreditValue 0.20)] ; interestChargedByManufacturer: Interest charged by the manufacturer.
   
  (printf "\n--- Resultados del cálculo ---\nMonto total de la compra: $~a\nCantidad invertida por la empresa: $~a\nValor del préstamo bancario: $~a\nValor del crédito al fabricante: $~a\nInterés cobrado por el fabricante (20%): $~a\nTotal a pagar (incluido interés): $~a"
          totalAmount
          investedAmount
          bankLoanValue
          manufacturerCreditValue
          interestChargedByManufacturer
          (+ totalAmount interestChargedByManufacturer))
} ; end function definition: CalculatePaymentDistribution

(CalculatePaymentDistribution)