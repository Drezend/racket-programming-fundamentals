#lang racket
#|
Publication date: 07/03/2025
Publication time: 1:15 pm
Code version: 1.3
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program displays the Lucas sequence starting with 2 and 1, 
                      adding progressively the last two elements of the series.
                      The program will ask the user for the number of terms to display.
Caution: This program is designed to display Lucas numbers for a user-specified number of terms. 
         Results for very large numbers of terms may cause performance issues.
         This program is designed to work with positive integers. Results for negative or non-integer values are not guaranteed.
|#

( define ( LucasSeriesAux firstNumber secondNumber currentTerm counter )
  ; firstNumber: Stores the first number in the current Lucas calculation.
  ; secondNumber: Stores the second number in the current Lucas calculation.
  ; currentTerm: Stores the current Lucas number to be displayed.
  ; counter: Keeps track of how many terms are left to be displayed.
  ( if ( > counter 1 )
      ( begin
        ( printf "~a, " firstNumber )
        ( LucasSeriesAux secondNumber ( + firstNumber secondNumber ) secondNumber ( - counter 1 ) )
      )
  ; else: We've reached the last term to display
      ( printf "~a" firstNumber )
  ); end if: checking if we've reached the requested number of terms
); end function definition: LucasSeriesAux

( define ( LucasSeries )
  ; Main function that initiates the Lucas sequence calculation
  ( printf "Por favor ingrese el número de términos deseados: " )
  ( define desiredTerms (read) )
  ( printf "\nLos primeros (~a) números de la serie de Lucas son: " desiredTerms )
  ( LucasSeriesAux 2 1 2 desiredTerms )
); end function definition: LucasSeries

( printf "Este programa presenta la serie de Lucas como la serie que comienza con los dígitos 2 y 1 y va\nsumando progresivamente los dos últimos elementos de la serie, así: 2, 1, 3, 4, 7, 11, 18, 29, 47...\nEl programa solicitará la cantidad de términos a mostrar.\n" )
( LucasSeries )