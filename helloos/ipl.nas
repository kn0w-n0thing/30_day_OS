; hello-os
; TAb=4

	ORG		0x7c00

; standard FAT12 floppy disk format

	JMP 	entry
	DB 		0x90
	DB 		"HELLOIPL"		; name of boot sector(8 bytes)
	DW 		512				; size of a sector(must be 512 bytes)
	DB		1				; size of a cluster(must 1 sector)
	DW		1				; initial sector of FAT
	DB		2				; number of FAT(must be 2)
	DW		224				; size of root directory
	DW		2880			; size of this drive(must be 2880 sectors)
	DB		0xf0			; type of media
	DW		9				; length of FAT
	DW		18				; 18 secotors in one track(must be 18)
	DW		2				; number of header(must be 2)
	DD		0				; no partion
	DD		2880			; size of this drive, once again
	DB		0, 0, 0x29		; don't know why
	DD		0xffffffff		; maybe volume serial
	DB		"HELLO-os   "	; name of the desk
	DB		"FAT12   "		; name of format
	RESB	18				; reserve 18 bytes

; body of program

entry:
		MOV		AX,0
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX
		MOV		ES,AX
		MOV 	SI,msg

; print msg to the terminal
putloop:
		MOV		AL,[SI]
		ADD		SI,1
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e
		MOV 	BX,15		; set color to red
		INT		0x10		; call vedio bios
		JMP		putloop

fin:
		HLT					; halt cpu and wait for instruction
		JMP		fin

msg:
		DB		0x0a,0x0a	; two new lines
		DB		"Hello, world"
		DB		0x0a		; new line
		DB		0

		RESB	0x7dfe-$	; write 0x00 till 0x7dfe

		DB		0x55,0xaa
