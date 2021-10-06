.arch rhody		;use rhody.cfg
.outfmt hex		;output format is hex
.memsize 2048		;specify 2K words
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
;I/O Address;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define kcntrl	0xf0000	;keyboard control register
.define kascii	0xf0001	;keyboard ASCII code
.define vcntrl	0xf0002	;video control register
.define time0	0xf0003	;Timer 0
.define time1	0xf0004	;Timer 1
.define inport 	0xf0005	;GPIO read address
.define outport	0xf0005	;GPIO write address
.define rand	0xf0006	;random number
;Program variables;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define	x3d1	0x0800	;for 3d line subroutine
.define y3d1	0x0801
.define	z3d1	0x0802
.define	x3d2	0x0803
.define	y3d2	0x0804
.define	z3d2	0x0805	
.define PRNG	0x0806	;LFSR random number
.define b3dx	0x0807	;base X for 3d plots
.define pmt		0x080D	;ASCII for prompt
.define tmpx	0x080E	;variable to hold TX
.define tmpc	0x080F	;variable to hold cursor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define m512	0x0810	;16 words M 0x810-0x81F
.define buffer	0x0820	;64 words W 0x820-0x85F
.define lend	0x0860	;end of line screen address
.define wva	0x0861	;working variable a
.define wvb	0x0862	;working variable b
.define wvc	0x0863	;working variable c
.define wvd	0x0864	;working variable d
.define wve	0x0865	;working variable e
.define wvf	0x0866	;working variable f
.define wvg	0x0867	;working variable g
.define wvh	0x0868	;working variable h
.define t1	0x0871	;temporary value 1
.define t2	0x0872	;temporary value 2
;Program constants;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define vmode	4	;text only video mode
.define gmode	6	;graphic only mode
.define svmode	7	;text XOR graphic video mode
.define hmin	518	;frame corners
.define hmax	778
.define vmin	182
.define vmax	442
.define basex	520	;screen X of (0,0)
.define basey	440	;screen Y of (0,0)
.define hmin2	208	;frame corners #2
.define hmax2	468
.define basex2	210	;screen X of (0,0) #2
.define b3dx1	400	;screen X of (0,0,0)
.define b3dy	440	;screen Y of (0,0,0)
;.define b3dx2	200	;screen X of (0,0,0) # 2
.define fmin	0	;0 for frame min
.define fmax	199	;200 for frame max
.define white	0xFF	;white color
.define gray	0x92	;gray color
.define seed	0xABC	;LFSR seed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 3D scatter plot of WELL512a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
top:	sys		clearg			;clear graphic screen
	    ldi		r0, 	white
	    stm		color, 	r0		;white frame
	    ldi		r0, 	seed
	    stm		PRNG, 	r0		;initializing LFSR
		ldi		r0, 	b3dx1
		stm		b3dx, 	r0		;base X 1
frame:	ldi		r0, 	fmin	
	    stm		x3d1, 	r0			;set 3d:x1, y1, z1, y2, and z2 to frame minimum
	    stm		y3d1, 	r0		
		stm		z3d1, 	r0		
		stm		y3d2, 	r0		
		stm		z3d2, 	r0		
		ldi		r0, 	fmax	
		stm		x3d2, 	r0			;set x2 to frame maximum
		call	line3d				;(0,0,0) to (1,0,0)
		ldi		r0, 	fmin
		stm		x3d2, 	r0			;set 3d x2 to frame minimum
		ldi		r0, 	fmax
		stm		y3d2, 	r0			;set 3d y2 to frame maximum
		call	line3d				;(0,0,0) to (0,1,0)
		ldi		r0, 	fmax
		stm		x3d1, 	r0		
		stm		y3d1, 	r0			;set 3d x1 and y1 to frame max
		ldi		r0, 	gray	
		stm		color, 	r0		
		call	line3d			;(0,1,0) to (1,1,0)
		ldi		r0, 	fmin
		stm		x3d1, 	r0
		ldi		r0, 	fmax
		stm		z3d1, 	r0
		ldi		r0, 	white
		stm		color, 	r0
		call	line3d			;(0,1,0) to (0,1,1)
		ldi		r0, 	fmax
		stm		x3d2, 	r0
		stm		z3d2, 	r0
		call	line3d			;(0,1,1) to (1,1,1)
		ldi		r0, 	fmin
		stm		z3d1, 	r0
		ldi		r0, 	fmax
		stm		x3d1, 	r0
		ldi		r0, 	gray			;inner frame in gray
		stm		color, 	r0
		call	line3d			;(1,1,1) to (1,1,0)
		ldi		r0, 	fmin
		stm		y3d2, 	r0
		stm		z3d2, 	r0
		call	line3d			;(1,1,0) to (1,0,0)
		ldi		r0, 	fmax
		stm		z3d1, 	r0
		ldi		r0, 	fmin
		stm		y3d1, 	r0
		ldi		r0, 	white
		stm		color, 	r0
		call	line3d			;(1,0,0) to (1,0,1)
		ldi		r0, 	fmax
		stm		y3d2, 	r0
		stm		z3d2, 	r0
		call	line3d			;(1,0,1) to (1,1,1)
