#lang racket
#|
Publication date: 08/03/2025
Publication time: 12:20 pm
Code version: 1.4
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program reads an integer from the keyboard and prints it in reverse order.
Caution: This program is designed to work with positive integers. 
         Results for negative or non-integer values are not guaranteed.
|#

( define ( ReverseNumberAux number reversedNumber )
  ; number: The number to be reversed.
  ; reversedNumber: The current reversed number being built.
  ( if ( = number 0 )
      reversedNumber
  ; else
      ( ReverseNumberAux ( quotient number 10 ) ( + ( * reversedNumber 10 ) ( remainder number 10 ) ) )
  ); end if:( = number 0 )
); end function definition: ReverseNumberAux

( define ( ReverseNumber )
  ; Main function that initiates the number reversal process.
  ( printf "Este programa lee desde el teclado un número\nentero y lo imprime al revés.\nEntre el número: " )
  ( define inputNumber ( read ) )
  ( printf "~a\n" ( ReverseNumberAux inputNumber 0 ) )
); end function definition: ReverseNumber

( ReverseNumber )