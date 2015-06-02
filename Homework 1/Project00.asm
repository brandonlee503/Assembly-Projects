TITLE Assignment 1     (Project01.asm)

; Name: Brandon Lee
; Email: leebran@onid.oregonstate.edu
; Class: CS271 Section 400
; Assignment: #1
; Due Date: 4/12/15

; Description: The first homework assignment - basic arithmetic

INCLUDE Irvine32.inc

.data
number1		DWORD	?	;Int #1 to be entered by user
number2		DWORD	?	;Int #2 to be entered by user
intro		BYTE	"Assignment 1 by Brandon Lee",0
intro2		BYTE	"For extra credit, I have validated second number to be less than first.",0
instruct	BYTE	"This program takes in two numbers calculuates the sum, difference, product, and quotient!",0
prompt1		BYTE	"Please enter your first number: ",0
prompt2		BYTE	"Please enter your second number (must be less than first input): ",0
sum			DWORD	?	;Sum of number1 and number2
difference	DWORD	?	;Difference of number1 and number2
product		DWORD	?	;Product of number1 and number2
quotient	DWORD	?	;Quotient of number1 and number2
remainder	DWORD	?	;Remainder
results		BYTE	"The results in the are as follows: ",0
result1		BYTE	"Sum: ",0
result2		BYTE	"Difference: ",0
result3		BYTE	"Product: ",0
result4		BYTE	"Quotient: ",0
result5		BYTE	" with remainder: ",0
goodbye		BYTE	"Ok we are done, goodbye!",0

.code
main PROC

;Introduce programmer
	mov		edx, OFFSET	intro
	call	WriteString
	call	CrLf
	mov		edx, OFFSET intro2
	call	WriteString
	call	Crlf

;Display instructions
	mov		edx, OFFSET instruct
	call	WriteString
	call	CrLf

L1:

;Get user input for 2 numbers
	mov		edx, OFFSET prompt1
	call	WriteString
	call	ReadInt
	mov		number1, eax
	call	CrLf
	mov		edx, OFFSET prompt2
	call	WriteString
	call	ReadInt
	mov		number2, eax
	call	CrLf

;Extra credit - Check user input 1 vs input 2
	cmp		eax, number1
	jg		L1			;Jump if number2 is greater than number 1

;Calculate sum/difference/product/quotient/remainder of the numbers
	mov		edx, OFFSET results
	call	WriteString
	call	CrLf

;Sum
	mov		eax, number1
	mov		ebx, number2
	add		eax, ebx
	mov		sum, eax

;Sum print
	mov		edx, OFFSET result1	
	call	WriteString
	mov		edx, OFFSET sum
	call	WriteInt
	call	CrLf

;Difference
	mov		eax, number1
	mov		ebx, number2
	sub		eax, ebx
	mov		difference, eax

;Difference print
	mov		edx, OFFSET	result2
	call	WriteString
	mov		edx, OFFSET difference
	call	WriteInt
	call	CrLf

;Product
	mov		eax, number1 
	mov		ebx, number2
	mul		ebx
	mov		product, eax

;Product print
	mov		edx, OFFSET result3
	call	WriteString
	mov		edx, OFFSET product
	call	WriteInt
	call	CrLf

;Quotient
	mov		eax, number1
	mov		ebx, number2
	mov		edx, 0
	div		ebx
	mov		quotient, eax
	mov		remainder, edx
	
;Print quotient
	mov		edx, OFFSET result4
	call	WriteString
	mov		edx, OFFSET quotient
	call	WriteInt

;And remainder
	mov		edx, OFFSET result5
	call	WriteString
	mov		edx, OFFSET remainder
	call	WriteInt
	call	CrLf

;Print goodbye
	mov		edx, OFFSET goodbye
	call	WriteString
	call	CrLf

; exit to operating system
	exit

main ENDP

END main