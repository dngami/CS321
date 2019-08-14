cpu "8085.tbl"
hof "int8"

org 9000h

GTHEX: EQU 030EH				;Gets hex digits and displays them
HXDSP: EQU 034FH				;Expands hex digits for display
OUTPUT:EQU 0389H				;Outputs characters to display
CLEAR: EQU 02BEH				;Clears the display
RDKBD: EQU 03BAH				;Reads keyboard


CURDT: EQU 8FF1H
UPDDT: EQU 044cH
CURAD: EQU 8FEFH
UPDAD: EQU 0440H

MVI A,00H 						;next 14 instructions used to display
MVI B,00H 						;"ClOC" on display showing start of clock

LXI H,8840H
MVI M,0CH

LXI H,8841H
MVI M,11H

LXI H,8842H
MVI M,00H

LXI H,8843H
MVI M,0CH

LXI H,8840H
CALL OUTPUT
CALL RDKBD
CALL CLEAR 						;clear the display

;This Clock works from 00:00:00 to 12:00:00 and starts from the
;given input time
MVI A,00H
MVI B,00H
CALL GTHEX					;take input time(start time of clock) from keyboard
MOV H,D 						;store in H-L register
MOV L,E

;When one minute is completed value of CURAD changes and is stored
;at HRS label
HRS:
	 SHLD CURAD
	 MVI A,00H

;When one second is completed value of CURDT changes and is stored
;at MIN label
MIN:
	STA CURDT
	CALL UPDAD
	CALL UPDDT
	 CALL DELAY                     ;add delay of one second
	 LDA CURDT
	 ADI 01H                        ;increase second by one
	 DAA                            ;adjust to BCD
	 CPI 60H
	 JNZ MIN                        ;if seconds != 60 jump to MIN

	 LHLD CURAD
	 MOV A,L
	 ADI 01H                        ;add one to minute after seconds reached 60
	 DAA
	 MOV L,A
	 CPI 60H
	 JNZ HRS                        ;if minutes != 60 jump to HRS

	 MVI L, 00H
	 MOV A,H
	 ADI 01H
	 DAA
	 MOV H,A
	 CPI 12H
	 JNZ HRS                         ;if hours < 12 then go to HRS
	 LXI H, 0000H                    ;else start from zero
	 JMP HRS

;This label takes approx. 1 second to completed
;Used to add 1 second delay
DELAY: MVI C,02H
	L1: MVI D, 0FCH
	   	MVI E, 0BH
	L2: DCX D
		  MOV A,D
	  	  ORA E
	  	  JNZ L2
	  	  DCR C
	  	  JNZ L1
RET
RST 5
