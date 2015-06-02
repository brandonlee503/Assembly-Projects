TITLE Assignment 5     (Project05.asm)

; Name: Brandon Lee
; Email: leebran@onid.oregonstate.edu
; Class: CS271 Section 400
; Assignment: #5
; Due Date: 5/24/15

INCLUDE Irvine32.inc

	min = 10
	max	= 200
	lo = 100
	hi = 999

.data
	introMsg0	BYTE	"TITLE: Assignment 5 - Brandon Lee",0
	introMsg1	BYTE	"This program generates random numbers in the range [100 .. 999],",0
	introMsg2	BYTE	"displays the original list, sorts the list, and calculates the",0
	introMsg3	BYTE	"median value. Finally, it displays the list sorted in descending order.",0
	inputPrompt	BYTE	"How many numbers should be generated? [10 .. 200]: ",0
	invalidMsg	BYTE	"Please enter a valid input.",0
	title1		BYTE	"This is the unsorted list:",0
	title2		BYTE	"This is the sorted list:",0
	title3		BYTE	"This is the median: ",0
	spaces		BYTE	"    ",0

	userInput	DWORD	?
	userArray	DWORD	max		DUP(?)
	arrayCount	DWORD	0

.code
;****************************************************************
; Title: main
; Purpose: Initilize the entire program
; Parameters: Intro message addresses
; Returns: Printed arrays from other procedures
;****************************************************************
main PROC
;-------------------------------Display the intro
	push	OFFSET introMsg0
	push	OFFSET introMsg1
	push	OFFSET introMsg2
	push	OFFSET introMsg3
	call	introduction

;-------------------------------Get the user's data
	push	OFFSET userInput	;pass by reference
	call	getData

;-------------------------------Fill the array with random numbers
	push	OFFSET userArray	;pass by reference
	push	userInput			;pass by value
	call	fillArray

;-------------------------------Display the array
	push	OFFSET userArray	;pass by reference
	push	userInput			;pass by value
	push	OFFSET title1		;pass by reference
	call	displayList

;-------------------------------Sort the array
	push	OFFSET userArray	;pass by reference
	push	userInput			;pass by value
	call	sortList

;-------------------------------Find the median
	push	OFFSET userArray	;pass by reference
	push	userInput			;pass by value
	push	OFFSET title3		;pass by reference
	call	displayMedian

;-------------------------------Display the array
	push	OFFSET userArray	;pass by reference
	push	userInput			;pass by value
	push	OFFSET title2		;pass by reference
	call	displayList

;-------------------------------Exit to operating system
	exit	
main ENDP

;****************************************************************
; Title: introduction
; Purpose: Print out intro
; Parameters: None
; Returns: Printed intro and instructions
;****************************************************************
introduction PROC
;-----------------------------------Print out intro stuff
	pushad
	mov		ebp, esp

	mov		edx, [ebp+48]
	call	WriteString
	call	CrLf

	mov		edx, [ebp+44]
	call	WriteString
	call	CrLf

	mov		edx, [ebp+40]
	call	WriteString
	call	CrLf

	mov		edx, [ebp+36]
	call	WriteString
	call	CrLf
	call	CrLf

	popad
	ret		16
introduction ENDP

;****************************************************************
; title: getData
; Purpose: Obtains user input and validates
; Parameters: prompt and input
; Returns: User's input
;****************************************************************
getData PROC
;-----------------------------------Set up stack
	push	ebp
	mov		ebp, esp
	mov		ebx, [esp+8]

;-----------------------------------Initialize prompt
StartPrompt:
	mov		edx, OFFSET inputPrompt
	call	WriteString
	call	ReadInt
	cmp		eax, min
	jl		InvalidInput
	cmp		eax, max
	jg		InvalidInput
	jmp		ValidInput

;-----------------------------------Handle errors and loop
InvalidInput:
	mov		edx, OFFSET invalidMsg
	call	WriteString
	call	Crlf
	jmp		StartPrompt

;-----------------------------------Accept input and restore stack
ValidInput:
	mov		[ebx] ,eax
	pop		ebp
	ret		4

getData ENDP

;****************************************************************
; title: fillArray
; Purpose: Fills array with random numbers
; Parameters: array address and user input
; Returns: Array with random numbers
;****************************************************************
fillArray PROC
;-----------------------------------Initilize stack and array
	push	ebp
	mov		ebp, esp
	mov		edi, [ebp+12]	;@array in edi
	mov		ecx, [ebp+8]	;value of count in ecx
	call	Randomize		;Random number generation

