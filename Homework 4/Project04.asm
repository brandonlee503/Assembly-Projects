TITLE Assignment 4     (Project04.asm)

; Name: Brandon Lee
; Email: leebran@onid.oregonstate.edu
; Class: CS271 Section 400
; Assignment: #4
; Due Date: 4/10/15

; Description: The fourth homework assignment - procedures, loops, nested loops, data validation

INCLUDE Irvine32.inc

	LOWER = 1
	UPPER = 400

.data
	introMsg		BYTE		"TITLE: Assignment 4 - Brandon Lee",0
	byeMsg			BYTE		"Goodbye",0
	instruct0		BYTE		"Enter the number of composite numbers you would like to see.",0
	instruct1		BYTE		"Please enter numbers in [1 .. 400]: ",0
	errMsg			BYTE		"Your input is not valid",0
	spaces			BYTE		"   ",0

	userInput		DWORD		?
	compositeNum	DWORD		?
	lineCounter		DWORD		0

.code
main PROC
	call	intro
	call	getUserData
	call	showComposites
	call	farewell

; exit to operating system
	exit
main ENDP

;----- Display Intro messages -----
intro PROC
	mov		edx, OFFSET introMsg
	call	WriteString
	call	CrLf
	mov		edx, OFFSET instruct0
	call	WriteString
	call	CrLf
	ret
intro ENDP

;----- Gets the user's input -----
getUserData PROC

;Prompt user to input data
	mov		edx, OFFSET instruct1
	call	WriteString
	call	ReadInt

;Move input into global and call validate procedure
	mov		userInput, eax
	call	validate
	call	CrLf
	ret
getUserData ENDP

;----- Validates the user's input givent by the getUserInfo procedure -----
validate PROC

;Validate if input is within bounds of 1 and 400, if not move to error handling
	cmp		userInput, LOWER
	jl		ErrorLabel
	cmp		userInput, UPPER
	jg		ErrorLabel
	ret

ErrorLabel:

;If data is not valid, display error message and jump back to input prompt procedure
	mov		edx, OFFSET errMsg
	call	WriteString
	call	CrLf
	jmp		getUserData
validate ENDP

;----- Displays a composite number for n (userinput) number of times.  Uses calls isComposite to get the next composite number -----
showComposites PROC

;Move user input to loop counter register.
;Initilize eax as 4 (lowest composite number) and ebx as 2 (lowest divider for composite numbers).
	mov		ecx, userInput
	mov		eax, 4
	mov		compositeNum, eax
	mov		ebx, 2

;Initilize outerloop to the userInput counter
OuterLoop:

;Call isComposite procedure to find the next composite number
	call	isComposite

;Once composite number is found, print it out to user, and increment the number
	mov		eax, compositeNum
	call	WriteDec
	inc		compositeNum

;Count the number of integers for each line
	inc		lineCounter
	mov		eax, lineCounter
	mov		ebx, 10
	cdq
	div		ebx

;Check if there are 10 in a line, if so, jump and add new line, if not, jump and add spaces
	cmp		edx, 0
	je		NewLine
	jne		AddSpaces

NewLine:
	call	CrLf
	jmp		ResumeLoop

AddSpaces:
	mov		edx, OFFSET spaces
	call	WriteString

;Loop the outer loop again!
ResumeLoop:
	mov		ebx, 2
	mov		eax, compositeNum
	loop	OuterLoop

;Done with looping
	ret
showComposites ENDP

;----- Finds the next composite number and returns it to showComposite procedure -----
isComposite PROC

;Initilize inner loop
InnerLoop:

;Check if the number still can possibably be composite
	cmp		ebx, eax

;If not, jump to incrementing the number of restarting
	je		NoCompositeAtAll
	
;Check if number is composite by dividing and comparing modulus to 0 
	cdq
	div		ebx
	cmp		edx, 0
	je		YesComposite
	jne		NoComposite

;If number composite, we're done with inner loop!
YesComposite:
	ret

;If number not composite with divisor, increment divisor, reset number, and restart inner loop 
NoComposite:
	mov		eax, compositeNum
	inc		ebx
	jmp		InnerLoop

;If number is just not composite, increment the composite number, reset divisor, and restart inner loop
NoCompositeAtAll:
	inc		compositeNum
	mov		eax, compositeNum
	mov		ebx, 2
	jmp		InnerLoop
isComposite ENDP

;----- Display goodbye message -----
farewell PROC

	mov		edx, OFFSET byeMsg
	call	CrLf
	call	CrLf
	call	WriteString
	call	CrLf
	ret
farewell ENDP

END main