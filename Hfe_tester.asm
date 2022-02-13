#make_bin#
 
 
#LOAD_SEGMENT=FFFFh#
#LOAD_OFFSET=0000h#
 
#CS=0000h#
#IP=0000h#
 
#DS=0000h#
#ES=0000h#
 
#SS=0000h#
#SP=FFFEh#
 
#AX=0000h#
#BX=0000h#
#CX=0000h#
#DX=0000h#
#SI=0000h#
#DI=0000h#
#BP=0000h#
 
 
		jmp     st1 
        nop
        dw      0000
        dw      0000
        dw      ad_isr
        dw      0000
		 
		db     1012 dup(0)
 
 
 
porta1 equ 00h
portb1 equ 02h
portc1 equ 04h
creg1  equ 06h
porta2 equ 08h
portb2 equ 0Ah
portc2 equ 0Ch
creg2  equ 0Eh
 
measure macro value,jpoi  
    mov bl,value;
    mov al,value;
        out portb2,al;
        mov al , 00001000b;
        out portc2,al;
        mov di,1;
        mov al ,00h;
        out portc2,al;
        or al ,  00000010b;
        out portc2,al
        or al , 00000001b;
        out portc2,al;
        
        nop
        nop
        nop
        nop
        nop 
        nop
        
        and al ,11111110b;
        out portc2,al
        and al , 11111101b;
        out portc2 ,al
        jpoi:        cmp di,0;
            jnz jpoi;
            
 endm		
;main program
st1:		cli
; intialize ds, es,ss to start of RAM
        mov       ax,0200h
        mov       ds,ax
        mov       es,ax
        mov       ss,ax
        mov       sp,0FFFEH 
        mov       si,0000h;
        
        
        
        mov al, 80h
        out creg1,al;
        mov al ,90h
        out creg2,al;
        ;can be made into macro;
off:        in al , portc2;
        and al, 80h;
        jz off

        zero: measure 255,busy1
        lodsw;
        cmp ax,00;
        mov si,00;
        jz zero;

       measure 231,busy2;
        inc si; 
	inc si ;

        measure 205,busy3;          
        inc si;
        inc si;
        measure 179,busy4;
        inc si; 
        inc si;
        measure 154, busy5;
        inc si; 
        inc si;
        measure 128,busy6;
        inc si; 
        inc si;    
        measure 103, busy7;
        inc si; 
        inc si;
        measure 77 ,busy8;
        inc si;
        inc si;
        measure 51 ,busy9;
        inc si;
        inc si;
        measure 26,busy10;
 
        
        mov si , 0000h;
        mov dx, 0000h;
        mov cx, 9;
        
loopi: add dx,[si];
       inc si ;
       inc si;
       loop loopi; 
       cmp dx,200;
       jg noAlarm;
alarm: 
       mov al, 00010000b;
       out portc1,al;
       
       
noAlarm::
        mov di, si;
        
        mov ax,dx;
        
        mov bl, 100;
        div bl;
        mov dl,al;
        mov al,ah;
        mov ah,00h;
        mov bl, 10;
        div bl; 
        
        
        
 
mov dh,al
x2:
    mov al,dh
    out porta1 ,al
    mov al , ah
    out portc1,al;
    mov al,dl
    out portb1,al
    
    
    
     
    loop x2        
        
end_of_asm:
    nop
    jmp end_of_asm        
       
        
 
 
 
 
 
ad_isr:
        push ax
        push dx
        dec di
       mov al , 00000100b;
       out portc2,al;
       in al , porta2;   
       mov ah , 255;
       sub ah,al;
       mov al , ah;
       mov ah ,00
       mov dh,250;
       mul dh;
       ;mov dl ,bl;
       div bl;
       
       
       ;mov dh , ah;
       
       mov dl , 2;
       mul dl
       
       mov [si],ax
       mov al ,00h
       out portc2,al;
       pop dx; 
       pop ax  
       
        iret