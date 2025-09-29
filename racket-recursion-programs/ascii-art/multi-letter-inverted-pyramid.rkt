#lang racket
#|
Publication date: 08/03/2025
Publication time: 5:30 pm
Code version: 1.0
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program displays a figure composed of specific letters in a pattern.
Caution: This program is designed to display the figure as described. 
         Results for other patterns are not guaranteed.
|#

( define ( GetLetterByRow rowNumber )
  ; rowNumber: The row number to determine which letter to display.
  ( if ( = rowNumber 1 )
      #\P
  ; else
      ( if ( = rowNumber 2 )
           #\N
      ; else
           ( if ( = rowNumber 3 )
                #\L
           ; else
                ( if ( = rowNumber 4 )
                     #\J
                ; else
                     ( if ( = rowNumber 5 )
                          #\H
                     ; else
                          ( if ( = rowNumber 6 )
                               #\F
                          ; else
                               ( if ( = rowNumber 7 )
                                    #\D
                               ; else
                                    #\space
                               ); end if:( = rowNumber 7 )
                          ); end if:( = rowNumber 6 )
                     ); end if:( = rowNumber 5 )
                ); end if:( = rowNumber 4 )
           ); end if:( = rowNumber 3 )
      ); end if:( = rowNumber 2 )
  ); end if:( = rowNumber 1 )
); end function definition: GetLetterByRow

( define ( DisplayLetterFigure currentColumn currentRow currentSpaces )
  ; currentColumn: Number of columns remaining in the figure.
  ; currentRow: Current row being processed in the figure.
  ; currentSpaces: Number of spaces to indent the current row.
  ( if ( < currentRow 7 )
      ( begin
        ( printf "~a~a\n" ( make-string currentSpaces #\space ) ( make-string currentColumn ( GetLetterByRow currentRow ) ) )
        ( DisplayLetterFigure ( - currentColumn 2 ) ( + currentRow 1 ) ( + currentSpaces 1 ) )
      ); end begin
  ; else
      ( printf "~a~a\n" ( make-string currentSpaces #\space ) ( make-string currentColumn ( GetLetterByRow currentRow ) ) )
  ); end if:( < currentRow 7 )
); end function definition: DisplayLetterFigure

( DisplayLetterFigure 13 1 0 )