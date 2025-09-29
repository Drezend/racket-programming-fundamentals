#lang racket

#|
- Fecha de publicación: 14/02/2025
- Hora: 4:00 p.m
- Versión: 1.0
- Autor: Ing(c) Andres David Rincon Salazar
- Nombre del lenguaje utilizado: Racket
- Versión del lenguaje utilizado: 8.15
- Presentado a: Doctor Ricardo Moreno Laverde
- Universidad Tecnológica de Pereira
- Programa de Ingeniería de Sistemas y Computación
- Este programa calcula el tercer ángulo de un triángulo cuando se ingresan los otros dos ángulos.
|#

; Mostramos por pantalla lo que requerimos del usuario, en este caso los valores de los dos primeros ángulos del triángulo
( printf "Por favor digite el valor del primer ángulo: " )

; Almacenamos el valor del primer ángulo ingresado por el usuario
( define firstAngle (read))

; Pedimos y almacenamos el segundo ángulo ingresado
( printf "Por favor digite el valor del segundo ángulo: " )
( define secondAngle (read))

; Calculamos el tercer ángulo restando la suma de los dos ángulos ingresados a 180°
( define thirdAngle ( - 180 ( + firstAngle secondAngle ))) ; Almacena el resultado del tercer ángulo

; Mostramos por pantalla el resultado del cálculo del tercer ángulo
( printf "\nEl valor del tercer ángulo de un triángulo con ángulos de ~a° y ~a° es de ~a°." firstAngle secondAngle thirdAngle )
