		AREA     RESET, CODE, READONLY
		ENTRY
		LDR 	r3, VALUE2		; r3 contains 0x78563412
		LDR	r2, VALUE3		; r2 contains 0x01000000
		ADD	r4, r3, r2		; r4 contains 0x79563412
		ADD	r5, r4, r2		; r5 contains 0x7a563412
		ADD	r6, r5, r2		; r6 contains 0x7b563412
		LDR 	r1, VALUE1 		; r1 contains 0x10000000
		STR 	r3, [r1]		; store r3 value at [0x10000000]
		STR	r4, [r1, #4] 		; store r3 value at [0x10000004]
		STR 	r5, [r1, #8] 		; store r3 value at [0x10000008]
		STR 	r6, [r1, #12] 		; store r3 value at [0x1000000c]
		ADD	r1, r1, #&10 		; r1 contains 0x10000010
		ADD	r3, r3, #&10		; r3 contains 0x78563422
		STR 	r3, [r1, #4]!		; store r3 value at [0x10000014] and [r1]:=0x10000014
		STR 	r4, [r1, #4]!		; store r3 value at [0x10000018] and [r1]:=0x10000018
		STR 	r5, [r1, #4]!		; store r3 value at [0x1000001c] and [r1]:=0x1000001c
		STR 	r6, [r1, #4]!		; store r3 value at [0x10000020] and [r1]:=0x10000020
		ADD	r1, r1, #8 		; r1 contains 0x10000028
		ADD	r3, r3, #&10		; r3 contains 0x78563432
		STR 	r3, [r1], #4		; store r3 value at [0x10000028] and [r1]:=0x1000002c
		STR 	r4, [r1], #4		; store r3 value at [0x1000002c] and [r1]:=0x10000030
		STR 	r5, [r1], #4		; store r3 value at [0x10000030] and [r1]:=0x10000034
		STR 	r6, [r1], #4		; store r3 value at [0x10000034] and [r1]:=0x10000038
		ADD	r1, r1, #4 		; r1 contains 0x1000003c
		ADD	r3, r3, #&10		; r3 contains 0x78563442
		STMIA	r1!, {r3, r4, r5, r6} ; [r1]:=0x1000004c
		MOV	r3, r2
		MOV	r4, r2
		MOV	r5, r2
		MOV	r6, r2
		LDMDB	r1!, {r3, r4, r5, r6} 	; [r1]:=0x1000003c
		ADD	r1, r1, #&24 		; r1 contains 0x10000060
		ADD	r3, r3, #&10		; r3 contains 0x78563452
		STMFD	r1!, {r3-r6} 		; [r1]:=0x10000050
		MOV	r3, r2
		MOV	r4, r2
		MOV	r5, r2
		MOV	r6, r2
		LDMFD	r1!, {r3-r6} 		; [r1]:=0x10000060
		ADD	r3, r3, #&10
		STMEA	r1, {r6, r5, r4, r3}
		MOV	r3, r2
		MOV	r4, r2
		MOV	r5, r2
		MOV	r6, r2
		LDMEA	r1, {r6, r5, r4, r3}
		ADD	r3, r3, #&10
VALUE1  	DCD 	&10000000
VALUE2		DCD	&78563412
VALUE3		DCD	&01000000	
             END
