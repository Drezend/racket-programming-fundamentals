#lang racket

#|
- Fecha de publicación: 14/02/2025
- Hora: 5:00 p.m
- Versión: 1.0
- Autor: Ing(c) Andres David Rincon Salazar
- Nombre del lenguaje utilizado: Racket
- Versión del lenguaje utilizado: 8.15
- Presentado a: Doctor Ricardo Moreno Laverde
- Universidad Tecnológica de Pereira
- Programa de Ingeniería de Sistemas y Computación
- Este programa convierte una cantidad de horas, minutos y segundos a milisegundos.
|#

; Mostramos por pantalla lo que requerimos del usuario, en este caso el número de horas, minutos y segundos a convertir
( printf "Por favor digite el numero de horas, minutos y segundos que desea convertir a milisegundos. \n\nDigite horas: ")

; Almacenamos el valor de horas ingresado por el usuario
( define hours (read))

; Pedimos y almacenamos los minutos ingresados
( printf "Digite minutos: ")
( define minutes (read))

; Pedimos y almacenamos los segundos ingresados
( printf "Digite segundos: ")
( define seconds (read))

; Convertimos el tiempo total a milisegundos
( define milliseconds ( + ( * hours 3600000 ) ( * minutes 60000 ) ( * seconds 1000 ) )) ; Almacena el resultado de la conversión

; Mostramos por pantalla el resultado de la conversión a milisegundos
( printf "\nLa cantidad de milisegundos para ~a horas, ~a minutos y ~a segundos es de ~a milisegundos." hours minutes seconds milliseconds )
