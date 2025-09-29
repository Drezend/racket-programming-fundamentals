#lang racket

#|
Publication date: 26/02/2025
Publication time: 02:20 pm
Code version: 2.2
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program calculates the calories consumed by a sick person based on activity and time.
Caution: This program only works with 'dormir' or 'estar_sentado' as activity values. Results for other activities are not guaranteed.
|#


{define (CalculateCalories)
  (printf "Este programa calcula cuántas calorías consume el cuerpo de una persona enferma, que pesa 70 kg, que se encuentra en reposo.\nLas actividades que tiene permitido realizar son únicamente dormir o estar sentado en reposo.\nLos datos que tiene son que estando dormido consume 1.08 calorías por minuto y estando sentado en reposo consume 1.66 calorías por minuto.\n")
  (printf "\nIngrese la actividad realizada {dormir} o {estar_sentado} tal como se indica: ")
  [define activity (read)] ; activity: Stores the activity entered by the user.
  (printf "\nIngrese la cantidad de minutos durante la cual realizó la actividad anteriormente mencionada: ")
  [define time (read)] ; time: Stores the time entered by the user.
  [if (equal? activity 'dormir)
      (printf "La cantidad de calorías consumidas fue de: ~a" (* time 1.08))
  ; else: Activity is not 'dormir'
      (begin
        [if (equal? activity 'estar_sentado)
            (printf "La cantidad de calorías consumidas fue de: ~a" (* time 1.66))
        ; else: Activity is neither 'dormir' nor 'estar_sentado'
            (void)
        ] ; end if: checking if activity is 'estar_sentado'
      ) ; end begin
  ] ; end if: checking if activity is 'dormir'
} ; end function definition: CalculateCalories

(CalculateCalories)