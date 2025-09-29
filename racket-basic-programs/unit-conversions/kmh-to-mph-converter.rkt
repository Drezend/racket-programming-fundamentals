#lang racket

#|
- Fecha de publicación: 14/02/2025
- Hora: 1:30 p.m
- Versión: 1.0
- Autor: Ing(c) Andres David Rincon Salazar
- Nombre del lenguaje utilizado: Racket
- Versión del lenguaje utilizado: 8.15
- Presentado a: Doctor Ricardo Moreno Laverde
- Universidad Tecnológica de Pereira
- Programa de Ingeniería de Sistemas y Computación
- Este programa convierte una velocidad dada en kilómetros por hora (Km/h) a millas por hora (mph).
|#

; Mostramos por pantalla lo que requerimos del usuario, en este caso la velocidad en Km/h a convertir
( printf "Por favor digite cuantos Km/h quiere convertir a mph: " )

; Almacenamos el valor de velocidad en Km/h ingresado por el usuario
( define kilometersPerHour (read))

; Convertimos de Km/h a mph usando la equivalencia 1 Km = 0.621371 millas
( define milesPerHour ( * kilometersPerHour 0.621371 )) ; Almacena el resultado de la conversión

; Mostramos por pantalla el resultado de la conversión
( printf "\n~a Km/h equivalen a ~a mph." kilometersPerHour milesPerHour )
