TITLE Assignment 3     (Project03.asm)

; Name: Brandon Lee
; Email: leebran@onid.oregonstate.edu
; Class: CS271 Section 400
; Assignment: #3
; Due Date: 4/26/15

; Description: The third homework assignment - data validation, accumulator, I/O procedures, control structures

INCLUDE Irvine32.inc

	LOWER = -100
	UPPER = -1

.data
	userName		BYTE		33 DUP(0)								;String to be entered by user
	intro			BYTE		"TITLE: Assignment 3 - Brandon Lee",0
	namePrompt		BYTE		"What is your name: ",0
	greeting		BYTE		"Hi ",0
	byeMessage		BYTE		"Goodbye ",0
	instruct1		BYTE		"Please enter numbers in [-100, -1]",0
	instruct2		BYTE		"Enter a non-negative number when you are finished to see results.",0
	instruct3		BYTE		" - Enter number: ",0
	printTotal		BYTE		"Your total amount of valid inputs: ",0
	printSum		BYTE		"The sum of your inputs: ",0
	printAvg		BYTE		"The rounded average of your inputs: ",0
	extraCred		BYTE		"**EC: Number lines during user input",0
	sMessage		BYTE		"You did not enter any negative numbers at all!",0
	
	userInput		DWORD		?
	theTotal		DWORD		0
	theSum			DWORD		?
	theAvg			DWORD		?

.code
main PROC
;Intro (Introduction)
	mov		edx, OFFSET intro
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extraCred
	call	WriteString
	call	CrLf

;Get user's name
	mov		edx, OFFSET namePrompt
	call	WriteString
	mov		edx, OFFSET UserName
	mov		ecx, 32
	call	ReadString

;Greet user
	mov		edx, OFFSET greeting
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

;Give user instructions
	mov		edx, OFFSET instruct1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruct2
	call	WriteString
	call	CrLf

;Repeatedly enter numbers and error check
MainLoop:
	;Extra credit - print increments
	mov		eax, theTotal
	call	WriteDec

;Validate for range between [-100,-1] - Loops back if less than or exits if greater than
	mov		edx, OFFSET instruct3
	call	WriteString
	call	ReadInt
	mov		userInput, eax
	cmp		userInput, LOWER
	jl		MainLoop
	cmp		userInput, UPPER
	jg		theEnd

;Passed error checking, log the input

;Increment the total number of inputs
	inc		theTotal
;Add to sum
	mov		eax, theSum
	add		eax, userInput
	mov		theSum,	eax

;Loopback to main loop
	loop	MainLoop

;Code executed after user terminates loop
theEnd:

;Jump to end if no negative inputs at all
	cmp		theTotal, 1
	jl		theBye

;Print total number of inputs
	mov		edx, OFFSET printTotal
	call	WriteString
	mov		eax, theTotal
	call	WriteInt
	call	CrLf

;Print sum
	mov		edx, OFFSET printSum
	call	WriteString
	mov		eax, theSum
	call	WriteInt
	call	CrLf

;Calculate Average
	mov		eax, theSum
	cdq
	mov		ebx, theTotal
	idiv	ebx
	mov		theAvg, eax

;Print Average
	mov		edx, OFFSET printAvg
	call	WriteString
	mov		eax, theAvg
	call	WriteInt
	call	CrLf

theBye:

;If no negative numbers entered..
	cmp		theTotal, 0
	je		SpecialMessage
	jne		Farewell

SpecialMessage:
	mov		edx, OFFSET sMessage
	call	WriteString
	jmp		Farewell

Farewell:
;Say goodbye to user
	call	CrLf
	mov		edx, OFFSET byeMessage
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

; exit to operating system
	exit
main ENDP

; (insert additional procedures here)

END main