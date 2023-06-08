	PRESERVE8
	AREA	Hello_world, CODE, READONLY
		
	IMPORT sendchar
	EXPORT Hello
		
	ENTRY
; this file has been changed	
Hello
	ADR r1, TEXT			; r1 -> ¡°Hello ARM World!¡±
	
LOOP	LDRB r0, [r1], #1		; get a byte and increment address (r1 = r1 +1)
	
; A routine for printing a character on the monitor
; print a character value at register r0

	STR LR, [SP, #-4]!		; keep return address at stack
	STR r1, [SP, #-4]!		; keep register values r1 at stack
	BL sendchar			; call a subroutine of printing a character	
	LDR r1, [SP], #4		; recover pushed register value from stack
	LDR LR, [SP], #4		; recover pushed register value from stack
; the end of a routine printing a character.
	
	CMP r0, #0			; check the end by comparing null	
	BNE	LOOP			;   ¡¦ and repeat for the next char.
	
	MOV PC, LR			; return to main routine

TEXT = "Hello ARM world!",  &0a, &0d, 0  	; sring + CR + LF + null

	END