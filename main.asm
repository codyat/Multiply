
;=================================================
; Name: Cody Troyer
;
; I hereby certify that the contents of this file
; are ENTIRELY my own original work.
;
;=================================================
.ORIG x3000          
;====================
;=== Instructions ===
;====================
RESTART                                 ;starting point
LD R6, CONVERT                          ;loads r6 with -48 to convert from ascii to binary

LEA R0, START_MSG                       ;prints the start message
PUTS            

GETC                                    ;gets the sign
OUT              
;////////////////
;error check sign
;////////////////
LD R1, CHECK_NEG                     
ADD R1, R0, R1                          ;checks to make sure sign is '+'
BRp  PRINT_ERROR_MSG     
BRz GOTO_HERE1        

LD R1, CHECK_POS                        ;checks to make sure sign is '-' if not already a '+'
ADD R1, R0, R1        
BRz GOTO_HERE1        

PRINT_ERROR_MSG        
LEA R0, ERROR_MSG                       ;if neither itll print and error message
PUTS            
BRnzp RESTART        

GOTO_HERE1          
;/////////////////      
LD R1, SIGN_CHECK      
ADD R1, R0, R1                          ; checks sign for '+' or '-'
BRn HERE          

ST R1, SIGN1        
LD R1, ONE                              ;if negative, add one to the counter for negative numbers
ST R1, NEG_COUNT                        ;if positive, skip.

HERE            
GETC                                    ;gets the first digit
OUT              
;////////////////
;check if numbers
;////////////////
LD R1, UPPER                            ;check if character is less than "9" or #57 
ADD R1, R0, R1        
BRp PRINT_ERROR_MSG                     ;if not, error

ADD R1, R0, R6                          ;checks if character is greater than "0" or #48
BRn PRINT_ERROR_MSG                     ;if not error.
;////////////////
ADD R1, R0, R6                          ;converts the ascii number to binary

FOR_INPUT1                              ;begin loop for collecting other digits of the number
  GETC                                  ;get next digit
  OUT            
  LD R5, CHECK_NEW_LINE                 ;checks for '\n'
  ADD R5, R5, R0      
  BRz END_FOR_INPUT1                    ;if true end loop
  ST R1, R1_backup
  ;////////////////
  ;check if numbers
  ;////////////////
  LD R1, UPPER                          ;if not '\n' then chack for less than "9" and
  ADD R1, R0, R1                        ;greater than "0" again.
  BRp PRINT_ERROR_MSG    
          
  ADD R1, R0, R6      
  BRn PRINT_ERROR_MSG    
  ;////////////////
  LD R1, R1_backup
  ADD R0, R0, R6                        ;multiply the current number stored in r1 by ten and add r0
  LD R5, TEN        
  ADD R2, R1, #0      
  TIMES10          
    ADD R1, R1, R2    
    ADD R5, R5, #-1    
    BRp TIMES10      
  ADD R1, R1, R0      
  BRnzp FOR_INPUT1    
END_FOR_INPUT1        
      
ST R1, FIRST_NUMBER                     ;stores the first number in "first_number"
;/////////////////////////  
;done getting first number  
;/////////////////////////
LEA R0, START_MSG2                      ;prints next instruction for the user
PUTS            
  
GETC                                    ;gets the sign for the second number from the user
OUT              
;////////////////    
;error check sign
;////////////////
LD R1, CHECK_NEG                        ; check for "+"
ADD R1, R0, R1        
BRp  PRINT_ERROR_MSG     
BRz GOTO_HERE2
    
LD R1, CHECK_POS                        ;if not "+", then chack for "-" 
ADD R1, R0, R1        
BRz GOTO_HERE2                          ;if not that either, then print error

GOTO_HERE2          
;/////////////////

LD R1, SIGN_CHECK      
ADD R1, R0, R1                          ;checks sign for "+" or "-"
BRn HERE2          
  
ST R1, SIGN2                            ;if "-" then add 1 to the negative counter
LD R1, ONE          
LD R4, NEG_COUNT                        ;else skip
ADD R1, R1, R4        
ST R1, NEG_COUNT      

HERE2            
GETC                                    ;get the first digit of the second number
OUT              
;////////////////
;check if numbers
;////////////////
LD R1, UPPER                            ;check if less than "9" and greater than "0"
ADD R1, R0, R1        
BRp PRINT_ERROR_MSG                     ;if not, error

ADD R1, R0, R6        
BRn PRINT_ERROR_MSG      
;////////////////
ADD R1, R0, R6                          ;converts r0 from ascii to binary

