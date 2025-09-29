#lang racket

#|
- Fecha de publicación: 14/02/2025
- Hora: 3:35 p.m
- Versión: 1.0
- Autor: Ing(c) Andres David Rincon Salazar
- Nombre del lenguaje utilizado: Racket
- Versión del lenguaje utilizado: 8.15
- Presentado a: Doctor Ricardo Moreno Laverde
- Universidad Tecnológica de Pereira
- Programa de Ingeniería de Sistemas y Computación
- Este programa solicita dos números y realiza las operaciones básicas: suma, resta, multiplicación y división.
|#

; Pedimos el primer número al usuario
( printf "Por favor digite el primer numero: ")
( define firstNumber (read))

; Pedimos el segundo número al usuario
( printf "Por favor digite el segundo numero: ")
( define secondNumber (read))

; Mostramos los resultados de las operaciones matemáticas básicas
( printf "\nSuma: ~a \nResta: ~a \nMultiplicacion: ~a \nDivision: ~a"
         (+ firstNumber secondNumber)  ; Calcula la suma
         (- firstNumber secondNumber)  ; Calcula la resta
         (* firstNumber secondNumber)  ; Calcula la multiplicación
         (/ firstNumber secondNumber 1.)  ; Calcula la división
        )
