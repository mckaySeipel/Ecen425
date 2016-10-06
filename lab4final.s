        CPU     8086
        ORG     0h
InterruptVectorTable:
        ; Internal x86 Interrupts:
        dd      0 ; Reserved (Div err)  ; Int 00h
        dd      0 ; Reserved (Step)     ; Int 01h
        dd      0 ; Reserved (NMI)      ; Int 02h
        dd      0 ; Reserved (Break)    ; Int 03h
        dd      0 ; Reserved (Overflow) ; Int 04h
        dd      0                       ; Int 05h
        dd      0                       ; Int 06h
        dd      0                       ; Int 07h
        ; Hardware Interrupts:
        dd      isrReset ; Reset        ; Int 08h (IRQ 0)
        dd      isrTick ; Tick          ; Int 09h (IRQ 1)
        dd      isrKeyPress ; Keyboard            ; Int 0Ah (IRQ 2)
        dd      0 ; Simptris Game Over  ; Int 0Bh (IRQ 3)
        dd      0 ; Simptris New Piece  ; Int 0Ch (IRQ 4)
        dd      0 ; Simptris Received   ; Int 0Dh (IRQ 5)
        dd      0 ; Simptris Touchdown  ; Int 0Eh (IRQ 6)
        dd      0 ; Simptris Clear      ; Int 0Fh (IRQ 7)
        ; Software Interrupts:
        dd      0 ; Reserved (PC BIOS)  ; Int 10h
        dd      0                       ; Int 11h
        dd      0                       ; Int 12h
        dd      0                       ; Int 13h
        dd      0                       ; Int 14h
        dd      0                       ; Int 15h
        dd      0                       ; Int 16h
        dd      0                       ; Int 17h
        dd      0                       ; Int 18h
        dd      0                       ; Int 19h
        dd      0                       ; Int 1Ah
        dd      0                       ; Int 1Bh
        dd      0                       ; Int 1Ch
        dd      0                       ; Int 1Dh
        dd      0                       ; Int 1Eh
        dd      0                       ; Int 1Fh
        dd      0                       ; Int 20h
        dd      0 ; Reserved (DOS)      ; Int 21h
        dd      0 ; Simptris Services   ; Int 22h
        dd      0                       ; Int 23h
        dd      0                       ; Int 24h
        dd      0                       ; Int 25h
        dd      0                       ; Int 26h
        dd      0                       ; Int 27h
        dd      0                       ; Int 28h
        dd      0                       ; Int 29h
        dd      0                       ; Int 2Ah
        dd      0                       ; Int 2Bh
        dd      0                       ; Int 2Ch
        dd      0                       ; Int 2Dh
        dd      0                       ; Int 2Eh
        dd      0                       ; Int 2Fh
KeyBuffer:                              ; Address 0xC0
        dw      0
NewPieceType:                           ; Address 0xC2
        dw      0
NewPieceID:                             ; Address 0xC4
        dw      0
NewPieceOrientation:                    ; Address 0xC6
        dw      0
NewPieceColumn:                         ; Address 0xC8
        dw      0
TouchdownID:                            ; Address 0xCA
	dw	0
ScreenBitMap0:                          ; Address 0xCC
        dw      0
ScreenBitMap1:
        dw      0
ScreenBitMap2:
        dw      0
ScreenBitMap3:
        dw      0
ScreenBitMap4:
        dw      0
ScreenBitMap5:
        dw      0
TIMES   100h-($-$$) db  0               ; Fill up to (but not including) address 100h with 0
	jmp	main
; This file contains support routines for 32-bit on the 8086.
; It is intended for use code generated by the C86 compiler.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SR_asldiv:			; l1 /= l2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of l1	(was push3)
	push	word [bp+8]	; Push hi l2		(was push1)
	push	word [bp+6]	; Push lo l2		(was push2)
	push	word [bx+2]	; Push hi l1
	push	word [bx]	; Push lo l1
	call	SR_ldiv
	mov	bx,[bp+4]	; Restore l1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_aslmod:			; l1 %= l2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of l1	(was push3)
	push	word [bp+8]	; Push hi l2		(was push1)
	push	word [bp+6]	; Push lo l2		(was push2)
	push	word [bx+2]	; Push hi l1
	push	word [bx]	; Push lo l1
	call	SR_lmod
	mov	bx,[bp+4]	; Restore l1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_aslmul:			; l1 *= l2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of l1	(was push3)
	push	word [bp+8]	; Push hi l2		(was push1)
	push	word [bp+6]	; Push lo l2		(was push2)
	push	word [bx+2]	; Push hi l1
	push	word [bx]	; Push lo l1
	call	SR_lmul
	add	sp,8
	mov	bx,[bp+4]	; Restore l1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_aslshl:			; l1 <<= l2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of l1	(was push3)
	push	word [bp+8]	; Push hi l2		(was push1)
	push	word [bp+6]	; Push lo l2		(was push2)
	push	word [bx+2]	; Push hi l1
	push	word [bx]	; Push lo l1
	call	SR_lshl
	add	sp,8
	mov	bx,[bp+4]	; Restore l1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_aslshr:			; l1 >>= l2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of l1	(was push3)
	push	word [bp+8]	; Push hi l2		(was push1)
	push	word [bp+6]	; Push lo l2		(was push2)
	push	word [bx+2]	; Push hi l1
	push	word [bx]	; Push lo l1
	call	SR_lshr
	add	sp,8
	mov	bx,[bp+4]	; Restore l1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret


