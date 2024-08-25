.model small 
.stack 100h 
.data 
msg db 'C'
num db 1,2,3,4
let db 'a','b','c','d' 
buffer db 0
.code 

puerto proc 
mov ah, 00h 
mov al, 11110011b 
mov dx, 00h
int 14h 
ret
puerto endp

enviar_dato proc 
push ax 
push dx 
mov ah,01h
mov al, msg
mov dx, 00h
int 14h 
pop dx
pop ax 
ret
enviar_dato endp 

estado_puerto proc 
	mov buffer, al 
	mov ah, 03h 
	mov dx, 00h
	int 14h 
	ret 
estado_puerto endp

delay proc 
	push cx 
	push dx
 	mov cx, 0FFFFh
 loop1: 
	mov dx, 0FFFFh
 loop2: 
  	nop 
	dec dx 
	jnz loop2 
	dec cx
	jnz loop1
	pop dx 
	pop cx
	ret 
delay endp 



start: 
mov dx, @data 
mov ds, dx 
call puerto
call delay
call enviar_dato
call delay
call estado_puerto
mov ax, 4c00h 
int 21h 
end start