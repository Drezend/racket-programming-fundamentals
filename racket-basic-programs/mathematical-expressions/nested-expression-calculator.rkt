#lang racket

#|
- Fecha de publicación: 14/02/2025
- Hora: 7:02 p.m
- Versión: 1.0
- Autor: Ing(c) Andres David Rincon Salazar
- Nombre del lenguaje utilizado: Racket
- Versión del lenguaje utilizado: 8.15
- Presentado a: Doctor Ricardo Moreno Laverde
- Universidad Tecnológica de Pereira
- Programa de Ingeniería de Sistemas y Computación
- Este programa evalúa una ecuación matemática compleja en función del valor ingresado de X.
|#

; Mostramos por pantalla lo que requerimos del usuario, en este caso el valor de X
( printf "Por favor digite el valor que le quiere asignar a X: " )

; Almacenamos el valor ingresado por el usuario
( define xValue (read))

; Calculamos la ecuación dada en el problema
(define equationResult (/ (+ (/ (/ (/ (/ 
                  (+ (/ xValue 6) (/ 45 xValue)) ; Calcula la primera parte de la ecuación
                  (- xValue (/ -8 2))) ; Segunda operación matemática
               12) 
            ( sqrt xValue)) ; Raíz cuadrada del valor ingresado
         5) 
      ( expt xValue 4)) ; Potencia de X elevada a la cuarta
   ( sqrt xValue))) ; Raíz cuadrada final del resultado

; Mostramos por pantalla el resultado de la ecuación para el valor ingresado de X
( printf "\nEl resultado de la ecuacion para un valor de ~a es de ~a" xValue equationResult)
