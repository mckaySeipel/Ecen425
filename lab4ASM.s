
YKEnterMutex:
	cli
	ret

YKExitMutex:
	sti
	ret

YKEnterISR:
	call pushAllTheCrap
	inc word [interrupt_depth]
	sti
	ret

YKExitISR:
	cli
	call	signalEOI
	call popAllTheCrap
	dec word [interrupt_depth]
	cmp word [interrupt_depth], 0
	jne	label1
	call YKScheduler
	
label1:
	iret

pushAllTheCrap:
	push bp
	mov bp, sp
	push    ax		;push everything
	push 	bx
	push 	cx
	push	dx                           
	push	si
	push	di
	push	ds
	push 	es
	jmp return

popAllTheCrap:
	push bp
	mov bp, sp
	pop    	es		;pop everything
	pop 	ds	
	pop 	di
	pop		si                           
	pop		dx
	pop		cx
	pop		bx
	pop 	ax
	jmp return

return:
	mov sp, bp
	pop bp
	ret

YKDispatcher:
	push bp
	mov bp, sp
	push ax
	mov ax, word [bp+4]
	cmp ax, [currTask]
	pop ax
	je	return

	inc word [YKCtxSwCount]
	cmp word [YKCtxSwCount], 1
	je restore_context
	pushf
	push cs
	mov ax, word[bp+2] ;push the return address
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push ds
	push es
	mov [bp+6], sp

restore_context:
	mov sp, word [bp+4]
	mov	[currTask], sp
	pop es
	pop ds
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop bp
	iret

		
NoOp:
	nop
	ret	

isrReset:
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
	iret



