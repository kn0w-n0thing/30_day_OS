; naskfunc
; TAB=4

[FORMAT "WCOFF"]	; object file mode
[INSTRSET "i486p"]	; use i486 instructions
[BITS 32]			; 32-bit mode
[FILE "naskfunc.nas"]	; source file name

		GLOBAL	_io_hlt


[SECTION .text]

_io_hlt:			; void io_hlt(void)
		HLT
		RET