FOR_INPUT2                              ;loop to get other digits of number2
  GETC          
  OUT            
  LD R5, CHECK_NEW_LINE                 ;checks for '\n'
  ADD R5, R5, R0      
  BRz END_FOR_INPUT2                    ;if true, exit loop
  st r1, R1_backup
  ;////////////////
  ;check if numbers
  ;////////////////
  LD R1, UPPER                          ;if not '\n' then check if less than "9" and greater than "0"
  ADD R1, R0, R1      
  BRp PRINT_ERROR_MSG    
          
  ADD R1, R0, R6      
  BRn PRINT_ERROR_MSG                   ;if not print error
  ;////////////////
  ld r1, R1_backup
  ADD R0, R0, R6                        ;multiply the current number stored in r1 by ten and add r0
  LD R5, TEN        
  ADD R2, R1, #0      
  TIMES10_2        
    ADD R1, R1, R2    
    ADD R5, R5, #-1    
    BRp TIMES10_2    
  ADD R1, R1, R0      
  BRnzp FOR_INPUT2    
END_FOR_INPUT2        
;//////////////////////////
;done getting second number
;//////////////////////////
ST R1, SECOND_NUMBER                    ;stores second number in "second_number"

LD R1, FIRST_NUMBER                     ;checks which number's magnitude is larger
LD R2, SECOND_NUMBER                    ;for efficient multiplying
NOT R3, R2          
ADD R3, R3, #1        
ADD R3, R1, R3        
BRn SWAPPER          

NEXT            
ld r6, NEG_COUNT
LD R7, MULTIPLY                         ;goes to the multiply function
JSRR R7            
ST R3, PRODUCT                          ;stores the product

LD R1, NEG_COUNT                        ;goes to error check to check for overflow and underflow
LD R7, ERROR_CHECK      
JSRR R7            

LD R1, FIRST_NUMBER                     ;loads values for the final function
LD R2, SECOND_NUMBER    
LD R3, PRODUCT        
LD R4, SIGN1        
LD R5, SIGN2        
LD R6, NEG_COUNT      
LD R7, PRINT        
JSRR R7                                 ;jumps to print

HALT            

SWAPPER            
  ADD R3, R2, #0                        ;swaps first and second number
  ADD R2, R1, #0      
  ADD R1, R3, #0      
  BRnzp NEXT        
;====================    
;======= DATA =======
;====================

ERROR_MSG           .STRINGZ  "Invalid input\n"
CHECK_NEW_LINE      .FILL     #-10
CONVERT             .FILL     #-48
UPPER               .FILL     #-57
TEN                 .FILL     #9
SIGN_CHECK          .FILL     #-44
CHECK_NEG           .FILL     #-45
CHECK_POS           .FILL     #-43
NEG_COUNT           .BLKW     #1
FIRST_NUMBER        .BLKW     #1
SECOND_NUMBER       .BLKW     #1
PRODUCT             .BLKW     #1
SIGN1               .BLKW     #1
SIGN2               .BLKW     #1
R1_backup           .BLKW     #1
ONE                 .FILL     #1
START_MSG           .STRINGZ  "Type in a number in the range of [-32767, +32767] preceeded with its sign. then press enter when done\n"
START_MSG2          .STRINGZ  "Repeat with a different number\n"
MULTIPLY            .FILL     x3200
ERROR_CHECK         .FILL     x3400
PRINT               .FILL     x3600

.END
;///////////////////////////////////////////////////////////////////////
;This function multiplies the two numbers together.
;
;parameters: R1 (number1), R2, (number2)
;
;return value: R3 (product)
;///////////////////////////////////////////////////////////////////////
.ORIG x3200          
ST R7, R7_BACKUP_3200                   ;backs up R7

ADD R1, R1, #0        
BRp SKIP_3200_1                         ;checks if the first number is a zero or not
AND R3, R3, #0        
BRnzp END_3200        
SKIP_3200_1          

ADD R2, R2, #0        
BRp SKIP_3200_2                         ;checks if the second number is a zero or not
AND R3, R3, #0        
BRnzp END_3200        
SKIP_3200_2          

ADD R3, R1, #0                          ;copies first number into r3
ADD R4, R2, #-1                         ;decreases second number(counter for loop)
BRz END_3200
        
MULTIPLY_LOOP        
  ADD R3, R3, R1                        ;multipies by adding first number to itself
  BRn im_done
  ADD R4, R4, #-1                       ;second number times
  BRp MULTIPLY_LOOP    
    
END_3200          
LD R7, R7_BACKUP_3200                   ;reloads the backed up R7
RET  
                                        ;return
            
im_done
  add r1, r6, #0
  ld r7, ERROR_CHECK_
  jsrr r7
  BRnzp  END_3200
  
ERROR_CHECK_        .FILL     x3400
R7_BACKUP_3200      .BLKW     #1
;///////////////////////////////////////////////////////////////////////
;This function checks the number of negatives and the product to see if
;is a possible over or underflow.
;parameters: R1 (the number of negatives), R3 (product)
;
;return value: N/A
;///////////////////////////////////////////////////////////////////////
.ORIG x3400          
ST R7, R7_BACKUP_3400                   ;backs up R7
  
