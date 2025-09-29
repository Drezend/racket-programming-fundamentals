#lang racket

#|
- Fecha de publicación: 14/02/2025
- Hora: 12:35 a.m
- Versión: 1.0
- Autor: Ing(c) Andres David Rincon Salazar
- Nombre del lenguaje utilizado: Racket
- Versión del lenguaje utilizado: 8.15
- Presentado a: Doctor Ricardo Moreno Laverde
- Universidad Tecnológica de Pereira
- Programa de Ingeniería de Sistemas y Computación
- Este programa calcula el volumen de una esfera con el radio ingresado por el usuario.
|#

; Mostramos por pantalla lo que requerimos del usuario, en este caso el radio de la esfera
( printf "Por favor digite el radio de la esfera: ")

; Almacenamos el valor del radio ingresado por el usuario
( define sphereRadius (read))

; Calculamos el volumen de la esfera usando la fórmula 4/3 * π * r^3
( define sphereVolume ( * ( / 4.0 3 ) pi ( expt sphereRadius 3 ))) ; Almacena el volumen calculado

; Mostramos por pantalla el radio ingresado y el volumen de la esfera calculado
( printf "\nEl volumen de una esfera de radio ~a es de ~a" sphereRadius sphereVolume )
