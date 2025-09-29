#lang racket
#|
Publication date: 09/03/2025
Publication time: 5:40 pm
Code version: 1.9
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program displays a figure composed of the letter 'Z' in a specific pattern.
Caution: This program is designed to display the figure as described. 
         Results for other patterns are not guaranteed.
|#

( define ( DisplayFigureZ currentRow initialSpaces middleSpaces currentLetters )
  ; currentRow: Current row being processed in the figure.
  ; initialSpaces: Number of spaces at the beginning of the row.
  ; middleSpaces: Number of spaces between the letters.
  ; currentLetters: Number of letters to display in the current row.
  ( if ( = currentRow 1 )
      ( begin
        ( printf "~a~a~a\n" ( make-string initialSpaces #\space ) ( make-string currentLetters #\Z ) ( make-string middleSpaces #\space ) )
        ( DisplayFigureZ ( + currentRow 1 ) ( - initialSpaces 1 ) ( + middleSpaces 1 ) currentLetters )
      ); end begin
  ; else
      ( if ( = currentRow 2 )
           ( begin
             ( printf "~a~a~a~a\n" ( make-string initialSpaces #\space ) ( make-string currentLetters #\Z ) ( make-string middleSpaces #\space ) ( make-string currentLetters #\Z ) )
             ( DisplayFigureZ ( + currentRow 1 ) ( - initialSpaces 1 ) ( + middleSpaces 2 ) currentLetters )
           ); end begin
      ; else
           ( if ( < currentRow 10 )
                ( begin
                  ( printf "~a~a~a~a\n" ( make-string initialSpaces #\space ) ( make-string currentLetters #\Z ) ( make-string middleSpaces #\space ) ( make-string currentLetters #\Z ) )
                  ( DisplayFigureZ ( + currentRow 1 ) ( - initialSpaces 1 ) ( + middleSpaces 2 ) currentLetters )
                ); end begin
           ; else
                ( printf "~a~a~a~a\n" ( make-string initialSpaces #\space ) ( make-string currentLetters #\Z ) ( make-string middleSpaces #\space ) ( make-string currentLetters #\Z ) )
           ); end if:( < currentRow 10 )
      ); end if:( = currentRow 2 )
  ); end if:( = currentRow 1 )
); end function definition: DisplayFigureZ

( DisplayFigureZ 1 9 0 1 )