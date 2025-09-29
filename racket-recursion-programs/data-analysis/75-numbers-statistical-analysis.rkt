#lang racket
#|
Publication date: 08/03/2025
Publication time: 2:50 pm
Code version: 5.5
Author: Ing(c) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program reads 75 numbers from the keyboard, ensuring they are different from zero.
                      It then calculates and displays:
                      * The count of numbers greater than 150
                      * The largest and smallest numbers in the group
                      * The count of negative numbers
                      * The average of the positive numbers found.
Caution: This program is designed to work with 75 non-zero numbers. 
         Results for other quantities or zero values are not guaranteed.
The current program calculates the average of positive numbers by dividing the sum
of positive numbers by 75 (the total number of inputs). This may not be correct if
the goal is to calculate the average of positive numbers relative to the count of
positive numbers found, rather than the total number of inputs. If that is the case,
the code would need to be modified to count the number of positive numbers and divide
the sum of positives by that count.


|#

[ define ( GetNumber number )
  ; number: The current number being requested from the user.
  ( printf "Por favor ingrese el número #~a: " number )
  ( define actualNumberToEvaluate (read) )
  ( if ( = actualNumberToEvaluate 0 )
      ( begin
        ( printf "Por favor ingrese un número diferente de 0.\n" )
        ( GetNumber number )
      ); end begin
  ; else
      actualNumberToEvaluate
  ); end if: checking if the number is zero
]; end function definition: GetNumber

[ define ( Evaluate75NumbersAux numberToEvaluate greaterThan150 greaterNumber lowestNumber negativeNumbers averagePositives )
  ; numberToEvaluate: The current number being evaluated.
  ; greaterThan150: Count of numbers greater than 150.
  ; greaterNumber: The largest number found so far.
  ; lowestNumber: The smallest number found so far.
  ; negativeNumbers: Count of negative numbers.
  ; averagePositives: Sum of positive numbers for calculating the average.
  ( define currentNumber ( GetNumber numberToEvaluate ) )
  ( if ( < numberToEvaluate 75 )
      ( begin
        ( Evaluate75NumbersAux
          ( + numberToEvaluate 1 )
          ( if ( > currentNumber 150 )
              ( + greaterThan150 1 )
          ; else
              greaterThan150
          ); end if: checking if the number is greater than 150
          ( if ( > currentNumber greaterNumber )
              currentNumber
          ; else
              greaterNumber
          ); end if: updating the largest number
          ( if ( or ( = numberToEvaluate 1 ) ( < currentNumber lowestNumber ) )
              currentNumber
          ; else
              lowestNumber
          ); end if: updating the smallest number
          ( if ( < currentNumber 0 )
              ( + negativeNumbers 1 )
          ; else
              negativeNumbers
          ); end if: counting negative numbers
          ( if ( > currentNumber 0 )
              ( + averagePositives currentNumber )
          ; else
              averagePositives
          ); end if: summing positive numbers
        ); end recursive call: Evaluate75NumbersAux
      ); end begin
  ; else
      ( if ( = numberToEvaluate 75 )
          ( printf "\n---Resultados de la evaluación de los 75 números---\nCantidad de números mayores que 150: ~a\nMayor número: ~a\nMenor número: ~a\nCantidad de números negativos: ~a\nPromedio de los números positivos encontrados: ~a"
                   ( if ( > currentNumber 150 )
                       ( + greaterThan150 1 )
                   ; else
                       greaterThan150
                   ); end if: checking if the last number is greater than 150
                   ( if ( > currentNumber greaterNumber )
                       currentNumber
                   ; else
                       greaterNumber
                   ); end if: updating the largest number
                   ( if ( or ( = numberToEvaluate 1 ) ( < currentNumber lowestNumber ) )
                       currentNumber
                   ; else
                       lowestNumber
                   ); end if: updating the smallest number
                   ( if ( < currentNumber 0 )
                       ( + negativeNumbers 1 )
                   ; else
                       negativeNumbers
                   ); end if: counting negative numbers
                   ( if ( > currentNumber 0 )
                       ( / ( + averagePositives currentNumber ) 75.0 )
                   ; else
                       ( / averagePositives 75.0 )
                   ); end if: calculating the average of positive numbers
          ); end printf: displaying results
      ; else
          (void)
      ); end if: checking if all 75 numbers have been evaluated
  ); end if: checking if the current number is less than 75
]; end function definition: Evaluate75NumbersAux

( define ( Evaluate75Numbers )
  ; Main function that initiates the evaluation of 75 numbers
  ( printf "Este programa lee desde el teclado un grupo de 75 números,\ndiferentes a cero y al final de leídos, imprime:\n* Cantidad de números mayores que 150\n* Número mayor y número menor encontrado en el grupo\n* Cantidad de números negativos encontrados\n* Promedio de los positivos encontrados.\n" )
  ( Evaluate75NumbersAux 1 0 0 0 0 0 )
); end function definition: Evaluate75Numbers

( Evaluate75Numbers )