org 0x7c00
bits 16
%define ENDL 0x0D, 0x0A

jmp short start
nop

bdb_oem:                   db 'MSWIN4.1'  ;8 bytes
bdb_bytes_per_sector:      dw 512
dbd_sectors_per_clusters:  db 1
bdb_reserved_sectors:      dw 1
dbd_fat_count:             db 2
bdb_dir_entries_count:     dw 0E0h
bdb_total_sectors:         dw 2880       ; 2880 * 512 = 1.44mb
bdb_media_descriptor_type: db 0F0h       ; F0 = 3.5" floppy
bdb_sectors_per_fat:       dw 9
bdb_sectors_per_track:     dw 18
bdb_heads:                 dw 2
bdb_hidden_sectors:        dd 0
dbd_large_sector_count:    dd 0

; extended boot record
ebr_drive_number:          db 0
                           db 0
ebr_signature:             db 29h
ebr_volume_id:             db 12h, 34h, 56h, 78h  ; serial number
ebr_volume_label:          db 'novaOS    '   ;padded apces ~11 bytes
ebr_system_id:             db ' FAT12   '   ; also padded with spaces

; more code here

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


lba_to_chs:  ;convert lba to chs addr

    push ax
    push dx
    xor dx, dx
    div word [bdb_sectors_per_track]    ; ax = lba / sectors_per_track
    inc dx
    mov cx, dx

    xor dx, dx
    div word [bdb_heads]

    mov dh, dl 
    mov ch, al
    shl ah, 6
    or cl, ah

    pop ax
    mov dl, al
    pop ax
    ret


disk_read:
    push cx
    call lba_to_chs
    pop ax
    



msg: db 'hello novaOS!', ENDL,  0

times 510-($-$$) db 0  ;msg length
dw 0xAA55

