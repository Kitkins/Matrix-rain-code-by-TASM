    .model tiny
    .data
column      db 0        ; Set column to 0
row         db 0        ; Set row to 0 
delayCount dw ?
    .code
    org 0100h           ; for creating .com file
main:
                        ; Set text mode 80x25
    mov ah, 00h         ; Set video mode
    mov al, 03h         ; desired video mode
    int 10h
    
rain:
    mov ah, 02h         ; Set cursor position       
    mov bh, 00h         ; bh for page number(0-7)
    mov dh, row         ; dh for row
    mov dl, column      ; dl for column
    int 10h
    
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
        
    mov ah, 09h
    mov al, dl
    mov bh, 00h
    mov bl, 0Ah
    mov cx, 1
    int 10h
    
    mov delayCount, 50000   ; delay that using to see clearly 
    mov cx, delayCount
delay:
    nop
    dec delayCount
    cmp delayCount, 0
    jne delay
        
    mov ah, 09h         ; to remove backward character
    mov al, ' '
    mov bh, 00h
    mov bl, 04h
    mov cx, 01h
    int 10h
    
    inc row
    
    cmp row, 24
    jg doExit
    jmp rain

doExit:    
    
    ret
    end main
