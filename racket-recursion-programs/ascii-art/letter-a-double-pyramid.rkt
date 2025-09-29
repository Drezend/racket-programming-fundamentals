#lang racket
#|
Publication date: 09/03/2025
Publication time: 6:10 pm
Code version: 1.9
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program displays a figure composed of the letter 'A' in a specific pattern.
Caution: This program is designed to display the figure as described. 
         Results for other patterns are not guaranteed.
|#

( define ( DisplayFigureA currentRow currentSpaces currentLetters )
  ; currentRow: Current row being processed in the figure.
  ; currentSpaces: Number of spaces to indent the current row.
  ; currentLetters: Number of letters to display in the current row.
  ( if ( < currentRow 6 )
      ( begin
        ( printf "~a~a\n" ( make-string currentSpaces #\space ) ( make-string currentLetters #\A ) )
        ( DisplayFigureA ( + currentRow 1 ) ( - currentSpaces 1 ) ( + currentLetters 1 ) )
      ); end begin
  ; else
      ( if ( = currentRow 6 )
           ( begin
             ( printf "~a~a\n" ( make-string currentSpaces #\space ) ( make-string currentLetters #\A ) )
             ( DisplayFigureA ( + currentRow 1 ) ( + currentSpaces 1 ) ( - currentLetters 1 ) )
           ); end begin
      ; else
           ( if ( < currentRow 11 )
                ( begin
                  ( printf "~a~a\n" ( make-string currentSpaces #\space ) ( make-string currentLetters #\A ) )
                  ( DisplayFigureA ( + currentRow 1 ) ( + currentSpaces 1 ) ( - currentLetters 1 ) )
                ); end begin
           ; else
                ( printf "~a~a\n" ( make-string currentSpaces #\space ) ( make-string currentLetters #\A ) )
           ); end if:( < currentRow 11 )
      ); end if:( = currentRow 6 )
  ); end if:( < currentRow 6 )
); end function definition: DisplayFigureA

( DisplayFigureA 1 39 1 )