ADD R1, R1, #-1                         ;check if answer should be negative or positive
BRz CHECK_IF_ANSWER_POS    

ADD R3, R3, #0                          ;checks if answer is positive when it should be
BRzp DONE
  LEA R0, OVER_MSG    
  PUTS                                  ;if not, then overflow and quit program
  BRnzp QUIT        

CHECK_IF_ANSWER_POS      
ADD R3, R3, #0                          ;checks if answer if negative when it should be
BRzp DONE          
  LEA R0, UNDER_MSG                     ;if not then underflow and quit program
  PUTS          
  BRnzp QUIT        
  
DONE            
LD R7, R7_BACKUP_3400                   ;reloads R7 from backup
RET                                     ;return

QUIT            
HALT                                    ;quits program

R7_BACKUP_3400      .BLKW     #1
OVER_MSG            .STRINGZ  "Woes! Overflows!"
UNDER_MSG           .STRINGZ  "Woahs! Underflows!"
;///////////////////////////////////////////////////////////////////////
;This function prints the final line.
;
;parameters: R1 (number1), R2 (number2), R3 (product), R4 (sign of number1)
;       R5 (sign of number2), R6 (the number of negatives) 
;
;return value: N/A
;///////////////////////////////////////////////////////////////////////
.ORIG x3600          
ST R7, R7_BACKUP_3600                   ;backs up R7

LD R0, NEW_LINE                         ;prints '\n'
OUT              

ADD R4, R4, #0        
BRz SKIP1                               ;checks if the first number is negative
LD R0, MINUS                            ;if true print a "-"
OUT                                     ;else skip

SKIP1            
ADD R0, R2, #0                          ;moves values around
ADD R2, R1, #0        
  
LD R7, PRINT_HELP                       ;calls the print_helper function
JSRR R7            

ADD R2, R0, #0                          ;moves value back to R2

LD R0,SPACE                             ;print " "
OUT              
LD R0, ASTERISK                         ;print "*"
OUT             
LD R0, SPACE                            ;print " "
OUT              
;......
ADD R5, R5, #0                          ;checks if the second number is negative
BRz SKIP2                               ;if true print "-"
LD R0, MINUS                            ;else skip
OUT              

SKIP2            

LD R7, PRINT_HELP                       ;calls the print_helper function
JSRR R7            

LD R0, SPACE                            ;print " "
OUT              
LD R0, EQUAL                            ;print "="
OUT             
LD R0, SPACE                            ;print " "
OUT              
;......
ADD R6, R6, #-1                         ;checks if answer is negative 
BRnp SKIP3                              ;if true print "-"
LD R0, MINUS                            ;else skip
OUT              
    
SKIP3            
ADD R2, R3, #0                          ;moves value around

LD R7, PRINT_HELP                       ;calls the print_helper function
JSRR R7            

LD R7, R7_BACKUP_3600                   ;reloads R7 from the backup
RET                                     ;return

R7_BACKUP_3600      .BLKW     #1
NEW_LINE            .FILL     #10
ASTERISK            .FILL     #42
PLUS                .FILL     #43
MINUS               .FILL     #45
SPACE               .FILL     #32
EQUAL               .FILL     #61
PRINT_HELP          .FILL     x3800
;///////////////////////////////////////////////////////////////////////
;This function prints a number.
;
;parameters: R2 (number)
;
;return value: N/A
;///////////////////////////////////////////////////////////////////////
.ORIG x3800          
ST R0, R0_BACKUP_3800                   ;backs up all register vaules.
ST R1, R1_BACKUP_3800    
ST R2, R2_BACKUP_3800    
ST R3, R3_BACKUP_3800    
ST R4, R4_BACKUP_3800    
ST R5, R5_BACKUP_3800  
ST R6, R6_BACKUP_3800    
ST R7, R7_BACKUP_3800    
LD R0, FLAG                             ;flag was created to not print leading 0's of a number
AND R0, R0, #0                          ;ex. 5 != "00005"
ST R0, FLAG                             ;resets flag to 0000 0000 0000 0000 every function call

LD R5, CONVERTER                        ;loads a converter
LD R1, COUNTER                          ;loads a counter
LD R3, TEN_THOUSANDS                    ;and laods place value
FOR_3            
  ADD R2, R2, R3                        ;CHECK TEN_THOUSAND
  BRzp HERE3        
  NOT R3, R3                            ;subtracts 10,000 from the number until the number 
  ADD R3, R3, #1                        ;turns negative.
  ADD R2, R2, R3                        ;if successful, add 1 to the counter
  BRzp END_FOR_3                        ;else add 10,000 back to the number and exit loop
  HERE3          
  ADD R1, R1, #1      
  BRnzp FOR_3        
