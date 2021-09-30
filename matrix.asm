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
.define matrix_A 0x0800	;matrix A
.define matrix_B 0x0810 ;matrix B
.define matrix_C 0x0820 ;matrix C
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define size 4			;matrix size
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				
;User program begins at 0x00000000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
top:	ldi		r0, 	0		;clear r0
		ldi		r1, 	0
		ldi		r2, 	0
        stm     tx,     r0
        stm     ty,     r0
	    stm	    format, r0		;format=DECIMAL
        sys     clear
;assign values matrix_A
assnA:	ldi		r3,		0		;r3=i
lp1:	ldi		r4,		0		;r4=j
lp2:	ldi		r7,		size	;mat size
		mul		r7,		r4		;r7=size*j
		add		r7,		r3		;r7=size*j+i
		ldi		r1,		matrix_A
		add		r1,		r7		;r1=*A(i,j)
		ldr		r0,		rand	;assign rand to r0
		str		r1,		r0		;write to matrixA
		adi		r4, 	1
		cmpi	r4,		size
		jnz		lp2
		adi		r3,		1
		cmpi	r3,		size
		jnz		lp1
;assign values matrix_B
assnB:	ldi		r3,		0		;r3=i
lp1:	ldi		r4,		0		;r4=j
lp2:	ldi		r7,		size	;mat size
		mul		r7,		r4		;r7=size*j
		add		r7,		r3		;r7=size*j+i
		ldi		r1,		matrix_B
		add		r1,		r7		;r1=*A(i,j)
		ldr		r0,		rand	;assign rand to r0
		str		r1,		r0		;write to matrixA
		adi		r4, 	1
		cmpi	r4,		size
		jnz		lp2
		adi		r3,		1
		cmpi	r3,		size
		jnz		lp1
;multiply and assign values to matrix_C
mult:	ldi		r3,		0		;r3=i
lp1:	ldi		r4,		0		;r4=j
lp2:	ldi		r5,		0		;r5=k
		ldi		r0,		0		;r6=sum
lp3:	ldi		r7,		size	;mat size
		mul		r7,		r5		;r7=size*k
		add		r7,		r3		;r7=size*k+i
		adi		r7,		matrix_A ;r7=*A(i,k)
		ldr		r0,		r7		;r0=A(i,k)
		ldi		r7,		size	;mat size
		mul 	r7, 	r4		;r7=size*j
		add 	r7, 	r5		;r7=size*j+k
		adi 	r7, 	matrix_B ;r7=*B(k,j)
		ldr 	r1, 	r7		;r1=B(1,
		mul 	r0, 	r1		
		add 	r6, 	r0		
		adi 	r5, 	1		
		cmpi	r5, 	size	
		jnz 	lp3				
		ldi 	r7, 	size		
		mul 	r7, 	r4		
		add 	r7, 	r3		
		adi 	r7, 	r6		
		str 	r7, 	r6		
		adi 	r4, 	1		
		cmpi 	r4, 	size		
		jnz 	lp2					
		adi 	r3, 	1		
		cmpi 	r3, 	size		
		jnz 	lp1					
;exit
exit:	jmp		exit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Addr:							;assuming ROW FIRST
		ldm		r0, 	Matrix_I
		ldm		r1		Matrix_J
		ldm		r2,		Matrix_Isize
		mul		r1,		r2
		add		r0,		r1
		add		r0,		matrix_A
		stm		Matrix_mem, r0