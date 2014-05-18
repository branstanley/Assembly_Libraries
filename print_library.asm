;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Name:                 Brandon Stanley
; Student Number:       0495470
; Date Created:         Jan. 24, 2014
; Last Modified:        Jan. 28, 2014
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Purpose:
;	General purpose Assembly 32 bit print library.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Notes:
;	- This library is written for use with the Linux Operating System, and will not work on Windows or Mac.
;
;	- Code is compiled using NASM.
;
;	- When using print_hex or print_decimal the number to be printed must be loaded into the
;	  EAX register before calling either print function.
;
;	- print_new_line and print_space don't change the current value in the registers, and
;	  so are safe to call without pushing your data to the stack (or saving it to memory.)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .data
	char:	dd 0x30
	char_len: equ $-char
	space:	dd " "
	new_line: dd 0xA


section .text
	global	print_hex
	global	print_decimal
	global	print_new_line
	global	print_space


print_hex:
	pop	ebx
	push	"$"
	push	0
hex_loop:
	mov	edx, 0
	mov	ecx, 0x10
	idiv	ecx
	cmp	edx, 0x09
	jle	num
	jmp	alpha
num:
	add	edx, 0x30
	jmp	hex_continue
alpha:
	add	edx, 0x37
hex_continue:
	pop	ecx
	inc	ecx
	push	edx
	push	ebx
	cmp	ecx, 9
	je	printer
	pop	ebx
	push	ecx
	mov	ecx, 0x10
	jmp	hex_loop


print_decimal:
	pop	ebx
	push	"$"
div_looping:
	;convert numbers to ascii
	;and store them in the stack
	mov     edx, 0
	mov     ecx, 10
	idiv    ecx
	add     edx, 0x30
	push	edx
	cmp     eax, 0
	jne     div_looping
	push	ebx
	jmp	printer


finished:
	push	ebx
	ret

printer:
	pop	ebx ;grab return address
	mov     eax, 4 ;stdout
	mov     edx, char_len ;size of string to print
print_loop:
	pop	ecx  
	cmp	ecx, '$'
	je	finished
	mov	[char], ecx
	mov	ecx, char
	push	ebx  ;put return address back on the stack
	mov	ebx, 1 ; select monitor for printing
	int	0x80 ; call kernel
	pop	ebx ; grab return address off the stack
	jmp	print_loop



print_new_line:
	push    ecx
	mov	ecx, new_line
	jmp	print_continue
print_space:
	push    ecx
	mov     ecx, space
	jmp	print_continue
print_continue:
	push    eax
	push    ebx

	mov     eax, 4
	mov     ebx, 1
	mov     edx, char_len
	int     0x80

	pop     eax
	pop     ebx
	pop     ecx
	ret

