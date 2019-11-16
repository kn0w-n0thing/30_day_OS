; hello-os
; TAb=4

; BOOT_INFO
CYLS	EQU		0x0ff0
LEDS	EQU		0x0ff1
VMODE	EQU		0x0ff2			; 8 bit-color, 256 colors
SCRNX	EQU		0x0ff4			; pixels of x axis
SCRNY	EQU		0x0ff6			; pixels of y axis
VRAM	EQU		0x0ff8			; start of graphic buffer

		ORG		0xc200

		MOV 	AL,0x13
		MOV		AH,0x00
		INT		0x10
		MOV		BYTE [VMODE],8
		MOV		WORD [SCRNX],320
		MOV		WORD [SCRNY],200
		MOV		DWORD [VRAM],0x000a0000
		
; Get leds status on the keyboard

		MOV		AH,0x02
		INT		0x16
		MOV		[LEDS],AL

fin:
		HLT
		JMP 	fin
