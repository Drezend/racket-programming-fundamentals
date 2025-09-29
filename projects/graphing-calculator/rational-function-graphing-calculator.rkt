#lang racket

#|
Publication date: 04/05/2025
Publication time: 11:00 p.m.
Code version: 3.26
Author: Ing.(C) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program implements a rational function graphing calculator that allows users to input
                    polynomial functions, extract coefficients and powers, evaluate the function over a range,
                    and display the results both in tabular form and as a graphical plot.
=== CAUTIONS AND TECHNICAL CONSIDERATIONS ===

1. INPUT VALIDATION:
   - Function input must follow the format: A1X^(n) + A2X^(n-1) + ... + AnX1 + b
   - Coefficients must be integers
   - Range values must be numeric
   - Increment must be positive

2. ERROR HANDLING:
   - Division by zero is detected and marked as "indefinido" in value tables
   - Invalid function format will result in parsing errors
   - Out-of-range menu selections are rejected

3. PERFORMANCE LIMITS:
   - Large coefficient values may cause display issues in the graph
   - Extremely small increments may generate too many points to display effectively

4. DEPENDENCIES:
   - Requires graphics/graphics library for plotting
   - Racket ≥8.2 (uses UTF-8 exclusively)

5. FUNCTIONAL PROGRAMMING CONSTRAINTS:
   - No mutable data structures used
   - No imperative constructs (let, set!, lambda, for, while)
   - Relies exclusively on recursion for iteration
   - Uses vectors of vectors for function storage

6. GRAPHICS REQUIREMENTS:
   - Fixed viewport size (1200x800 pixels)
   - Axes scaled appropriately according to the range of functions.
    (Coordinates may be incorrect or not appear if the ranges are only in a single quadrant.)
|#

(require graphics/graphics)
(open-graphics)
(require (prefix-in srfi: srfi/13))

;; ========================== MAIN FUNCTION =========================