END_FOR_3          
;_________
ADD R1, R1, #0                          ;sets the flag if necessary
BRp CONTINUE1        
ADD R0, R0, #0        
BRz SKIP_1          
;_________  
CONTINUE1          
ADD R0, R0, #1                          ;checks flag
ST R0, FLAG          
ADD  R0, R1, R5                         ;prints counter value
OUT              
SKIP_1            

LD R1, COUNTER                          ;reset counter
LD R0, FLAG          
LD R3, THOUSANDS                        ;loads the place value
FOR_4            
  ADD R2, R2, R3      
  BRzp HERE4        
  NOT R3, R3        
  ADD R3, R3, #1      
  ADD R2, R2, R3                        ;CHECK THOUSAND
  BRzp END_FOR_4                        ;subtracts 1,000 from the number until the value 
  HERE4                                 ;is negative.
  ADD R1, R1, #1                        ;if successful, add 1 to the counter
  BRnzp FOR_4                           ;else add 1,000 back to the value and exit loop
END_FOR_4          
;_________
ADD R1, R1, #0                          ;set flag if necessary
BRp CONTINUE2        
ADD R0, R0, #0        
BRz SKIP_2          
;_________  
CONTINUE2                               ;checks flag
ADD R0, R0, #1        
ST R0, FLAG          
ADD  R0, R1, R5                         ;prints counter
OUT              
SKIP_2            

LD R1, COUNTER                          ;resets counter
LD R0, FLAG          
LD R3, HUNDREDS                         ;loads next place value
FOR_5            
  ADD R2, R2, R3      
  BRzp HERE5        
  NOT R3, R3        
  ADD R3, R3, #1      
  ADD R2, R2, R3                        ;CHECK HUNDRED
  BRzp END_FOR_5                        ;subtracts 100 from the number until it is negative
  HERE5                                 ;if successful, add 1 to the counter
  ADD R1, R1, #1                        ;else add 100 back to the number and exit loop
  BRnzp FOR_5        
END_FOR_5          
;_________          
ADD R1, R1, #0                          ;set flag if necessary
BRp CONTINUE3        
ADD R0, R0, #0        
BRz SKIP_3          
;_________  
CONTINUE3          
ADD R0, R0, #1                          ;checks flag
ST R0, FLAG          
ADD  R0, R1, R5                         ;prints counter
OUT              
SKIP_3            
    
LD R1, COUNTER                          ;reset counter
LD R0, FLAG          
LD R3, TENS                             ;loads next place value
FOR_6            
  ADD R2, R2, R3      
  BRzp HERE6        
  NOT R3, R3        
  ADD R3, R3, #1      
  ADD R2, R2, R3                        ;CHECK TEN
  BRzp END_FOR_6                        ;subtracts 10 from the number until it is negative
  HERE6                                 ;if successful, add 1 to counter
  ADD R1, R1, #1                        ;else add 10 back to the number and exit loop
  BRnzp FOR_6        
END_FOR_6          
;_________  
ADD R1, R1, #0                          ;set flag if necessary
BRp CONTINUE4        
ADD R0, R0, #0        
BRz SKIP_4          
;_________  
CONTINUE4                               ;checks flag
ADD R0, R0, #1        
ST R0, FLAG          
ADD  R0, R1, R5                         ;prints counter
OUT              
SKIP_4            
  
ADD R0, R2, R5                          ;CHECK 1 // prints remaining value
OUT              

LD R0, R0_BACKUP_3800    
LD R1, R1_BACKUP_3800                   ;reloads all backed up values
LD R2, R2_BACKUP_3800    
LD R3, R3_BACKUP_3800    
LD R4, R4_BACKUP_3800    
LD R5, R5_BACKUP_3800    
LD R6, R6_BACKUP_3800    
LD R7, R7_BACKUP_3800     
  
RET                                     ;return

FLAG                .FILL     #0
NEW_LINE_1          .FILL     #10
CONVERTER           .FILL     #48
COUNTER             .FILL     #0
R0_BACKUP_3800      .BLKW     #1
R1_BACKUP_3800      .BLKW     #1
R2_BACKUP_3800      .BLKW     #1
R3_BACKUP_3800      .BLKW     #1
R4_BACKUP_3800      .BLKW     #1
R5_BACKUP_3800      .BLKW     #1
R6_BACKUP_3800      .BLKW     #1
R7_BACKUP_3800      .BLKW     #1
TEN_THOUSANDS       .FILL     #-10000
THOUSANDS           .FILL     #-1000
HUNDREDS            .FILL     #-100
TENS                .FILL     #-10
;///////////////////////////////////////////////////////////////////////
