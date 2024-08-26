.model small 
.stack 100h 
.data 
buffer db 0
recNum db 5 dup('$')
recLet db 5 dup('$')
.code 

mosmen proc 
    push ax 
    mov ah, 09 
    int 21h 
    pop ax
    ret 
mosmen endp 

puerto proc  
push ax 
push dx 
mov ah, 00h 
mov al, 11100011b 
mov dx, 00h
int 14h 
pop dx 
pop ax 
ret
puerto endp

recibir_dato proc 
mov ah,02h
mov dx, 00h
int 14h 
ret
recibir_dato endp 

estado_puerto proc
push ax
push dx  
recb_ciclo: 
	mov ah, 03h 
	mov dx, 00h
	int 14h 
	test ah, 02h
jnz recb_ciclo

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


recibir_string proc 
	push si 
	push cx 
	lea si, recNum
	mov cx,4
	cicloCopiar: 
	call estado_puerto
	call recibir_dato
	mov [si], al 
	inc si
	dec cx 
	jnz cicloCopiar
	pop si 
	pop cx
	ret 
recibir_string endp 


recibir_let proc 
	push si 
	push cx 
	lea si, recLet
	mov cx,4
	cicloPasar: 
	call estado_puerto
	call recibir_dato
	mov [si], al 
	inc si
	dec cx 
	jnz cicloPasar
	pop si 
	pop cx
	ret 
recibir_let endp 


start: 
mov dx, @data 
mov ds, dx 
call puerto 
call delay
call recibir_string
call delay 
call delay 
call recibir_let
lea dx, recLet 
call mosmen
lea dx, recNum
call mosmen
mov ax, 4c00h 
int 21h 
end start
