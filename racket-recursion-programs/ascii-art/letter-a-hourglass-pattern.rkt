#lang racket
#|
Publication date: 09/03/2025
Publication time: 4:30 pm
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

( define ( DisplayFigureA currentRow initialSpaces middleSpaces currentLetters )
  ; currentRow: Current row being processed in the figure.
  ; initialSpaces: Number of spaces at the beginning of the row.
  ; middleSpaces: Number of spaces between the letters.
  ; currentLetters: Number of letters to display in the current row.
  ( if ( < currentRow 4 )
      ( begin
        ( printf "~a~a~a~a\n" ( make-string initialSpaces #\space ) ( make-string currentLetters #\A ) ( make-string middleSpaces #\space ) ( make-string currentLetters #\A ) )
        ( DisplayFigureA ( + currentRow 1 ) initialSpaces ( - middleSpaces 2 ) ( + currentLetters 1 ) )
      ); end begin
  ; else
      ( if ( = currentRow 4 )
           ( begin
              ( printf "~a~a\n" ( make-string initialSpaces #\space ) ( make-string 7 #\A ) )
              ( DisplayFigureA ( + currentRow 1 ) initialSpaces 1 ( - currentLetters 1 ) )
           ); end begin
      ; else
           ( if ( < currentRow 7 )
                ( begin
                   ( printf "~a~a~a~a\n" ( make-string initialSpaces #\space ) ( make-string currentLetters #\A ) ( make-string middleSpaces #\space ) ( make-string currentLetters #\A ) )
                   ( DisplayFigureA ( + currentRow 1 ) initialSpaces ( + middleSpaces 2 ) ( - currentLetters 1 ) )
                ); end begin
           ; else
                     ( printf "~a~a~a~a\n" ( make-string initialSpaces #\space ) ( make-string currentLetters #\A ) ( make-string middleSpaces #\space ) ( make-string currentLetters #\A ) )
           ); end if:( < currentRow 7 )
      ); end if:( = currentRow 4 )
  ); end if:( < currentRow 4 )
); end function definition: DisplayFigureA

( DisplayFigureA 1 27 5 1 )