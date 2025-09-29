#lang racket
#|
Publication date: 08/03/2025
Publication time: 5:20 pm
Code version: 1.2
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

( define ( DisplayFigureA currentColumn currentRow )
  ; currentColumn: Number of columns remaining in the figure.
  ; currentRow: Current row being processed in the figure.
  ( if ( < currentRow 25 )
      ( begin
        ( printf "~a~a\n" ( make-string ( - currentColumn 1 ) #\space ) ( make-string ( + currentRow 1 ) #\A ) )
        ( DisplayFigureA ( - currentColumn 1 ) ( + currentRow 1 ) )
      ); end begin
  ; else
      ( void )
  ); end if
); end function definition: DisplayFigureA

( DisplayFigureA 80 0 )