.arch 	rhody			;use rhody.cfg
.outfmt hex				;output format is hex
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
.define msx		0xf0007	;mouse X
.define msy		0xf0008	;mouse Y
.define msrb	0xf0009	;mouse right button
.define mslb	0xf000A	;mouse left button
.define trdy	0xf0010	;touch ready
.define tcnt	0xf0011	;touch count
.define gesture	0xf0012	;touch gesture
.define tx1		0xf0013	;touch X1
.define ty1		0xf0014	;touch Y1
.define tx2		0xf0015	;touch X2
.define ty2		0xf0016	;touch Y2
.define tx3		0xf0017	;touch X3
.define ty3		0xf0018	;touch Y3
.define tx4		0xf0019	;touch X4
.define ty4		0xf001A	;touch Y4
.define tx5		0xf001B	;touch X5
.define ty5		0xf001C	;touch Y5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Define part to be included in user's program
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define tx		0x0900	;text video X (0 - 79)
.define ty		0x0901	;text video Y (0 - 59)
.define taddr	0x0902	;text video address
.define tascii	0x0903	;text video ASCII code
.define cursor	0x0904	;ASCII for text cursor
.define prompt	0x0905	;prompt length for BS left limit
.define tnum	0x0906	;text video number to be printed
.define format	0x0907	;number output format
.define gx		0x0908	;graphic video X (0 - 799)
.define gy		0x0909	;graphic video Y (0 - 479)
.define gaddr	0x090A	;graphic video address
.define color	0x090B	;color for graphic
.define x1		0x090C	;x1 for line/circle
.define y1		0x090D	;y1
.define x2		0x090E	;x2 for line
.define y2		0x090F	;y2
.define rad		0x0910	;radius for circle
.define	string	0x0911	;string pointer
.define oldx	0x0800
.define sz_arr	0x0801	;array of sizes

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define size 4			;matrix size
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
	ldi	r4, 0x1E ;color
	stm color, r4
	call srect
	call wait
cpy:	ldr r0, r2
		str r1, r0
		adi r1, 1
		adi r2, 1
		adi r7, 0xffff
		jns cpy
;done cpy
;		ldi		 r0, 	0
;		ldi		 r1,	0
;		ldi		 r2,	0
;		ldi 	 r7,	sz_arr	; r7 = size*
 ;       ldr 	 r1, 	r7
;		ldr		 r3,	r7
 ;       ldi 	 r5, 	0xff ; color
  ;      stm 	 gx, 	r0
   ;     stm 	 gy, 	r0
    ;    stm   color, 	r5
	;	sys dump
    ;    call  srect
	;	sys dump
	;	ldi	  	 r5,	0
	;	stm   color,	r5
	;	ldi		r5,		4
		;sys dump
end:	jmp end
iter:	sys dump
		call   wait
		adi r5, 0xFFFF
		jz end
		adi		r7,		1 ; increment size*
		ldr r6, r7		; r6 = size
		mov r0, r6		; r0 = x1
		mov r1, r6		; r1 = y1 
		mov r2, r6		; r2 = x2
		add r2, r6
		mov r3, r2		; r3 = y2
loop:		; 
		call srect
		cmpi r2, 243	; if x2 == 243, 
		jnz incx		
incy:	mov r3, r1		;	 y1 = y2, 
		add r3, r6		;	 y2 += size. 
incx:		; else	
		mov r0, r2		;	 x1 = x2, 
		add r2, r6		;	 x2 += size
		cmpi r2, 243	; if y1 != 243
		jnz loop	;	loop
		jmp iter	; else, go to next iter
;end:	jmp end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;solid rectangle
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
srect:	push	r0
		push	r1
		push	r2
		push	r3
		stm	x1, r0
		stm	y1, r1
		stm	x2, r2
		stm	y2, r1
		sys	line
		adi	r1, 1
		cmp	r3, r1
		jns	srect
		pop		r3
		pop		r2
		pop		r1
		pop		r0
		ret
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
;
sizes:
		byte	243		; init
		byte 	81		; first iteration
		byte 	27		; second iter
		byte	9		; 3rd iter
		byte	3		; 4th iter
		byte	1		; 5th iter
		byte	0x00	; null
