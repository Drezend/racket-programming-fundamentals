#lang racket

#|
Publication date: 26/02/2025
Publication time: 04:00 pm
Code version: 2.6
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program calculates a person's Body Mass Index (BMI) and displays the corresponding diagnosis.
Caution: This program assumes positive values for weight and height. Results for negative or zero values are not guaranteed.
|#


{define (CalculateBMI)
  (printf "Este programa calcula el índice de masa corporal (IMC) de una persona y muestra su diagnóstico.")
  (printf "\nIngrese el peso en kilogramos (kg): ")
  [define weight (read)] ; weight: Stores the weight in kilograms entered by the user.
  (printf "\nIngrese la altura en metros (m): ")
  [define height (read)] ; height: Stores the height in meters entered by the user.
   
  [define bmi (/ weight (sqr height))] ; bmi: Calculates the Body Mass Index.
   
  [define diagnosis
    [if (< bmi 16)
        "Criterio de ingreso en hospital"
    ; else: BMI is greater than or equal to 16
        [if (< bmi 17)
            "Infrapeso"
        ; else: BMI is greater than or equal to 17
            [if (< bmi 18)
                "Bajo peso"
            ; else: BMI is greater than or equal to 18
                [if (< bmi 25)
                    "Peso normal (saludable)"
                ; else: BMI is greater than or equal to 25
                    [if (< bmi 30)
                        "Sobrepeso (obesidad de grado I)"
                    ; else: BMI is greater than or equal to 30
                        [if (< bmi 35)
                            "Sobrepeso crónico (obesidad de grado II)"
                        ; else: BMI is greater than or equal to 35
                            [if (< bmi 40)
                                "Obesidad premórbida (obesidad de grado III)"
                            ; else: BMI is greater than or equal to 40
                                "Obesidad mórbida (obesidad de grado IV)"
                            ] ; end if: checking if BMI is less than 40
                        ] ; end if: checking if BMI is less than 35
                    ] ; end if: checking if BMI is less than 30
                ] ; end if: checking if BMI is less than 25
            ] ; end if: checking if BMI is less than 18
        ] ; end if: checking if BMI is less than 17
    ] ; end if: checking if BMI is less than 16
  ] ; diagnosis: Stores the diagnosis based on the BMI value.
   
  (printf "\n--- Resultados del cálculo ---\nPeso: ~a kg\nAltura: ~a m\nIMC calculado: ~a kg/m2\nDiagnóstico: ~a"
          weight height bmi diagnosis )
} ; end function definition: CalculateBMI

(CalculateBMI)