;this will be what handles the interrupt routines
	CPU	8086
	align	2

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
	sti		;enable interrupts
	call isrHandle_tick				;run the handler
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
	sti		;enable interrupts
	call isrHandle_keyPress			;run the handler
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

