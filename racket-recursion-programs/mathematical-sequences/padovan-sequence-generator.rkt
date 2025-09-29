#lang racket
#|
Publication date: 07/03/2025
Publication time: 2:35 pm
Code version: 1.7
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program displays the Padovan sequence starting with 1, 0 and 0, 
                      where each subsequent term is calculated as the sum of the second previous term and the third previous term.
                      The program will ask the user for the number of terms to display.
Caution: This program is designed to display Padovan numbers for a user-specified number of terms. 
         Results for very large numbers of terms may cause performance issues.
         This program is designed to work with positive integers. Results for negative or non-integer values are not guaranteed.
|#

[ define ( PadovanSeriesAux firstNumber secondNumber thirdNumber counter )
  ; firstNumber: Stores the first number in the current Padovan calculation.
  ; secondNumber: Stores the second number in the current Padovan calculation.
  ; thirdNumber: Stores the third number in the current Padovan calculation.
  ; counter: Keeps track of how many terms are left to be displayed.
  ( if ( > counter 1 )
      ( begin
        ( printf "~a, " firstNumber )
        ( PadovanSeriesAux secondNumber thirdNumber ( + firstNumber secondNumber ) ( - counter 1 ) )
      ); end begin
  ; else: We've reached the last term to display
      ( printf "~a" firstNumber )
  ); end if: checking if we've reached the requested number of terms
]; end function definition: PadovanSeriesAux

( define ( PadovanSeries )
  ; Main function that initiates the Padovan sequence calculation
  ( printf "Por favor ingrese el número de términos deseados: " )
  ( define desiredTerms (read) )
  ( printf "\nLos primeros (~a) números de la serie de Padovan son: " desiredTerms )
  ( PadovanSeriesAux 1 0 0 desiredTerms )
); end function definition: PadovanSeries

( printf "Este programa presenta la serie de Padovan como la serie que comienza con los dígitos 1, 0 y 0 y se calcula\ncomo la suma de los dos términos anteriores y el tercer término anterior.\nLa fórmula para el enésimo número de Padovan es P(n) = P(n-2) + P(n-3), donde P(0) = 1, P(1) = 0 y P(2) = 0.\nLos primeros nueve(9) números de la serie de Padovan son: 1, 0, 0, 1, 0, 1, 1, 1, 2\nEl programa solicitará la cantidad de términos a mostrar.\n" )
( PadovanSeries )