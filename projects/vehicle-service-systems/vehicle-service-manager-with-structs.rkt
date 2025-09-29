#lang racket

#|
Publication date: 21/04/2025
Publication time: 6:50 a.m.
Code version: 7.23
Author: Ing.(C) Andrés David Rincón Salazar
Programming language: Racket
Language version: 8.16
Presented to: Doctor Ricardo Moreno Laverde
Universidad Tecnológica de Pereira
Programa de Ingeniería de Sistemas y Computación
Course: IS105 Programación I
Program description: This program manages a vehicle service center's operations including product portfolio management,
                    service vouchers creation, and invoice generation with tax calculations.
=== CAUTIONS AND TECHNICAL CONSIDERATIONS ===

1. INPUT VALIDATION:
   - Numeric inputs must:
     * Be positive integers (for codes/quantities)
     * Have ≤2 decimal places (for prices, with 0.01 granularity)
   - Dates require strict ISO 8601 format (YYYY-MM-DD)
   - Tax IDs (NITs) must comply with country-specific validation rules
   - Text fields (names, plates) must:
     * Exclude special chars: <>{}[]|\\^~%
     * Avoid format-breaking sequences: \n, \t, \\"

2. ERROR HANDLING:
   - Unhandled edge cases:
     * File corruption during I/O operations
     * Concurrent modification conflicts
     * Network timeouts (if networked)
   - Reserved error codes:
     * -1: Product not found
     * -2: Invalid type/format
     * -3: Precondition violation (e.g., unordered portfolio)

3. PERFORMANCE LIMITS:
   - Not thread-safe for concurrent operations

4. DEPENDENCIES:
   - Mandatory requirements:
     * SRFI-13 for string operations
     * Racket ≥8.2 (uses UTF-8 exclusively)
   - Platform-specific behaviors:
     * File permissions follow OS defaults
     * Little-endian systems only

5. SECURITY:
   - Critical gaps:
     * No input sanitization for shell commands
     * Plaintext storage of sensitive data
   - Required mitigations for production:
     * Encrypt voucher files at rest
     * Validate NITs with government-approved algorithms

6. INTERNATIONALIZATION:
   - Current limitations:
     * USD/COP currency formatting hardcoded
     * Spanish-only UI strings
     * American number formatting (1,000.00)

7. TESTING REQUIREMENTS:
   - Must verify:
     * Binary search with unsorted input
     * Invoice generation with boundary values:
       - Subtotal: 0.01 vs. 999,999.99
       - Tax calculations (19% vs. 20% edge cases)
   - Stress test beyond 5,000 vouchers

8. DATA MIGRATION:
   - Backup protocol before:
     * Racket version upgrades
     * Schema modifications (e.g., adding VAT fields)
   - Incompatible with:
     * Big-endian architectures
     * Systems without SRFI support

9. AUDIT REQUIREMENTS:
   - Mandatory logging:
     * Portfolio changes (timestamp + user)
     * Invoice sequence numbers (no gaps)
   - Retention policy:
     * 5 years for financial records
     * 30 days for debug logs

10. PERFORMANCE CHARACTERISTICS:
    - Algorithmic complexity:
      * Ordered insertion: O(n)
      * Binary search: O(log n)
    - Memory scales linearly with:
      * Active service vouchers
      * Product catalog size
|#

(require srfi/13) ; Required for string operations

