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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				
;User program begins at 0x00000000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
top:	ldi	r0, 0
	stm	format, r0	;force decimal output
	call	wait
	sys	clearg
	sys	clear
	ldi	r0, 0
	ldi	r1, 200
	ldi	r2, 150
	ldi	r3, 0xC0
	stm	tx, r0
	stm	ty, r0
	stm	x1, r1
	stm	y1, r1
	stm	rad, r2
	stm	color, r3
	stm	time0, r0	;start timer at 03
	sys	circle
	ldm	r0, time0
	stm	tnum, r0
	sys	printn		
	call	wait
	sys	clear
	sys	clearg
	ldi	r0, 0
	stm	tx, r0
	stm	ty, r0
	ldi	r3, 0xF0
	stm	color, r3
	stm	time0, r0
	sys	scircle
	ldm	r0, time0
	stm	tnum, r0
	sys	printn
	jmp 	top
exit:	jmp	exit		;enter endless loop here
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
