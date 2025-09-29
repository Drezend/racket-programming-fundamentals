#lang racket

#|
- Fecha de publicación: 14/02/2025
- Hora: 1:00 p.m
- Versión: 1.0
- Autor: Ing(c) Andres David Rincon Salazar
- Nombre del lenguaje utilizado: Racket
- Versión del lenguaje utilizado: 8.15
- Presentado a: Doctor Ricardo Moreno Laverde
- Universidad Tecnológica de Pereira
- Programa de Ingeniería de Sistemas y Computación
- Este programa calcula el perímetro de un rectángulo cuando se ingresan su largo y ancho.
|#

; Mostramos por pantalla lo que requerimos del usuario, en este caso el largo y ancho del rectángulo
( printf "Por favor digite el largo del rectángulo: " )

; Almacenamos el valor del largo ingresado por el usuario
( define length (read))

; Pedimos y almacenamos el valor del ancho ingresado
( printf "\nPor favor digite el ancho del rectángulo: " )
( define width (read))

; Calculamos el perímetro sumando dos veces la suma del largo y ancho
( define perimeter ( + ( * length 2 ) ( * width 2 ))) ; Almacena el resultado del perímetro

; Mostramos por pantalla el resultado del cálculo del perímetro
( printf "\nEl perímetro de un rectángulo con largo ~a y ancho ~a es de ~a" length width perimeter )
