#lang racket

#|
- Fecha de publicación: 14/02/2025
- Hora: 4:30 p.m
- Versión: 1.0
- Autor: Ing(c) Andres David Rincon Salazar
- Nombre del lenguaje utilizado: Racket
- Versión del lenguaje utilizado: 8.15
- Presentado a: Doctor Ricardo Moreno Laverde
- Universidad Tecnológica de Pereira
- Programa de Ingeniería de Sistemas y Computación
- Este programa convierte una cantidad de millas por hora (mph) a metros por segundo (m/s) utilizando la conversión estándar.
|#

; Mostramos por pantalla lo que requerimos del usuario, en este caso la cantidad de millas por hora a convertir
( printf "Por favor digite la cantidad de mph que desea convertir a m/s: ")

; Almacenamos el valor de millas por hora ingresado por el usuario
( define milesPerHour (read))

; Convertimos de mph a m/s usando la equivalencia 1 milla = 1609.344 metros y 1 hora = 3600 segundos
( define metersPerSecond ( / ( * milesPerHour 1609.344 ) 3600 )) ; Almacena el resultado de la conversión

; Mostramos por pantalla el resultado de la conversión
( printf "\n~a mph equivalen a ~a m/s." milesPerHour metersPerSecond )
