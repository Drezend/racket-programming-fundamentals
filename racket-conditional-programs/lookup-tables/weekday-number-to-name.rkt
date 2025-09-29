#lang racket

#|
Publication date: 24/02/2025
Publication time: 02:03 pm
Code version: 1.2
Author: Eng(c) Andres David Rincon Salazar
Programming language: Racket
Language version: 8.15
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program reads a number between 1 and 7 and prints the corresponding day of the week.
Caution: For values outside this range, results are not guaranteed.
|#


{define (PrintWeekdayByNumber)
  (printf "Este programa, lee un número entre [1 y 7] e imprime el\ndía que le corresponde en la semana.Referencia:\n1=Lunes. 7=Domingo.\nSalvedad: Para valores fuera de este rango, no\ngarantizamos los resultados.")
  (printf "\nEntre un número: ")
  [define dayNumber (read)] ; dayNumber: Stores the number entered by the user.
  [if (= dayNumber 1)
      (printf "El día es Lunes")
  ; else
      {begin
        [if (= dayNumber 2)
            (printf "El día es Martes")
        ; else
            {begin
              [if (= dayNumber 3)
                  (printf "El día es Miercoles")
              ; else
                  {begin
                    [if (= dayNumber 4)
                        (printf "El día es Jueves")
                    ; else
                        {begin
                          [if (= dayNumber 5)
                              (printf "El día es Viernes")
                          ; else
                              {begin
                                [if (= dayNumber 6)
                                    (printf "El día es Sábado")
                                ; else
                                    {begin
                                      [if (= dayNumber 7)
                                          (printf "El día es Domingo")
                                      ; else
                                          (void)
                                      ] ; end if: checking if day number is 7
                                    } ; end begin
                                ] ; end if: checking if day number is 6
                              } ; end begin
                          ] ; end if: checking if day number is 5
                        } ; end begin
                    ] ; end if: checking if day number is 4
                  } ; end begin
              ] ; end if: checking if day number is 3
            } ; end begin
        ] ; end if: checking if day number is 2
      } ; end begin
  ] ; end if: checking if day number is 1
} ; end function definition: PrintWeekdayByNumber

(PrintWeekdayByNumber)