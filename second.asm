DATA SEGMENT  
      SUCCESS   DB  'Got it!Location:$'
      FAIL      DB  'Sorry!',0AH,0DH,'$'
      ENDL      DB  0AH,0DH,'$'
      STRING    DB  200 DUP('$')
      MYNAME    DB  'Name: Du Shangchen',0AH,0DH,'$'
      ID        DB  'ID: 1600012782$'
DATA ENDS     
STACK SEGMENT STACK
    STA DB 200 DUP('$')
    TOP EQU LENGTH STA
STACK ENDS

CODE SEGMENT
    ASSUME CS:CODE,DS:DATA,SS:STACK
    BEGIN: 
    MOV AX,DATA
    MOV DS,AX
    MOV AX,STACK
    MOV SS,AX
    
INPUTSTRING: 
    LEA DX,STRING
    MOV AH,0AH
    INT 21H                 ;input to a buffer

    MOV DX,OFFSET ENDL      ;next line
    MOV AH,09H
    INT 21H      
      
INPUT:
    MOV AH,01H
    INT 21H                 ;input a char from keybroad
                            ;store in AL and show it  
    PUSH AX                 ;protect AX
    MOV DX,OFFSET ENDL      ;next line
    MOV AH,09H
    INT 21H
    POP AX                  ;restore AX
    
    CMP AL,1BH              ;judge if it is an ESC
    JE  EXIT                ;go to exit
    
    MOV CH,DS:[STRING+1]    ;get lendth in CH
    MOV CL,0D               ;make CL a counter    
    
LOOPP:    
    LEA BX,STRING+2         ;BX get string's address
    PUSH CX                 ;protect CX 
    MOV CH,0D               ;make CX[CH:CL] = [0,CL]
    ADD BX,CX               ;add CX[CL] to BX to get the address of CL-th char in the string
    POP CX                  ;restore CX
    
    MOV DH,[BX]             ;get the CL-th char 
    CMP DH,AL               ;compare
    JE  SUCC                ;if the same, go to success
                             
    CMP CL,CH               ;else judge if the string is done comparing
    JG  FAILING             ;if so, go to failing
    INC CL                  ;else CL <- CL+1
    JMP LOOPP               ;go to next compare
    
FAILING:
    MOV DX,OFFSET FAIL
    MOV AH,09H              ;print fail sentence
    INT 21H
    JMP INPUT

SUCC:    
    MOV DX,OFFSET SUCCESS
    MOV AH,09H              ;print success sentence
    INT 21H
    
    INC CL                  ;increase CL to get position
    
    PUSH DX                 ;protect DX,AX,CX
    PUSH AX
    PUSH CX
    XOR DX,DX               ;DX = 0
    MOV DH,100D             ;DX[DH:DL] = [100D,0] prepare divisor
    MOV CH,0D               ;CH = 0
    MOV AX,CX               ;prepare for divide
    DIV DH                  ;AX/DH=AL...AH
                            ;AL=quotient AH=remainder
    CMP AL,0                ;if AL quotient is 0
    JE  SHIWEI              ;it is not a 3-digit number
                            ;go to judge if it is a 2-digit number 
    MOV DL,AL               ;if 3, DL = quotient and print
    ADD DL,48D
    MOV AH,02H
    INT 21H
SHIWEI:
    MOV DH,10D              ;prepare divisor
    MOV AL,AH               ;make AX[AH:AL]->AX[0,(AH)]
    MOV AH,0D
    DIV DH                  ;AX/DH=AL...AH
    MOV CL,AH               ;CL = AH remainder
    CMP AL,0                ;if AL = 0 it is not 2-digit
    JE  GEWEI               ;go to print the last digit
    MOV DL,AL               ;print the second digit 
    ADD DL,48D
    MOV AH,02H
    INT 21H    
GEWEI:                      ;print the last digit in CL
    MOV DL,CL
    ADD DL,48D
    MOV AH,02H
    INT 21H     
    
    POP CX                  ;restore CX,AX,DX
    POP AX
    POP DX
    
    
NEXTLINE:
    PUSH AX                 ;proetct AX
    MOV DX,OFFSET ENDL      ;next line
    MOV AH,09H
    INT 21H
    POP AX                  ;restore AX
    JMP INPUT               ;jump back to receive another char

EXIT: 
    
    MOV DX,OFFSET MYNAME    ;print name
    MOV AH,09H
    INT 21H 
    
    MOV DX,OFFSET ID        ;print ID
    MOV AH,09H
    INT 21H   

    MOV AX,4C00H            ;exit
    INT 21H   
    
CODE ENDS
    END BEGIN