;-----------------------------------While still spots, generate number
NotDone:
	mov		eax, hi				    ;Generate random number
	sub		eax, lo
	inc		eax
	call	RandomRange
	add		eax, lo

;-----------------------------------Set number, increment, and repeat
	mov		[edi], eax
	add		edi, 4
	loop	NotDone

;-----------------------------------Restore stack
	pop		ebp
	ret		8

fillArray ENDP

;****************************************************************
; title: sortList
; Purpose: Obtains random array and sorts it
; Parameters: array address
; Returns: sorted list
;****************************************************************
sortList PROC
;-----------------------------------Initilize stack
	pushad
	mov		ebp, esp
	mov		ecx, [ebp+36]
	mov		edi, [ebp+40]
	dec 	ecx 			;request-1
	mov		ebx, 0

;-----------------------------------Initilize outer loop
OuterLoop:
	mov		eax, ebx		;i=k
	mov		edx, eax
	inc 	edx 			;j=k+1
	push 	ecx
	mov 	ecx, [ebp+36]	;request

;-----------------------------------Initilize inner loop
InnerLoop:
	mov		esi, [edi+edx*4]
	cmp		esi, [edi+eax*4]
	jle		PassLabel
	mov		eax, edx

;-----------------------------------Skip if not greater
PassLabel:
	inc 	edx
	loop 	InnerLoop

;-----------------------------------If greater we swap
	lea 	esi, [edi+ebx*4]
	push 	esi
	lea 	esi, [edi+eax*4]
	push 	esi
	call 	exchange
	pop 	ecx
	inc 	ebx
	loop 	OuterLoop
	popad
	ret 	8

sortList ENDP

;****************************************************************
; title: exchange
; Purpose: Obtains array indexes and swaps them
; Parameters: array indexes
; Returns: Swapped indexes
;****************************************************************
exchange PROC
;-----------------------------------Swap array values
	pushad
	mov 	ebp, esp
	mov 	eax, [ebp+40] 		;array[k] (low)
	mov 	ecx, [eax]
	mov 	ebx, [ebp+36] 		;array[i] (high)
	mov		edx, [ebx]
	mov		[eax], edx
	mov 	[ebx], ecx
	popad
	ret 	8

exchange ENDP

;****************************************************************
; title: displayMedian
; Purpose: Finds median of the array
; Parameters: array
; Returns: median number
;****************************************************************
displayMedian PROC
;-----------------------------------Initilize stack
	pushad
    mov     ebp, esp
    mov     edi, [ebp+44]

;-----------------------------------Print title
    mov     edx, [ebp+36]
    call    WriteString

;-----------------------------------Find the median
    mov     eax, [ebp+40]
    cdq
    mov     ebx, 2
    div     ebx
    shl     eax, 2
    add     edi, eax
    cmp     edx, 0
    je      EvenNumber

;-----------------------------------Odd array = display middle     
    mov     eax, [edi]
    call    writeDec
    call    CrLf
    call    CrLf
    jmp     Finished

;-----------------------------------Even array = add two middle and divide by 2
EvenNumber:
    mov     eax, [edi]
    add     eax, [edi-4]
    cdq     
    mov     ebx, 2
    div     ebx
    call    WriteDec
    call    CrLf
    call    CrLf

;-----------------------------------Clear stack
Finished:
    popad
    ret 12

displayMedian ENDP

;****************************************************************
; title: displayList
; Purpose: print out the list
; Parameters: title address, array address, and user input
; Returns: Printed array
;****************************************************************
displayList PROC
;-----------------------------------Initilize stack and variables
	push	ebp
	mov		ebp, esp
	mov		esi, [ebp+16]	;@array
	mov		ecx, [ebp+12]	;ecx is loop control
	mov		edx, [ebp+8]	;print title
	mov		ebx, 0
	call	WriteString
	call	CrLf

;-----------------------------------Count for rows, continue looping
Continue:
	inc		ebx
	mov		eax, [esi]
	call	WriteDec
	add		esi, 4
	cmp		ebx, 10
	jne		AddSpaces
	call	CrLf
	mov		ebx, 0
	jmp		EndContinue

;-----------------------------------Insert spaces
AddSpaces:
	mov		edx, OFFSET spaces
	call	WriteString

;-----------------------------------Clear stack, end looping
EndContinue:
	loop	Continue
	call	CrLf
	pop		ebp
	ret		12

displayList ENDP

END main