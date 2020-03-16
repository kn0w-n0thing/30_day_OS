; naskfunc
; TAB=4

[FORMAT "WCOFF"]	; object file mode
[INSTRSET "i486p"]	; use i486 instructions
[BITS 32]			; 32-bit mode
[FILE "naskfunc.nas"]	; source file name

		GLOBAL	_io_hlt,_write_mem8


[SECTION .text]

_io_hlt:			; void io_hlt(void)
		HLT
		RET

_write_mem8:		; void write_mem8(int addr, int data);
		MOV		ECX,[ESP+4]	; addr
		MOV		AL,[ESP+8]	; data
		MOV		[ECX],AL
		RET