SR_asuldiv:			; u1 /= u2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of u1	(was push3)
	push	word [bp+8]	; Push hi u2		(was push1)
	push	word [bp+6]	; Push lo u2		(was push2)
	push	word [bx+2]	; Push hi u1
	push	word [bx]	; Push lo u1
	call	SR_uldiv
	mov	bx,[bp+4]	; Restore u1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_asilmod:			; u1 %= u2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of u1	(was push3)
	push	word [bp+8]	; Push hi u2		(was push1)
	push	word [bp+6]	; Push lo u2		(was push2)
	push	word [bx+2]	; Push hi u1
	push	word [bx]	; Push lo u1
	call	SR_ilmod
	mov	bx,[bp+4]	; Restore u1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_asulmul:			; u1 *= u2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of u1	(was push3)
	push	word [bp+8]	; Push hi u2		(was push1)
	push	word [bp+6]	; Push lo u2		(was push2)
	push	word [bx+2]	; Push hi u1
	push	word [bx]	; Push lo u1
	call	SR_ulmul
	add	sp,8
	mov	bx,[bp+4]	; Restore u1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_asulshl:			; u1 << u2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of u1	(was push3)
	push	word [bp+8]	; Push hi u2		(was push1)
	push	word [bp+6]	; Push lo u2		(was push2)
	push	word [bx+2]	; Push hi u1
	push	word [bx]	; Push lo u1
	call	SR_ulshl
	add	sp,8
	mov	bx,[bp+4]	; Restore u1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret
SR_asulshr:			; u1 >> u2
	push	bp
	mov	bp,sp
	push	bx
	mov	bx,[bp+4]	; Get address of u1	(was push3)
	push	word [bp+8]	; Push hi u2		(was push1)
	push	word [bp+6]	; Push lo u2		(was push2)
	push	word [bx+2]	; Push hi u1
	push	word [bx]	; Push lo u1
	call	SR_ulshr
	add	sp,8
	mov	bx,[bp+4]	; Restore u1 address
	mov	[bx+2],dx	; Store result
	mov	[bx],ax
	pop	bx
	pop	bp
	ret


; Main 32-bit routines begin here:

SR_ldiv:	; N_LDIV@
	pop    cx
	push   cs
	push   cx
	; LDIV@
	xor    cx,cx
	jmp    LSR_01
SR_uldiv:	; N_LUDIV@
	pop    cx
	push   cs
	push   cx
	; F_LUDIV@
	mov    cx,0001
	jmp    LSR_01
SR_lmod:	; N_LMOD@
	pop    cx
	push   cs
	push   cx
	; F_LMOD@
	mov    cx,0002
	jmp    LSR_01
SR_ilmod:	; N_LUMOD@
	pop    cx
	push   cs
	push   cx
	; LUMOD@
	mov    cx,0003
LSR_01:
	push   bp
	push   si
	push   di
	mov    bp,sp
	mov    di,cx
	mov    ax,[bp+0Ah]
	mov    dx,[bp+0Ch]
	mov    bx,[bp+0Eh]
	mov    cx,[bp+10h]
	or     cx,cx
	jne    LSR_02
	or     dx,dx
	je     LSR_10
	or     bx,bx
	je     LSR_10
LSR_02:
	test   di,0001
	jne    LSR_04
	or     dx,dx
	jns    LSR_03
	neg    dx
	neg    ax
	sbb    dx,0000
	or     di,000Ch
LSR_03:
	or     cx,cx
	jns    LSR_04
	neg    cx
	neg    bx
	sbb    cx,0000
	xor    di,0004
LSR_04:
	mov    bp,cx
	mov    cx,0020h
	push   di
	xor    di,di
	xor    si,si
LSR_05:
	shl    ax,1
	rcl    dx,1
	rcl    si,1
	rcl    di,1
	cmp    di,bp
	jb     LSR_07
	ja     LSR_06
	cmp    si,bx
	jb     LSR_07
LSR_06:
	sub    si,bx
	sbb    di,bp
	inc    ax
LSR_07:
	loop   LSR_05
	pop    bx
	test   bx,0002
	je     LSR_08
	mov    ax,si
	mov    dx,di
	shr    bx,1
LSR_08:
	test   bx,0004h
	je     LSR_09
	neg    dx
	neg    ax
	sbb    dx,0000
LSR_09:
	pop    di
	pop    si
	pop    bp
	retf   0008
LSR_10:
	div    bx
	test   di,0002
	je     LSR_11
	xchg   dx,ax
LSR_11:
	xor    dx,dx
	jmp    LSR_09
SR_lshl:	; N_LXLSH@
SR_ulshl:
	; r = a << b
	pop    bx
	push   cs
	push   bx

	push   bp
	mov    bp,sp

	push   cx	; C86 doesn't expect use of cx or bx

	mov    ax, [bp+6]	; pop loword(a)
	mov    dx, [bp+8]	; pop hiword(a)
	mov    cx, [bp+10]	; pop word(b)
	
	; LXLSH@
	cmp    cl,10h
	jnb    LSR_12
	mov    bx,ax
	shl    ax,cl
	shl    dx,cl
	neg    cl
	add    cl,10h
	shr    bx,cl
	or     dx,bx
	pop    cx
	pop    bp
	retf
LSR_12:
	sub    cl,10h
	xchg   dx,ax
	xor    ax,ax
	shl    dx,cl
	pop    cx
	pop    bp
	retf
SR_lshr:	; N_LXRSH@
	; r = a >> b
	pop    bx
	push   cs
	push   bx

	push   bp
	mov    bp,sp

	push   cx	; C86 doesn't expect use of cx or bx

        mov    ax, [bp+6]	; pop loword(a)
	mov    dx, [bp+8]	; pop hiword(a)
	mov    cx, [bp+10]	; pop word(b)
	
	; LXRSH@
	cmp    cl,10h
	jnb    LSR_13
	mov    bx,dx
	shr    ax,cl
	sar    dx,cl
	neg    cl
	add    cl,10h
	shl    bx,cl
	or     ax,bx
	pop    cx
	pop    bp
	retf
LSR_13:
	sub    cl,10h
	xchg   dx,ax
	cwd
	sar    ax,cl
	pop    cx
	pop    bp
	retf
SR_ulshr:	; N_LXURSH@
	; r = a >> b
	pop    bx
	push   cs
	push   bx

	push   bp
	mov    bp,sp

	push   cx	; C86 doesn't expect use of cx or bx

        mov    ax, [bp+6]	; pop loword(a)
	mov    dx, [bp+8]	; pop hiword(a)
	mov    cx, [bp+10]	; pop word(b)
	
	; LXURSH@
	cmp    cl,10h
	jnb    LSR_14
	mov    bx,dx
	shr    ax,cl
	shr    dx,cl
	neg    cl
	add    cl,10h
	shl    bx,cl
	or     ax,bx
	pop    cx
	pop    bp
	retf
