YKEnterMutex:
    cli
    ret

YKExitMutex:
    sti
    ret

pushAllTheCrap:
    push bp
    mov bp, sp
    push    ax        ;push everything
    push     bx
    push     cx
    push    dx                          
    push    si
    push    di
    push    ds
    push     es
    jmp return

popAllTheCrap:
    push bp
    mov bp, sp
    pop        es        ;pop everything
    pop     ds   
    pop     di
    pop        si                          
    pop        dx
    pop        cx
    pop        bx
    pop     ax
    jmp return

return:
    mov sp, bp
    pop bp
	sti
    ret

YKDispatcher:
	cli
    push bp
    mov bp, sp
    push ax
    mov ax, word [bp+4]
    cmp ax, [currTask]
    pop ax
    je    return

    inc word [YKCtxSwCount]
    cmp word [YKCtxSwCount], 1
    je restore_context
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push ds
    push es
    mov si, [bp+6]
	mov [si], sp

restore_context:
    mov sp, word [bp+4]
    pushf
    pop ax
    mov [bp+6], ax
    mov [bp+4], cs
    mov    [currTask], sp
    pop es
    pop ds
    pop di
    pop si
    pop dx
    pop cx
    pop bx
	pop ax
    pop bp
	sti
    iret

isrReset:
	push    ax		;push everything
	push 	bx
	push 	cx
	push	dx                           
    push	bp
	push	si
	push	di
	push	ds
	push 	es
	sti		;enable interrupts
	call isrHandle_reset				;run the handler
	cli				;disable interrupts
	mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
	out	0x20, al	; Write EOI to PIC (port 0x20)
	pop    	es		;pop everything
	pop 	ds	
	pop 	di
	pop		si                           
    pop		bp
	pop		dx
	pop		cx
	pop		bx
	pop 	ax
	iret
isrTick:
	push    ax		;push everything
	push 	bx
	push 	cx
	push	dx                           
    push	bp
	push	si
	push	di
	push	ds
	push 	es
	call YKEnterISR
	sti		;enable interrupts
	call YKTickHandler			;run the handler
	cli				;disable interrupts
	mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
	out	0x20, al	; Write EOI to PIC (port 0x20)
	call YKExitISR
	pop    	es		;pop everything
	pop 	ds	
	pop 	di
	pop		si                           
    pop		bp
	pop		dx
	pop		cx
	pop		bx
	pop 	ax
	iret
isrKeyPress:
	push    ax		;push everything
	push 	bx
	push 	cx
	push	dx                           
    push	bp
	push	si
	push	di
	push	ds
	push 	es
	call YKEnterISR
	sti		;enable interrupts
	call isrHandle_keyPress			;run the handler
	cli				;disable interrupts
	mov	al, 0x20	; Load nonspecific EOI value (0x20) into register al
	out	0x20, al	; Write EOI to PIC (port 0x20)
	call YKExitISR
	pop    	es		;pop everything
	pop 	ds	
	pop 	di
	pop		si                           
    pop		bp
	pop		dx
	pop		cx
	pop		bx
	pop 	ax
	iret

