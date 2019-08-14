A 12 hour clock :
(After 12 clock shows 00)

-------------------------------------------------------------------------------
step to run:
1. Open command prompt as administrator.
2. Change directory to the folder containing asm file.
3. run command "c16 -h output.hex -l list.lst file_name.asm".
4. Run xt85.exe.
5. Keep dip switch 1 on always.
6. Switch on 4th dip switch and press reset on board.
7. Press ctrl+d and enter file name test.hex
8. Press enter till download is complete.
9: Once download is completed switch 4th dip to left.
-------------------------------------------------------------------------------

On board:
1: Press Go.
2: enter 9000 and then Execute. (9000 is the origin)
3: CLOC is displayed press any key except RESET.
4: Enter the time from where user want to start the clock.
5: Press Execute.

DELAY Function:
        101480.6666*3 ~= 304442 T states
        1 T state take 1/3 micro second.
        so 304442 T states will take 304442/3 micro second i.e 1.014 seconds 
        
-------------------------------------------------------------------------------
Other Functions used:

GTHEX: Gets hexadecimal digits and displays them.
HXDSP: Expands hexadecimal digits for display
CLEAR: Clears the display
RDKBD: Reads from keyboard.

CURDT: Data of display
UPDDT: Updates Data field of the display
CURAD: Address of display
UPDAD: Updates Address field of the display

-------------------------------------------------------------------------------

A 24 hour Clock with added alarm feature 
*********************************************** 
How to use: 

On the execution of program on the 8085 microprocessor, address display intialize with “CLOC” written over them. Then by pressing ‘exec’ key it prompt user to input a time which he/she wants to set as alarm time.  Once alarm has been set clock starts with initial time as 00:00:00 (hh:mm). Hours and min will be displayed on Address display whereas seconds will be displayed on data display. 

When the clock time match earlier set alarm time, seconds will stop changing for a minute and during that time data display will show ‘00’.  After that minute, seconds will start ticking again on display. 