LSR_14:
	sub    cl,10h
	xchg   dx,ax
	xor    dx,dx
	shr    ax,cl
	pop    cx
	pop    bp
	retf
SR_lmul:	; N_LXMUL@
SR_ulmul:
	; r = a * b
	push   bp
	push   si
	mov    bp,sp

	push   cx	; C86 doesn't expect use of cx or bx
	push   bx

        mov    bx, [bp+6]	; pop loword(a)
	mov    cx, [bp+8]	; pop hiword(a)
	mov    ax, [bp+10]	; pop loword(b)
	mov    dx, [bp+12]	; pop hiword(b)
	
	xchg   si,ax
	xchg   dx,ax
	test   ax,ax
	je     LSR_15
	mul    bx
LSR_15:
	jcxz   LSR_16
	xchg   cx,ax
	mul    si
	add    ax,cx
LSR_16:
	xchg   si,ax
	mul    bx
	add    dx,si
	pop    bx
	pop    cx
	pop    si
	pop    bp
	ret

; Generated by c86 (BYU-NASM) 5.1 (beta) from clib.c
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
new_line:
	db	13,10,36
	ALIGN	2
signalEOI:
	jmp	L_clib_1
L_clib_2:
	mov	al, 0x20
	out	0x20, al
	mov	sp, bp
	pop	bp
	ret
L_clib_1:
	push	bp
	mov	bp, sp
	jmp	L_clib_2
	ALIGN	2
exit:
	jmp	L_clib_4
L_clib_5:
	mov	ah, 4Ch
	mov	al, [bp+4]
	int	21h
	mov	sp, bp
	pop	bp
	ret
L_clib_4:
	push	bp
	mov	bp, sp
	jmp	L_clib_5
	ALIGN	2
print:
	jmp	L_clib_7
L_clib_8:
	mov	ah, 40h
	mov	bx, 1
	mov	cx, [bp+6]
	mov	dx, [bp+4]
	int	21h
	mov	sp, bp
	pop	bp
	ret
L_clib_7:
	push	bp
	mov	bp, sp
	jmp	L_clib_8
	ALIGN	2
printChar:
	jmp	L_clib_10
L_clib_11:
	mov	ah, 2
	mov	dl, [bp+4]
	int	21h
	mov	sp, bp
	pop	bp
	ret
L_clib_10:
	push	bp
	mov	bp, sp
	jmp	L_clib_11
	ALIGN	2
printNewLine:
	jmp	L_clib_13
L_clib_14:
	mov	ah, 9
	mov	dx, new_line
	int	21h
	mov	sp, bp
	pop	bp
	ret
L_clib_13:
	push	bp
	mov	bp, sp
	jmp	L_clib_14
	ALIGN	2
printString:
	jmp	L_clib_16
L_clib_17:
	xor	si,si
	mov	bx, [bp+4]
	jmp	printString2
	printString1:
	inc	si
	printString2:
	cmp	byte [bx+si],0
	jne	printString1
	mov	dx, bx
	mov	cx, si
	mov	ah, 40h
	mov	bx, 1
	int	21h
	mov	sp, bp
	pop	bp
	ret
L_clib_16:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_clib_17
	ALIGN	2
printInt:
	jmp	L_clib_19
L_clib_20:
	mov	word [bp-2], 0
	mov	word [bp-4], 10000
	cmp	word [bp+4], 0
	jge	L_clib_21
	mov	byte [bp-10], 45
	inc	word [bp-2]
	mov	ax, word [bp+4]
	neg	ax
	mov	word [bp+4], ax
L_clib_21:
	mov	ax, word [bp+4]
	test	ax, ax
	jne	L_clib_22
	mov	word [bp-4], 1
	jmp	L_clib_23
L_clib_22:
	jmp	L_clib_25
L_clib_24:
	mov	ax, word [bp-4]
	cwd
	mov	cx, 10
	idiv	cx
	mov	word [bp-4], ax
L_clib_25:
	mov	ax, word [bp+4]
	cwd
	idiv	word [bp-4]
	test	ax, ax
	je	L_clib_24
L_clib_26:
L_clib_23:
	jmp	L_clib_28
L_clib_27:
	mov	ax, word [bp+4]
	xor	dx, dx
	div	word [bp-4]
	add	al, 48
	mov	si, word [bp-2]
	lea	dx, [bp-10]
	add	si, dx
	mov	byte [si], al
	inc	word [bp-2]
	mov	ax, word [bp+4]
	xor	dx, dx
	div	word [bp-4]
	mov	ax, dx
	mov	word [bp+4], ax
	mov	ax, word [bp-4]
	cwd
	mov	cx, 10
	idiv	cx
	mov	word [bp-4], ax
	mov	ax, word [bp-4]
	mov	word [bp-4], ax
L_clib_28:
	cmp	word [bp-4], 0
	jg	L_clib_27
L_clib_29:
	push	word [bp-2]
	lea	ax, [bp-10]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_19:
	push	bp
	mov	bp, sp
	sub	sp, 10
	jmp	L_clib_20
	ALIGN	2
printLong:
	jmp	L_clib_31
L_clib_32:
	mov	word [bp-2], 0
	mov	word [bp-6], 51712
	mov	word [bp-4], 15258
	cmp	word [bp+6], 0
	jg	L_clib_33
	jl	L_clib_34
	cmp	word [bp+4], 0
	jae	L_clib_33
L_clib_34:
	mov	byte [bp-17], 45
	inc	word [bp-2]
	mov	ax, word [bp+4]
	mov	dx, word [bp+6]
	neg	ax
	adc	dx, 0
	neg	dx
	mov	word [bp+4], ax
	mov	word [bp+6], dx
L_clib_33:
	mov	ax, word [bp+4]
	mov	dx, word [bp+6]
	or	dx, ax
	jne	L_clib_35
	mov	word [bp-6], 1
	mov	word [bp-4], 0
	jmp	L_clib_36
L_clib_35:
	jmp	L_clib_38
