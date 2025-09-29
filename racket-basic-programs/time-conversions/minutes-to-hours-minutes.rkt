#lang racket

#|
- Fecha de publicación: 14/02/2025
- Hora: 2:35 p.m
- Versión: 1.0
- Autor: Ing(c) Andres David Rincon Salazar
- Nombre del lenguaje utilizado: Racket
- Versión del lenguaje utilizado: 8.15
- Presentado a: Doctor Ricardo Moreno Laverde
- Universidad Tecnológica de Pereira
- Programa de Ingeniería de Sistemas y Computación
- Este programa convierte una cantidad de minutos a su equivalente en horas y minutos.
|#

; Mostramos por pantalla lo que requerimos del usuario, en este caso la cantidad de minutos a convertir
( printf "Por favor digite la cantidad de minutos: " )

; Almacenamos el valor de minutos ingresado por el usuario
( define totalMinutes (read))

; Calculamos la cantidad de horas y minutos restantes
( define hours ( quotient totalMinutes 60 )) ; Almacena la cantidad de horas calculada
( define remainingMinutes ( remainder totalMinutes 60 )) ; Almacena los minutos restantes

; Mostramos por pantalla el resultado de la conversión a horas y minutos
( printf "\n~a minutos equivalen a ~a horas y ~a minutos." totalMinutes hours remainingMinutes )
