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
.define sz_arr	0x0800	;array of sizes
.define oldx	0x0810	
.define temp1	0x0811
.define temp2	0x0812
.define temp3	0x0813
.define i1fpx	382 	;first iteration, first point x;  300 + 81
.define i1fpy	182		;first iteration, first point y;  100 + 81
.define i2fpx	328 	;second iteration, first point x; 300 + 27
.define i2fpy	128		;second iteration, first point y; 100 + 27
.define i3fpx	310 	;third iteration, first point x;  300 + 9
.define i3fpy	110		;third iteration, first point y;  100 + 9
.define i4fpx	304 	;fourth iteration, first point x; 300 + 3
.define i4fpy	104		;fourth iteration, first point y; 100 + 3
.define i1size	81		;first iteration block size
.define i2size	27		;first iteration block size
.define i3size	9		;first iteration block size
.define i4size	3		;first iteration block size
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				
;User program begins at 0x00000000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
top:	ldi		r0, 0
		stm		format, r0	;force decimal output
		stm		tx, 	r0
		stm		ty, 	r0
		sys		clearg
		sys		clear
		ldi 	r1, 	sz_arr
		ldi 	r2, 	sizes
cpy:	ldr 	r0, 	r2
		str 	r1, 	r0
		adi 	r1, 	1
		adi 	r2, 	1
		cmpi 	r0, 	0x00
		jnz 	cpy
		sys dump
		call 	wait
	;Initialization
		ldi		r0, 	300 	;x1
		ldi		r1, 	100 	;y1
		ldi 	r2, 	543 	;x2
		ldi 	r3, 	343 	;y2
		ldi		r5, 	0x1E 	;color
		stm 	color, 	r5
		stm		temp1,	r1
		call 	srect			;self-explanatory
		ldm		r1,		temp1
		call	wait
		ldi		r7,		sz_arr	;Iteration 1		| Iteration 2		| Iteration 3 		| Iteration 4
		cmpi	r7,		0x00	;-------------------+-------------------+-------------------+-------------------
		ldr 	r4, 	r7		;r4 = sz = 81		| sz = 27			| sz = 9			| sz = 3
		ldi 	r5, 	0x03	;black
		stm 	color, 	r5		;set color to black
iter:	ldi		r6,		1		;inc
		ldi		r0, 	300
		ldi		r1, 	100
		add 	r0, 	r4		;r0 = 300 + sz		| r0 = 300 + sz		| r0 = 300 + sz		| r0 = 300 + sz
		add 	r1, 	r4		;r1 = 100 + sz		| r1 = 100 + sz 	| r1 = 300 + sz		| r1 = 300 + sz
		mov 	r2, 	r0		;r2 = r0 + sz		| r2 = r0 + sz		| r2 = r0 + sz		| r2 = r0 + sz
		mov 	r3, 	r1		;r3 = r1 + sz		| r3 = r1 + sz		| r3 = r1 + sz		| r3 = r1 + sz
		add 	r2, 	r4		;r2 += sz
		add 	r3, 	r4		;r2 += sz
		stm temp1, r6
		ldi	r6, msgitr		;r1 = *msg (pointer to msg)
		stm	string, r6	;string = *msg
		sys	prints		;call system function prints
		ldm r6, temp1
		
recur:	adi		r5,		1
		stm		temp1,	r1
		call 	srect			;self-explanatory
		ldm		r1,		temp1
		stm temp1, r6
		ldi	r6, msgrcr		;r1 = *msg (pointer to msg)
		stm	string, r6	;string = *msg
		sys	prints		;call system function prints
		ldm r6, temp1
		sys dump
		call wait
		cmp		r5,		r6
		jz  	incx
		cmp	 	r5,		r6		;    IF Y2 >= 343
		jns		reset	
incy:	
		add		r3,		r4		;    INCREMENT Y
		mov		r1,		r3
		add		r3,		r4
		stm temp1, r6
		ldi	r6, msgy		;r1 = *msg (pointer to msg)
		stm	string, r6	;string = *msg
		sys	prints		;call system function prints
		ldm r6, temp1
		sys dump
		call wait
		ldi		r0, 	300 	; ELSE
		sys dump
		call wait
		mul	r6, 3		;inc
		jmp		recur			;    reset x
incx:	
		add		r2,		r4		; IF X2 (r2) >= 543
		mov		r0,		r2		
		add		r2,		r4
		stm temp1, r6
		ldi	r6, msgx		;r1 = *msg (pointer to msg)
		stm	string, r6	;string = *msg
		sys	prints		;call system function prints
		ldm r6, temp1		
		sys dump
		call wait
		jmp recur
