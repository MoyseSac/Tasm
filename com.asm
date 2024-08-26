.model small 
.stack 100h 
.data 
num_act db 0
num db '1','2','3','4'  
let db 'a','b','c','d' 
buffer db 0
.code 

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

enviar_dato proc 
	push ax 
	push dx 	
    mov ah, 01h
	mov al, num_act
    mov dx, 00h
    int 14h 
	pop dx 
	pop ax 
    ret
enviar_dato endp 

delay proc 
    push cx 
    mov cx, 0FFFFh
delay_loop: 
    dec cx 
    jnz delay_loop
    pop cx 
    ret
delay endp

estado_puerto proc 
	push ax 
	push dx 
	verf_ciclo: 
    mov ah, 03h 
    mov dx, 00h
    int 14h 
    test ah, 00000010b
	jnz verf_ciclo

	pop dx
	pop ax 
 	ret 
estado_puerto endp

mostrar_puerto proc 
    mov ah, 03h 
    mov dx, 00h
    int 14h 
    mov buffer, ah 
mostrar_puerto endp

mandar_string proc 
	push si 
	push ax 
    lea si, let
    mov cx, 4 

ciclo_enviar: 
    mov al , [si]
	mov num_act, al 
	call estado_puerto
    call enviar_dato   
    inc si 
    dec cx 
    jnz ciclo_enviar 
   
	pop ax 
	pop si 
 	ret 
mandar_string endp 

mandar_let proc 
	push si 
	push ax 
    lea si, num 
    mov cx, 4 

ciclo_enviar2: 
    mov al , [si]
	mov num_act, al 
	call estado_puerto
    call enviar_dato   
    inc si 
    dec cx 
    jnz ciclo_enviar2
   
	pop ax 
	pop si 
 	ret 
mandar_let endp 

start: 
    mov dx, @data 
    mov ds, dx 
    call puerto
    call delay
    call mandar_string
    call delay 
    call delay 
    call mandar_let
    mov ax, 4c00h 
    int 21h 
end start
