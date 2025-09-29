#lang racket
#|
Publication date: 07/03/2025
Publication time: 2:00 pm
Code version: 1.3
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program displays the Perrin sequence starting with 3, 0 and 2, 
                      where each subsequent term is calculated as the sum of the second previous term and the third previous term.
                      The program will ask the user for the number of terms to display.
Caution: This program is designed to display Perrin numbers for a user-specified number of terms. 
         Results for very large numbers of terms may cause performance issues.
         This program is designed to work with positive integers. Results for negative or non-integer values are not guaranteed.
|#

[ define ( PerrinSeriesAux firstNumber secondNumber thirdNumber counter )
  ; firstNumber: Stores the first number in the current Perrin calculation.
  ; secondNumber: Stores the second number in the current Perrin calculation.
  ; thirdNumber: Stores the third number in the current Perrin calculation.
  ; counter: Keeps track of how many terms are left to be displayed.
  ( if ( > counter 1 )
      ( begin
        ( printf "~a, " firstNumber )
        ( PerrinSeriesAux secondNumber thirdNumber ( + firstNumber secondNumber ) ( - counter 1 ) )
      ); end begin
  ; else: We've reached the last term to display
      ( printf "~a" firstNumber )
  ); end if: checking if we've reached the requested number of terms
]; end function definition: PerrinSeriesAux

( define ( PerrinSeries )
  ; Main function that initiates the Perrin sequence calculation
  ( printf "Por favor ingrese el número de términos deseados: " )
  ( define desiredTerms (read) )
  ( printf "\nLos primeros (~a) números de la serie de Perrin son: " desiredTerms )
  ( PerrinSeriesAux 3 0 2 desiredTerms )
); end function definition: PerrinSeries

( printf "Este programa presenta la serie de Perrin como la serie que comienza con los dígitos 3, 0 y 2 y va\nsumando progresivamente el segundo término anterior más el tercero anterior, así: 3, 0, 2, 3, 2, 5, 5, 7, 10...\nEl programa solicitará la cantidad de términos a mostrar.\n" )
( PerrinSeries )