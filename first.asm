DATA SEGMENT       
      UPPER     DB  'Alpha $Bravo $China $Delta $Echo $Foxtrot $'
                DB  'Golf $Hotel $India $Juliet $Kilo $Lima $'
                DB  'Mary $November $Oscar $Paper $Quebec $'
                DB  'Research $Sierra $Tango $Uniform $Victor $'
                DB  'Whisky $X-ray $Yankee $Zulu $'                                                                                                                                                                                          
      NUMBER    DB  'Zero $First $Second $Third $Fourth $'
                DB  'Fifth $Sixth $Seventh $Eighth $Ninth $'  
      LOWER     DB  'alpha $bravo $china $delta $echo $foxtrot $'
                DB  'golf $hotel $india $juliet $kilo $lima $'
                DB  'mary $november $oscar $paper $quebec $'
                DB  'research $sierra $tango $uniform $victor $'
                DB  'whisky $x-ray $yankee $zulu $' 
      L_OFFSET  DW  0,7,14,21,28,34,43,49,56,63,71,77,83,89,99,106,113,121,131,139,146,155,163,171,178,186  
      N_OFFSET  DW  0,6,13,21,28,36,43,50,59,67 
      STAR      DB  '*$' 
      ENDL      DB  0AH,0DH,'$'
      MYNAME    DB  0AH,0DH,'Name: Du Shangchen','$'
      ID        DB  0AH,0DH,'ID: 1600012782','$'
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

INPUT:
    MOV AH,01H
    INT 21H                 ;input a char from keybroad, store in AL and show it  
    CMP AL,1BH              ;judge if it is an ESC
    JE  EXIT                ;go to exit
    
    PUSH AX
    MOV DX,OFFSET ENDL      ;next line
    MOV AH,09H
    INT 21H 
    MOV AH,0D
    POP AX
    
ISLOWER:    
    CMP AL,97D              ;judge if >= a 
    JL  ISUPPER             ;no,go to judge if it is upper letter
    CMP AL,122D             ;judge if > z
    JG  OTHER               ;no,print *
    
    ;if it is a lower letter
    SUB AL,97D              ;get the place the letter is
    MOV BX,OFFSET L_OFFSET  ;get the letter offset's address
    MOV AH,0D               ;make the %ax[%ah %al] = [0,%al]
    ADD AX,AX
    ADD BX,AX
    MOV AX,[BX]             ;get the offset the exact word begins
    MOV DX,OFFSET LOWER     ;get the lower letter's address 
    ADD DX,AX               ;add the offset up
    JMP PRINT               ;go to print
       
ISUPPER:
    CMP AL,65D              ;judge if >= A 
    JL  ISNUMBER            ;no,go to judge if it is upper letter
    CMP AL,90D              ;judge if > Z
    JG  OTHER               ;no,print *
    
    ;if it is a upper letter
    SUB AL,65D              ;get the place the letter is
    MOV BX,OFFSET L_OFFSET  ;get the letter offset's address
    MOV AH,0D
    ADD AX,AX
    ADD BX,AX               ;make the %ax[%ah %al] = [0,%al]
    MOV AX,[BX]             ;get the offset the exact word begins
    MOV DX,OFFSET UPPER     ;get the upper letter's address 
    ADD DX,AX               ;add the offset up
    JMP PRINT               ;go to print  
    

ISNUMBER:
    CMP AL,48D              ;judge if >= 0 
    JL  OTHER               ;no,go to judge if it is number
    CMP AL,57D              ;judge if < 9
    JG  OTHER               ;no,print *
    
    ;if it is a number
    SUB AL,48D              ;get the place the number is
    MOV BX,OFFSET N_OFFSET  ;get the number offset's address
    MOV AH,0D
    ADD AX,AX
    ADD BX,AX               ;make the %ax[%ah %al] = [0,%al]
    MOV AX,[BX]             ;get the offset the exact word begins
    MOV DX,OFFSET NUMBER    ;get the number's address 
    ADD DX,AX               ;add the offset up  
    JMP PRINT               ;go to print  

OTHER:
    MOV DX,OFFSET STAR


PRINT:
    MOV AH,09H               ;print
    INT 21H
    
    MOV DX,OFFSET ENDL       ;next line
    MOV AH,09H
    INT 21H
    
    
    JMP INPUT                ;jump back to receive another char

EXIT: 
    MOV DX,OFFSET MYNAME     ;print name
    MOV AH,09H
    INT 21H 
    
    MOV DX,OFFSET ID         ;print ID
    MOV AH,09H
    INT 21H   

    MOV AX,4C00H             ;exit
    INT 21H   
    
CODE ENDS
    END BEGIN
