AREA Convolution, CODE, READONLY

	EXPORT Convolution

	; Define constants
	ROWS        EQU 1920
	COLS        EQU 1080
	ZCOL        EQU 1922
	FILTER_ADDR EQU 0x40900000 //double
	ZERO_ADDR	EQU 0x43000000 //uint8
	CON_ADDR	EQU 0x44000000 //int8 
		

Convolution
	PUSH    {LR}                ; Save return address

	LDR     R0, =ZERO_ADDR     ; zero array address
	LDR     R1, =CON_ADDR     ; con array address
	LDR     R2, =FILTER_ADDR    ; filter array address

	MOV     R3, #0              ; i initialize
LoopRows
	CMP     R3, ROWS            ; i < ROWS 
	BEQ     DoneRows            ; i >= ROWS end

	MOV     R4, #0              ; j initialize
LoopCols
	CMP     R4, COLS            ; j < COLS cmp
	BEQ     NextRow             ; j >= COLS end

	MOV     R11, #0              ; con[i][j] initialize
	MOV     R12, #0 
	MOV     R5, R3              ; x = i copy
LoopX
	CMP     R5, R3 + 2          ; x < i + 3 
	BEQ     NextX               ; x >= i + 3 go to next x

	MOV     R6, R4              ; y = j copy
LoopY
	CMP     R6, R4 + 2          ; y < j + 3 cmp
	BEQ     NextY               ; y >= j + 3 go to next y
	
	LDMIA   R2!, {R8, R7}       ; filter[x][y] double load without auto-indexing
	LDMIA   R0!, {R10, R9}      ; zero[i + x][j + y] double load
	
	VMULL.S8 Q0, D0, D2         ; zero[i + x][j + y] * filter[x][y] ??
	VADD.I16 Q1, Q1, Q0         ; con[i][j] += zero[i + x][j + y] * filter[x][y]

	ADD     R6, R6, #1          ; y ++
	B       LoopY

NextY
	ADD     R5, R5, #1          ; x ++
	B       LoopX

NextX
	STMIA 	R1!, {R11, R12} ; con[i][j] save
	
	ADD     R4, R4, #1          ; j ++
	B       LoopCols

NextRow
	ADD     R3, R3, #1          ; i ++
	B       LoopRows

DoneRows
	POP     {PC}                ; Restore return address

	END
