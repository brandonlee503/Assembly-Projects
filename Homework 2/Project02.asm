TITLE Assignment 2     (Project02.asm)

; Name: Brandon Lee
; Email: leebran@onid.oregonstate.edu
; Class: CS271 Section 400
; Assignment: #2
; Due Date: 4/19/15

; Description: The second homework assignment - string input, loops, previous values, data validation.
; **EC: A poem.

INCLUDE Irvine32.inc

;Constants
	LOWER = 1
	UPPER = 46

.data
	userName		BYTE		33 DUP(0)								;String to be entered by user
	fibInput		DWORD		?										;Fib to be entered by user
	intro			BYTE		"TITLE: Assignment 2 - Brandon Lee",0
	namePrompt		BYTE		"What is your name: ",0
	greeting		BYTE		"Hi ",0
	byeMessage		BYTE		"Goodbye ",0
	space			BYTE		"     ",0
	fibPrompt		BYTE		"How many Fibonacci terms do you wish to display? (1-46):",0
	initFib			DWORD		1										;Initial fib value
	initPrev		DWORD		-1										;Previous value to add for fib

	extraCredit		BYTE		"My INCREDIBLE Extra Credit, a poem for our instructor: ",0
	extraCredit1	BYTE		"Stephen Redfield, Steven Redfield",0
	extraCredit2	BYTE		"He is our instructor!",0
	extraCredit3	BYTE		"Stephen Redfield, Stephen Redfield",0
	extraCredit4	BYTE		"He is the conductor!",0
	extraCredit5	BYTE		"Stephen lives in Salem and commutes to Corvallis for work.",0
	extraCredit6	BYTE		"He gives us these assignments that make us struggle and jerk..",0
	extraCredit7	BYTE		"His background includes a BS and Masters,",0
	extraCredit8	BYTE		"He is on his Ph.D. which hopefully won’t end up in disaster..",0
	extraCredit9	BYTE		"Steven chose Computer Engineering because he likes software and circuits,",0
	extraCredit10	BYTE		"His specialties are hybrid, jack of all trades, all-purpose!",0
	extraCredit11	BYTE		"He made a scanner in high school using an old typewriter,",0
	extraCredit12	BYTE		"Photo-sensitive resistors, LED/BASIC microprocessor kit, what a fighter!",0
	extraCredit13	BYTE		"Stephen has a daughter, dog, and cat,",0
	extraCredit14	BYTE		"Two, eight, and eight years old.",0
	extraCredit15	BYTE		"He is currently building a backyard shed,",0
	extraCredit16	BYTE		"Wow so bold!",0
			

.code
main PROC
;Intro (Introduction)
	mov		edx, OFFSET intro
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
	
;Prompt user for # of Fibonacci terms (1-46) - (userInstructions)
check1:	
	mov		edx, OFFSET fibPrompt
	call	WriteString
	call	ReadInt							 ; (getUserData)
	mov		fibInput, eax

;Validate user input
	cmp		fibInput, LOWER
	jl		check1
	cmp		fibInput, UPPER
	jg		check1
	mov		ecx, fibInput
	add		ecx, 1

;Calculate Fibonacci numbers (displayFibs)
Label1:

;Set initialized variables and print to screen
	mov		eax, initFib
	add		eax, initPrev
	cmp		eax,0
	je		Zerofix
	call	WriteDec

Zerofix:
	mov		initFib, eax
	sub		eax, initPrev
	mov		initPrev, eax

;Check if new line needed or spaces
	mov		edx, 0
	mov		eax, ecx
	mov		ebx, 5
	div		ebx
	cmp		edx, 0
	je		NewLine
	jne		Spaces

NewLine:
	cmp		ecx, fibInput
	je		Spaces
	call	CrLf
	jmp		Label2

Spaces:
	mov		edx, OFFSET space
	call	WriteString
	jmp		Label2

Label2:
	loop	Label1

;Say goodbye to user (farewell)
	call	CrLf
	call	CrLf
	mov		edx, OFFSET byeMessage
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	call	CrLf

;-------------------------
;Extra Credit
	call	CrLf
	call	CrLf
	mov		edx, OFFSET extraCredit
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, OFFSET extraCredit1
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extraCredit2
	call	WriteString
	call	CrLf

	mov		edx, OFFSET extraCredit3
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extraCredit4
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, OFFSET extraCredit5
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extraCredit6
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, OFFSET extraCredit7
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extraCredit8
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, OFFSET extraCredit9
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extraCredit10
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, OFFSET extraCredit11
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extraCredit12
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, OFFSET extraCredit13
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extraCredit14
	call	WriteString
	call	CrLf
	
	mov		edx, OFFSET extraCredit15
	call	WriteString
	call	CrLf
	mov		edx, OFFSET extraCredit16
	call	WriteString
	call	CrLf
	call	CrLf

;-------------------------

; exit to operating system
	exit
main ENDP

END main