L_clib_37:
	mov	ax, 10
	xor	dx, dx
	push	dx
	push	ax
	lea	ax, [bp-6]
	push	ax
	call	SR_asldiv
L_clib_38:
	push	word [bp-4]
	push	word [bp-6]
	push	word [bp+6]
	push	word [bp+4]
	call	SR_ldiv
	or	dx, ax
	je	L_clib_37
L_clib_39:
L_clib_36:
	jmp	L_clib_41
L_clib_40:
	push	word [bp-4]
	push	word [bp-6]
	push	word [bp+6]
	push	word [bp+4]
	call	SR_uldiv
	add	al, 48
	mov	si, word [bp-2]
	lea	dx, [bp-17]
	add	si, dx
	mov	byte [si], al
	inc	word [bp-2]
	push	word [bp-4]
	push	word [bp-6]
	push	word [bp+6]
	push	word [bp+4]
	call	SR_lmod
	mov	word [bp+4], ax
	mov	word [bp+6], dx
	mov	ax, 10
	xor	dx, dx
	push	dx
	push	ax
	lea	ax, [bp-6]
	push	ax
	call	SR_asldiv
L_clib_41:
	cmp	word [bp-4], 0
	jg	L_clib_40
	jne	L_clib_43
	cmp	word [bp-6], 0
	ja	L_clib_40
L_clib_43:
L_clib_42:
	push	word [bp-2]
	lea	ax, [bp-17]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_31:
	push	bp
	mov	bp, sp
	sub	sp, 18
	jmp	L_clib_32
	ALIGN	2
printUInt:
	jmp	L_clib_45
L_clib_46:
	mov	word [bp-2], 0
	mov	word [bp-4], 10000
	mov	ax, word [bp+4]
	test	ax, ax
	jne	L_clib_47
	mov	word [bp-4], 1
	jmp	L_clib_48
L_clib_47:
	jmp	L_clib_50
L_clib_49:
	mov	ax, word [bp-4]
	xor	dx, dx
	mov	cx, 10
	div	cx
	mov	word [bp-4], ax
L_clib_50:
	mov	ax, word [bp+4]
	xor	dx, dx
	div	word [bp-4]
	test	ax, ax
	je	L_clib_49
L_clib_51:
L_clib_48:
	jmp	L_clib_53
L_clib_52:
	mov	ax, word [bp+4]
	xor	dx, dx
	div	word [bp-4]
	add	al, 48
	mov	si, word [bp-2]
	lea	dx, [bp-10]
	add	si, dx
	mov	byte [si], al
	inc	word [bp-2]
	mov	ax, word [bp+4]
	xor	dx, dx
	div	word [bp-4]
	mov	word [bp+4], dx
	mov	ax, word [bp-4]
	xor	dx, dx
	mov	cx, 10
	div	cx
	mov	word [bp-4], ax
L_clib_53:
	mov	ax, word [bp-4]
	test	ax, ax
	jne	L_clib_52
L_clib_54:
	push	word [bp-2]
	lea	ax, [bp-10]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_45:
	push	bp
	mov	bp, sp
	sub	sp, 10
	jmp	L_clib_46
	ALIGN	2
printULong:
	jmp	L_clib_56
L_clib_57:
	mov	word [bp-2], 0
	mov	word [bp-6], 51712
	mov	word [bp-4], 15258
	mov	ax, word [bp+4]
	mov	dx, word [bp+6]
	or	dx, ax
	jne	L_clib_58
	mov	word [bp-6], 1
	mov	word [bp-4], 0
	jmp	L_clib_59
L_clib_58:
	jmp	L_clib_61
L_clib_60:
	mov	ax, 10
	xor	dx, dx
	push	dx
	push	ax
	lea	ax, [bp-6]
	push	ax
	call	SR_asuldiv
L_clib_61:
	push	word [bp-4]
	push	word [bp-6]
	push	word [bp+6]
	push	word [bp+4]
	call	SR_uldiv
	or	dx, ax
	je	L_clib_60
L_clib_62:
L_clib_59:
	jmp	L_clib_64
L_clib_63:
	push	word [bp-4]
	push	word [bp-6]
	push	word [bp+6]
	push	word [bp+4]
	call	SR_uldiv
	add	al, 48
	mov	si, word [bp-2]
	lea	dx, [bp-17]
	add	si, dx
	mov	byte [si], al
	inc	word [bp-2]
	push	word [bp-4]
	push	word [bp-6]
	lea	ax, [bp+4]
	push	ax
	call	SR_asilmod
	mov	ax, 10
	xor	dx, dx
	push	dx
	push	ax
	lea	ax, [bp-6]
	push	ax
	call	SR_asuldiv
L_clib_64:
	mov	ax, word [bp-6]
	mov	dx, word [bp-4]
	or	dx, ax
	jne	L_clib_63
L_clib_65:
	push	word [bp-2]
	lea	ax, [bp-17]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_56:
	push	bp
	mov	bp, sp
	sub	sp, 18
	jmp	L_clib_57
	ALIGN	2
printByte:
	jmp	L_clib_67
L_clib_68:
	mov	al, byte [bp+4]
	cbw
	mov	cx, 4
	sar	ax, cl
	and	ax, 15
	mov	byte [bp-1], al
	cmp	byte [bp-1], 9
	jle	L_clib_69
	mov	al, byte [bp-1]
	cbw
	sub	ax, 10
	add	ax, 65
	jmp	L_clib_70
L_clib_69:
	mov	al, byte [bp-1]
	cbw
	add	ax, 48
L_clib_70:
	mov	byte [bp-3], al
	mov	al, byte [bp+4]
	and	al, 15
	mov	byte [bp-1], al
	cmp	byte [bp-1], 9
	jle	L_clib_71
	mov	al, byte [bp-1]
	cbw
	sub	ax, 10
	add	ax, 65
	jmp	L_clib_72
L_clib_71:
	mov	al, byte [bp-1]
	cbw
	add	ax, 48
L_clib_72:
	mov	byte [bp-2], al
	mov	ax, 2
	push	ax
	lea	ax, [bp-3]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_67:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_clib_68
	ALIGN	2
