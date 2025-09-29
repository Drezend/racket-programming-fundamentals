#lang racket

#|
- Fecha de publicación: 14/02/2025
- Hora: 3:00 p.m
- Versión: 1.0
- Autor: Ing(c) Andres David Rincon Salazar
- Nombre del lenguaje utilizado: Racket
- Versión del lenguaje utilizado: 8.15
- Presentado a: Doctor Ricardo Moreno Laverde
- Universidad Tecnológica de Pereira
- Programa de Ingeniería de Sistemas y Computación
- Este programa solicita el nombre, apellido y año de nacimiento del usuario y los imprime en pantalla.
|#

; Pedimos el nombre del usuario
( printf "Por favor digite su nombre: ")
( define firstName (read))

; Pedimos el apellido del usuario
( printf "Por favor digite su apellido: ")
( define lastName (read))

; Pedimos el año de nacimiento del usuario
( printf "Por favor digite su año de nacimiento: ")
( define birthYear (read))

; Mostramos por pantalla los datos ingresados
( printf "\n~a ~a ~a" firstName lastName birthYear )
