#lang racket
#|
Publication date: 07/03/2025
Publication time: 3:15 pm
Code version: 1.3
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program displays the Narayana sequence starting with 1, 1 and 1, 
                      where each subsequent term is calculated as the sum of the previous term and the third previous term.
                      The program will ask the user for the number of terms to display.
Caution: This program is designed to display Narayana numbers for a user-specified number of terms. 
         Results for very large numbers of terms may cause performance issues.
         This program is designed to work with positive integers. Results for negative or non-integer values are not guaranteed.
|#

[ define ( NarayanaSeriesAux firstNumber secondNumber thirdNumber counter )
  ; firstNumber: Stores the first number in the current Narayana calculation.
  ; secondNumber: Stores the second number in the current Narayana calculation.
  ; thirdNumber: Stores the third number in the current Narayana calculation.
  ; counter: Keeps track of how many terms are left to be displayed.
  ( if ( > counter 1 )
      ( begin
        ( printf "~a, " firstNumber )
        ( NarayanaSeriesAux secondNumber thirdNumber ( + thirdNumber firstNumber ) ( - counter 1 ) )
      ); end begin
  ; else: We've reached the last term to display
      ( printf "~a" firstNumber )
  ); end if: checking if we've reached the requested number of terms
]; end function definition: NarayanaSeriesAux

( define ( NarayanaSeries )
  ; Main function that initiates the Narayana sequence calculation
  ( printf "Por favor ingrese el número de términos deseados: " )
  ( define desiredTerms (read) )
  ( printf "\nLos primeros (~a) números de la serie de Narayana son: " desiredTerms )
  ( NarayanaSeriesAux 1 1 1 desiredTerms )
); end function definition: NarayanaSeries

( printf "Este programa presenta la serie de Narayana como la serie que comienza con los dígitos 1, 1 y 1 y va\nsumando progresivamente el término anterior más el tercero anterior, así: 1, 1, 1, 2, 3, 4, 6, 9, 13...\nEl programa solicitará la cantidad de términos a mostrar.\n" )
( NarayanaSeries )