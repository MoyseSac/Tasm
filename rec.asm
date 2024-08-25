.model small 
.stack 100h 
.data 
buffer db 0
rec db 2 dup('$')
.code 

mosm proc 
    push ax 
    mov ah, 09 
    int 21h 
    pop ax
    ret 
mosm endp 

puerto proc 
mov ah, 00h 
mov al, 11110011b 
mov dx, 00h
int 14h 
ret
puerto endp

recibir_dato proc 
push ax 
mov ah,02h
mov dx, 00h
int 14h 
mov rec,al
pop ax 
ret
recibir_dato endp 

estado_puerto proc
push ax
push dx  
mov ah, 03h 
mov dx, 00h
int 14h 
mov buffer, ah 
pop ax 
pop dx 
ret
estado_puerto endp

delay proc 
push cx 
push dx 
 mov cx, 1830h 
 loop1: 
	mov dx, 0FFFFh
 loop2: 
  	nop 
	dec dx 
	jnz loop2 
	loop loop1
	pop dx 
	pop cx 
ret 
delay endp 

start: 
mov dx, @data 
mov ds, dx 
call puerto 
call recibir_dato
call delay 
lea dx, rec
call mosm 

mov ax, 4c00h 
int 21h 
end start

