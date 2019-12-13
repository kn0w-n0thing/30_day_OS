; haribote-os boot asm
; TAb=4

BOTPAK	EQU		0x00280000		; bootpack load address
DSKCAC	EQU		0x00100000		; disk cache address
DSKCAC0	EQU		0x00008000		; disk cache address(real mode)
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

; Prohibit interrupts

		MOV 	AL,0xff
		OUT 	0x21,AL
		NOP
		OUT		0xa1,AL

		CLI

; Set A20GATE to access memory over 1MB

		CALL	waitkbdout
		MOV		AL,0xd1
		OUT		0x64,AL
		CALL	waitkbdout
		MOV		AL,0xdf
		OUT		0x60,AL
		CALL	waitkbdout

; Enable protect mode

[instrset "i486p"]			; Use 486 command

		LGDT	[GDTR0]			; Set tmporary GDT
		MOV		EAX,CR0
		AND		EAX,0x7fffffff  ; Set bit31 to 0, disable paging
		OR		EAX,0x00000001	; Set bit0 to 1, enable protect mode
		MOV		CR0,EAX
		JMP		pipelineflush
pipelineflush:
		MOV		AX,1*8
		MOV		DS,AX
		MOV		ES,AX
		MOV		FS,AX
		MOV		GS,AX
		MOV		SS,AX

; Transfer bootpack

		MOV		ESI,bootpack	; Source
		MOV		EDI,BOTPAK		; Destiny
		MOV		ECX,512*1024/4
		CALL	memcpy

; Send disk data to the origin address

; Start from boot sector

		MOV		ESI,0x7c00
		MOV		EDI,DSKCAC
		MOV		ECX,512/4
		CALL	memcpy

; all of the rest

		MOV		ESI,DSKCAC0+512	; Source
		MOV		EDI,DSKCAC+512	; Desitny
		MOV		ECX,0
		MOV		CL,BYTE[CYLS]
		IMUL	ECX,512*18*2/4	; Transform number of cylinder to byte/4
		SUB		ECX,512
		CALL	memcpy

; End asmhead
; The following is bootpack

		MOV		EBX,BOTPAK
		MOV		ECX,[EBX+16]
		ADD		ECX,3
		SHR		ECX,4
		JZ		skip
		MOV		ESI,[EBX+20]
		ADD		ESI,EBX
		MOV		EDI,[EBX+12]
		CALL	memcpy
skip:
		MOV		ESP,[EBX+12]
		JMP		DWORD 2*8:0x0000001b

waitkbdout:
		IN		AL,0x64
		AND		AL,0x02
		JNZ		waitkbdout

memcpy:
		MOV		EAX,[ESI]
		ADD 	ESI,4
		MOV		[EDI],EAX
		ADD		EDI,4
		SUB		ECX,1
		JNZ		memcpy
		RET

		ALIGNB	16
GDT0:
		RESB	8
		DW		0xffff,0x0000,0x9200,0x00cf
		DW		0xffff,0x0000,0x9a28,0x0047

		DW		0

GDTR0:
		DW		8*3-1
		DD		GDT0

		ALIGNB	16
bootpack:
