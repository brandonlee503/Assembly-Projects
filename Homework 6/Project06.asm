TITLE Assignment 6     (Project06.asm)

; Name: Brandon Lee
; Email: leebran@onid.oregonstate.edu
; Class: CS271 Section 400
; Assignment: #6A
; Due Date: 6/7/15

INCLUDE Irvine32.inc

;----------------------------------------------------------------------------------------
; Macro: getString
; Description: Moves the user's input into a memory location. 
; Parameters: address, length
;----------------------------------------------------------------------------------------
getString	MACRO address, length	
	push	edx
	push	ecx
	mov  	edx, address
	mov  	ecx, length
	call 	ReadString
	pop		ecx
	pop		edx
ENDM

;----------------------------------------------------------------------------------------
; Macro: displayString
; Description: Displays string stored in specified memory location.
; Parameters: theString
;----------------------------------------------------------------------------------------
displayString	MACRO	theString
	push	edx
	mov		edx, OFFSET theString
	call	WriteString
	pop		edx
ENDM

;Constant for number of inputs
	THENUM = 15

.data
	buffer			BYTE	255 DUP(0)
	stringTemp		BYTE	32 DUP(?);

	introMsg0		BYTE	"TITLE: Assignment 6 - Brandon Lee",0
	introMsg1		BYTE	"Please provide 15 unsigned decimal integers.",0
	introMsg2		BYTE	"Each number needs to be small enough to fit inside a 32 bit register.",0
	introMsg3		BYTE	"of the integers, their sum, and their average value.",0
	userPrompt		BYTE	"Enter an unsigned integer: ", 0
	errorMsg		BYTE	"Invalid input, please try again: ",0
	valueMsg		BYTE	"You entered: ",0
	sumMsg			BYTE	"The sum is: ",0
	averageMsg		BYTE	"The average is: ",0
	goodbyeMsg		sBYTE	"Goodbye!", 0

	sum				DWORD	?
	average			DWORD	?

	theArray		DWORD	15 DUP(0)

.code
main PROC

;Print intro
	displayString	introMsg0
	call	CrLf
	displayString	introMsg1
	call	CrLf
	displayString	introMsg2
	call	CrLf
	displayString	introMsg3
	call	CrLf
	call	CrLf

;--------------------------------------------------------------------------------
;Set loop controls
	mov		ecx, THENUM
	mov		edi, OFFSET theArray

userInputLabel:
;Display prompt for user input
	displayString	userPrompt

;Push onto stack, call ReadVal
	push	OFFSET buffer
	push	SIZEOF buffer
	call	ReadVal

;Go to next array spot	
	mov		eax, DWORD PTR buffer
	mov		[edi], eax
	add		edi, 4				;For next DWORD in array

;Loop if not 15 values yet
	loop	userInputLabel

;--------------------------------------------------------------------------------	
;Show the user what they entered into the array

;Set loop variables
	mov		ecx, THENUM
	mov		esi, OFFSET theArray
	mov		ebx, 0					;For calculating sum

;Display message
	displayString	valueMsg
	call			CrLf

;Calculate the sum | Print numbers to console
sumAgainLabel:
	mov		eax, [esi]
	add		ebx, eax	;add eax to the sum

;Push parameters eax and stringTemp | Call WriteVal
	push	eax
	push	OFFSET stringTemp
	call	WriteVal
	call	CrLf
	add		esi, 4		;increment the array looper
	loop	sumAgainLabel

;Display the sum
	mov				eax, ebx
	mov				sum, eax
	displayString	sumMsg

;Push sum and stringTemp paramaters | Call WriteVal
	push	sum
	push	OFFSET stringTemp
	call	WriteVal
	call	CrLf

;--------------------------------------------------------------------------------	
;Calculate the average (sum in eax)

;Clear edx | Move 15 into ebx
	mov		ebx, THENUM
	mov		edx, 0

;Divide the sum by 15
	div		ebx

;Determine if average needs to be rounded up
	mov		ecx, eax
	mov		eax, edx
	mov		edx, 2
	mul		edx
	cmp		eax, ebx
	mov		eax, ecx
	mov		average, eax
	jb		noRoundLabel
	inc		eax
	mov		average, eax

noRoundLabel:
	displayString	averageMsg

;Push parameters average and stringTemp | Call WriteVal
	push	average
	push	OFFSET stringTemp
	call	WriteVal
	call	CrLf
	call	CrLf

;--------------------------------------------------------------------------------	
;Display goodbye message
	displayString	goodbyeMsg
	call	CrLf

	exit		; exit to operating system
main ENDP

;----------------------------------------------------------------------------------------
; Procedure: ReadVal
; Description: Invokes getString macro to get the user's string of digits. Converts
; the digits string to numbers and validates input.
; Parameters: OFFSET buffer, SIZEOF buffer
;----------------------------------------------------------------------------------------

readVal PROC
	push	ebp
	mov		ebp, esp
	pushad

StartLabel:
	mov		edx, [ebp+12]	;@address of buffer
	mov		ecx, [ebp+8]	;size of buffer into ecx

;Read the input
	getString	edx, ecx

;Set registers
	mov		esi, edx
	mov		eax, 0
	mov		ecx, 0
	mov		ebx, 10

;Load the string in byte by byte
LoadByteLabel:
	lodsb					;loads from memory at esi
	cmp		ax, 0			;check if we have reached the end of the string
	je		DoneLabel

;Check the range if char is int in ASCII
	cmp		ax, 48				;0 is ASCII 48
	jb		ErrorLabel
	cmp		ax, 57				;9 is ASCII 57
	ja		ErrorLabel

;Adjust for value of digit
	sub		ax, 48
	xchg	eax, ecx
	mul		ebx				;mult by 10 for correct digit place
	jc		ErrorLabel
	jnc		NoErrorLabel

ErrorLabel:
	displayString	errorMsg
	jmp				StartLabel

NoErrorLabel:
	add		eax, ecx
	xchg	eax, ecx		;Exchange for the next loop through
	jmp		LoadByteLabel	;Parse next byte
	
DoneLabel:
	xchg	ecx, eax
	mov		DWORD PTR buffer, eax	;Save int in passed variable
	popad
	pop ebp
	ret 8
readVal ENDP

;----------------------------------------------------------------------------------------
; Procedure: WriteVal
; Description: Convert numeric value to a string of digits | Invoke displayString to produce output.
; Parameters: integer and string (memory) to write the output
;----------------------------------------------------------------------------------------
writeVal PROC
	push	ebp
	mov		ebp, esp
	pushad		;save registers

;Set for looping through the integer
	mov		eax, [ebp+12]	;move integer to convert to string to eax
	mov		edi, [ebp+8]	;move @address to edi to store string
	mov		ebx, 10
	push	0

ConvertLabel:
	mov		edx, 0
	div		ebx
	add		edx, 48
	push	edx				;push next digit onto stack

;Check if at end
	cmp		eax, 0
	jne		ConvertLabel

;Pop numbers off the stack
PopLabel:
	pop		[edi]
	mov		eax, [edi]
	inc		edi
	cmp		eax, 0				;check if the end
	jne		PopLabel

;Write as string using macro
	mov				edx, [ebp+8]
	displayString	OFFSET stringTemp
	call			CrLf

	popad		;restore registers
	pop ebp
	ret 8
writeVal ENDP

END main