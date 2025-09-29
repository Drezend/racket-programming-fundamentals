#lang racket

#|
- Fecha de publicación: 14/02/2025
- Hora: 1:58 p.m
- Versión: 1.0
- Autor: Ing(c) Andres David Rincon Salazar
- Nombre del lenguaje utilizado: Racket
- Versión del lenguaje utilizado: 8.15
- Presentado a: Doctor Ricardo Moreno Laverde
- Universidad Tecnológica de Pereira
- Programa de Ingeniería de Sistemas y Computación
- Este programa convierte una cantidad de horas y minutos a su equivalente en minutos totales.
|#

; Mostramos por pantalla lo que requerimos del usuario, en este caso las horas y minutos a convertir
( printf "Por favor digite la cantidad de horas: " )

; Almacenamos el valor de horas ingresado por el usuario
( define hours (read))

; Pedimos y almacenamos el valor de minutos ingresado
( printf "Por favor digite la cantidad de minutos: " )
( define minutes (read))

; Convertimos las horas y minutos a minutos totales
( define totalMinutes ( + ( * hours 60 ) minutes )) ; Almacena el resultado de la conversión

; Mostramos por pantalla el resultado de la conversión a minutos
( printf "\n~a horas y ~a minutos equivalen a ~a minutos." hours minutes totalMinutes )