plotw:	ldi		r0, 	31
		stm		color, 	r0
		ldi		r7, 	30000
loopw:	ldi		r2, 	0xFF	;8-bit mask
		ldi		r3, 	200		;scale factor
		ldm		r1, 	rand
		and		r1, 	r2		;last 8-bit only
		mul		r1, 	r3		;scale
		ror		r1, 	8
		and		r1, 	r2
		stm		x3d1, 	r1
		ldm		r1, 	rand
		and		r1, 	r2		;last 8-bit only
		mul		r1, 	r3		;scale
		ror		r1, 	8
		and		r1, 	r2
		stm		y3d1, 	r1
		ldm		r1, 	rand
		and		r1, 	r2		;last 8-bit only
		mul		r1, 	r3		;scale
		ror		r1, 	8
		and		r1, 	r2
		stm		z3d1, 	r1
		call	pixel3d
		adi		r7, 	0xFFFF
		jnz		loopw
done:	jmp		done
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
line3d:	call 	xeq
		call	yeq
		sys		line
		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pixel3d:
		ldm		r0, b3dx		;r0 = b3dx
		ldm		r1, x3d1		;r1 = ax
		ldm		r2, y3d1		;r2 = ay
		ldm		r3, z3d1		;r3 = az
		add		r0, r1
		sub		r0, r2			;bx = b3dx + ax - ay
		stm		gx, r0
		ldi		r0, b3dy
		sub		r0, r3
		add		r1, r2
		ldi		r2, 0xFFFE
		and 	r1, r2
		ror		r1, 1		
		sub		r0, r1			;by = b3dy - az - 1/2 (ax + ay)
		stm		gy, r0
		sys		pixel
		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
xeq:
		push 	r0
		push 	r1
		push 	r2
		push 	r3
		ldm		r0, b3dx		;r0 = b3dx
		ldm		r1, x3d1		;r1 = ax
		ldm		r2, y3d1		;r2 = ay
		ldm		r3, z3d1		;r3 = az
		add		r0, r1			;r0 = bx + x1
		sub		r0, r2		;bx = b3dx + ax - ay
		stm		x1, r0			;store bx into x1
		ldi		r0, b3dy		;r0 = b3dy
		sub		r0, r3			;b3dy -= az
		add		r1, r2			;ax += ay
		ldi		r2, 0xFFFE		;r2 = b'1111111111111110'
		and 	r1, r2			;make last bit of r1 '0'
		ror		r1, 1			;divide r1 / 2
		sub		r0, r1		;by = b3dy - az - 1/2 (ax + ay)
		stm		y1, r0			;y1 = by
		pop		r3
		pop 	r2
		pop 	r1
		pop 	r0
		ret
yeq:
		push 	r0
		push 	r1
		push 	r2
		push 	r3
		ldm		r0, b3dx
		ldm		r1, x3d2
		ldm		r2, y3d2
		ldm		r3, z3d2
		add		r0, r1
		sub		r0, r2		;bx = b3dx + ax - ay
		stm		x2, r0
		ldi		r0, b3dy
		sub		r0, r3
		add		r1, r2
		ldi		r2, 0xFFFE
		and 	r1, r2
		ror		r1, 1		
		sub		r0, r1		;by = b3dy - az - 1/2 (ax + ay)
		stm		y2, r0
		pop		r3
		pop 	r2
		pop 	r1
		pop 	r0
		ret
x1eq:		; bx = b3dx + 1/2 ax - ay
		push 	r0
		push 	r1
		push 	r2
		push 	r3
		ldm		r0, 	b3dx		;r0 = b3dx
		ldm		r1, 	x3d1		;r1 = ax
		ldi		r2, 	0xFFFE
		and 	r1, 	r2			;r1 = ax/2
		ldm		r2, 	y3d1		;r2 = ay
		ldm		r3, 	z3d1		;r3 = az
		add		r0,		r1			;r0 = b3dx + 1/2 ax
		sub		r0,		r2			;r0 = b3dx + 1/2 ax - ay
		pop		r3
		pop 	r2
		pop 	r1
		pop 	r0
		ret
x2eq:		; bx = b3dx + ax - 1/2 ay
		push 	r0
		push 	r1
		push 	r2
		push 	r3
		;eq
		pop		r3
		pop 	r2
		pop 	r1
		pop 	r0
		ret
y1eq:		; by = b3dy - 1/2 az = 1/2 (ax + ay)
		push 	r0
		push 	r1
		push 	r2
		push 	r3
		;eq
		pop		r3
		pop 	r2
		pop 	r1
		pop 	r0
y2eq:		; by = b3dy - az - 1/2 ax - 3/4 ay
		push 	r0
		push 	r1
		push 	r2
		push 	r3
		;eq
		pop		r3
		pop 	r2
		pop 	r1
		pop 	r0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
thrqrt:							; r7 is the arg to be multiplied by 3/4
		push 	r0
		push	r1
		ldi		r1,		3
		mul		r7,		r1		; multiply r7 by 3
		ldi		r0,		0xFFFC 	; b'1111111111111100'
		and		r7,		r0		; set 2 lsb's of r7 to 0
		ror		r7,		2		; divide r7 by 4
		pop 	r1
		pop		r0
		ret
