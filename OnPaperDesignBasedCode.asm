;road map for desired design
.model tiny
.data
porta1 equ 00h
portb1 equ 02h
portc1 equ 04h
creg1  equ 06h
porta2 equ 08h
portb2 equ 0Ah
portc2 equ 0Ch
creg2  equ 0Eh
temp db ? ;value from ADC temp stored
hun db ? 
ten db ?
one db ?
.code

inactive_state macro 

mov al,01h ;CONVST
out creg2,al
mov al,03h ;CS
out creg2,al
mov al,05h ;RD
out creg2,al
mov al,07h ;CS
out creg2,al
mov al,09h ;CE
out creg2,al
endm

reset_disp macro
mov al,01h
out creg1,al
mov al,03h
out creg1,al
mov al,05h
out creg1,al
endm

start_DAC macro
;give CE and CS as active low to DAC
mov al,06h
out creg2,al
mov al,08h
out creg2,al
endm

start_read_ADC macro jumppoint
;give CONVST as active low to ADC and then wait for busy to become low, then give CS and RD as LOW and read data
mov al,00h
out creg2,al
;waiting for busy to be low
jumppoint: in al,portc1 ;time is 20ns hence polling
and al,20h
jnz jumppoint
; making convst high again for ADC to remain in mode1
mov al,01h
out creg2,al
;now send CS as low
mov al,02h
out creg2,al
;now send RD as low
mov al,04h
out creg2,al

in al,porta2

mov ah,255 ;getting voltage difference
sub ah,al
mov al,ah
endm

calculate macro value,jppoint
start_DAC
mov al,value
out portb2,al

start_read_ADC jppoint

mov temp,al

inactive_state

mov al,temp
mov bh,250
mul bh
mov bl,value
div bl

mov bh,ah
mov bl,2
mul bl

mov dx,ax
mov al,bh
mov ah,00
mov bl,2
mul bl

mov bl,value
div bl
mov ah,00
add dx, ax
endm

.startup
    
    mov al,82h ;initializing 1st 8255
    ;A --> 7447 op
    ;B --> Empty (input by default) 
    ;CL --> control 7 Segment Display op
    ;CL of 1st 0--> 7(1)
    ;CL of 1st 1--> 7(2)
    ;CL of 1st 2--> 7(3)
    ;CU --> switch and adc busy response ip
    ;CU of 1st 4--> switch
    ;CU of 1st 5--> adc busy
    out creg1,al
    
    mov al,90h;initializing 2nd 8255
    ;A --> ADC ip
    ;B --> DAC op
    ;CL and CU --> Control ADC and DAC op
    ;CL(active low) of 2nd 0 --> ADC CONVST
    ;CL(active low) of 2nd 1 --> ADC CS
    ;CL(active low) of 2nd 2 --> ADC RD
    ;CL(active low) of 2nd 3 --> DAC CE
    ;CU(active low) of 2nd 4--> DAC CS
    ;CU 5--> Alarm 
    out creg2,al

switch: in al,portc1
    and al,00010000b
    jz switch

    reset_disp

    inactive_state
    ;1-->26
    ;2-->51
    ;3-->77
    ;4-->103
    ;5-->128
    ;6-->154
    ;7-->179
    ;8-->205
    ;9-->231
    ;10-->255
    ;2nd 8255 CU 0,1,2-->ADC
    ;                3-->DAC
    mov cx,00
zero: start_DAC ;checking if Transistor is placed.
    mov al,255
    out portb2,al

    start_read_ADC busy1
    mov temp,al

    inactive_state

    cmp temp,255 ;input 0 hence difference is 255 if transistor is not placed
    je zero

    calculate 255,busy11
    add cx,dx
    calculate 231,busy2
    add cx,dx
    calculate 205,busy3
    add cx,dx
    calculate 179,busy4
    add cx,dx
    calculate 154,busy5
    add cx,dx
    calculate 128,busy6
    add cx,dx
    calculate 103,busy7
    add cx,dx
    calculate 77,busy8
    add cx,dx
    calculate 51,busy9
    add cx,dx
    calculate 26,busy10
    add cx,dx

    inactive_state
    
    mov bl,100
    mov ax,cx
    div bl
    mov hun,al
    mov bl,10
    mov al,ah
    mov ah,00
    div bl
    mov ten,al
    mov one,ah

    cmp cx,200
    jg disp

    mov al,09h
    out creg1,al
    mov bx,0ffffh

d:  mov cx,0ffffh

disp: mov ah,00
    mov al,hun
    out porta1,al
    mov al,00h
    out creg1,al
    mov al,03h
    out creg1,al
    mov al,05h
    out creg1,al

    mov ah,00
    mov al,ten
    out porta1,al

    mov al,01h
    out creg1,al
    mov al,02h
    out creg1,al
    mov al,05h
    out creg1,al

    mov ah,00
    mov al,one
    out porta1,al

    mov al,01h
    out creg1,al
    mov al,03h
    out creg1,al
    mov al,04h
    out creg1,al
    loop disp
    dec bx
    jnz d

    reset_disp

    mov al,08h
    out creg1,al

.exit
end
