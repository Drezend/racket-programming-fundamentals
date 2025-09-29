#lang racket
#|
Publication date: 14/03/2025
Publication time: 3:00 pm
Code version: 1.3
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program calculates the Taylor series expansion for the function ln(x).
                     It prompts the user for the value of x and the number of terms to compute.
Caution: This program is designed to work with positive integers and floating-point numbers. 
         Results for invalid inputs are not guaranteed.
         The terms of the series will be displayed as floating-point numbers, and the total sum 
         will also be displayed as a floating-point number. Due to the nature of floating-point arithmetic, 
         there may be minor inaccuracies in the representation of the terms. After a certain term, 
         the values will be displayed in scientific notation for better readability.
|#

( define ( ComputeTaylorSeries xValue numberOfTerms currentTerm totalSum )
   ; xValue: The value of x in the Taylor series expansion.
   ; numberOfTerms: The total number of terms to calculate.
   ; currentTerm: The current term being processed.
   ; totalSum: The accumulated sum of the series terms.
  ( if ( < currentTerm numberOfTerms )
      ( begin
        ( printf "Término #~a: ~a\n" currentTerm ( * ( expt -1 currentTerm ) ( / ( expt ( - xValue 1 ) ( + currentTerm 1 ) ) ( + currentTerm 1 ) ) ) )
        ( ComputeTaylorSeries xValue numberOfTerms ( + currentTerm 1 ) ( + totalSum ( * ( expt -1 currentTerm ) ( / ( expt ( - xValue 1 ) ( + currentTerm 1 ) ) ( + currentTerm 1 ) ) ) ) )
      ); end begin
  ; else
      ( printf "\nTotal suma: ~a\n" totalSum )
  ); end if
); end function definition: ComputeTaylorSeries

( define ( DisplayTaylorSeries )
  ; Main function that begins the computation of the Taylor Series
  ( printf "Función: ln(x)\n\nSalvedad: Los términos se mostrarán como números de punto flotante,\ny el total de la suma también se mostrará como un número de punto flotante.\nDebido a la naturaleza de la aritmética de punto flotante, pueden\nocurrir pequeñas inexactitudes en la representación de los términos y la suma final.\nDespués de cierto término, los valores se mostrarán en notación científica para mejor legibilidad.\n\nPor favor ingrese el valor de x: " )
  ( define xValue ( read ) )
  ( printf "Por favor ingrese el número de términos a calcular: " )
  ( define numberOfTerms ( read ) )
  ( printf "\n" )
  ( ComputeTaylorSeries xValue numberOfTerms 0 0 )
); end function definition: DisplayTaylorSeries

( DisplayTaylorSeries )