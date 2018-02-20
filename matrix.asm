    .model tiny
    .data
column  db 80 dup(?)  
row     db 25 dup(0)
delayCount  dw ?
    .code
    org 0100h
main:
    
                        ; Set text mode 80x25
    mov ah, 00h         ; Set video mode
    mov al, 03h         ; desired video mode
    int 10h
   
    ;mov ax, 1003h       ; enable intensive colors
    ;mov bl, 0
    ;mov bh, 0
    ;int 10h
    
setColumnValue:
    mov row[bx], 0
    call randColumn
rain:
    call setCursor
    call randChar
    call printChar
    call delayF
    call clearChar
    cmp row[bx], 24
    jg setColumnValue
    jle rain
    
randColumn:

    push ax             ; Random Clr with Ticks of the Day
    mov ah, 00h
    int 1Ah
    shr dl, 2           ; Try to slow down
    pop ax
    
    mov ax, dx
    xor dx, dx
    mov cx, 80
    div cx             ; here dx contains the remainder of the division - from 0 to 9
    add dl, 0          ; to ascii from '0' to '9'
    mov column[bx], dl
    add column[bx], 4
    ret    

randChar:
    push ax             ; Random Clr with Ticks of the Day
    mov ah, 00h
    int 1Ah
    shr dl, 2           ; Try to slow down
    pop ax
    
    mov ax, dx
    xor dx, dx
    mov cx, 94
    div cx             ; here dx contains the remainder of the division - from 0 to 9
    add dl, '!'        ; to ascii from '0' to '9'
    ret 
    
setCursor:
    mov ah, 02h         ; Set cursor position       
    mov bh, 00h         ; bh for page number(0-7)
    mov dh, row[bx]     ; dh for row
    mov dl, column[bx]  ; dl for column
    int 10h
    
    inc row[bx]
    
    ret

printChar:
    mov ah, 09h
    mov al, dl
    mov bh, 00h
    mov bl, 0Ah
    mov cx, 01h
    int 10h
    ret

clearChar:  
    mov ah, 09h         ; to remove backward character
    mov al, ' '
    mov bh, 00h
    mov bl, 04h
    mov cx, 01h
    int 10h
    ret
    
delayF:
    mov delayCount, 50000   ; delay that using to see clearly 
    mov cx, delayCount
delay:
    nop
    dec delayCount
    cmp delayCount, 0
    jne delay
    ret    

    
doExit:
    
    end main
