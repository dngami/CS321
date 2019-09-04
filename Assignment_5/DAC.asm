cpu "8085.tbl"
hof "int8"

org 9000h

GTHEX: EQU 030EH
HXDSP: EQU 034FH
OUTPUT:EQU 0389H
CLEAR: EQU 02BEH
RDKBD: EQU 03BAH
KBINT: EQU 3CH

CURDT: EQU 8FF1H
UPDDT: EQU 044cH
CURAD: EQU 8FEFH
UPDAD: EQU 0440H

;Give the i/p frequency at location 8200h

CALL LDIV   ;function to calculate time period for i/p frequency

MVI A,80H   ;Control word for DAC
OUT 03H
MVI A,8BH   ;Control Word for LCI
OUT 43H

;To jump to the required waveform when a given dip switch is high -
;D7 - Square wave
;D6 - Triangular
;D5 - Sawtooth
;D4 - Staircase
;D3 - Symmetrical Staircase
;D2 - Sine
CHECK:
	IN 41H
	MOV B,A
	ANI 01H
	CPI 01H
	JZ Square
	MOV A,B
	ANI 02H
	CPI 02H
	JZ Triangular
	MOV A,B
	ANI 04H
	CPI 04H
	JZ Sawtooth
	MOV A,B
	ANI 08H
	CPI 08H
	JZ Staircase
	MOV A,B
	ANI 10H
	CPI 10H
	JZ SymStair
	MOV A,B
	ANI 20H
	CPI 20H
	JZ Sine
	JMP CHECK

;Generates a square wave
Square:

L11:
	MVI A, 0FFH
	OUT 00H
	OUT 01H
	OUT 40H
	CALL DELAY
	MVI A,00H
	OUT 00H
	OUT 01H
	OUT 40H
	OUT 41H
	CALL DELAY
	JMP L11


Triangular:

CALL LDIV4               ;It decreases the amplitude to attain the req. freq.

XRA A
L21:                     ;Generates positive slope of the Triangular wave
	OUT 00H
	OUT 01H
	OUT 40H
	INR A
	MOV B,A
	LDA 8400H
	CMP B
  MOV A,B
	JNZ L21
L22:                    ;Generates negative slope of the Triangular wave
	OUT 00H
	OUT 01H
	OUT 40H
	DCR A
	JNZ L22
	JMP L21


Sawtooth:

CALL LDIV5             ;It decreases the amplitude to attain the req. freq.

XRA A
L31:
	OUT 00H
	OUT 01H
	OUT 40H
	INR A
	MOV B,A
	LDA 8400H
	CMP B
  MOV A,B
	JNZ L31
	XRA A
	JMP L31


Staircase:

CALL LDIV3          ;Divides the result of LDIV by 3(no. of stairs/2) to find the
                    ;delay for one step
XRA A
L41:
	OUT 00H
	OUT 01H
	OUT 40H
	MOV B,A
	CALL DELAY
	MOV A,B
	ADI 25h           ; Height of single step = resolution*25h
	CPI 0DEH
	JNZ L41
	XRA A
	JMP L41

SymStair:

CALL LDIV2          ;Divides the result of LDIV by 6(no. of stairs o one side) to find the
                    ;delay for one step
XRA A
L51:
	OUT 00H
	OUT 01H
	OUT 40H
	MOV B,A
	CALL DELAY
	MOV A,B
	ADI 25H            ; Height of single step = resolution*25h
	CPI 0DEH
	JNZ L51
L52:
	OUT 00H
	OUT 01H
	OUT 40H
	MOV B,A
	CALL DELAY
	MOV A,B
	MVI B,25H
	SUB B
	JNZ L52
	JMP L51


Sine:                     ;Generates sine wave using hard coded values
                          ;from mem loc 8501 to 8525
	MVI A,00H
	STA 8501H
	MVI A,01H
	STA 8502H
	MVI A,02H
	STA 8503H
	MVI A,04H
	STA 8504H
	MVI A,08H
	STA 8505H
	MVI A,11H
	STA 8506H
	MVI A,17H
	STA 8507H
	MVI A,1EH
	STA 8508H
	MVI A,25H
	STA 8509H
	MVI A,2DH
	STA 850AH
	MVI A,36H
	STA 850BH
	MVI A,40H
	STA 850CH
	MVI A,49H
	STA 850DH
	MVI A,54H
	STA 850EH
	MVI A,5EH
	STA 850FH
	MVI A,69H
	STA 8510H
	MVI A,74H
	STA 8511H
	MVI A,7FH
	STA 8512H
	MVI A,84H
	STA 8513H
	MVI A,95H
	STA 8514H
	MVI A,9FH
	STA 8515H
	MVI A,0AFH
	STA 8516H
	MVI A,0B4H
	STA 8517H
	MVI A,0C0H
	STA 8518H
	MVI A,0C8H
	STA 8519H
	MVI A,0D0H
	STA 851AH
	MVI A,0D8H
	STA 851BH
	MVI A,0E0H
	STA 851CH
	MVI A,0EAH
	STA 851DH
	MVI A,0EDH
	STA 851EH
	MVI A,0EFH
	STA 851FH
	MVI A,0F2H
	STA 8520H
	MVI A,0F9H
	STA 8521H
	MVI A,0FCH
	STA 8522H
	MVI A,0FDH
	STA 8523H
	MVI A,0FFH
	STA 8524H
	MVI A,00H
	STA 8525H

