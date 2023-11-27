	BITS 16
	
	mov	ax, 0x7c0
	mov	ds, ax
	
	mov	ax, 3
	int	0x10

scanf:
	mov	ah, 0x0
	int	0x16

	mov	[bufferKey + bx], al
	inc	bx

	cmp	bx, 4
	je	KSA

	jmp	scanf

KSA:
	xor bx, bx
	xor	ax, ax 
	xor	cx, cx 

	mov	di, 0x7e00

loopKSA:
	cmp	bx, 256
	jge	clearLoop

	mov	[di + bx], bl

	inc	bx
	jmp	loopKSA

clearLoop:
	xor	ax, ax
	xor	cx, cx

loopKSATwo:
	cmp	ax, 256
	jge	PRGA


	mov	bx, ax
	add	cl, byte [di + bx]

	mov	bx, 4

	push	ax
	div	bl

	mov	bl, ah

	pop	ax
	add	cl, byte [bufferKey + bx]

	call	SWAP

	inc	ax
	jmp	loopKSATwo

PRGA:
	xor	ax, ax
	xor	cx, cx
	xor	dx, dx
    
PRGALoop:

	cmp dx, 359
    je end
    
    inc al

    mov bx, ax
    add cl, byte [di+bx]

    push dx
    call SWAP

    xor dx, dx

    mov bx, ax
    add dl, byte [di+bx]

    mov bx, cx
    add dl, byte [di+bx]

    xor dh, dh
    mov bx, dx
    pop dx
    
    push ax
    mov al, byte[di+bx]

    mov bx, dx
    
    mov ah, 0x0e
    xor al, byte [coderText+bx]
    int 0x10

    pop ax
    inc dx
	
    jmp PRGALoop


	
end:
	jmp	$


SWAP:
	mov	bx, ax
	mov	dl, [di + bx]
	mov	bx, cx
	xchg	dl, [di + bx]
	mov	bx, ax
	mov	[di + bx], dl
	ret
	
	bufferKey:	times	4	db	0
	coderText:	times	359	db	0xff
	times	510 - ($ - $$)	db	0
	db	0x55, 0xaa
