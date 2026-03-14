org 0x7c00
bits 16
%define ENDL 0x0D, 0x0A

start:
    jmp main

puts:  
    push si
    push ax

.loop:
    lodsb       ;load next char to al
    or al, al   ; verify next char is null
    jz .done
    

    mov ah, 0x0e  ;bios interrupt
    mov bh, 0
    int 0x10
    jmp .loop

.done:
    pop ax
    pop si
    ret


main:           ;data seg

    mov ax, 0
    mov ds, ax
    mov es, ax

    mov ss, ax
    mov sp, 0x7c00

    mov si, msg
    call puts   ;print the msg

    hlt

.halt:
    jmp .halt

msg: db 'hello my OS', ENDL,  0

times 510-($-$$) db 0
dw 0xAA55

