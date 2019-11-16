; hello-os
; TAb=4

CYLS	EQU		10
		ORG		0x7c00

; standard FAT12 floppy disk format

		JMP 	entry
		DB 		0x90
		DB 		"TURINGOS"		; name of boot sector(8 bytes)
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
		DB		"TURINGOS   "	; name of the desk(11 bytes)
		DB		"FAT12   "		; name of format(8 bytes)
		RESB	18				; reserve 18 bytes

; body of program

entry:
		MOV		AX,0
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX
; read disk
		MOV		AX,0x0820
		MOV		ES,AX		; set ES to 0x0820
							; address after 0x7e00 is free to use
		MOV		CH,0		; cylinder 0
		MOV		DH,0		; head 0
		MOV		CL,2		; sector 2
readloop:
		MOV		SI,0		; time of failure
retry:
		MOV		AH,0x02		; command of reading
		MOV		AL,1		; number of manipulating sector
		MOV		BX,0		; ES:BX->buffer address
		MOV		DL,0x00		; drive number, Drive A
		INT		0x13		; mass storage (disk, floppy) access
		JNC		next		; The carry flag will be set if there is any
							; error during the read. AH should be set to
							; 0 on success.
		ADD		SI,1
		CMP		SI,5
		; Jump short if above or equal(CF=0)
		JAE		error
		MOV		AH, 0x00	; reset drive
		MOV		DL, 0x00
		INT		0x13
		JMP		retry
next:
		MOV		AX,ES
		ADD		AX,0x0020
		MOV		ES,AX		; add 0x0200 to ES, namely 512 bytes
		ADD		CL,1
		CMP		CL,18
		; Jump short if below or equal (CF=1 or ZF=1)
		JBE		readloop
		MOV		CL,1
		ADD		DH,1
		CMP		DH,2
		JB		readloop
		MOV 	DH,0
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop

; Jump to turing.sys
		MOV		[0x0ff0],CH	; restore the number of cylinders IPL read
		JMP		0xc200
error:
		MOV		SI,msg

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
		HLT
		JMP 	fin

msg:
		DB		0x0a,0x0a	; two new lines
		DB		"LOAD ERROR!"
		DB		0x0a		; new line
		DB		0

		RESB	0x7dfe-$	; write 0x00 till 0x7dfe

		DB		0x55,0xaa