printWord:
	jmp	L_clib_74
L_clib_75:
	mov	word [bp-2], 3
	jmp	L_clib_77
L_clib_76:
	mov	ax, word [bp+4]
	and	ax, 15
	mov	byte [bp-3], al
	cmp	byte [bp-3], 9
	jle	L_clib_80
	mov	al, byte [bp-3]
	cbw
	sub	ax, 10
	add	ax, 65
	jmp	L_clib_81
L_clib_80:
	mov	al, byte [bp-3]
	cbw
	add	ax, 48
L_clib_81:
	mov	si, word [bp-2]
	lea	dx, [bp-7]
	add	si, dx
	mov	byte [si], al
	mov	ax, word [bp+4]
	mov	cx, 4
	sar	ax, cl
	mov	word [bp+4], ax
L_clib_79:
	dec	word [bp-2]
L_clib_77:
	cmp	word [bp-2], 0
	jge	L_clib_76
L_clib_78:
	mov	ax, 4
	push	ax
	lea	ax, [bp-7]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_74:
	push	bp
	mov	bp, sp
	sub	sp, 8
	jmp	L_clib_75
	ALIGN	2
printDWord:
	jmp	L_clib_83
L_clib_84:
	lea	ax, [bp+4]
	mov	si, ax
	mov	ax, word [si]
	mov	word [bp-6], ax
	lea	ax, [bp+4]
	mov	si, ax
	add	si, 2
	mov	ax, word [si]
	mov	word [bp-8], ax
	mov	word [bp-2], 3
	jmp	L_clib_86
L_clib_85:
	mov	ax, word [bp-6]
	and	ax, 15
	mov	byte [bp-3], al
	cmp	byte [bp-3], 9
	jle	L_clib_89
	mov	al, byte [bp-3]
	cbw
	sub	ax, 10
	add	ax, 65
	jmp	L_clib_90
L_clib_89:
	mov	al, byte [bp-3]
	cbw
	add	ax, 48
L_clib_90:
	mov	dx, word [bp-2]
	add	dx, 4
	mov	si, dx
	lea	dx, [bp-16]
	add	si, dx
	mov	byte [si], al
	mov	ax, word [bp-6]
	mov	cx, 4
	sar	ax, cl
	mov	word [bp-6], ax
	mov	ax, word [bp-8]
	and	ax, 15
	mov	byte [bp-3], al
	cmp	byte [bp-3], 9
	jle	L_clib_91
	mov	al, byte [bp-3]
	cbw
	sub	ax, 10
	add	ax, 65
	jmp	L_clib_92
L_clib_91:
	mov	al, byte [bp-3]
	cbw
	add	ax, 48
L_clib_92:
	mov	si, word [bp-2]
	lea	dx, [bp-16]
	add	si, dx
	mov	byte [si], al
	mov	ax, word [bp-8]
	mov	cx, 4
	sar	ax, cl
	mov	word [bp-8], ax
L_clib_88:
	dec	word [bp-2]
L_clib_86:
	cmp	word [bp-2], 0
	jge	L_clib_85
L_clib_87:
	mov	ax, 8
	push	ax
	lea	ax, [bp-16]
	push	ax
	call	print
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_clib_83:
	push	bp
	mov	bp, sp
	sub	sp, 16
	jmp	L_clib_84

; Generated by c86 (BYU-NASM) 5.1 (beta) from yakk.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
	ALIGN	2
running:
	DW	0
currIndex:
	DW	0
YKTickNum:
	DW	0
YKIdleCount:
	DW	0
taskCount:
	DW	0
tick:
	DW	0
interrupt_depth:
	DW	0
	ALIGN	2
