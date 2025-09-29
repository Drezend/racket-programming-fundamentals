#lang racket

#|
Publication date: 24/02/2025
Publication time: 02:38 pm
Code version: 1.3
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program reads a number between 1 and 12 and prints the corresponding month.
Caution: For values outside this range, results are not guaranteed.
|#


{define (PrintMonthByNumber)
  (printf "Este programa, lee un número entre [1 y 12] e imprime\nel mes que le corresponde en el año. Referencia:\n1=Enero. 12=Diciembre.\nSalvedad: Para valores fuera de este rango, no\ngarantizamos los resultados.")
  (printf "\nEntre un número: ")
  [define monthNumber (read)] ; monthNumber: Stores the number entered by the user.
  [if (= monthNumber 1)
      (printf "El mes es Enero")
  ; else
      {begin
        [if (= monthNumber 2)
            (printf "El mes es Febrero")
        ; else
            {begin
              [if (= monthNumber 3)
                  (printf "El mes es Marzo")
              ; else
                  {begin
                    [if (= monthNumber 4)
                        (printf "El mes es Abril")
                    ; else
                        {begin
                          [if (= monthNumber 5)
                              (printf "El mes es Mayo")
                          ; else
                              {begin
                                [if (= monthNumber 6)
                                    (printf "El mes es Junio")
                                ; else
                                    {begin
                                      [if (= monthNumber 7)
                                          (printf "El mes es Julio")
                                      ; else
                                          {begin
                                            [if (= monthNumber 8)
                                                (printf "El mes es Agosto")
                                            ; else
                                                {begin
                                                  [if (= monthNumber 9)
                                                      (printf "El mes es Septiembre")
                                                  ; else
                                                      {begin
                                                        [if (= monthNumber 10)
                                                            (printf "El mes es Octubre")
                                                        ; else
                                                            {begin
                                                              [if (= monthNumber 11)
                                                                  (printf "El mes es Noviembre")
                                                              ; else
                                                                  {begin
                                                                    [if (= monthNumber 12)
                                                                        (printf "El mes es Diciembre")
                                                                    ; else
                                                                        (void)
                                                                    ] ; end if: checking if month number is 12
                                                                  } ; end begin
                                                              ] ; end if: checking if month number is 11
                                                            } ; end begin
                                                        ] ; end if: checking if month number is 10
                                                      } ; end begin
                                                  ] ; end if: checking if month number is 9
                                                } ; end begin
                                            ] ; end if: checking if month number is 8
                                          } ; end begin
                                      ] ; end if: checking if month number is 7
                                    } ; end begin
                                ] ; end if: checking if month number is 6
                              } ; end begin
                          ] ; end if: checking if month number is 5
                        } ; end begin
                    ] ; end if: checking if month number is 4
                  } ; end begin
              ] ; end if: checking if month number is 3
            } ; end begin
        ] ; end if: checking if month number is 2
      } ; end begin
  ] ; end if: checking if month number is 1
} ; end function definition: PrintMonthByNumber

(PrintMonthByNumber)
