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
.define oldx	0x0801	;oldx for touch screen
.define sw1		0x0802	;first sw
.define numA	0x0805	;numA for lab2
.define numB	0x0806	;numB for lab2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				
;User program begins at 0x00000000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
top:	ldi		r0, 	1		;clear r0
		ldi		r1, 	0		;clear r1
		ldi		r2,		0
		ldi		r3,		0
		stm		format, r0		;format=DECIMAL
		ldi		r0,		0
		ldm		r0, 	inport	;load state of switches into r3
		ldi		r1, 	0x000f		
		and		r0,		r1		;clear all but last 4 bits
		stm		numA,		r0 		;store in r2
		ldm		r0,		inport	;restore r0 to state of switches
		ldi		r1, 	0x00f0
		and		r0, 	r1		;delete unused portion of r0
		ror		r0, 	4		;rotate right 4 bits
		stm		numB,		r0		;store in r3	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;compare the vals of registers r2 and r3
;if r2 < r3, (s=1)		write 0x12345678 to led
;if r2 = r3, (z=1)		write 0x01010101 to led
;if r2 > r3, (else)		write 0x87654321 to led
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
compare:
		ldm		r0,		numA
		ldm		r1, 	numB
        ldh     r2,     0xFFFF
        ldl     r2,     0xFF00
        cmpi    r0,     0x7
        jns     next
        or      r0,     r2
next:	cmpi    r1,     0x7
        jns     sgncmp
        or      r1,     r2
sgncmp: cmp		r0,		r1
		js		less 
		jz		equal
greater:
		ldl		r0,		0x10FE
		ldh		r0,		0xDCBA
		jmp		show
less:	
		ldl		r0,		0xABCD
		ldh		r0,		0xEF01
		jmp 	show
equal:	
		ldl		r0,		0x1212
		ldh		r0,		0x1212
		jmp 	show
show:
;show the numbers on the 7seg
		stm		outport, r0	
		jmp		top				;enter endless loop here
