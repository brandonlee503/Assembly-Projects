TITLE Program Template     (template.asm)

; Author:
; Course / Project ID                 Date:
; Description:

INCLUDE Irvine32.inc

.data
main PROC
   push 3
   push 8
   call rcrsn
   exit
main ENDP

rcrsn PROC
   push ebp
   mov ebp,esp
   mov eax,[ebp + 12]
   mov ebx,[ebp+8]
   cmp eax,ebx
   jl recurse
   jmp quit

recurse:
   inc eax
   push eax
   push ebx
   call rcrsn
   mov eax,[ebp + 12]
   call WriteDec

quit:
   pop ebp
   ret 8
rcrsn ENDP

END main
