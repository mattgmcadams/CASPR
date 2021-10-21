.arch rhody			;use rhody.cfg
.outfmt hex			;output format is hex
.memsize 2048			;specify 2K words
;I/O Address;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define kcntrl	0xf0000	;keyboard control register
.define kascii	0xf0001	;keyboard ASCII code
.define vcntrl	0xf0002	;video control register
.define time0	0xf0003	;Timer 0
.define time1	0xf0004	;Timer 1
.define inport 	0xf0005	;GPIO read address
.define outport	0xf0005	;GPIO write address
.define rand	0xf0006	;random number
.define msx	0xf0007	;mouse X
.define msy	0xf0008	;mouse Y
.define msrb	0xf0009	;mouse right button
.define mslb	0xf000A	;mouse left button
.define trdy	0xf0010	;touch ready
.define tcnt	0xf0011	;touch count
.define gesture	0xf0012	;touch gesture
.define tx1	0xf0013	;touch X1
.define ty1	0xf0014	;touch Y1
.define tx2	0xf0015	;touch X2
.define ty2	0xf0016	;touch Y2
.define tx3	0xf0017	;touch X3
.define ty3	0xf0018	;touch Y3
.define tx4	0xf0019	;touch X4
.define ty4	0xf001A	;touch Y4
.define tx5	0xf001B	;touch X5
.define ty5	0xf001C	;touch Y5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Define part to be included in user's program
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define tx	0x0900	;text video X (0 - 79)
.define ty	0x0901	;text video Y (0 - 59)
.define taddr	0x0902	;text video address
.define tascii	0x0903	;text video ASCII code
.define cursor	0x0904	;ASCII for text cursor
.define prompt	0x0905	;prompt length for BS left limit
.define tnum	0x0906	;text video number to be printed
.define format	0x0907	;number output format
.define gx	0x0908	;graphic video X (0 - 799)
.define gy	0x0909	;graphic video Y (0 - 479)
.define gaddr	0x090A	;graphic video address
.define color	0x090B	;color for graphic
.define x1	0x090C	;x1 for line/circle
.define y1	0x090D	;y1
.define x2	0x090E	;x2 for line
.define y2	0x090F	;y2
.define rad	0x0910	;radius for circle
.define	string	0x0911	;string pointer
.define oldx	0x0801	;oldx for touch screen
.define x		0x0802	;first point x (local to sierpinski)
.define y		0x0803	;first point y (local to sierpinski)
.define iter1x	382 	;first iter, first point x
.define iter1y	182		;first iter, first point y
.define iter2x	328 	;second iter, first point x
.define iter2y	128		;second iter, first point y
.define iter3x	310 	;third iter, first point x
.define iter3y	110		;third iter, first point y
.define iter4x	304 	;fourth iter, first point x
.define iter4y	104		;fourth iter, first point y
.define iter1sz	81		;first iter block size
.define iter2sz	27		;first iter block size
.define iter3sz	9		;first iter block size
.define iter4sz	3		;first iter block size
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				
;User program begins at 0x00000000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
top:
	ldi	r0, 0
	stm	format, r0	;force decimal output
	stm	tx, r0
	stm	ty, r0
	sys	clearg
	sys	clear
	call wait
	
	;Initialization
	ldi	r0, 300 ;x1
	ldi	r1, 100 ;y1
	ldi r2, 543 ;x2
	ldi r3, 343 ;y2
	ldi	r4, 0x03 ;color
	stm color, r4
	call srect
	call wait
	
	;iter 1
	ldi r0, iter1x
	ldi r1, iter1y
	ldi r4, iter1sz	;81
	mov r2, r0		;r2 = r0 + 81
	mov r3, r1		;r3 = r1 + 81
	add r2, r4
	add r3, r4
	ldi r4, 0x00	;black
	stm color, r4
	call srect
	call wait
	
	;iter 2
	ldi r0, iter2x
	ldi r1, iter2y
	ldi r4, iter2sz	;27
	ldi r5, 0x00	;black
	stm color, r5
	ldi r5, 3		;blocks per row

	mov r2, r0		;r2 = r0 + size
	mov r3, r1		;r3 = r1 + size
	add r2, r4		
	add r3, r4
	ldi r6, 0
	ldi r7, 0
	lp1:
	call srect
	add r0, r4		;+= sz *3
	add r0, r4
	add r0, r4
	add r2, r4
	add r2, r4
	add r2, r4
	sub r1, r4
	adi r1, 0xFFFF
	adi r7, 1
	cmp r7, r5
	jnz lp1
	ldi r7, 0
	ldi r0, iter2x	;reset x values
	mov r2, r0
	add r2, r4
	add r1, r4
	add r1, r4
	add r1, r4
	add r3, r4
	add r3, r4
	add r3, r4
	adi r6, 1
	cmp r6, r5
	jnz lp1
	call wait
	
	;iter 3
	ldi r0, iter3x
	ldi r1, iter3y
	ldi r4, iter3sz	;9
	ldi r5, 0x00	;black
	stm color, r5
	mov r2, r0		;r2 = r0 + size
	mov r3, r1		;r3 = r1 + size
	add r2, r4		
	add r3, r4
	ldi r6, 0
	ldi r7, 0
	lp2:
	call srect
	add r0, r4		;+= sz *3
	add r0, r4
	add r0, r4
	add r2, r4
	add r2, r4
	add r2, r4
	sub r1, r4
	adi r1, 0xFFFF
	adi r7, 1
	cmpi r7, 9
	jnz lp2
	ldi r7, 0
	ldi r0, iter3x	;reset x values
	mov r2, r0
	add r2, r4
	add r1, r4
	add r1, r4
	add r1, r4
	add r3, r4
	add r3, r4
	add r3, r4
	adi r6, 1
	cmpi r6, 9
	jnz lp2
	call wait
	
	;iter 4
	ldi r0, iter4x
	ldi r1, iter4y
	ldi r4, iter4sz	;3
	ldi r5, 0x00	;black
	stm color, r5
	mov r2, r0		;r2 = r0 + size
	mov r3, r1		;r3 = r1 + size
	add r2, r4		
	add r3, r4
	ldi r6, 0
	ldi r7, 0
	lp3:
	call srect
	add r0, r4		;+= size *3
	add r0, r4
	add r0, r4
	add r2, r4
	add r2, r4
	add r2, r4
	sub r1, r4
	adi r1, 0xFFFF
	adi r7, 1
	cmpi r7, 27
	jnz lp3
	ldi r7, 0
	ldi r0, iter4x	;reset x values
	mov r2, r0
	add r2, r4
	add r1, r4
	add r1, r4
	add r1, r4
	add r3, r4
	add r3, r4
	add r3, r4
	adi r6, 1
	cmpi r6, 27
	jnz lp3
	call wait
	
	jmp 	top
end: jmp end		;enter endless loop here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;wait for touch screen sensor;Accept next touch only if TX1 changes!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wait:	ldi	r0, 0
	ldh	r0, 0x10
dly:	adi	r0, 0xFFFF
	jnz	dly
	ldm	r0, trdy
	cmpi	r0, 1
	jz	wait
wait0:
	ldm	r0, trdy
	cmpi	r0, 1
	jz	wait0
	ldm	r0, tcnt
	cmpi	r0, 1
	jnz	wait
	ldm	r0, tx1
	ldm	r1, oldx
	cmp	r0, r1
	jz	wait		;no respond to old touch
	stm	oldx, r0	;update oldx
	ret
; Solid rectangle
srect:
    stm    x1, r0
    stm    y1, r1
    stm    x2, r2
    stm    y2, r1
    sys    line
    adi    r1, 1
    cmp    r3, r1
    jns    srect
    ret
