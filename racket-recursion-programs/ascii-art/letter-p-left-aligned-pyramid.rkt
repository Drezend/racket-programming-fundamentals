#lang racket
#|
Publication date: 09/03/2025
Publication time: 3:30 pm
Code version: 1.0
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program displays a figure composed of the letter 'P' in a specific pattern.
Caution: This program is designed to display the figure as described. 
         Results for other patterns are not guaranteed.
|#

( define ( DisplayFigureP currentRow currentSpaces currentLetters )
  ; currentRow: Current row being processed in the figure.
  ; currentSpaces: Number of spaces to indent the current row.
  ; currentLetters: Number of letters to display in the current row.
  ( if ( < currentRow 7 )
      ( begin
        ( printf "~a~a\n" ( make-string currentSpaces #\space ) ( make-string currentLetters #\P ) )
        ( DisplayFigureP ( + currentRow 1 ) ( + currentSpaces 1 ) ( - currentLetters 2 ) )
      ); end begin
  ; else
      ( printf "~a~a\n" ( make-string currentSpaces #\space ) ( make-string currentLetters #\P ) )
  ); end if:( < currentRow 7 )
); end function definition: DisplayFigureP

( DisplayFigureP 1 0 13 )