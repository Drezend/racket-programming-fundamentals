#lang racket
#|
Publication date: 08/03/2025
Publication time: 3:30 pm
Code version: 1.2
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program displays multiplication tables from 1 to 10,
                      showing all multiplications from 1 to 10 for each table.
Caution: This program is designed to display multiplication tables from 1 to 10.
         Results for other ranges are not guaranteed.
|#

[ define ( MultiplicationTablesAux tableNumber numberToMultiply )
  ; tableNumber: Stores the current multiplication table number (1-10).
  ; numberToMultiply: Stores the current number to multiply with the table number (1-10).
  ( if ( <= tableNumber 10 )
      ( begin
        ( if ( <= numberToMultiply 10 )
            ( begin
              ( printf "~a x ~a = ~a\n" tableNumber numberToMultiply ( * tableNumber numberToMultiply ) )
              ( MultiplicationTablesAux tableNumber ( + numberToMultiply 1 ) )
            ) ; end begin: printing current multiplication
        ; else: We've completed the current table
            ( MultiplicationTablesAux ( + tableNumber 1 ) 1 )
        ) ; end if: checking if we've completed the current table
      ) ; end begin: processing tables
  ; else: We've completed all 10 tables
      ( void )
  ) ; end if: checking if we've processed all tables
] ; end function definition: MultiplicationTablesAux

( define ( MultiplicationTables )
  ; Main function that initiates the multiplication tables calculation
  ( MultiplicationTablesAux 1 1 )
) ; end function definition: MultiplicationTables

( printf "Este programa muestra las tablas de multiplicar del 1 al 10.\n" )
( MultiplicationTables )