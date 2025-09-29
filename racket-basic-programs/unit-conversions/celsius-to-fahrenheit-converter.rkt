#lang racket

#|
- Fecha de publicación: 14/02/2025
- Hora: 12:01 a.m
- Versión: 1.0
- Autor: Ing(c) Andres David Rincon Salazar
- Nombre del lenguaje utilizado: Racket
- Versión del lenguaje utilizado: 8.15
- Presentado a: Doctor Ricardo Moreno Laverde
- Universidad Tecnológica de Pereira
- Programa de Ingeniería de Sistemas y Computación
- Este programa convierte grados Celsius a Fahrenheit utilizando la fórmula estándar de conversión.
|#


; Mostramos por pantalla lo que requerimos del usuario, en este caso el numero de grados centigrados que pasaremos a Fahrenheit
( printf "Por favor digite los centigrados a convertir a Fahrenheit: " )

; Almacenamos el valor de grados Celsius ingresado por el usuario
( define celciusDegrees (read))

; Conviertimos de grados Celsius a Fahrenheit con la formula estandar
( define fahrenheitDegrees ( + ( / ( * 9 celciusDegrees ) 5) 32.0 )) ; Almacena el resultado de la conversión

; Mostramos por pantalla el numero dado por el usuario y luego cual es su conversion a fahrenheit
( printf "\n~a°C son ~a grados Fahrenheit." celciusDegrees fahrenheitDegrees )