YKInitialize:
	; >>>>> Line:	28
	; >>>>> void YKInitialize(){ 
	jmp	L_yakk_1
L_yakk_2:
	; >>>>> Line:	29
	; >>>>> YKNewTask(*YKIdleTask, (void *)&IdleStk[256], 255); 
	mov	al, 255
	push	ax
	mov	ax, (IdleStk+512)
	push	ax
	mov	ax, YKIdleTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	30
	; >>>>> [taskCount]. 
	mov	word [YKCtxSwCount], 0
	mov	sp, bp
	pop	bp
	ret
L_yakk_1:
	push	bp
	mov	bp, sp
	jmp	L_yakk_2
	ALIGN	2
InitStack:
	; >>>>> Line:	35
	; >>>>> { 
	jmp	L_yakk_4
L_yakk_5:
	; >>>>> Line:	38
	; >>>>> base_pointer = tasks[taskCount].stack_pointer; 
	mov	ax, word [taskCount]
	mov	cx, 3
	shl	ax, cl
	mov	si, ax
	add	si, tasks
	mov	ax, word [si]
	mov	word [bp-4], ax
	; >>>>> Line:	40
	; >>>>> tasks[taskCount].stack_pointer--; 
	mov	ax, word [taskCount]
	mov	cx, 3
	shl	ax, cl
	mov	si, ax
	add	si, tasks
	sub	word [si], 2
	; >>>>> Line:	41
	; >>>>> *(tasks[taskCount].stack_pointer) = 0x200; 
	mov	ax, word [taskCount]
	mov	cx, 3
	shl	ax, cl
	mov	si, ax
	add	si, tasks
	mov	si, word [si]
	mov	word [si], 512
	; >>>>> Line:	42
	; >>>>> tasks[taskCount].stack_pointer--; 
	mov	ax, word [taskCount]
	mov	cx, 3
	shl	ax, cl
	mov	si, ax
	add	si, tasks
	sub	word [si], 2
	; >>>>> Line:	44
	; >>>>> *(tasks[taskCount].stack_pointer) = 0x0000; 
	mov	ax, word [taskCount]
	mov	cx, 3
	shl	ax, cl
	mov	si, ax
	add	si, tasks
	mov	si, word [si]
	mov	word [si], 0
	; >>>>> Line:	46
	; >>>>> tasks[taskCount].stack_pointer--; 
	mov	ax, word [taskCount]
	mov	cx, 3
	shl	ax, cl
	mov	si, ax
	add	si, tasks
	sub	word [si], 2
	; >>>>> Line:	47
	; >>>>> *(tasks[taskCount].stack_pointer) = (int)task; 
	mov	ax, word [taskCount]
	mov	cx, 3
	shl	ax, cl
	mov	si, ax
	add	si, tasks
	mov	si, word [si]
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	48
	; >>>>> tasks[taskCount].stack_pointer--; 
	mov	ax, word [taskCount]
	mov	cx, 3
	shl	ax, cl
	mov	si, ax
	add	si, tasks
	sub	word [si], 2
	; >>>>> Line:	49
	; >>>>> *(tasks[taskCount].stack_pointer) = (int) base_pointer; 
	mov	ax, word [taskCount]
	mov	cx, 3
	shl	ax, cl
	mov	si, ax
	add	si, tasks
	mov	si, word [si]
	mov	ax, word [bp-4]
	mov	word [si], ax
	; >>>>> Line:	50
	; >>>>> for(i = 0 ; i < 7; i++) 
	mov	word [bp-2], 0
	jmp	L_yakk_7
L_yakk_6:
	; >>>>> Line:	52
	; >>>>> tasks[taskCount]. 
	mov	ax, word [taskCount]
	mov	cx, 3
	shl	ax, cl
	mov	si, ax
	add	si, tasks
	sub	word [si], 2
	; >>>>> Line:	54
	; >>>>> *(tasks[taskCount].stack_pointer) = 0x0000; 
	mov	ax, word [taskCount]
	mov	cx, 3
	shl	ax, cl
	mov	si, ax
	add	si, tasks
	mov	si, word [si]
	mov	word [si], 0
L_yakk_9:
	inc	word [bp-2]
L_yakk_7:
	cmp	word [bp-2], 7
	jl	L_yakk_6
L_yakk_8:
	mov	sp, bp
	pop	bp
	ret
L_yakk_4:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_yakk_5
	ALIGN	2
YKNewTask:
	; >>>>> Line:	59
	; >>>>> void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority){ 
	jmp	L_yakk_11
L_yakk_12:
	; >>>>> Line:	60
	; >>>>> tasks[taskCount] . stack_pointer = (int*)taskStack; 
	mov	ax, word [taskCount]
	mov	cx, 3
	shl	ax, cl
	mov	si, ax
	add	si, tasks
	mov	ax, word [bp+6]
	mov	word [si], ax
	; >>>>> Line:	61
	; >>>>> tasks[taskCount] . ready = READY; 
	mov	ax, word [taskCount]
	mov	cx, 3
	shl	ax, cl
	add	ax, tasks
	mov	si, ax
	add	si, 2
	mov	word [si], 0
	; >>>>> Line:	62
	; >>>>> tasks[taskCount] . delay_count = 0; 
	mov	ax, word [taskCount]
	mov	cx, 3
	shl	ax, cl
	add	ax, tasks
	mov	si, ax
	add	si, 4
	mov	word [si], 0
	; >>>>> Line:	63
	; >>>>> tasks[taskCount] . priority = priority; 
	mov	ax, word [taskCount]
	mov	cx, 3
	shl	ax, cl
	add	ax, tasks
	mov	si, ax
	add	si, 6
	mov	al, byte [bp+8]
	mov	byte [si], al
	; >>>>> Line:	64
	; >>>>> InitStack(*task); 
	push	word [bp+4]
	call	InitStack
	add	sp, 2
	; >>>>> Line:	65
	; >>>>> taskCount++; 
	inc	word [taskCount]
	; >>>>> Line:	66
	; >>>>> if (running){ 
	mov	ax, word [running]
	test	ax, ax
	je	L_yakk_13
	; >>>>> Line:	67
	; >>>>> YKScheduler(); 
	call	YKScheduler
L_yakk_13:
	mov	sp, bp
	pop	bp
	ret
L_yakk_11:
	push	bp
	mov	bp, sp
	jmp	L_yakk_12
	ALIGN	2
YKIdleTask:
	; >>>>> Line:	72
	; >>>>> void YKIdleTask(){ 
	jmp	L_yakk_15
L_yakk_16:
	; >>>>> Line:	73
	; >>>>> while(1){ 
	jmp	L_yakk_18
L_yakk_17:
	; >>>>> Line:	74
	; >>>>> YKIdleCount++; 
	inc	word [YKIdleCount]
	; >>>>> Line:	75
	; >>>>> NoOp(); NoOp(); 
	call	NoOp
	; >>>>> Line:	75
	; >>>>> NoOp(); NoOp(); 
	call	NoOp
L_yakk_18:
	jmp	L_yakk_17
L_yakk_19:
	mov	sp, bp
	pop	bp
	ret
L_yakk_15:
	push	bp
	mov	bp, sp
	jmp	L_yakk_16
L_yakk_21:
	DB	"Running...",0xA,0
	ALIGN	2
YKRun:
	; >>>>> Line:	80
	; >>>>> void YKRun(){ 
	jmp	L_yakk_22
L_yakk_23:
	; >>>>> Line:	81
	; >>>>> running = 1; 
	mov	word [running], 1
	; >>>>> Line:	82
	; >>>>> printString("Running...\n 
	mov	ax, L_yakk_21
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	83
	; >>>>> YKScheduler(); 
	call	YKScheduler
	mov	sp, bp
	pop	bp
	ret
L_yakk_22:
	push	bp
	mov	bp, sp
	jmp	L_yakk_23
	ALIGN	2
YKDelayTask:
	; >>>>> Line:	87
	; >>>>> void YKDelayTask(unsigned delay){ 
	jmp	L_yakk_25
L_yakk_26:
	; >>>>> Line:	88
	; >>>>> tasks[currIndex].ready = DELAY; 
	mov	ax, word [currIndex]
	mov	cx, 3
	shl	ax, cl
	add	ax, tasks
	mov	si, ax
	add	si, 2
	mov	word [si], 1
	; >>>>> Line:	89
	; >>>>> tasks[currIndex].delay_count = delay; 
	mov	ax, word [currIndex]
	mov	cx, 3
	shl	ax, cl
	add	ax, tasks
	mov	si, ax
	add	si, 4
	mov	ax, word [bp+4]
	mov	word [si], ax
	; >>>>> Line:	90
	; >>>>> YKScheduler(); 
	call	YKScheduler
	mov	sp, bp
	pop	bp
	ret
L_yakk_25:
	push	bp
	mov	bp, sp
	jmp	L_yakk_26
L_yakk_29:
	DB	"Task index: ",0
L_yakk_28:
	DB	"Scheduling...",0xA,0
	ALIGN	2
YKScheduler:
	; >>>>> Line:	94
	; >>>>> void YKScheduler(){ 
	jmp	L_yakk_30
L_yakk_31:
	; >>>>> Line:	100
	; >>>>> local_currIndex = currIndex; 
	mov	word [bp-4], 0
	; >>>>> Line:	100
	; >>>>> local_currIndex = currIndex; 
	mov	ax, word [currIndex]
	mov	word [bp-6], ax
	; >>>>> Line:	101
	; >>>>> printString("Scheduling...\n"); 
	mov	ax, L_yakk_28
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	103
	; >>>>> for (i = 1; i < taskCount; i++) { 
	mov	word [bp-2], 1
	jmp	L_yakk_33
L_yakk_32:
	; >>>>> Line:	105
	; >>>>> if(tasks[i].ready == READY && tasks[i].priority < tasks[index].priority) { 
	mov	ax, word [bp-2]
	mov	cx, 3
	shl	ax, cl
	add	ax, tasks
	mov	si, ax
	add	si, 2
	mov	ax, word [si]
	test	ax, ax
	jne	L_yakk_36
	mov	ax, word [bp-2]
	mov	cx, 3
	shl	ax, cl
	add	ax, tasks
	mov	si, ax
	add	si, 6
	mov	ax, word [bp-4]
	mov	cx, 3
	shl	ax, cl
	add	ax, tasks
	mov	di, ax
	add	di, 6
	mov	al, byte [di]
	cmp	al, byte [si]
	jbe	L_yakk_36
	; >>>>> Line:	107
	; >>>>> index = i; 
	mov	ax, word [bp-2]
	mov	word [bp-4], ax
L_yakk_36:
L_yakk_35:
	inc	word [bp-2]
L_yakk_33:
	mov	ax, word [taskCount]
	cmp	ax, word [bp-2]
	ja	L_yakk_32
L_yakk_34:
	; >>>>> Line:	110
	; >>>>> currIndex = index; 
	mov	ax, word [bp-4]
	mov	word [currIndex], ax
	; >>>>> Line:	111
	; >>>>> printString("Task index: "); 
	mov	ax, L_yakk_29
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	112
	; >>>>> printInt(index); 
	push	word [bp-4]
	call	printInt
	add	sp, 2
	; >>>>> Line:	113
	; >>>>> printString("\n"); 
	mov	ax, (L_yakk_21+10)
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	114
	; >>>>> YKDisp 
	mov	ax, word [bp-6]
	mov	cx, 3
	shl	ax, cl
	add	ax, tasks
	push	ax
	mov	ax, word [bp-4]
	mov	cx, 3
	shl	ax, cl
	mov	si, ax
	add	si, tasks
	push	word [si]
	call	YKDispatcher
	add	sp, 4
	mov	sp, bp
	pop	bp
	ret
L_yakk_30:
	push	bp
	mov	bp, sp
	sub	sp, 6
	jmp	L_yakk_31
	ALIGN	2
YKTickHandler:
	; >>>>> Line:	118
	; >>>>> void YKTickHandler(){ 
	jmp	L_yakk_38
L_yakk_39:
	; >>>>> Line:	121
	; >>>>> YKEnterISR(); 
	call	YKEnterISR
	; >>>>> Line:	123
	; >>>>> YKTickNum++; 
	inc	word [YKTickNum]
	; >>>>> Line:	125
	; >>>>> for(i = 0; i< taskCount; i++) { 
	mov	word [bp-2], 0
	jmp	L_yakk_41
L_yakk_40:
	; >>>>> Line:	126
	; >>>>> if (tasks[i] . delay_count != 0) { 
	mov	ax, word [bp-2]
	mov	cx, 3
	shl	ax, cl
	add	ax, tasks
	mov	si, ax
	add	si, 4
	mov	ax, word [si]
	test	ax, ax
	je	L_yakk_44
	; >>>>> Line:	127
	; >>>>> tasks[i] . delay_count--; 
	mov	ax, word [bp-2]
	mov	cx, 3
	shl	ax, cl
	add	ax, tasks
	mov	si, ax
	add	si, 4
	dec	word [si]
L_yakk_44:
L_yakk_43:
	inc	word [bp-2]
L_yakk_41:
	mov	ax, word [taskCount]
	cmp	ax, word [bp-2]
	ja	L_yakk_40
L_yakk_42:
	; >>>>> Line:	131
	; >>>>> YKExitISR(); 
	call	YKExitISR
	mov	sp, bp
	pop	bp
	ret
L_yakk_38:
	push	bp
	mov	bp, sp
	push	cx
	jmp	L_yakk_39
L_yakk_46:
	DB	"TICK ",0
	ALIGN	2
isrHandle_tick:
	; >>>>> Line:	135
	; >>>>> { 
	jmp	L_yakk_47
L_yakk_48:
	; >>>>> Line:	138
	; >>>>> printNewLine(); 
	call	printNewLine
	; >>>>> Line:	139
	; >>>>> printString("TICK "); 
	mov	ax, L_yakk_46
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	140
	; >>>>> printInt(tick); 
	push	word [tick]
	call	printInt
	add	sp, 2
	; >>>>> Line:	141
	; >>>>> tick++; 
	inc	word [tick]
	; >>>>> Line:	142
	; >>>>> printNewLine(); 
	call	printNewLine
L_yakk_49:
	; >>>>> Line:	143
	; >>>>> return; 
	mov	sp, bp
	pop	bp
	ret
L_yakk_47:
	push	bp
	mov	bp, sp
	jmp	L_yakk_48
	ALIGN	2
YKCtxSwCount:
	TIMES	2 db 0
IdleStk:
	TIMES	512 db 0
tasks:
	TIMES	32 db 0
currTask:
	TIMES	2 db 0

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



; Generated by c86 (BYU-NASM) 5.1 (beta) from lab4b_app.i
	CPU	8086
	ALIGN	2
	jmp	main	; Jump to program start
L_lab4b_app_2:
	DB	"Starting kernel...",0xA,0
L_lab4b_app_1:
	DB	"Creating task A...",0xA,0
	ALIGN	2
main:
	; >>>>> Line:	23
	; >>>>> { 
	jmp	L_lab4b_app_3
L_lab4b_app_4:
	; >>>>> Line:	24
	; >>>>> YKInitialize(); 
	call	YKInitialize
	; >>>>> Line:	26
	; >>>>> printString("Creating task A...\n"); 
	mov	ax, L_lab4b_app_1
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	27
	; >>>>> YKNewTask(ATask, (void *)&AStk[256], 5); 
	mov	al, 5
	push	ax
	mov	ax, (AStk+512)
	push	ax
	mov	ax, ATask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	29
	; >>>>> printString("Starting kernel...\n"); 
	mov	ax, L_lab4b_app_2
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	30
	; >>>>> YKRun(); 
	call	YKRun
	mov	sp, bp
	pop	bp
	ret
L_lab4b_app_3:
	push	bp
	mov	bp, sp
	jmp	L_lab4b_app_4
L_lab4b_app_9:
	DB	"Task A is still running! Oh no! Task A was supposed to stop.",0xA,0
L_lab4b_app_8:
	DB	"Creating task C...",0xA,0
L_lab4b_app_7:
	DB	"Creating low priority task B...",0xA,0
L_lab4b_app_6:
	DB	"Task A started!",0xA,0
	ALIGN	2
ATask:
	; >>>>> Line:	34
	; >>>>> { 
	jmp	L_lab4b_app_10
L_lab4b_app_11:
	; >>>>> Line:	35
	; >>>>> printString("Task A started!\n"); 
	mov	ax, L_lab4b_app_6
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	37
	; >>>>> printString("Creating low priority task B...\n"); 
	mov	ax, L_lab4b_app_7
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	38
	; >>>>> YKNewTask(BTask, (void *)&BStk[256], 7); 
	mov	al, 7
	push	ax
	mov	ax, (BStk+512)
	push	ax
	mov	ax, BTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	40
	; >>>>> printString("Creating task C...\n"); 
	mov	ax, L_lab4b_app_8
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	41
	; >>>>> YKNewTask(CTask, (void *)&CStk[256], 2); 
	mov	al, 2
	push	ax
	mov	ax, (CStk+512)
	push	ax
	mov	ax, CTask
	push	ax
	call	YKNewTask
	add	sp, 6
	; >>>>> Line:	43
	; >>>>> printString("Task A is still running! Oh no! Task A was supposed to stop.\n"); 
	mov	ax, L_lab4b_app_9
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	44
	; >>>>> exit(0); 
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_lab4b_app_10:
	push	bp
	mov	bp, sp
	jmp	L_lab4b_app_11
L_lab4b_app_13:
	DB	"Task B started! Oh no! Task B wasn't supposed to run.",0xA,0
	ALIGN	2
BTask:
	; >>>>> Line:	48
	; >>>>> { 
	jmp	L_lab4b_app_14
L_lab4b_app_15:
	; >>>>> Line:	49
	; >>>>> printString("Task B started! Oh no! Task B wasn't supposed to run.\n"); 
	mov	ax, L_lab4b_app_13
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	50
	; >>>>> exit(0); 
	xor	al, al
	push	ax
	call	exit
	add	sp, 2
	mov	sp, bp
	pop	bp
	ret
L_lab4b_app_14:
	push	bp
	mov	bp, sp
	jmp	L_lab4b_app_15
L_lab4b_app_19:
	DB	"Executing in task C.",0xA,0
L_lab4b_app_18:
	DB	" context switches!",0xA,0
L_lab4b_app_17:
	DB	"Task C started after ",0
	ALIGN	2
CTask:
	; >>>>> Line:	54
	; >>>>> { 
	jmp	L_lab4b_app_20
L_lab4b_app_21:
	; >>>>> Line:	58
	; >>>>> YKEnterMutex(); 
	call	YKEnterMutex
	; >>>>> Line:	59
	; >>>>> numCtxSwitches = YKCtxSwCount; 
	mov	ax, word [YKCtxSwCount]
	mov	word [bp-4], ax
	; >>>>> Line:	60
	; >>>>> YKExitMutex(); 
	call	YKExitMutex
	; >>>>> Line:	62
	; >>>>> printString("Task C started after "); 
	mov	ax, L_lab4b_app_17
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	63
	; >>>>> printUInt(numCtxSwitches); 
	push	word [bp-4]
	call	printUInt
	add	sp, 2
	; >>>>> Line:	64
	; >>>>> printString(" context switches!\n"); 
	mov	ax, L_lab4b_app_18
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	66
	; >>>>> while (1) 
	jmp	L_lab4b_app_23
L_lab4b_app_22:
	; >>>>> Line:	68
	; >>>>> printString("Executing in task C.\n"); 
	mov	ax, L_lab4b_app_19
	push	ax
	call	printString
	add	sp, 2
	; >>>>> Line:	69
	; >>>>> for(count = 0; count < 5000; count++); 
	mov	word [bp-2], 0
	jmp	L_lab4b_app_26
L_lab4b_app_25:
L_lab4b_app_28:
	inc	word [bp-2]
L_lab4b_app_26:
	cmp	word [bp-2], 5000
	jl	L_lab4b_app_25
L_lab4b_app_27:
L_lab4b_app_23:
	jmp	L_lab4b_app_22
L_lab4b_app_24:
	mov	sp, bp
	pop	bp
	ret
L_lab4b_app_20:
	push	bp
	mov	bp, sp
	sub	sp, 4
	jmp	L_lab4b_app_21
	ALIGN	2
AStk:
	TIMES	512 db 0
BStk:
	TIMES	512 db 0
CStk:
	TIMES	512 db 0
