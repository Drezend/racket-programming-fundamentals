#lang racket

#|
Publication date: 26/02/2025
Publication time: 01:00 pm
Code version: 1.9
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program determines whether a student passes or fails a course based on the average of three grades.
Caution: This program assumes grades are on a scale of 0.0 to 5.0. Results for values outside this range are not guaranteed.
|#


{define (CheckStudentApproval)
  (printf "Este programa determina si un alumno aprueba o reprueba un curso, sabiendo que aprobará si su promedio de tres calificaciones es mayor o igual a 3,0 y reprueba en caso contrario.\n")
  (printf "\nPor favor ingrese la primera nota: ")
  [define firstGrade (read)] ; firstGrade: Stores the first grade entered by the user.
  (printf "Por favor ingrese la segunda nota: ")
  [define secondGrade (read)] ; secondGrade: Stores the second grade entered by the user.
  (printf "Por favor ingrese la tercera nota: ")
  [define thirdGrade (read)] ; thirdGrade: Stores the third grade entered by the user.
  [define finalGrade (/ (+ firstGrade secondGrade thirdGrade) 3.0)] ; finalGrade: Calculates the average of the three grades.
  [if (>= finalGrade 3.0)
      (printf "Si aprueba, con una nota final de: ~a" finalGrade)
  ; else: Student failed the course
      (printf "No aprueba, con una nota final de: ~a" finalGrade)
  ] ; end if: checking if student passes with grade >= 3.0
} ; end function definition: CheckStudentApproval

(CheckStudentApproval)