(define (main)
;; ========================== DATA STRUCTURES =========================

; Structure representing a product in the inventory
; code: Unique numeric identifier for the product
; name: Descriptive name of the product
; value: Unit price of the product
(define-struct product (code name value))

; Structure representing a service voucher
; plate: Vehicle license plate
; date: Service date in YYYY-MM-DD format
; clientName: Name of the customer
; nit: Tax identification number
; codes: Vector of product codes included in the service
; quantities: Vector of quantities for each product
(define-struct voucher (plate date clientName nit codes quantities))

;; ========================== INITIAL STATE =========================

; Initial empty product portfolio
(define initialPortfolio (vector))

; Initial empty voucher list
(define initialVouchers (vector))

;; ========================== AUXILIARY FUNCTIONS =========================

(define (ExtractSubVector sourceVector startIndex endIndex)
  ; sourceVector: Original vector to extract from
  ; startIndex: Starting position (inclusive)
  ; endIndex: Ending position (exclusive)
  ; Returns: New vector containing elements from startIndex to endIndex-1
  (ExtractSubVectorAux sourceVector startIndex endIndex 0 (vector)))

(define (ExtractSubVectorAux sourceVector startIndex endIndex currentIndex resultVector)
  ; Helper function for ExtractSubVector using recursion
  ; currentIndex: Current position in the result vector
  ; resultVector: Accumulated result
  (if (= currentIndex (- endIndex startIndex))
      resultVector
  ; else
      (ExtractSubVectorAux sourceVector startIndex endIndex (add1 currentIndex) 
                     (vector-append resultVector (vector (vector-ref sourceVector (+ startIndex currentIndex)))))
  ); end if: checking if extraction is complete
); end function definition: ExtractSubVectorAux

(define (ClearInputBuffer)
  ; Clears any remaining input in the buffer
  ; Returns: Nothing (side effect)
  (read-line))

(define (CheckCodeExists productCode productPortfolio lowerBound upperBound)
  ; productCode: Code to search for
  ; productPortfolio: Vector of products to search in
  ; lowerBound: Lower index for binary search
  ; upperBound: Upper index for binary search
  ; Returns: Boolean indicating if code exists
  (if (>= lowerBound upperBound)
      #f
  ; else
      (CheckCodeExistsAux productCode productPortfolio lowerBound upperBound)
  ); end if: checking if search range is valid
); end function definition: CheckCodeExists

(define (CheckCodeExistsAux productCode productPortfolio lowerBound upperBound)
  ; First helper for binary search implementation
  (define middlePoint (quotient (+ lowerBound upperBound) 2))
  (if (= middlePoint (vector-length productPortfolio))
      #f
  ; else
      (CheckCodeExistsAux2 productCode productPortfolio lowerBound upperBound middlePoint)
  ); end if: checking if middle point is valid
); end function definition: CheckCodeExistsAux

(define (CheckCodeExistsAux2 productCode productPortfolio lowerBound upperBound middlePoint)
  ; Second helper for binary search implementation
  (define middleCode (product-code (vector-ref productPortfolio middlePoint)))
  (if (= productCode middleCode)
      #t
  ; else
      (CheckCodeExistsAux3 productCode productPortfolio lowerBound upperBound middlePoint middleCode)
  ); end if: checking if code matches
); end function definition: CheckCodeExistsAux2

(define (CheckCodeExistsAux3 productCode productPortfolio lowerBound upperBound middlePoint middleCode)
  ; Third helper for binary search implementation
  (if (< productCode middleCode)
      (CheckCodeExists productCode productPortfolio lowerBound middlePoint)
  ; else
      (CheckCodeExists productCode productPortfolio (add1 middlePoint) upperBound)
  ); end if: deciding search direction
); end function definition: CheckCodeExistsAux3

(define (FindProduct productCode productPortfolio lowerBound upperBound)
  ; productCode: The code to search for
  ; productPortfolio: Vector containing all available products
  ; lowerBound: Starting index for binary search
  ; upperBound: Ending index for binary search
  ; Returns: Product structure or "Not found" product
  (if (>= lowerBound upperBound)
      (make-product 0 "No encontrado" 0)
  ; else
      (FindProductAux productCode productPortfolio lowerBound upperBound)
  ); end if: checking if search range is valid
); end function definition: FindProduct

(define (FindProductAux productCode productPortfolio lowerBound upperBound)
  ; First helper for product search
  (define middlePoint (quotient (+ lowerBound upperBound) 2))
  (if (= middlePoint (vector-length productPortfolio))
      (make-product 0 "No encontrado" 0)
  ; else
      (FindProductAux2 productCode productPortfolio lowerBound upperBound middlePoint)
  ); end if: checking if middle point is valid
); end function definition: FindProductAux

(define (FindProductAux2 productCode productPortfolio lowerBound upperBound middlePoint)
  ; Second helper for product search
  (define middleProduct (vector-ref productPortfolio middlePoint))
  (define middleCode (product-code middleProduct))
  (if (= productCode middleCode)
      middleProduct
  ; else
      (FindProductAux3 productCode productPortfolio lowerBound upperBound middlePoint middleCode)
  ); end if: checking if code matches
); end function definition: FindProductAux2

(define (FindProductAux3 productCode productPortfolio lowerBound upperBound middlePoint middleCode)
  ; Third helper for product search
  (if (< productCode middleCode)
      (FindProduct productCode productPortfolio lowerBound middlePoint)
  ; else
      (FindProduct productCode productPortfolio (add1 middlePoint) upperBound)
  ); end if: deciding search direction
); end function definition: FindProductAux3

(define (InsertInOrder newProduct productPortfolio)
  ; newProduct: Product structure to insert
  ; productPortfolio: Existing product vector
  ; Returns: New vector with product inserted in correct position
  (if (= 0 (vector-length productPortfolio))
      (vector newProduct)
  ; else
      (InsertInOrderAux newProduct productPortfolio 0 (vector))
  ); end if: checking if portfolio is empty
); end function definition: InsertInOrder

(define (InsertInOrderAux newProduct productPortfolio currentIndex resultVector)
  ; Helper for ordered insertion using recursion
  ; currentIndex: Current position in original vector
  ; resultVector: Accumulated result
  (if (= currentIndex (vector-length productPortfolio))
      (vector-append resultVector (vector newProduct))
  ; else
      (InsertInOrderAux2 newProduct productPortfolio currentIndex resultVector)
  ); end if: checking if insertion is complete
); end function definition: InsertInOrderAux

(define (InsertInOrderAux2 newProduct productPortfolio currentIndex resultVector)
  ; Second helper for ordered insertion
  (if (< (product-code newProduct) (product-code (vector-ref productPortfolio currentIndex)))
      (vector-append resultVector (vector newProduct) (ExtractSubVector productPortfolio currentIndex (vector-length productPortfolio)))
  ; else
      (InsertInOrderAux newProduct productPortfolio (add1 currentIndex) 
                        (vector-append resultVector (vector (vector-ref productPortfolio currentIndex))))
  ); end if: checking insertion position
); end function definition: InsertInOrderAux2

(define (FormatNumberWithCommas inputNumber)
  ; inputNumber: Number to format
  ; Returns: String with number formatted with thousands separators
  (define numberString (number->string (exact-round inputNumber)))
  (AddCommas numberString (string-length numberString) 0 ""))

(define (AddCommas stringNumber stringLength currentPosition resultString)
  ; Helper for number formatting
  ; stringNumber: Original number as string
  ; stringLength: Length of the number string
  ; currentPosition: Current digit being processed
  ; resultString: Accumulated result
  (if (= currentPosition stringLength)
      resultString
  ; else
      (AddCommasAux stringNumber stringLength currentPosition resultString)
  ); end if: checking if formatting is complete
); end function definition: AddCommas

(define (AddCommasAux stringNumber stringLength currentPosition resultString)
  ; Second helper for number formatting
  (if (and (> currentPosition 0) (= (remainder (- stringLength currentPosition) 3) 0))
      (AddCommas stringNumber stringLength (add1 currentPosition) 
               (string-append resultString "," (substring stringNumber currentPosition (add1 currentPosition))))
  ; else
      (AddCommas stringNumber stringLength (add1 currentPosition) 
               (string-append resultString (substring stringNumber currentPosition (add1 currentPosition))))
  ); end if: checking if comma is needed
); end function definition: AddCommasAux

(define (ConvertNumberToText inputNumber)
  ; inputNumber: Number to convert to text
  ; Returns: String with number written in Spanish words
  (define unitWords (vector "CERO" "UN" "DOS" "TRES" "CUATRO" "CINCO" "SEIS" "SIETE" "OCHO" "NUEVE"))
  (define tensWords (vector "DIEZ" "VEINTE" "TREINTA" "CUARENTA" "CINCUENTA" "SESENTA" "SETENTA" "OCHENTA" "NOVENTA"))
  (define teensWords (vector "ONCE" "DOCE" "TRECE" "CATORCE" "QUINCE" "DIECISEIS" "DIECISIETE" "DIECIOCHO" "DIECINUEVE"))
  (define hundredsWords (vector "CIENTO" "DOSCIENTOS" "TRESCIENTOS" "CUATROCIENTOS" "QUINIENTOS" 
                                "SEISCIENTOS" "SETECIENTOS" "OCHOCIENTOS" "NOVECIENTOS"))
  
  ; Converts the number to exact integer (rounds if decimal)
  (define exactNum (inexact->exact (round inputNumber)))
  
  (define (ConvertNumber num)
    (cond
      [(= num 0) ""]
      [(< num 10) (vector-ref unitWords num)]
      [(= num 10) "DIEZ"]
      [(< num 20) (vector-ref teensWords (- num 11))]
      [(< num 100)
       (string-append
        (vector-ref tensWords (- (quotient num 10) 1))
        (if (> (remainder num 10) 0)
            (string-append " Y " (ConvertNumber (remainder num 10)))
            ""))]
      [(= num 100) "CIEN"]
      [(< num 1000)
       (string-append
        (vector-ref hundredsWords (- (quotient num 100) 1))
        (if (> (remainder num 100) 0)
            (string-append " " (ConvertNumber (remainder num 100)))
            ""))]
      [(< num 1000000)
       (string-append
        (ConvertNumber (quotient num 1000))
        (if (= (quotient num 1000) 1) "" " ")
        "MIL"
        (if (> (remainder num 1000) 0)
            (string-append " " (ConvertNumber (remainder num 1000)))
            ""))]
      [(< num 100000000)
       (string-append
        (ConvertNumber (quotient num 1000000))
        (if (= (quotient num 1000000) 1) 
            " MILLON" 
            " MILLONES")
        (if (> (remainder num 1000000) 0)
            (string-append " " (ConvertNumber (remainder num 1000000)))
            ""))]
      [else "NUMERO DEMASIADO GRANDE"]))

  (if (= exactNum 0)
      "CERO"
  ; else
      (ConvertNumber exactNum)
  ); end if: checking for zero
); end function definition: ConvertNumberToText

(define (CalculateSubtotal productPortfolio productCodes productQuantities currentIndex accumulatedTotal)
  ; productPortfolio: Vector of all products
  ; productCodes: Vector of product codes in invoice
  ; productQuantities: Vector of corresponding quantities
  ; currentIndex: Current position being processed
  ; accumulatedTotal: Running total of subtotal
  ; Returns: Calculated subtotal amount
  (if (= currentIndex (vector-length productCodes))
      accumulatedTotal
  ; else
      (CalculateSubtotalItem productPortfolio productCodes productQuantities currentIndex accumulatedTotal)
  ); end if: checking if all items processed
); end function definition: CalculateSubtotal

(define (CalculateSubtotalItem productPortfolio productCodes productQuantities currentIndex accumulatedTotal)
  ; Helper for subtotal calculation
  (define currentCode (vector-ref productCodes currentIndex))
  (define currentQuantity (vector-ref productQuantities currentIndex))
  (define currentProduct (FindProduct currentCode productPortfolio 0 (vector-length productPortfolio)))
  (define unitPrice (product-value currentProduct))
  (define itemTotal (* currentQuantity unitPrice))
  
  (CalculateSubtotal productPortfolio productCodes productQuantities (add1 currentIndex) (+ accumulatedTotal itemTotal)))

(define (PrintInvoiceItems productPortfolio productCodes productQuantities currentIndex)
  ; productPortfolio: Vector of all products
  ; productCodes: Vector of product codes in invoice
  ; productQuantities: Vector of corresponding quantities
  ; currentIndex: Current position being processed
  ; Returns: Nothing (side effect of printing)
  (if (= currentIndex (vector-length productCodes))
      (void)
  ; else
      (PrintCurrentInvoiceItem productPortfolio productCodes productQuantities currentIndex)
  ); end if: checking if all items printed
); end function definition: PrintInvoiceItems

(define (PrintCurrentInvoiceItem productPortfolio productCodes productQuantities currentIndex)
  ; Helper for printing invoice items
  (define currentCode (vector-ref productCodes currentIndex))
  (define currentQuantity (vector-ref productQuantities currentIndex))
  (define currentProduct (FindProduct currentCode productPortfolio 0 (vector-length productPortfolio)))
  (define unitPrice (product-value currentProduct))
  (define totalPrice (* currentQuantity unitPrice))
  
  (printf "│           │   ~a│ ~a│      ~a│ ~a││\n"
          (string-pad-right (~a currentCode) 4 #\space)
          (string-pad-right (~a (product-name currentProduct)) 48 #\space)
          (string-pad-right (~a currentQuantity) 7 #\space)
          (string-pad-right (~a (FormatNumberWithCommas totalPrice)) 14 #\space)
  )
  (printf "│           ├───────┼─────────────────────────────────────────────────┼─────────────┼───────────────┤│\n")
  
  (PrintInvoiceItems productPortfolio productCodes productQuantities (add1 currentIndex)))

;; ========================== USER INPUT FUNCTIONS =========================

(define (EnterVehiclePlate)
  ; Prompts for and reads vehicle plate
  ; Returns: String with plate number
  (printf "│ PLACA: ")
  (ClearInputBuffer)
  (read-line))

(define (EnterServiceDate)
  ; Prompts for and reads service date
  ; Returns: String with date in YYYY-MM-DD format
  (printf "│ FECHA (AAAA-MM-DD): ")
  (read-line))

(define (EnterClientName)
  ; Prompts for and reads client name
  ; Returns: String with client name
  (printf "│ Nombre del Cliente: ")
  (read-line))

(define (EnterClientNit)
  ; Prompts for and reads client tax ID
  ; Returns: String with NIT
  (printf "│ NIT: ")
  (read-line))

(define (EnterProductCode)
  ; Prompts for and reads product code
  ; Returns: Numeric product code
  (printf "│ Ingrese código de producto (0 para terminar): ")
  (read))

(define (EnterProductQuantity)
  ; Prompts for and reads product quantity
  ; Returns: Numeric quantity
  (printf "│ Ingrese cantidad: ")
  (read))

(define (EnterProductName)
  ; Prompts for and reads product name
  ; Returns: String with product name
  (printf "│ Ingrese el nombre del producto: ")
  (ClearInputBuffer)
  (read-line))

(define (EnterProductValue)
  ; Prompts for and reads product value
  ; Returns: Numeric value
  (printf "│ Ingrese el valor del producto: ")
  (read))

(define (EnterVoucherNumber maxVoucher)
  ; Prompts for and reads voucher number
  ; maxVoucher: Highest valid voucher number
  ; Returns: Numeric voucher number
  (printf "│ Ingrese el número de comprobante: ")
  (read))

;; ========================== DISPLAY FUNCTIONS =========================

(define (DisplayMainMenu)
  ; Displays the main menu interface
  ; Returns: Nothing (side effect)
  (printf "╔════════════════════════════════════════════════════════╗\n")
  (printf "║ DIAGNOSTICENTRO EL PROGRESO         NIT. 903.103.888-2 ║\n")
  (printf "╠════════════════════════════════════════════════════════╣\n")
  (printf "║                MENU PRINCIPAL                          ║\n")
  (printf "╠════════════════════════════════════════════════════════╣\n")
  (printf "║                                                        ║\n")
  (printf "║  0. Salir del aplicativo                               ║\n")
  (printf "║  1. Añadir nuevos productos al portafolio              ║\n")
  (printf "║  Comprobante de servicio a un cliente                  ║\n")
  (printf "║    2. Crear un nuevo comprobante                       ║\n")
  (printf "║    3. Agregar elementos a un comprobante existente     ║\n")
  (printf "║  4. Generar e imprimir factura a un número de          ║\n")
  (printf "║     comprobante de servicio                            ║\n")
  (printf "║  Seleccione su opción:                                 ║\n")
  (printf "╠════════════════════════════════════════════════════════╣\n"))

(define (DisplayAddProductScreen)
  ; Displays the product addition screen
  ; Returns: Nothing (side effect)
  (printf "┌─────────────────────────────────────────────────────────────────────────┐\n")
  (printf "│       DIAGNOSTICENTRO EL PROGRESO                     NIT. 903.103.888-2│\n")
  (printf "├─────────────────────────────────────────────────────────────────────────┤\n")
  (printf "│                      AGREGAR NUEVO PRODUCTO                             │\n")
  (printf "├─────────────────────────────────────────────────────────────────────────┤\n")
  (printf "│ (Si no desea entrar nuevos productos teclee 0 en nuevo código)          │\n"))

(define (DisplayPreVoucherHeader)
  ; Displays header for voucher creation
  ; Returns: Nothing (side effect)
  (printf "┌───────────────────────────────────────────────────────────┐\n")
  (printf "│ DIAGNOSTICENTRO EL PROGRESO             NIT. 903.103.888-2│\n")
  (printf "│ INFORMACION GENERAL COMPROBANTE DE SOLICITUD DE SERVICIO: │\n")
  (printf "├───────────────────────────────────────────────────────────┤\n"))

(define (DisplayPreVoucherProductSection)
  ; Displays product section header for voucher
  ; Returns: Nothing (side effect)
  (printf "├───────────────────────────────────────────────────────────┤\n")
  (printf "│ REQUERIMIENTOS COMPROBANTE DE SOLICITUD DE SERVICIO       │\n")
  (printf "├───────────────────────────────────────────────────────────┤\n"))

(define (DisplayVoucherInfo plate date clientName nit codes quantities voucherNumber productPortfolio)
  ; Displays complete voucher information
  ; plate: Vehicle plate number
  ; date: Service date
  ; clientName: Customer name
  ; nit: Tax ID
  ; codes: Product codes
  ; quantities: Product quantities
  ; voucherNumber: Voucher identifier
  ; productPortfolio: Product database
  ; Returns: Nothing (side effect)
  (printf "┌────────────────────────────────────────────────────────────────────────────────┐\n")
  (printf "│  DIAGNOSTICENTRO EL PROGRESO                                NIT. 903.103.888-2 │\n")
  (printf "│  COMPROBANTE DE SOLICITUD DE SERVICIO NÚMERO: ~a~a│\n" 
          voucherNumber 
          (make-string (- 33 (string-length (number->string voucherNumber))) #\space))
  (printf "│ ┌─────────────────────────────────────────────────────────────────────────────┐│\n")
  (printf "│ │PLACA: ~a~a││\n" plate (make-string (- 70 (string-length plate)) #\space))
  (printf "│ │FECHA: ~a~a││\n" date (make-string (- 70 (string-length date)) #\space))
  (printf "│ │Nombre del Cliente: ~a~a││\n" clientName (make-string (- 57 (string-length clientName)) #\space))
  (printf "│ │NIT: ~a~a││\n" nit (make-string (- 72 (string-length nit)) #\space))
  (printf "│ ├────────────┬─────────────────────────────────────────────────┬──────────────┤│\n")
  (printf "│ │   CÓDIGO   │                     NOMBRE                      │   CANTIDAD   ││\n")
  (printf "│ │  PRODUCTO  │                    PRODUCTO                     │              ││\n")
  (printf "│ ├────────────┼─────────────────────────────────────────────────┼──────────────┤│\n")
  
  (DisplayVoucherProducts productPortfolio codes quantities 0 (vector-length codes))
  
  (printf "│ └────────────┴─────────────────────────────────────────────────┴──────────────┘│\n")
  (printf "└────────────────────────────────────────────────────────────────────────────────┘\n"))

(define (DisplayVoucherProductsAux productPortfolio codes quantities currentIndex totalProducts)
  ; Helper for displaying voucher products
  (define product (FindProduct (vector-ref codes currentIndex) productPortfolio 0 (vector-length productPortfolio)))
  (printf "│ │ ~a│ ~a│ ~a││\n"
          (string-pad-right(~a (vector-ref codes currentIndex)) 11 #\space)
          (string-pad-right(~a (product-name product)) 48 #\space)
          (string-pad-right(~a (vector-ref quantities currentIndex)) 13 #\space)
  )
  (printf "│ ├────────────┼─────────────────────────────────────────────────┼──────────────┤│\n")
  (DisplayVoucherProducts productPortfolio codes quantities (add1 currentIndex) totalProducts)
)

(define (DisplayVoucherProducts productPortfolio codes quantities currentIndex totalProducts)
  ; Displays products in voucher format
  (if (= currentIndex totalProducts)
      (void)
      (DisplayVoucherProductsAux productPortfolio codes quantities currentIndex totalProducts)
  )
)

(define (DisplayProductTable productPortfolio)
  ; Displays product portfolio in table format
  ; Returns: Nothing (side effect)
  (printf "┌───────┬─────────────────────────────────────────────────┬───────────────┐\n")
  (printf "│Código │Producto                                         │Valor          │\n")
  (printf "├───────┼─────────────────────────────────────────────────┼───────────────┤\n")
  (DisplayProductTableRows productPortfolio 0 (vector-length productPortfolio))
  (printf "└───────┴─────────────────────────────────────────────────┴───────────────┘\n"))

(define (DisplayProductTableRows productPortfolio currentIndex totalProducts)
  ; Helper for displaying product table rows
  (if (= currentIndex totalProducts)
      (void)
      (DisplayProductRow productPortfolio currentIndex totalProducts)))

(define (DisplayProductRow productPortfolio currentIndex totalProducts)
  ; Displays a single product row
  (define currentProduct (vector-ref productPortfolio currentIndex))
  (printf "│   ~a│ ~a│ ~a│\n"
          (string-pad-right (~a (product-code currentProduct)) 4 #\space)
          (string-pad-right (~a (product-name currentProduct)) 48 #\space)
          (string-pad-right (~a (FormatNumberWithCommas (product-value currentProduct))) 14 #\space)
  )
  
  (DisplayProductTableRows productPortfolio (add1 currentIndex) totalProducts))

(define (DisplayInvoiceHeader vehiclePlate serviceDate clientName clientNit)
  ; Displays invoice header section
  ; Returns: Nothing (side effect)
  (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
  (printf "┌────────────────────────────────────────────────────────────────────────────────────────────────────┐\n")
  (printf "│                                                                                                    │\n")
  (printf "│                                                                                                    │\n")
  (printf "│           ┌───────────────────────────────────────────────────────────────────────────────────────┐│\n")
  (printf "│           │ DIAGNOSTICENTRO EL PROGRESO                                        NIT. 903.103.888-2 ││\n")
  (printf "│           │ Factura de venta                                        Fecha(AAAA-MM-DD): ~a ││\n" (string-pad (~a serviceDate) 10 #\space))
  (printf "│           │ Nombre del cliente: ~a││\n"(string-pad-right (~a clientName) 66 #\space))
  (printf "│           │ NIT del cliente: ~a││\n" (string-pad-right (~a clientNit) 69 #\space))
  (printf "│           │ Placa: ~a││\n" (string-pad-right (~a vehiclePlate) 79 #\space))
  (printf "│           ├───────┬─────────────────────────────────────────────────┬─────────────┬───────────────┤│\n")
  (printf "│           │Código │Producto                                         │Cantidad     │Valor          ││\n")
  (printf "│           ├───────┼─────────────────────────────────────────────────┼─────────────┼───────────────┤│\n"))

(define (DisplayInvoiceFooter subtotalAmount taxAmount totalAmount)
  ; Displays invoice footer with totals
  ; Returns: Nothing (side effect)
  (printf "│           │       │*******************FIN FACTURA*******************│*************│***************││\n")
  (printf "│           └───────┴─────────────────────────────────────────────────┴─────────────┴───────────────┘│\n")
  (printf "│                                                           Sub-total~a│\n" (string-pad (~a (FormatNumberWithCommas subtotalAmount)) 32 #\space))
  (printf "│                                                            IVA(20%)~a│\n" (string-pad (~a (FormatNumberWithCommas taxAmount)) 32 #\space))
  (printf "│                                                               Total~a│\n" (string-pad (~a (FormatNumberWithCommas totalAmount)) 32 #\space))
  (if (> (string-length (ConvertNumberToText totalAmount)) 72)
      (begin
        (printf "│ Valor total a pagar: ~a      │\n" (string-pad-right (ConvertNumberToText totalAmount) 72 #\space))
        (printf "│                      ~a│\n" (string-pad-right (string-append (substring (ConvertNumberToText totalAmount) 72 (string-length (ConvertNumberToText totalAmount))) " PESOS") 78 #\space))
      )
      (printf "│ Valor total a pagar: ~a│\n" (string-pad-right (string-append (ConvertNumberToText totalAmount) " PESOS") 78 #\space))
  )
  (printf "│                    ($~a) MCTE~a│\n" (FormatNumberWithCommas totalAmount) (make-string (- 72 (string-length (FormatNumberWithCommas totalAmount))) #\space))
  (printf "└────────────────────────────────────────────────────────────────────────────────────────────────────┘\n"))

(define (DisplayVoucherList voucherList)
  ; Displays list of all vouchers
  ; Returns: Nothing (side effect)
  (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
  (printf "┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐\n")
  (printf "│                                      LISTA DE COMPROBANTES DE SERVICIO                                           │\n")
  (printf "├──────────┬────────────┬──────────────────────────────┬────────────────┬────────────┬────────────┬────────────────┤\n")
  (printf "│  Placa   │   Fecha    │        Nombre Cliente        │      NIT       │Cod Producto│  Cantidad  │ Nro Comprobante│\n")
  (printf "├──────────┼────────────┼──────────────────────────────┼────────────────┼────────────┼────────────┼────────────────┤\n")
  (DisplayVoucherListItems voucherList 0 (vector-length voucherList))
  (printf "└──────────┴────────────┴──────────────────────────────┴────────────────┴────────────┴────────────┴────────────────┘\n"))

(define (DisplayVoucherListItems voucherList currentIndex totalVouchers)
  ; Helper for displaying voucher list items
  (if (= currentIndex totalVouchers)
      (void)
      (begin
        (DisplayVoucherItems (vector-ref voucherList currentIndex) (add1 currentIndex))
        (DisplayVoucherListItems voucherList (add1 currentIndex) totalVouchers))))

(define (DisplayVoucherItems voucher voucherNumber)
  ; Displays items for a single voucher
  (DisplayVoucherItemsAux (voucher-codes voucher) 
                         (voucher-quantities voucher) 
                         0 
                         (vector-length (voucher-codes voucher))
                         (voucher-plate voucher)
                         (voucher-date voucher)
                         (voucher-clientName voucher)
                         (voucher-nit voucher)
                         voucherNumber))

(define (DisplayVoucherItemsAux codes quantities itemIndex totalItems plate date clientName nit voucherNumber)
  ; Helper for displaying voucher items
  (if (= itemIndex totalItems)
      (void)
      (begin
        (printf "│ ~a│ ~a│ ~a│ ~a│ ~a│ ~a│ ~a│\n"
                (string-pad-right (~a plate) 9 #\space)
                (string-pad-right (~a date) 11 #\space)
                (string-pad-right (~a clientName) 29 #\space)
                (string-pad-right (~a nit) 15 #\space)
                (string-pad-right (~a (vector-ref codes itemIndex)) 11 #\space)
                (string-pad-right (~a (vector-ref quantities itemIndex)) 11 #\space)
                (string-pad-right (~a voucherNumber) 15 #\space))
        (DisplayVoucherItemsAux codes quantities (add1 itemIndex) totalItems plate date clientName nit voucherNumber))))

;; ========================== MAIN FUNCTIONS =========================

(define (GetVoucherProducts productPortfolio voucherList vehiclePlate serviceDate clientName nit productCodes productQuantities isNewVoucher [voucherIndex -1])
  ; Main function for collecting voucher products
  ; productPortfolio: Current product database
  ; voucherList: Current list of vouchers
  ; vehiclePlate: Vehicle identifier
  ; serviceDate: Date of service
  ; clientName: Customer name
  ; nit: Tax ID
  ; productCodes: Accumulated product codes
  ; productQuantities: Accumulated quantities
  ; isNewVoucher: Boolean for new vs existing voucher
  ; voucherIndex: Index for existing voucher (-1 for new)
  ; Returns: Nothing (proceeds to next step)
  (define currentCode (EnterProductCode))
  (if (= currentCode 0)
      (if isNewVoucher
          (FinalizeNewVoucher productPortfolio voucherList vehiclePlate serviceDate clientName nit productCodes productQuantities)
          (FinalizeExistingVoucher productPortfolio voucherList vehiclePlate serviceDate clientName nit productCodes productQuantities voucherIndex))
      (ProcessProductCode productPortfolio voucherList vehiclePlate serviceDate clientName nit productCodes productQuantities currentCode isNewVoucher voucherIndex)))

(define (ProcessProductCode productPortfolio voucherList vehiclePlate serviceDate clientName nit productCodes productQuantities currentCode isNewVoucher voucherIndex)
  ; Processes a single product code entry
  (if (CheckCodeExists currentCode productPortfolio 0 (vector-length productPortfolio))
      (ProcessValidCode productPortfolio voucherList vehiclePlate serviceDate clientName nit productCodes productQuantities currentCode isNewVoucher voucherIndex)
      (ProcessInvalidCode productPortfolio voucherList vehiclePlate serviceDate clientName nit productCodes productQuantities currentCode isNewVoucher voucherIndex)))

(define (ProcessValidCode productPortfolio voucherList vehiclePlate serviceDate clientName nit productCodes productQuantities currentCode isNewVoucher voucherIndex)
  ; Processes a valid product code
  (define quantity (EnterProductQuantity))
  (define newCodes (vector-append productCodes (vector currentCode)))
  (define newQuantities (vector-append productQuantities (vector quantity)))
  (GetVoucherProducts productPortfolio voucherList vehiclePlate serviceDate clientName nit newCodes newQuantities isNewVoucher voucherIndex))

(define (ProcessInvalidCode productPortfolio voucherList vehiclePlate serviceDate clientName nit productCodes productQuantities currentCode isNewVoucher voucherIndex)
  ; Handles invalid product codes
  (printf "│ Error: El código ~a no existe en el portafolio │\n" currentCode)
  (GetVoucherProducts productPortfolio voucherList vehiclePlate serviceDate clientName nit productCodes productQuantities isNewVoucher voucherIndex))

(define (FinalizeVoucher productPortfolio voucherList vehiclePlate serviceDate clientName taxId productCodes productQuantities isNewVoucher)
  ; Finalizes voucher creation/update
  (if isNewVoucher
      (FinalizeNewVoucher productPortfolio voucherList vehiclePlate serviceDate clientName taxId productCodes productQuantities)
      (FinalizeExistingVoucher productPortfolio voucherList vehiclePlate serviceDate clientName taxId productCodes productQuantities)))

(define (FinalizeNewVoucher productPortfolio voucherList vehiclePlate serviceDate clientName taxId productCodes productQuantities)
  ; Completes creation of new voucher
  ; productPortfolio: Current product database
  ; voucherList: Current list of vouchers
  ; vehiclePlate: Vehicle identifier
  ; serviceDate: Date of service
  ; clientName: Customer name
  ; taxId: Tax identification number
  ; productCodes: Vector of product codes
  ; productQuantities: Vector of quantities
  ; Returns: Nothing (proceeds to main menu)
  (define newVoucher (make-voucher vehiclePlate serviceDate clientName taxId productCodes productQuantities))
  (define updatedVoucherList (vector-append voucherList (vector newVoucher)))
  (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
  (printf "┌───────────────────────────────────────────────────────────┐\n")
  (printf "│ Comprobante generado exitosamente                         │\n")
  (printf "└───────────────────────────────────────────────────────────┘\n")
  (DisplayVoucherInfo (voucher-plate newVoucher) (voucher-date newVoucher) (voucher-clientName newVoucher) (voucher-nit newVoucher) (voucher-codes newVoucher) (voucher-quantities newVoucher) (vector-length updatedVoucherList) productPortfolio)
  (MainMenu productPortfolio updatedVoucherList))

(define (FinalizeExistingVoucher productPortfolio voucherList vehiclePlate serviceDate clientName nit productCodes productQuantities voucherIndex)
  ; Completes update of existing voucher
  ; voucherIndex: Position of voucher to update
  ; Returns: Nothing (proceeds to main menu)
  (define updatedVoucher (make-voucher vehiclePlate serviceDate clientName nit productCodes productQuantities))
  (define updatedVoucherList 
    (vector-append 
     (ExtractSubVector voucherList 0 voucherIndex)      ; Part before voucher to modify
     (vector updatedVoucher)                            ; Updated voucher
     (ExtractSubVector voucherList (add1 voucherIndex) (vector-length voucherList)))) ; Part after
  (printf "│ Comprobante actualizado exitosamente                                                                             │\n")
  (printf "└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘\n")
  (DisplayVoucherInfo vehiclePlate serviceDate clientName nit productCodes productQuantities (add1 voucherIndex) productPortfolio)
  (MainMenu productPortfolio updatedVoucherList))

(define (AddProduct productPortfolio voucherList)
  ; Manages product addition workflow
  ; Returns: Nothing (proceeds to next step)
  (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
  (DisplayProductTable productPortfolio)
  (DisplayAddProductScreen)
  (AddProductLoop productPortfolio voucherList))

(define (AddProductLoop productPortfolio voucherList)
  ; Main loop for adding products
  ; Returns: Nothing (proceeds to next step)
  (printf "│ Entre un nuevo código (0 para terminar): ")
  (define newCode (read))
  (if (= newCode 0)
      (begin
        (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
        (MainMenu productPortfolio voucherList)
      )
  ; else
      (ProcessProductCodeForAddition productPortfolio voucherList newCode)
  ); end if: checking for termination code
); end function definition: AddProductLoop

(define (ProcessProductCodeForAddition productPortfolio voucherList newCode)
  ; Processes product code during addition
  (if (CheckCodeExists newCode productPortfolio 0 (vector-length productPortfolio))
      (DisplayExistingProduct productPortfolio voucherList newCode)
  ; else
      (AddNewProduct productPortfolio voucherList newCode)
  ); end if: checking if code exists
); end function definition: ProcessProductCodeForAddition

(define (DisplayExistingProduct productPortfolio voucherList newCode)
  ; Handles case when product code already exists
  (define existingProduct (FindProduct newCode productPortfolio 0 (vector-length productPortfolio)))
  (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
  (printf "┌─────────────────────────────────────────────────────────────────────────┐\n")
  (printf "│ Este código ya existe y es:                                             │\n")
  (printf "│ Nombre: ~a~a│\n" (product-name existingProduct) (make-string (- 64 (string-length (product-name existingProduct))) #\space))
  (printf "│ Valor: ~a~a│\n" (product-value existingProduct) (make-string (- 65 (string-length (number->string (product-value existingProduct)))) #\space))
  (AddProductLoop productPortfolio voucherList))

(define (AddNewProduct productPortfolio voucherList newCode)
  ; Adds new product to portfolio
  (define newName (EnterProductName))
  (define newValue (EnterProductValue))
  (define newProduct (make-product newCode newName newValue))
  (define updatedPortfolio (InsertInOrder newProduct productPortfolio))
  (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
  (printf "┌─────────────────────────────────────────────────────────────────────────┐\n")
  (printf "│ Producto agregado exitosamente                                          │\n")
  (DisplayProductTable updatedPortfolio)
  (AddProductLoop updatedPortfolio voucherList))

(define (FillServiceVoucher productPortfolio voucherList)
  ; Manages new voucher creation workflow
  (printf "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
  (DisplayProductTable productPortfolio)
  (DisplayPreVoucherHeader)
  (define vehiclePlate (EnterVehiclePlate))
  (define serviceDate (EnterServiceDate))
  (define clientName (EnterClientName))
  (define taxId (EnterClientNit))
  (DisplayPreVoucherProductSection)
  (GetVoucherProducts productPortfolio voucherList vehiclePlate serviceDate clientName taxId (vector) (vector) #t))

(define (AddToExistingVoucherAux productPortfolio voucherList voucherNumber)
  ; Helper for adding to existing voucher
  (define voucherIndex (sub1 voucherNumber)) ; Convert to 0-based index
  (define selectedVoucher (vector-ref voucherList voucherIndex))
  (DisplayProductTable productPortfolio)
  (GetVoucherProducts productPortfolio voucherList 
                      (voucher-plate selectedVoucher)
                      (voucher-date selectedVoucher)
                      (voucher-clientName selectedVoucher)
                      (voucher-nit selectedVoucher)
                      (voucher-codes selectedVoucher)
                      (voucher-quantities selectedVoucher)
                      #f
                      voucherIndex)) ; Pass voucher index to modify

(define (AddToExistingVoucher productPortfolio voucherList)
  ; Manages adding items to existing voucher
  (DisplayVoucherList voucherList)
  (printf "│ Ingrese el número de comprobante a modificar: ")
  (define voucherNumber (read))
  (if (or (< voucherNumber 1) (> voucherNumber (vector-length voucherList)))
      (begin
        (printf "│ Número de comprobante inválido                                                                                   │\n")
        (printf "└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘\n")
        (MainMenu productPortfolio voucherList))
  ; else
      (AddToExistingVoucherAux productPortfolio voucherList voucherNumber)
  ); end if: validating voucher number
); end function definition: AddToExistingVoucher

(define (GenerateInvoice productPortfolio voucherList)
  ; Manages invoice generation workflow
  (if (= (vector-length voucherList) 0)
      (GenerateInvoiceNoVouchers productPortfolio voucherList)
  ; else
      (GenerateInvoiceWithVouchers productPortfolio voucherList)
  ); end if: checking for empty voucher list
); end function definition: GenerateInvoice

(define (GenerateInvoiceNoVouchers productPortfolio voucherList)
  ; Handles case when no vouchers exist
  (printf "┌───────────────────────────────────────────────────────────┐\n")
  (printf "│ No hay comprobantes registrados                           │\n")
  (printf "└───────────────────────────────────────────────────────────┘\n")
  (MainMenu productPortfolio voucherList))

(define (GenerateInvoiceWithVouchers productPortfolio voucherList)
  ; Main invoice generation logic
  (DisplayVoucherList voucherList)
  (printf "┌───────────────────────────────────────────────────────────┐\n")
  (printf "│                    GENERAR FACTURA                        │\n")
  (printf "├───────────────────────────────────────────────────────────┤\n")
  (printf "│ Entre el número de comprobante de servicio: ")
  (define voucherNumber (read))
  (if (or (< voucherNumber 1) (> voucherNumber (vector-length voucherList)))
      (GenerateInvoiceInvalidNumber productPortfolio voucherList)
  ; else
      (PrintInvoice productPortfolio voucherList (sub1 voucherNumber))
  ); end if: validating voucher number
); end function definition: GenerateInvoiceWithVouchers

(define (GenerateInvoiceInvalidNumber productPortfolio voucherList)
  ; Handles invalid voucher numbers
  (printf "│ Número de comprobante inválido                            │\n")
  (printf "└───────────────────────────────────────────────────────────┘\n")
  (MainMenu productPortfolio voucherList))

(define (PrintInvoice productPortfolio voucherList index)
  ; Generates and displays invoice
  (define currentVoucher (vector-ref voucherList index))
  (define vehiclePlate (voucher-plate currentVoucher))
  (define serviceDate (voucher-date currentVoucher))
  (define clientName (voucher-clientName currentVoucher))
  (define taxId (voucher-nit currentVoucher))
  (define productCodes (voucher-codes currentVoucher))
  (define productQuantities (voucher-quantities currentVoucher))
  
  (DisplayInvoiceHeader vehiclePlate serviceDate clientName taxId)
  
  (define subtotalAmount (CalculateSubtotal productPortfolio productCodes productQuantities 0 0))
  (define taxAmount (* subtotalAmount 0.2))
  (define totalAmount (+ subtotalAmount taxAmount))
  
  (PrintInvoiceItems productPortfolio productCodes productQuantities 0)
  
  (DisplayInvoiceFooter subtotalAmount taxAmount totalAmount)
  
  (MainMenu productPortfolio voucherList))

(define (MainMenu productPortfolio voucherList)
  ; Displays and handles main menu
  (DisplayMainMenu)
  (define userOption (read))
  (if (equal? userOption 0)
      (printf "┌───────────────────────────────────────────────────────────┐\n│ Gracias por usar el aplicativo                            │\n└───────────────────────────────────────────────────────────┘\n")
  ; else
      (ProcessOption userOption productPortfolio voucherList)
  ); end if: checking for exit command
); end function definition: MainMenu

(define (ProcessOption userOption productPortfolio voucherList)
  ; Processes main menu selection
  (if (equal? userOption 1)
      (AddProduct productPortfolio voucherList)
  ; else
      (ProcessOptionAux userOption productPortfolio voucherList)
  ); end if: checking for option 1
); end function definition: ProcessOption

(define (ProcessOptionAux userOption productPortfolio voucherList)
  ; Secondary option processor
  (if (equal? userOption 2)
      (FillServiceVoucher productPortfolio voucherList)
  ; else
      (ProcessOptionAux2 userOption productPortfolio voucherList)
  ); end if: checking for option 2
); end function definition: ProcessOptionAux

(define (ProcessOptionAux2 userOption productPortfolio voucherList)
  ; Tertiary option processor
  (if (equal? userOption 3)
      (AddToExistingVoucher productPortfolio voucherList)
  ; else
      (ProcessOptionAux3 userOption productPortfolio voucherList)
  ); end if: checking for option 3
); end function definition: ProcessOptionAux2

(define (ProcessOptionAux3 userOption productPortfolio voucherList)
  ; Final option processor
  (if (equal? userOption 4)
      (GenerateInvoice productPortfolio voucherList)
  ; else
      (ProcessInvalidOption productPortfolio voucherList)
  ); end if: checking for option 4
); end function definition: ProcessOptionAux3

(define (ProcessInvalidOption productPortfolio voucherList)
  ; Handles invalid menu options
  (printf "│ El número ingresado es incorrecto                         │\n" )
  (printf "└───────────────────────────────────────────────────────────┘\n")
  (MainMenu productPortfolio voucherList))

(define (StartApplication)
  ; Application entry point
  (MainMenu initialPortfolio initialVouchers))

;; Start the application
(StartApplication)

)

(main)