CALL LDIV6           ;Finds delay for each point to get the i/p freq.
                     ;Divides LDIV result by 25h
START:
	MVI C,24H
	LXI H,8501H
POS:                      ;Generates positive slope side of sine wave
	MOV A,M
	OUT 00H
	OUT 01H
	OUT 40H
	INX H
	MOV A,C
	STA 8120H
	SHLD 8100H
	CALL DELAY
	LHLD 8100H
	LDA 8120H
	MOV C,A
	DCR C
	JNZ POS
	MVI C,24H
NEG:                   ;Generates negative slope side of sine wave
	DCX H
	MOV A,M
	OUT 00H
	OUT 01H
	OUT 40H
	MOV A,C
	STA 8120H
	SHLD 8100H
	CALL DELAY
	LHLD 8100H
	LDA 8120H
	MOV C,A
	DCR C
	JNZ NEG
	JMP START

DELAY:
			 MVI C,01H            ; Runs the loop for the value stored at 8400h
LOOP1: LHLD 8400H           ; For value FC0B loop runs for 0.5 sec
	     XCHG
LOOP2: DCX D
			 MOV A,D
			 ORA E
			 JNZ LOOP2
			 DCR C
			 JNZ LOOP1
RET


LDIV:                        ;Divides FC0B by freq
	MVI H,0FCH
	MVI L,0BH
	XCHG
	MVI H, 00H
	LDA 8200H
	MOV L,A
	LXI B,0000H
LP2:
	MOV A, E
	SUB L
	MOV E,A
	MOV A,D
	SBB H
	MOV D,A
	INX B
	JNC LP2
	DCX B
	XCHG
	DAD D   ; bc quotient hl remainder
	MOV A,B
	STA 8401H
	MOV A,C
	STA 8400H
	RET



LDIV2:                          ; Divides value at 8400h by 6
	LHLD 8400H
	XCHG
	MVI H, 00H
	MVI L, 06H
	LXI B,0000H
LOP2:
	MOV A, E
	SUB L
	MOV E,A
	MOV A,D
	SBB H
	MOV D,A
	INX B
	JNC LOP2
	DCX B
	XCHG
	DAD D   ; bc quotient hl remainder
	MOV A,B
	STA 8401H
	MOV A,C
	STA 8400H
	RET


LDIV3:                      ; Divides value at 8400h by 3
	LHLD 8400H
	XCHG
	MVI H, 00H
	MVI L, 03H
	LXI B,0000H
LOPO2:
	MOV A, E
	SUB L
	MOV E,A
	MOV A,D
	SBB H
	MOV D,A
	INX B
	JNC LOPO2
	DCX B
	XCHG
	DAD D   ; bc quotient hl remainder
	MOV A,B
	STA 8401H
	MOV A,C
	STA 8400H
	RET

LDIV4:                                ;  Divides 6897h by freq. to find amplitude for triangular waveform
	MVI L,97H
	MVI H,68H
	XCHG
	MVI H, 00H
	LDA 8200H
	MOV L,A
	LXI B,0000H
P2:
	MOV A, E
	SUB L
	MOV E,A
	MOV A,D
	SBB H
	MOV D,A
	INX B
	JNC P2
	DCX B
	XCHG
	DAD D   ; bc quotient hl remainder
	MOV A,B
	STA 8401H
	MOV A,C
	STA 8400H
	RET

LDIV5:                    ;Divides C43Bh by freq. to find amplitude for Sawtooth waveform
	MVI L,3BH
	MVI H,0C4H
	XCHG
	MVI H, 00H
	LDA 8200H
	MOV L,A
	LXI B,0000H
	P22:
	MOV A, E
	SUB L
	MOV E,A
	MOV A,D
	SBB H
	MOV D,A
	INX B
	JNC P22
	DCX B
	XCHG
	DAD D   ; bc quotient hl remainder
	MOV A,B
	STA 8401H
	MOV A,C
	STA 8400H
	RET

LDIV6:                  ; Divides freq. by 24h
	LHLD 8400H
	XCHG
	MVI H, 00H
	MVI L, 24H
	LXI B,0000H
LOP12:
	MOV A, E
	SUB L
	MOV E,A
	MOV A,D
	SBB H
	MOV D,A
	INX B
	JNC LOP12
	DCX B
	XCHG
	DAD D   ; bc quotient hl remainder
	MOV A,B
	STA 8401H
	MOV A,C
	STA 8400H
	RET