reset:	stm temp1, r6
		ldi	r6, msgr		;r1 = *msg (pointer to msg)
		stm	string, r6	;string = *msg
		sys	prints		;call system function prints
		ldm r6, temp1
		ldi		r6,		0
		adi		r7,		1		;prepare for next iteration
		ldr		r4,		r7
		jz		end
		ldi		r0, 	300 	;x1
		ldi		r1, 	100 	;y1
		jmp 	iter
	
	;Iteration 2
;	ldi r0, i2fpx
;	ldi r1, i2fpy
;	ldi r4, i2size	;27
;	ldi r5, 0x00	;black
;	stm color, r5
;	ldi r5, 3		;blocks per row
;
;	mov r2, r0		;r2 = r0 + size
;	mov r3, r1		;r3 = r1 + size
;	add r2, r4		
;	add r3, r4
;	ldi r6, 0
;	ldi r7, 0
;	loop1:
;	call srect
;	add r0, r4		;+= size *3
;	add r0, r4
;	add r0, r4
;	add r2, r4
;	add r2, r4
;	add r2, r4
;	sub r1, r4
;	adi r1, 0xFFFF
;	adi r7, 1
;	cmp r7, r5
;	jnz loop1
;	ldi r7, 0
;	ldi r0, i2fpx	;reset x values
;	mov r2, r0
;	add r2, r4
;	add r1, r4
;	add r1, r4
;	add r1, r4
;	add r3, r4
;	add r3, r4
;	add r3, r4
;	adi r6, 1
;	cmp r6, r5
;	jnz loop1
;	call wait
;	
;	;Iteration 3
;	ldi r0, i3fpx
;	ldi r1, i3fpy
;	ldi r4, i3size	;9
;	ldi r5, 0x00	;black
;	stm color, r5
;	mov r2, r0		;r2 = r0 + size
;	mov r3, r1		;r3 = r1 + size
;	add r2, r4		
;	add r3, r4
;	ldi r6, 0
;	ldi r7, 0
;	loop2:
;	call srect
;	add r0, r4		;+= size *3
;	add r0, r4
;	add r0, r4
;	add r2, r4
;	add r2, r4
;	add r2, r4
;	sub r1, r4
;	adi r1, 0xFFFF
;	adi r7, 1
;	cmpi r7, 9
;	jnz loop2
;	ldi r7, 0
;	ldi r0, i3fpx	;reset x values
;	mov r2, r0
;	add r2, r4
;	add r1, r4
;	add r1, r4
;	add r1, r4
;	add r3, r4
;	add r3, r4
;	add r3, r4
;	adi r6, 1
;	cmpi r6, 9
;	jnz loop2
;	call wait
;	
	;Iteration 4
;	ldi r0, i4fpx
;	ldi r1, i4fpy
;	ldi r4, i4size	;3
;	ldi r5, 0x00	;black
;	stm color, r5
;	mov r2, r0		;r2 = r0 + size
;	mov r3, r1		;r3 = r1 + size
;	add r2, r4		
;	add r3, r4
;	ldi r6, 0
;	ldi r7, 0
;	loop3:
;	call srect
;	add r0, r4		;+= size *3
;	add r0, r4
;	add r0, r4
;	add r2, r4
;	add r2, r4
;	add r2, r4
;	sub r1, r4
;	adi r1, 0xFFFF
;	adi r7, 1
;	cmpi r7, 27
;	jnz loop3
;	ldi r7, 0
;	ldi r0, i4fpx	;reset x values
;	mov r2, r0
;	add r2, r4
;	add r1, r4
;	add r1, r4
;	add r1, r4
;	add r3, r4
;	add r3, r4
;	add r3, r4
;	adi r6, 1
;	cmpi r6, 27
;	jnz loop3
;	call wait
;	
;	jmp 	top
end:	jmp	end		;enter endless loop here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;wait for touch screen sensor;Accept next touch only if TX1 changes!
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wait:	stm temp3, r0
		stm temp2, r1
		ldi	r0, 0
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
	ldm r1, temp2
	ldm r0, temp3
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
	
sizes:
		byte 	81		; first iteration
		byte 	27		; second iter
		byte	9		; 3rd iter
		byte	3		; 4th iter
		byte	0x00	; null

msgx:	byte	I		;define string= "HELLO WORLD"
	byte	N
	byte	C
	byte	0x20		;ASCII space
	byte	X
	byte 0x0D
	byte	0x00		;null character to terminate string
msgy:	byte	I		;define string= "HELLO WORLD"
	byte	N
	byte	C
	byte	0x20		;ASCII space
	byte	Y
	byte 0x0D
	byte	0x00		;null character to terminate string
msgr:	byte	R		;define string= "HELLO WORLD"
	byte E
	byte	S
	byte E
	byte	T
	byte 0x0D
	byte	0x00		;null character to terminate string
msgitr:	byte I
	byte T
	byte E 
	byte R 
	byte 0x0D
	byte 0x00
msgrcr:	byte R 
	byte E 
	byte C 
	byte U 
	byte R 
	byte 0x0D
	byte 0x00