(define (Main)
  ;; ========================== AUXILIARY FUNCTIONS =========================
  
  ;; Extracts a subvector from sourceVector between startIndex and endIndex
  ;; sourceVector: The original vector to extract from
  ;; startIndex: Starting index for extraction
  ;; endIndex: Ending index for extraction
  ;; Returns: A new vector containing the extracted elements
  (define (ExtractSubVector sourceVector startIndex endIndex)
    (cond
      [(or (< startIndex 0) 
           (> endIndex (vector-length sourceVector)) 
           (> startIndex endIndex))
       (vector)] 
      [(> (- endIndex startIndex) 10000)
       (vector-append 
        (ExtractSubVectorAux sourceVector startIndex (+ startIndex 5000) 0 (vector))
        (ExtractSubVector sourceVector (+ startIndex 5000) endIndex))]
      [else (ExtractSubVectorAux sourceVector startIndex endIndex 0 (vector))]))
  
  ;; Helper function for ExtractSubVector
  ;; currentIndex: Current position in result vector
  ;; resultVector: Accumulated result
  ;; Returns: The extracted subvector
  (define (ExtractSubVectorAux sourceVector startIndex endIndex currentIndex resultVector)
    (if (= currentIndex (- endIndex startIndex))
         resultVector
      ; else
         (ExtractSubVectorAux sourceVector startIndex endIndex (add1 currentIndex) 
                        (vector-append resultVector (vector (vector-ref sourceVector (+ startIndex currentIndex)))))))

  ;; Parses a function string into coefficient-power pairs
  ;; functionString: String representation of the function
  ;; Returns: Vector of vectors, each containing [coefficient power]
  (define (ParseFunction functionString)
    (ParseFunctionImproved functionString 0 (vector)))

  ;; Improved function parser with position tracking
  ;; functionString: String to parse
  ;; currentPos: Current position in string
  ;; resultVector: Accumulated result
  ;; Returns: Parsed function as vector of vectors
  (define (ParseFunctionImproved functionString currentPos resultVector)
    (if (>= currentPos (string-length functionString))
        resultVector
        (ParseFunctionTerm functionString currentPos resultVector)))

  ;; Parses a single term from the function string
  ;; Returns: Updated resultVector and new position
  (define (ParseFunctionTerm functionString currentPos resultVector)
    (ParseFunctionTermAux functionString currentPos resultVector
                          (ExtractNextTerm functionString currentPos)))
  
  ;; Helper for ParseFunctionTerm
  (define (ParseFunctionTermAux functionString currentPos resultVector termInfo)
    (ParseFunctionTermWithTermAndPos functionString currentPos resultVector
                                     (vector-ref termInfo 0)
                                     (vector-ref termInfo 1)))
  
  ;; Processes a term with its position information
  (define (ParseFunctionTermWithTermAndPos functionString currentPos resultVector term newPos)
    (if (string=? term "")
        resultVector
        (ParseFunctionImproved 
         functionString 
         newPos 
         (vector-append resultVector (vector (ParseTermImproved term))))))
  
  ;; Extracts the next term from the function string
  ;; Returns: Vector [term newPos]
  (define (ExtractNextTerm functionString startPos)
    (ExtractNextTermAux functionString startPos "" #f 0))

  ;; Helper for extracting next term with state tracking
  (define (ExtractNextTermAux functionString currentPos currentTerm foundOperator parenDepth)
    (if (>= currentPos (string-length functionString))
        (vector currentTerm currentPos)
      ; else
        (ExtractNextTermChar functionString currentPos currentTerm foundOperator parenDepth)))
  
  ;; Processes a single character during term extraction
  (define (ExtractNextTermChar functionString currentPos currentTerm foundOperator parenDepth)
    (if (>= currentPos (string-length functionString))
        (vector currentTerm currentPos)
        (ExtractNextTermCharAux functionString currentPos currentTerm foundOperator parenDepth
                                (string-ref functionString currentPos))))

  ;; Determines how to handle current character during term extraction
  (define (ExtractNextTermCharAux functionString currentPos currentTerm foundOperator parenDepth currentChar)
    (cond
      [(and (or (char=? currentChar #\+) (char=? currentChar #\-)) 
            (not (string=? currentTerm "")) 
            (not foundOperator)
            (= parenDepth 0))
       (vector currentTerm currentPos)]
      [(and (or (char=? currentChar #\+) (char=? currentChar #\-)) 
            (string=? currentTerm ""))
       (ExtractNextTermAux functionString (add1 currentPos) 
                           (string currentChar) #t parenDepth)]
      [(char=? currentChar #\()
       (ExtractNextTermAux functionString (add1 currentPos) 
                           (string-append currentTerm (string currentChar)) 
                           foundOperator (add1 parenDepth))]
      [(char=? currentChar #\))
       (ExtractNextTermAux functionString (add1 currentPos) 
                           (string-append currentTerm (string currentChar)) 
                           foundOperator (sub1 parenDepth))]
      [(char=? currentChar #\space)
       (ExtractNextTermAux functionString (add1 currentPos) 
                           currentTerm foundOperator parenDepth)]
      [else
       (ExtractNextTermAux functionString (add1 currentPos) 
                           (string-append currentTerm (string currentChar)) 
                           #f parenDepth)]))
  
  ;; Parses a term into coefficient and power
  ;; termString: String representation of term
  ;; Returns: Vector [coefficient power]
  (define (ParseTermImproved termString)
    (ParseTermImprovedAux termString (FindCharPosition termString #\X 0)))
  
  ;; Helper for ParseTermImproved with X position
  (define (ParseTermImprovedAux termString xPos)
    (if (= xPos -1)
        (vector (SafeStringToNumber termString 0) 0)
        (ParseTermWithX termString xPos)))
  
  ;; Safely converts string to number with default
  ;; str: String to convert
  ;; defaultValue: Value to return if conversion fails
  ;; Returns: Number or defaultValue
  (define (SafeStringToNumber str defaultValue)
    (if (string=? str "")
        defaultValue
        (if (string->number str)
            (string->number str)
            defaultValue)))
  
  ;; Finds position of character in string
  ;; str: String to search
  ;; char: Character to find
  ;; startPos: Position to start searching
  ;; Returns: Position or -1 if not found
  (define (FindCharPosition str char startPos)
    (cond
      [(string=? str "") -1]
      [(or (< startPos 0) (>= startPos (string-length str))) -1]
      [(char=? (string-ref str startPos) char) startPos]
      [else (FindCharPosition str char (add1 startPos))]))
  
  ;; Parses a term containing X
  (define (ParseTermWithX termString xPos)
    (ParseTermWithXAux termString xPos 
                       (substring termString 0 xPos) 
                       (substring termString (add1 xPos))))

  ;; Helper for ParseTermWithX with before/after X parts
  (define (ParseTermWithXAux termString xPos beforeX afterX)
    (ParseTermWithXCoeffPower termString xPos beforeX afterX
                              (ParseCoefficient beforeX)
                              (ParsePowerFromAfterX afterX)))
  
  ;; Final step in term parsing
  (define (ParseTermWithXCoeffPower termString xPos beforeX afterX coefficient power)
    (vector coefficient power))
  
  ;; Parses the coefficient part of a term
  (define (ParseCoefficient beforeX)
    (cond
      [(string=? beforeX "") 1]
      [(string=? beforeX "+") 1]
      [(string=? beforeX "-") -1]
      [else (ParseCoefficientNumber beforeX)]))
  
  ;; Parses coefficient as number
  (define (ParseCoefficientNumber beforeX)
    (if (string->number beforeX)
        (string->number beforeX)
        1))
  
  ;; Parses the power part after X
  (define (ParsePowerFromAfterX afterX)
    (cond
      [(string=? afterX "") 1]
      [(and (> (string-length afterX) 0) 
            (char=? (string-ref afterX 0) #\())
       (ParseParenthesizedPower afterX)]
      [(and (> (string-length afterX) 0) 
            (or (char-numeric? (string-ref afterX 0))
                (and (char=? (string-ref afterX 0) #\-)
                     (> (string-length afterX) 1)
                     (char-numeric? (string-ref afterX 1))))
       (string->number afterX))]
      [else 1]))
  
  ;; Parses power enclosed in parentheses
  (define (ParseParenthesizedPower powerString)
    (if (and (> (string-length powerString) 0) 
             (char=? (string-ref powerString 0) #\())
        (ParseParenthesizedPowerAux powerString (FindClosingParenthesis powerString 0 0))
        1))

  ;; Helper for ParseParenthesizedPower
  (define (ParseParenthesizedPowerAux powerString closingParenPos)
    (if (> closingParenPos 0)
        (SafeStringToNumber (substring powerString 1 closingParenPos) 1)
        1))

  ;; Finds matching closing parenthesis
  (define (FindClosingParenthesis str startPos depth)
    (FindClosingParenthesisWithLimit str startPos depth 1000))
  
  ;; Version with depth limit to prevent stack overflow
  (define (FindClosingParenthesisWithLimit str startPos depth remainingDepth)
    (cond
      [(= remainingDepth 0) -1]
      [(>= startPos (string-length str)) -1]
      [else (FindClosingParenthesisChar str startPos depth remainingDepth)]))
  
  ;; Helper for finding closing parenthesis
  (define (FindClosingParenthesisChar str startPos depth remainingDepth)
    (FindClosingParenthesisCharAux str startPos depth remainingDepth (string-ref str startPos)))

  ;; Processes single character when finding closing parenthesis
  (define (FindClosingParenthesisCharAux str startPos depth remainingDepth currentChar)
    (cond
      [(char=? currentChar #\()
       (FindClosingParenthesisWithLimit str (add1 startPos) (add1 depth) (sub1 remainingDepth))]
      [(char=? currentChar #\))
       (if (= depth 1)
           startPos
           (FindClosingParenthesisWithLimit str (add1 startPos) (sub1 depth) (sub1 remainingDepth)))]
      [else
       (FindClosingParenthesisWithLimit str (add1 startPos) depth (sub1 remainingDepth))]))
  
  ;; Parses power value from string
  (define (ParsePower powerString)
    (if (and (> (string-length powerString) 0) 
             (char=? (string-ref powerString 0) #\())
        (string->number (substring powerString 1 (- (string-length powerString) 1)))
        (string->number powerString)))
  
  ;; Original term parser (kept for compatibility)
  (define (ParseTerm termString)
    (ParseTermAux termString "" "" #f (vector)))
  
  ;; Helper for original term parser
  (define (ParseTermAux termString coeffStr powerStr inPower resultVector)
    (if (string=? termString "")
        (if (string=? powerStr "")
            (if (string=? coeffStr "")
                (vector 0 0)
                (vector (string->number coeffStr) 0))
            (vector (string->number coeffStr) (string->number powerStr)))
        (ParseTermAuxChar termString coeffStr powerStr inPower resultVector)))
  
  ;; Processes single character in original term parser
  (define (ParseTermAuxChar termString coeffStr powerStr inPower resultVector)
    (ParseTermAuxCharAux termString coeffStr powerStr inPower resultVector
                      (string-ref termString 0)
                      (substring termString 1)))

  ;; Determines how to handle character in original term parser
  (define (ParseTermAuxCharAux termString coeffStr powerStr inPower resultVector firstChar restString)
    (cond
      [(char=? firstChar #\X)
       (if (string=? restString "")
           (if (string=? coeffStr "")
               (vector 1 1)
               ; else if coefficient is just a minus sign
               (if (string=? coeffStr "-")
                   (vector -1 1)
                   ; else normal coefficient
                   (vector (string->number coeffStr) 1)))
           ; else
           (ParseTermAux restString coeffStr "" #t resultVector))]
      [(char=? firstChar #\^)
       (ParseTermAux restString coeffStr "" #t resultVector)]
      [(char=? firstChar #\()
       (ParseTermAuxCharParenthesis restString coeffStr powerStr inPower resultVector)]
      [(char=? firstChar #\))
       (ParseTermAux restString coeffStr powerStr #f resultVector)]
      [inPower
       (ParseTermAux restString coeffStr (string-append powerStr (string firstChar)) #t resultVector)]
      [else
       (ParseTermAux restString (string-append coeffStr (string firstChar)) powerStr #f resultVector)]))
  
  ;; Handles parentheses in original term parser
  (define (ParseTermAuxCharParenthesis restString coeffStr powerStr inPower resultVector)
    (if inPower
        (if (and (> (string-length restString) 0) (char=? (string-ref restString 0) #\-))
            (ParseTermAux (substring restString 1) coeffStr "-" #t resultVector)
            (ParseTermAux restString coeffStr "" #t resultVector))
        (ParseTermAux restString coeffStr "" #t resultVector)))

  ;; Validates function string format
  (define (ValidateFunctionFormat functionString)
    (and (not (string=? functionString ""))
         (ValidateFunctionFormatImproved functionString 0 #f #f 1000)))

  ;; Improved validation with position tracking
  (define (ValidateFunctionFormatImproved functionString currentPos foundX inParenthesis remainingDepth)
    (cond
      [(= remainingDepth 0) #f]
      [(>= currentPos (string-length functionString)) foundX]
      [else (ValidateCharacterImproved functionString currentPos foundX inParenthesis remainingDepth)]))

  ;; Validates single character in function string
  (define (ValidateCharacterImproved functionString currentPos foundX inParenthesis remainingDepth)
    (ValidateCharacterImprovedAux functionString currentPos foundX inParenthesis remainingDepth
                                 (string-ref functionString currentPos)))

  ;; Determines if character is valid in function string
  (define (ValidateCharacterImprovedAux functionString currentPos foundX inParenthesis remainingDepth currentChar)
    (cond
      [(char-numeric? currentChar)
       (ValidateFunctionFormatImproved functionString (add1 currentPos) foundX inParenthesis (sub1 remainingDepth))]
      [(char=? currentChar #\X)
       (ValidateFunctionFormatImproved functionString (add1 currentPos) #t inParenthesis (sub1 remainingDepth))]
      [(or (char=? currentChar #\+) (char=? currentChar #\-))
       (ValidateFunctionFormatImproved functionString (add1 currentPos) foundX inParenthesis (sub1 remainingDepth))]
      [(char=? currentChar #\()
       (ValidateFunctionFormatImproved functionString (add1 currentPos) foundX #t (sub1 remainingDepth))]
      [(char=? currentChar #\))
       (ValidateFunctionFormatImproved functionString (add1 currentPos) foundX #f (sub1 remainingDepth))]
      [(char=? currentChar #\space)
       (ValidateFunctionFormatImproved functionString (add1 currentPos) foundX inParenthesis (sub1 remainingDepth))]
      [else #f]))

  ;; Evaluates parsed function at given x value
  (define (EvaluateFunction parsedFunction xValue)
    (if (vector? parsedFunction)
        (EvaluateFunctionAux parsedFunction xValue 0 0)
        0))
  
  ;; Helper for function evaluation
  (define (EvaluateFunctionAux parsedFunction xValue currentIndex accumulatedResult)
    (if (= currentIndex (vector-length parsedFunction))
        accumulatedResult
        (EvaluateTerm parsedFunction xValue currentIndex accumulatedResult)))
  
  ;; Evaluates single term in function
  (define (EvaluateTerm parsedFunction xValue currentIndex accumulatedResult)
    (EvaluateTermAux parsedFunction xValue currentIndex accumulatedResult
                     (vector-ref parsedFunction currentIndex)))
  
  ;; Helper for term evaluation
  (define (EvaluateTermAux parsedFunction xValue currentIndex accumulatedResult term)
    (define coefficient (vector-ref term 0))
    (define power (vector-ref term 1))
    
    (cond
      [(and (= xValue 0) (< power 0))
       +inf.0]
      [else
       (EvaluateFunctionAux 
        parsedFunction 
        xValue 
        (add1 currentIndex) 
        (+ accumulatedResult (* coefficient (expt xValue power))))]))

  ;; Generates table of [x y] values for function
  (define (GenerateValueTable parsedFunction startX endX increment)
    (GenerateValueTableAux parsedFunction startX endX increment (vector)))
  
  ;; Helper for value table generation
  (define (GenerateValueTableAux parsedFunction currentX endX increment resultVector)
    (if (> currentX endX)
        resultVector
        (GenerateValueTablePoint parsedFunction currentX endX increment resultVector)))
  
  ;; Generates single point in value table
  (define (GenerateValueTablePoint parsedFunction currentX endX increment resultVector)
    (GenerateValueTableAux parsedFunction (+ currentX increment) endX increment 
                           (vector-append resultVector 
                                          (vector (vector currentX (SafeEvaluate parsedFunction currentX))))))
  
  ;; Safely evaluates function, handling errors
  (define (SafeEvaluate parsedFunction xValue)
    (SafeEvaluateAux parsedFunction xValue))
  
  ;; Helper for safe evaluation
  (define (SafeEvaluateAux parsedFunction xValue)
    (if (SafeToEvaluate parsedFunction xValue)
        (EvaluateFunction parsedFunction xValue)
        "indefinido"))
  
  ;; Checks if function can be safely evaluated at xValue
  (define (SafeToEvaluate parsedFunction xValue)
    (SafeToEvaluateAux parsedFunction xValue 0))
  
  ;; Helper for safety check
  (define (SafeToEvaluateAux parsedFunction xValue currentIndex)
    (if (= currentIndex (vector-length parsedFunction))
        #t
        (SafeToEvaluateTerm parsedFunction xValue currentIndex)))
  
  ;; Checks if single term is safe to evaluate
  (define (SafeToEvaluateTerm parsedFunction xValue currentIndex)
    (SafeToEvaluateTermAux parsedFunction xValue currentIndex
                          (vector-ref parsedFunction currentIndex)))
  
  ;; Helper for term safety check
  (define (SafeToEvaluateTermAux parsedFunction xValue currentIndex term)
    (SafeToEvaluateTermWithCoeffPower parsedFunction xValue currentIndex
                                     (vector-ref term 0)
                                     (vector-ref term 1)))
  
  ;; Checks for division by zero in term
  (define (SafeToEvaluateTermWithCoeffPower parsedFunction xValue currentIndex coefficient power)
    (cond
      [(and (= xValue 0) (< power 0)) #f]
      [else (SafeToEvaluateAux parsedFunction xValue (add1 currentIndex))]))

  ;; Checks if term is safe to evaluate (original version)
  (define (TermIsSafe term xValue)
    (TermIsSafeAux term xValue
                   (vector-ref term 0)
                   (vector-ref term 1)))
  
  ;; Helper for original term safety check
  (define (TermIsSafeAux term xValue coefficient power)
    (if (and (< power 0) (= xValue 0))
        #f
        #t))
  
  ;; Finds min and max y values in value table
  (define (FindMinMaxY valueTable)
    (FindMinMaxYAux valueTable 0 +inf.0 -inf.0))
  
  ;; Helper for finding min/max y values
  (define (FindMinMaxYAux valueTable currentIndex minY maxY)
    (if (= currentIndex (vector-length valueTable))
        (vector minY maxY)
        (FindMinMaxYPoint valueTable currentIndex minY maxY)))
  
  ;; Processes single point when finding min/max
  (define (FindMinMaxYPoint valueTable currentIndex minY maxY)
    (FindMinMaxYPointAux valueTable currentIndex minY maxY
                      (vector-ref valueTable currentIndex)))

  ;; Helper for point processing in min/max search
  (define (FindMinMaxYPointAux valueTable currentIndex minY maxY currentPoint)
    (FindMinMaxYPointWithY valueTable currentIndex minY maxY
                           (vector-ref currentPoint 1)))

  ;; Updates min/max with current y value
  (define (FindMinMaxYPointWithY valueTable currentIndex minY maxY yValue)
    (if (string? yValue)
        (FindMinMaxYAux valueTable (add1 currentIndex) minY maxY)
        (FindMinMaxYAux valueTable (add1 currentIndex) 
                        (min minY yValue) (max maxY yValue))))
  
  ;; Scales point from math to screen coordinates
  (define (ScalePoint xValue yValue minX maxX minY maxY viewportWidth viewportHeight marginX marginY)
    (define xRange (- maxX minX))
    (define yRange (- maxY minY))
    
    (define drawingWidth (- viewportWidth (* 2 marginX)))
    (define drawingHeight (- viewportHeight (* 2 marginY)))
    
    (define xProportion (if (= xRange 0) 0.5 (/ (- xValue minX) xRange)))
    (define yProportion (if (= yRange 0) 0.5 (/ (- yValue minY) yRange)))
    
    (define screenX (+ marginX (* xProportion drawingWidth)))
    (define screenY (+ marginY (* (- 1 yProportion) drawingHeight)))
    
    (vector screenX screenY))

    ;; ========================== GRAPHING FUNCTIONS =========================
  
  ;; Draws graph of function based on value table
  (define (DrawGraph valueTable functionString)
    (define viewport (open-viewport "Graficadora de Funciones" 1200 800))
    (define viewportWidth 1200)
    (define viewportHeight 800)
    (define marginX 100)
    (define marginY 100)
    
    (define minX (vector-ref (vector-ref valueTable 0) 0))
    (define maxX (vector-ref (vector-ref valueTable (- (vector-length valueTable) 1)) 0))
    (define minMaxY (FindMinMaxY valueTable))
    (define minY (vector-ref minMaxY 0))
    (define maxY (vector-ref minMaxY 1))
    
    (define yRange (max 1 (- maxY minY)))
    (define yPadding (* 0.1 yRange))
    (define adjustedMinY (- minY yPadding))
    (define adjustedMaxY (+ maxY yPadding))
    
    ((draw-solid-rectangle viewport) (make-posn 0 0) viewportWidth viewportHeight "white")
    
    (define originPoint (ScalePoint 0 0 minX maxX adjustedMinY adjustedMaxY viewportWidth viewportHeight marginX marginY))
    (define originX (vector-ref originPoint 0))
    (define originY (vector-ref originPoint 1))
    
    (DrawGridLines viewport minX maxX adjustedMinY adjustedMaxY viewportWidth viewportHeight marginX marginY)
    
    ((draw-line viewport) (make-posn marginX originY) (make-posn (- viewportWidth marginX) originY) "black")
    ((draw-line viewport) (make-posn originX marginY) (make-posn originX (- viewportHeight marginY)) "black")
    
    (DrawAxisLabels viewport minX maxX adjustedMinY adjustedMaxY viewportWidth viewportHeight marginX marginY)
    
    ((draw-string viewport) (make-posn (/ viewportWidth 2) 50) functionString "black")
    
    (DrawPoints viewport valueTable minX maxX adjustedMinY adjustedMaxY viewportWidth viewportHeight marginX marginY 0)
    
    viewport)
  
  ;; Draws grid lines on viewport
  (define (DrawGridLines viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY)
    (DrawHorizontalGridLines viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY minY 10)
    (DrawVerticalGridLines viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY minX 10))
  
  ;; Draws horizontal grid lines
  (define (DrawHorizontalGridLines viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentY numLines)
    (if (<= numLines 0)
        (void)
        (DrawHorizontalGridLinesAux viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentY numLines)))
  
  ;; Helper for horizontal grid lines
  (define (DrawHorizontalGridLinesAux viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentY numLines)
    (define yStep (/ (- maxY minY) numLines))
    (define yValue (+ currentY yStep))
    (if (>= yValue maxY)
        (void)
        (DrawHorizontalGridLine viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY yValue yStep numLines)))
  
  ;; Draws single horizontal grid line
  (define (DrawHorizontalGridLine viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY yValue yStep numLines)
    (define scaledPoint1 (ScalePoint minX yValue minX maxX minY maxY viewportWidth viewportHeight marginX marginY))
    (define scaledPoint2 (ScalePoint maxX yValue minX maxX minY maxY viewportWidth viewportHeight marginX marginY))
    ((draw-line viewport) 
     (make-posn (vector-ref scaledPoint1 0) (vector-ref scaledPoint1 1))
     (make-posn (vector-ref scaledPoint2 0) (vector-ref scaledPoint2 1))
     "lightgray")
    (DrawHorizontalGridLines viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY yValue (sub1 numLines)))
  
  ;; Draws vertical grid lines
  (define (DrawVerticalGridLines viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentX numLines)
    (if (<= numLines 0)
        (void)
        (DrawVerticalGridLinesAux viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentX numLines)))
  
  ;; Helper for vertical grid lines
  (define (DrawVerticalGridLinesAux viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentX numLines)
    (define xStep (/ (- maxX minX) numLines))
    (define xValue (+ currentX xStep))
    (if (>= xValue maxX)
        (void)
        (DrawVerticalGridLine viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY xValue xStep numLines)))
  
  ;; Draws single vertical grid line
  (define (DrawVerticalGridLine viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY xValue xStep numLines)
    (define scaledPoint1 (ScalePoint xValue minY minX maxX minY maxY viewportWidth viewportHeight marginX marginY))
    (define scaledPoint2 (ScalePoint xValue maxY minX maxX minY maxY viewportWidth viewportHeight marginX marginY))
    ((draw-line viewport) 
     (make-posn (vector-ref scaledPoint1 0) (vector-ref scaledPoint1 1))
     (make-posn (vector-ref scaledPoint2 0) (vector-ref scaledPoint2 1))
     "lightgray")
    (DrawVerticalGridLines viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY xValue (sub1 numLines)))

  ;; Calculates optimal number of axis labels
  (define (CalculateOptimalLabelCount range)
    (cond
      [(< range 10) 10]
      [(< range 50) 10]
      [(< range 100) 10]
      [(< range 1000) 10]
      [else 10]))
  
  ;; Calculates step size between axis labels
  (define (CalculateStepSize range numLabels)
    (define rawStep (/ range numLabels))
    (cond
      [(< rawStep 0.1) 0.1]
      [(< rawStep 1) (/ (ceiling (* rawStep 10)) 10)]
      [(< rawStep 10) (ceiling rawStep)]
      [(< rawStep 100) (* (ceiling (/ rawStep 10)) 10)]
      [else (* (ceiling (/ rawStep 100)) 100)]))
  
  ;; Draws labels on X and Y axes
  (define (DrawAxisLabels viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY)
    (define xRange (- maxX minX))
    (define yRange (- maxY minY))
    
    (define numXLabels (CalculateOptimalLabelCount xRange))
    (define numYLabels (CalculateOptimalLabelCount yRange))
    
    (define xStep (CalculateStepSize xRange numXLabels))
    (define yStep (CalculateStepSize yRange numYLabels))
    
    (define firstXLabel (* (floor (/ minX xStep)) xStep))
    (define firstYLabel (* (floor (/ minY yStep)) yStep))
    
    (DrawXAxisLabelsWithStep viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY firstXLabel xStep)
    (DrawYAxisLabelsWithStep viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY firstYLabel yStep))
  
  ;; Draws X axis labels with consistent spacing
  (define (DrawXAxisLabelsWithStep viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentX step)
    (if (> currentX maxX)
        (void)
        (DrawXAxisLabelWithStep viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentX step)))
  
  ;; Draws single X axis label
  (define (DrawXAxisLabelWithStep viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentX step)
    (if (< currentX minX)
        (DrawXAxisLabelsWithStep viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY (+ currentX step) step)
        (DrawXAxisLabelAndContinue viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentX step)))
  
  ;; Draws X label and continues to next
  (define (DrawXAxisLabelAndContinue viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentX step)
    (define scaledPoint (ScalePoint currentX 0 minX maxX minY maxY viewportWidth viewportHeight marginX marginY))
    (define scaledX (vector-ref scaledPoint 0))
    (define scaledY (vector-ref scaledPoint 1))
    
    (define labelText (FormatLabelValue currentX))
    
    ((draw-line viewport) (make-posn scaledX scaledY) (make-posn scaledX (+ scaledY 5)) "black")
    ((draw-string viewport) (make-posn scaledX (+ scaledY 15)) labelText "black")
    
    (DrawXAxisLabelsWithStep viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY (+ currentX step) step))
  
  ;; Draws Y axis labels with consistent spacing
  (define (DrawYAxisLabelsWithStep viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentY step)
    (if (> currentY maxY)
        (void)
        (DrawYAxisLabelWithStep viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentY step)))
  
  ;; Draws single Y axis label
  (define (DrawYAxisLabelWithStep viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentY step)
    (if (< currentY minY)
        (DrawYAxisLabelsWithStep viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY (+ currentY step) step)
        (DrawYAxisLabelAndContinue viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentY step)))
  
  ;; Draws Y label and continues to next
  (define (DrawYAxisLabelAndContinue viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentY step)
    (define scaledPoint (ScalePoint 0 currentY minX maxX minY maxY viewportWidth viewportHeight marginX marginY))
    (define scaledX (vector-ref scaledPoint 0))
    (define scaledY (vector-ref scaledPoint 1))
    
    (define labelText (FormatLabelValue currentY))
    
    ((draw-line viewport) (make-posn scaledX scaledY) (make-posn (- scaledX 5) scaledY) "black")
    ((draw-string viewport) (make-posn (- scaledX 40) scaledY) labelText "black")
    
    (DrawYAxisLabelsWithStep viewport minX maxX minY maxY viewportWidth viewportHeight marginX marginY (+ currentY step) step))
  
  ;; Formats value for axis label display
  (define (FormatLabelValue value)
    (FormatLabelValueAux value (- value (floor value))))
  
  ;; Helper for label value formatting
  (define (FormatLabelValueAux value fractionalPart)
    (cond
      [(< fractionalPart 0.001) (number->string (exact-round value))]
      [(< fractionalPart 0.01) (number->string (/ (round (* value 100)) 100))]
      [else (number->string (/ (round (* value 100)) 100))]))
  
  ;; Draws all points in value table
  (define (DrawPoints viewport valueTable minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentIndex)
    (if (= currentIndex (vector-length valueTable))
        (void)
        (DrawPoint viewport valueTable minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentIndex)))
  
  ;; Draws single point from value table
  (define (DrawPoint viewport valueTable minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentIndex)
    (define currentPoint (vector-ref valueTable currentIndex))
    (define xValue (vector-ref currentPoint 0))
    (define yValue (vector-ref currentPoint 1))
    
    (if (string? yValue)
        (DrawPoints viewport valueTable minX maxX minY maxY viewportWidth viewportHeight marginX marginY (add1 currentIndex))
        (DrawPointAux viewport valueTable minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentIndex xValue yValue)))
  
  ;; Helper for drawing valid point
  (define (DrawPointAux viewport valueTable minX maxX minY maxY viewportWidth viewportHeight marginX marginY currentIndex xValue yValue)
    (define scaledPoint (ScalePoint xValue yValue minX maxX minY maxY viewportWidth viewportHeight marginX marginY))
    (define scaledX (- (vector-ref scaledPoint 0) 3))
    (define scaledY (- (vector-ref scaledPoint 1) 3))
    
    ((draw-solid-ellipse viewport) (make-posn scaledX scaledY) 5 5 "blue")
    
    (DrawPoints viewport valueTable minX maxX minY maxY viewportWidth viewportHeight marginX marginY (add1 currentIndex)))

  ;; ========================== PRINTING FUNCTIONS =========================
  
  ;; Prints table of function values
  (define (PrintValueTable valueTable functionString)
    (printf "╠══════════════════════════════════════════════════════════════════════════════════════════╣\n")
    (printf "║ Tabla de valores para la función: ~a ║\n" (srfi:string-pad-right (~a functionString) 54))
    (printf "╠════════════════════════════╦════════════════════════════════════════╦════════════════════╣\n")
    (printf "║             X              ║               Evaluación               ║          Y         ║\n")
    (printf "╠════════════════════════════╬════════════════════════════════════════╬════════════════════╣\n")
    
    (PrintValueTableRows valueTable functionString 0))
  
  ;; Prints rows of value table
  (define (PrintValueTableRows valueTable functionString currentIndex)
    (if (= currentIndex (vector-length valueTable))
        (printf "╠════════════════════════════╩════════════════════════════════════════╩════════════════════╣\n")
        (PrintValueTableRow valueTable functionString currentIndex)))
  
  ;; Prints single row of value table
  (define (PrintValueTableRow valueTable functionString currentIndex)
    (define currentPoint (vector-ref valueTable currentIndex))
    (define xValue (vector-ref currentPoint 0))
    (define yValue (vector-ref currentPoint 1))
    
    (if (string? yValue)
        (printf "║ ~a ║ ~a ║ ~a ║\n"
                (srfi:string-pad-right (~a xValue) 26)
                (srfi:string-pad-right "indefinido" 38)
                (srfi:string-pad-right "indefinido" 18))
        (printf "║ ~a ║ ~a ║ ~a ║\n"
                (srfi:string-pad-right (~a xValue) 26)
                (srfi:string-pad-right (~a (string-append (SubstituteXInFunction functionString xValue) " = " (~a yValue))) 38)
                (srfi:string-pad-right (~a yValue) 18)))
    
    (PrintValueTableRows valueTable functionString (add1 currentIndex)))

  ;; Substitutes X in function string with given value
  (define (SubstituteXInFunction functionString xValue)
    (SubstituteXInFunctionAux functionString 0 "" xValue))

;; Helper for X substitution 
  (define (SubstituteXInFunctionAux functionString currentPos result xValue) 
    (if (>= currentPos (string-length functionString)) 
        result 
        (SubstituteXInFunctionAuxChar functionString currentPos result xValue
                                      (string-ref functionString currentPos))))
  
  (define (SubstituteXInFunctionAuxChar functionString currentPos result xValue currentChar)
    (cond 
      [(char=? currentChar #\X) 
       (SubstituteXInFunctionAux 
        functionString 
        (add1 currentPos) 
        (string-append result (if (< xValue 0) 
                                  (string-append "(" (~a xValue) ")") 
                                  (string-append "(" (~a xValue) ")"))) 
        xValue)] 
      [else 
       (SubstituteXInFunctionAux 
        functionString 
        (add1 currentPos) 
        (string-append result (string currentChar)) 
        xValue)]))
  
  ;; Prints table of coefficients and powers
  (define (PrintCoefficientTable parsedFunction)
    (printf "╠══════════════════════════════════════════════════════════════════════════════════════════╣\n")
    (printf "║                         Tabla de coeficientes y potencias                                ║\n")
    (printf "╠═════════════════════════════════════════════╦════════════════════════════════════════════╣\n")
    (printf "║                 Coeficiente                 ║                  Potencia                  ║\n")
    (printf "╠═════════════════════════════════════════════╬════════════════════════════════════════════╣\n")
    
    (PrintCoefficientTableRows parsedFunction 0))
  
  ;; Prints rows of coefficient table
  (define (PrintCoefficientTableRows parsedFunction currentIndex)
    (if (= currentIndex (vector-length parsedFunction))
        (printf "╠═════════════════════════════════════════════╩════════════════════════════════════════════╣\n")
        (PrintCoefficientTableRow parsedFunction currentIndex)))
  
  ;; Prints single row of coefficient table
  (define (PrintCoefficientTableRow parsedFunction currentIndex)
    (define currentTerm (vector-ref parsedFunction currentIndex))
    (define coefficient (vector-ref currentTerm 0))
    (define power (vector-ref currentTerm 1))
    
    (printf "║ ~a ║ ~a ║\n" 
            (srfi:string-pad-right (~a coefficient) 43)
            (srfi:string-pad-right (~a power) 42))
    
    (PrintCoefficientTableRows parsedFunction (add1 currentIndex)))
  
  ;; Adds new function to functions vector
  (define (AddFunction functions functionCounter functionString parsedFunction valueTable)
    (define newFunction (vector functionCounter functionString parsedFunction valueTable))
    (vector-append functions (vector newFunction)))
  
  ;; Displays list of available functions
  (define (DisplayFunctionList functions)
    (printf "╔═══════════════════════════════════════════════════════════════╗\n")
    (printf "║                     FUNCIONES DISPONIBLES                     ║\n")
    (printf "╠═══════════════════════════════╦═══════════════════════════════╣\n")
    (printf "║            Número             ║            Función            ║\n")
    (printf "╠═══════════════════════════════╬═══════════════════════════════╣\n")
    
    (DisplayFunctionListRows functions 0))
  
  ;; Displays rows of function list
  (define (DisplayFunctionListRows functions currentIndex)
    (if (= currentIndex (vector-length functions))
        (printf "╠═══════════════════════════════╩═══════════════════════════════╣\n")
        (DisplayFunctionListRow functions currentIndex)))
  
  ;; Displays single row of function list
  (define (DisplayFunctionListRow functions currentIndex)
    (define currentFunction (vector-ref functions currentIndex))
    (define functionNumber (vector-ref currentFunction 0))
    (define functionString (vector-ref currentFunction 1))
    
    (printf "║ ~a║ ~a║\n" (srfi:string-pad-right (~a functionNumber) 30) (srfi:string-pad-right (~a functionString) 30))
    
    (DisplayFunctionListRows functions (add1 currentIndex)))

  ;; ========================== USER INPUT FUNCTIONS =========================
  
  ;; Prompts user to enter function string
  (define (EnterFunction)
    (printf "╔══════════════════════════════════════════════════════════════════════════════════════════╗\n")
    (printf "║               INGRESAR UNA NUEVA FUNCIÓN                                                 ║\n")
    (printf "╠══════════════════════════════════════════════════════════════════════════════════════════╣\n")
    (printf "║ Ingrese la función en formato \"A1X^(n) + A2X^(n-1) + ... + AnX1 + b\"                     ║\n")
    (printf "║ Ejemplo: \"348X(-5)–784X2+6\" (debe ingresarse entre comillas)     (\"0\" para salir)        ║\n")
    (printf "║ f(x): ")
    (read))
  
  ;; Prompts user to enter range start value
  (define (EnterRangeStart)
    (printf "║ Ingrese el valor inicial del rango: ")
    (read))
  
  ;; Prompts user to enter range end value
  (define (EnterRangeEnd)
    (printf "║ Ingrese el valor final del rango: ")
    (read))
  
  ;; Prompts user to enter increment value
  (define (EnterIncrement)
    (printf "║ Ingrese el incremento: ")
    (read))
  
  ;; Prompts user to select function number
  (define (EnterFunctionNumber)
    (printf "║ Ingrese el número de la función que desea graficar: ")
    (read))
  
  ;; ========================== DISPLAY FUNCTIONS =========================
  
  ;; Displays main menu interface
  (define (DisplayMainMenu)
    (printf "╔════════════════════════════════════════════════════════╗\n")
    (printf "║        GRAFICADORA DE FUNCIONES EN BASE A X            ║\n")
    (printf "╠════════════════════════════════════════════════════════╣\n")
    (printf "║                    MENU PRINCIPAL                      ║\n")
    (printf "╠════════════════════════════════════════════════════════╣\n")
    (printf "║                                                        ║\n")
    (printf "║  1. Graficar una nueva función                         ║\n")
    (printf "║  2. Graficar una función anterior                      ║\n")
    (printf "║  3. Salir del aplicativo                               ║\n")
    (printf "║                                                        ║\n")
    (printf "║  (Para volver a este menú, debera ingresar 0 en        ║\n")
    (printf "║               los otros sub menús)                     ║\n")
    (printf "║                                                        ║\n")
    (printf "╠════════════════════════════════════════════════════════╣\n")
    (printf "║ Seleccione su opción: "))

  ;; ========================== MENU FUNCTIONS =========================
  
  ;; Processes main menu selection
  (define (ProcessMainMenu functions functionCounter)
    (DisplayMainMenu)
    (define option (read))
    
    (cond
      [(= option 1)
       (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
       (ProcessNewFunction functions functionCounter)]
      [(= option 2)
       (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
       (ProcessExistingFunction functions functionCounter)]
      [(= option 3) (ProcessExit)]
      [else (ProcessInvalidOption functions functionCounter)]))
  
  ;; Processes new function creation
  (define (ProcessNewFunction functions functionCounter)
    (define functionString (EnterFunction))
    
    (cond
      [(string=? functionString "0")
       (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
       (ProcessMainMenu functions functionCounter)]
      
      [(not (ValidateFunctionFormat functionString))
       (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
       (printf "╔══════════════════════════════════════════════════════════════════════════════════════════╗\n")
       (printf "║ Formato de función inválido. Solo se permiten funciones polinómicas con la variable X.   ║\n")
       (printf "║ Ejemplo: 348X(-5)–784X2+6                                                                ║\n")
       (printf "╚══════════════════════════════════════════════════════════════════════════════════════════╝\n")
       (ProcessNewFunction functions functionCounter)]
      
      [else
       (ProcessNewFunctionAux functions functionCounter functionString)]))
  
  ;; Helper for new function processing
  (define (ProcessNewFunctionAux functions functionCounter functionString)
    (define parsedFunction (ParseFunction functionString))
    (PrintCoefficientTable parsedFunction)
    
    (define startX (EnterRangeStart))
    (define endX (EnterRangeEnd))
    (if (> startX endX )
        (begin
          (printf "╠══════════════════════════════════════════════════════════════════════════════════════════╣\n")
          (printf "║ El valor inicial de rango no puede ser menor que el valor final del rango.               ║\n")
          (printf "╠══════════════════════════════════════════════════════════════════════════════════════════╣\n")
          (ProcessNewFunctionAux functions functionCounter functionString))
        (void))
    
    (define increment (EnterIncrement))
    (if (<= increment 0)
        (begin
          (printf "╠══════════════════════════════════════════════════════════════════════════════════════════╣\n")
          (printf "║ El valor de incremento debe ser positivo.                                                ║\n")
          (printf "╠══════════════════════════════════════════════════════════════════════════════════════════╣\n")
          (ProcessNewFunctionAux functions functionCounter functionString))
        (void))
    
    (define valueTable (GenerateValueTable parsedFunction startX endX increment))
    (PrintValueTable valueTable functionString)
    
    (DrawGraph valueTable functionString)
    
    (define updatedFunctions (AddFunction functions functionCounter functionString parsedFunction valueTable))
    (define updatedCounter (add1 functionCounter))

    (define (ProcessNextStep)
      (printf "╠══════════════════════════════════════════════════════════════════════════════════════════╣\n")
      (printf "║ Escriba 0 para volver al menú principal o 1 para procesar otra función                   ║\n")
      (printf "╠══════════════════════════════════════════════════════════════════════════════════════════╣\n")
      (printf "║ ")
      (define option (read))

      (if (= option 0)
          (begin
            (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
            (ProcessMainMenu updatedFunctions updatedCounter))
          (if (= option 1)
              (begin
                (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
                (ProcessNewFunction updatedFunctions updatedCounter))
              (begin
                (printf "╠══════════════════════════════════════════════════════════════════════════════════════════╣\n")
                (printf "║ Seleccion invalida, por valor seleccione una opcion correcta.                            ║\n")
                (printf "╚══════════════════════════════════════════════════════════════════════════════════════════╝\n\n\n\n")
                (ProcessNextStep)))))
    (ProcessNextStep))
  
  ;; Processes selection of existing function
  (define (ProcessExistingFunction functions functionCounter)
    (if (= (vector-length functions) 0)
        (ProcessNoFunctions functions functionCounter)
        (ProcessExistingFunctionAux functions functionCounter)))
  
  ;; Handles case when no functions exist
  (define (ProcessNoFunctions functions functionCounter)
    (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
    (printf "╔════════════════════════════════════════════════════════════════════════╗\n")
    (printf "║ No hay funciones disponibles. Debe crear al menos una función primero. ║\n")
    (printf "╚════════════════════════════════════════════════════════════════════════╝\n")
    (ProcessMainMenu functions functionCounter))
  
  ;; Helper for existing function processing
  (define (ProcessExistingFunctionAux functions functionCounter)
    (DisplayFunctionList functions)
    (define functionNumber (EnterFunctionNumber))
    
    (if (= functionNumber 0)
        (begin
          (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
          (ProcessMainMenu functions functionCounter))
        (ProcessExistingFunctionSelection functions functionCounter functionNumber)))
  
  ;; Processes user's function selection
  (define (ProcessExistingFunctionSelection functions functionCounter functionNumber)
    (if (or (< functionNumber 1) (> functionNumber (vector-length functions)))
        (ProcessInvalidFunctionNumber functions functionCounter)
        (ProcessValidFunctionNumber functions functionCounter functionNumber)))
  
  ;; Handles invalid function number selection
  (define (ProcessInvalidFunctionNumber functions functionCounter)
    (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
    (printf "╔═══════════════════════════════════════════════════════════════╗\n")
    (printf "║ Número de función inválido.                                   ║\n")
    (printf "╚═══════════════════════════════════════════════════════════════╝\n")
    (ProcessExistingFunction functions functionCounter))
  
  ;; Processes valid function number selection
  (define (ProcessValidFunctionNumber functions functionCounter functionNumber)
    (define selectedFunction (FindFunctionByNumber functions functionNumber 0))
    
    (if (vector? selectedFunction)
        (DisplaySelectedFunction selectedFunction functions functionCounter)
        (ProcessMainMenu functions functionCounter)))
  
  ;; Finds function by its number
  (define (FindFunctionByNumber functions functionNumber currentIndex)
    (if (= currentIndex (vector-length functions))
        #f
        (FindFunctionByNumberAux functions functionNumber currentIndex)))
  
  ;; Helper for finding function by number
  (define (FindFunctionByNumberAux functions functionNumber currentIndex)
    (define currentFunction (vector-ref functions currentIndex))
    (define currentFunctionNumber (vector-ref currentFunction 0))
    
    (if (= currentFunctionNumber functionNumber)
        currentFunction
        (FindFunctionByNumber functions functionNumber (add1 currentIndex))))
  
  ;; Displays selected function information
  (define (DisplaySelectedFunction selectedFunction functions functionCounter)
    (define functionString (vector-ref selectedFunction 1))
    (define parsedFunction (vector-ref selectedFunction 2))
    (define valueTable (vector-ref selectedFunction 3))
    
    (PrintCoefficientTable parsedFunction)
    (PrintValueTable valueTable functionString)
    
    (DrawGraph valueTable functionString)
    
    (define (ProcessNextStep)
      (printf "╠══════════════════════════════════════════════════════════════════════════════════════════╣\n")
      (printf "║ Escriba 0 para volver al menú principal o 1 para graficar otra función                   ║\n")
      (printf "╠══════════════════════════════════════════════════════════════════════════════════════════╣\n")
      (printf "║ ")
      (define option (read))

      (if (= option 0)
          (begin
            (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
            (ProcessMainMenu functions functionCounter))
          (if (= option 1)
              (begin
                (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
                (ProcessExistingFunction functions functionCounter))
              (begin
                (printf "╔════════════════════════════════════════════════════════════════════════╗\n")
                (printf "║ Seleccion invalida, por valor seleccione una opción correcta.          ║\n")
                (printf "╚════════════════════════════════════════════════════════════════════════╝\n\n\n\n")
                (ProcessNextStep)))))
    (ProcessNextStep))
  
  ;; Handles invalid menu option selection
  (define (ProcessInvalidOption functions functionCounter)
    (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
    (printf "╔════════════════════════════════════════════════════════╗\n")
    (printf "║ Opción inválida. Por favor seleccione una opción válida║\n")
    (printf "╚════════════════════════════════════════════════════════╝\n")
    (ProcessMainMenu functions functionCounter))
  
  ;; Handles program exit
  (define (ProcessExit)
    (printf "║ Gracias por utilizar la Graficadora de Funciones.      ║\n")
    (printf "╚════════════════════════════════════════════════════════╝")
    (close-graphics))
  
  ;; ========================== PROGRAM ENTRY POINT =========================
  
  (ProcessMainMenu (vector) 1))

(Main)