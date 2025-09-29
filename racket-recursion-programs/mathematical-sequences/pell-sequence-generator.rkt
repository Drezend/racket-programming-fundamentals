#lang racket
#|
Publication date: 07/03/2025
Publication time: 1:35 pm
Code version: 1.7
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program displays the Pell sequence starting with 0 and 1, 
                      where each subsequent term is calculated as 2 times the previous term plus the term before that.
                      The program will ask the user for the number of terms to display.
Caution: This program is designed to display Pell numbers for a user-specified number of terms. 
         Results for very large numbers of terms may cause performance issues.
         This program is designed to work with positive integers. Results for negative or non-integer values are not guaranteed.
|#

[ define ( PellSeriesAux firstNumber secondNumber currentTerm counter )
  ; firstNumber: Stores the first number in the current Pell calculation.
  ; secondNumber: Stores the second number in the current Pell calculation.
  ; currentTerm: Stores the current Pell number to be displayed.
  ; counter: Keeps track of how many terms are left to be displayed.
  ( if ( > counter 1 )
      ( begin
        ( printf "~a, " firstNumber )
        ( PellSeriesAux secondNumber ( + ( * 2 secondNumber ) firstNumber ) secondNumber ( - counter 1 ) )
      ); end begin
  ; else: We've reached the last term to display
      ( printf "~a" firstNumber )
  ); end if: checking if we've reached the requested number of terms
]; end function definition: PellSeriesAux

( define ( PellSeries )
  ; Main function that initiates the Pell sequence calculation
  ( printf "Por favor ingrese el número de términos deseados: " )
  ( define desiredTerms (read) )
  ( printf "\nLos primeros (~a) números de la serie de Pell son: " desiredTerms )
  ( PellSeriesAux 0 1 0 desiredTerms )
); end function definition: PellSeries

( printf "Este programa presenta la serie de Pell como la serie que comienza con los dígitos 0 y 1 y va\nsumando progresivamente el doble del término anterior más el término anterior al anterior, así: 0, 1, 2, 5, 12,\n29, 70, 169, 408...\nEl programa solicitará la cantidad de términos a mostrar.\n" )
( PellSeries )