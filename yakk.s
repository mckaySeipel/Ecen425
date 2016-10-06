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
