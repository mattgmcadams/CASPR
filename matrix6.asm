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
		sys		clearg
;assign values matrix_A
assnA:	ldi		r2,		matA
		ldi		r3,		0		;r3=i
lp1a:	ldi		r4,		0		;r4=j
lp2a:	ldi		r7,		size	;mat size
		mul		r7,		r4		;r7=size*j
		add		r7,		r3		;r7=size*j+i
		ldi		r1,		matrix_A
		add		r1,		r7		;r1=*A(i,j)
		ldr		r0,		r2		;read from matA
		str		r1,		r0		;write to matrixA
		stm		tnum,	r0
		;sys	printn
		adi		r4, 	1
		adi 	r2, 	1
		cmpi	r4,		size
		jnz		lp2a
		adi		r3,		1
		;ldi		r6,		newln
		;stm		string,	r6
		;sys	prints
		cmpi	r3,		size
		jnz		lp1a
		;ldi		r6,		newln
		;stm		string,	r6
		;sys	prints
		;sys	prints
;assign values matrix_B
assnB:	ldi		r2,		matB
		ldi		r3,		0		;r3=i
lp1b:	ldi		r4,		0		;r4=j
lp2b:	ldi		r7,		size	;mat size
		mul		r7,		r4		;r7=size*j
		add		r7,		r3		;r7=size*j+i
		ldi		r1,		matrix_B
		add		r1,		r7		;r1=*A(i,j)
		ldr		r0,		r2		;read from matB
		str		r1,		r0		;write to matrixB
		;stm		tnum,	r0
		;sys	printn
		adi		r4, 	1
		adi 	r2, 	1
		cmpi	r4,		size
		jnz		lp2b
		adi		r3,		1
		ldi		r6,		newln
		stm		string,	r6
		;sys	prints
		cmpi	r3,		size
		jnz		lp1b
		ldi		r6,		newln
		stm		string,	r6
		;sys	prints
		;sys	prints
		;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
assnC:	ldi		r3,		0		;r3=i
lp1c:	ldi		r4,		0		;r4=j
lp2c:	ldi		r7,		size	;mat size
		mul		r7,		r4		;r7=size*j
		add		r7,		r3		;r7=size*j+i
		ldi		r1,		matrix_C
		add		r1,		r7		;r1=*C(i,j)
		ldi		r0,		0		
		str		r1,		r0		;write to matrixC
		stm		tnum,	r0
		;sys	printn
		adi		r4, 	1
		adi 	r2, 	1
		cmpi	r4,		size
		jnz		lp2c
		adi		r3,		1
		ldi		r6,		newln
		stm		string,	r6
		;sys	prints
		cmpi	r3,		size
		jnz		lp1c
		;ldi	r6,		newln
		;stm	string,	r6
		;sys	prints
		;sys	prints
		call	mult
		;call	printc
;exit
exit:	jmp		exit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;multiply and assign values to matrix_C~~~~~~~~~~~~~~~~~~~~~~~~~
mult:	push 	r0
		push 	r1
		push 	r3
		push 	r4
		push 	r5
		push 	r6
		push 	r7
		;start timer here
		stm	time0, r0
		ldi		r3,		0		;r3=i
lp1m:	ldi		r4,		0		;r4=j
lp2m:	ldi		r6, 0
		ldi		r5,		0		;r5=k
		ldi		r0,		0		;r6=sum
lp3m:	ldi		r7,		size	;mat size
		mul		r7,		r5		;r7=size*k
		add		r7,		r3		;r7=size*k+i
;		adi		r7,		matrix_A ;r7=*A(i,k)
;		ldr		r0,		r7		;r0=A(i,k)
		ldix	r0,	r7,	matrix_A
		ldi		r7,		size	;mat size
		mul 	r7, 	r4		;r7=size*j
		add 	r7, 	r5		;r7=size*j+k
;		adi 	r7, 	matrix_B ;r7=*B(k,j)
;		ldr 	r1, 	r7		;r1=B(k,j)
		ldix	r1,	r7,	matrix_B
		mul 	r0, 	r1		;r0=A(i,k)*B(k,j)
		add 	r6, 	r0		;r6=sum+A(i,k)*B(k,j)
		adi 	r5, 	1		
		cmpi	r5, 	size	
		jnz 	lp3m				
		ldi 	r7, 	size	;mat size
		mul 	r7, 	r4		;r7=size*j
		add 	r7, 	r3		;r7=size*j+i
;		adi 	r7, 	matrix_C ;r7=*C(i,j)
;		str 	r7, 	r6		;C(i,j)= r6
		stix	r7, r6, matrix_C
		;stm		tnum,	r6
		;sys		printn
		adi 	r4, 	1		
		cmpi 	r4, 	size		
		jnz 	lp2m		
		;ldi		r6,		newln
		;stm		string,	r6
		;sys		prints
		adi 	r3, 	1		
		cmpi 	r3, 	size		
		jnz 	lp1m	
		;ldi		r6,		newln
		;stm		string,	r6
		;sys		prints
		ldm r6, time0
		stm tnum, r6
		ldi r5, timestr
		stm string, r5
		sys prints
		sys printn
		ldi r5, secstr
		stm string, r5
		sys prints	
		ldi		r2, 	newln
		stm		string, r2
		sys		prints
		ldi		r3,		0		;r3=i
lp1p:	ldi		r4,		0		;r4=j
lp2p:	ldi		r7,		size	;mat size
		mul		r7,		r4		;r7=size*j
		add		r7,		r3		;r7=size*j+i
;		ldi		r1,		matrix_C
;		add		r1,		r7		;r1=*C(i,j)
		ldix 	r1, r7, matrix_C
		ldr		r0,		r1		;read from matrixC
		stm		tnum,	r0		;write to tnum
		sys		printn
		ldi		r2, matMid
		stm		string, r2
		sys		prints
		adi		r4, 	1		
		cmpi	r4,		size	
		jnz		lp2p
		ldi		r2, newln
		stm		string, r2
		sys		prints
		adi		r3,		1		
		cmpi	r3,		size	
		jnz		lp1p
		
		pop r7
		pop r6
		pop r5
		pop r4
		pop r3
		pop r1
		pop r0
		ret
;end multiply~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printc:
		push r0
		push r1
		push r2
		push r3
		push r4
		push r5
		push r6
		push r7

		pop r7
		pop r6
		pop r5
		pop r4
		pop r3
		pop r1
		pop r0
		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
matBeg:
		byte	0x0d
		byte	0x5b ; [
		byte	0x20
		byte	0x00
matMid:	
		byte	0x20
		byte	0x00
newln:
		byte	0x0d
		byte 	0x00
matEnd: 
		byte	0x5D ; ]
		byte	0x00
secstr:
        byte    0x0B
        byte    s
        byte    0x00
timestr:
        byte    0x0D
        byte    t
        byte    i
        byte    m
        byte    e
        byte    0x3A
        byte    0x20
        byte    0x00
matA:	byte	1
		byte	1
		byte	1
		byte	0
		byte	1
		byte	0
		byte	0
		byte	1
		byte	0
		byte	0
		byte	1
		byte	1
		byte	0
		byte	0
		byte	1
		byte	1
		byte	0x00
matB:	byte	0
		byte	1
		byte	1
		byte	0
		byte	1
		byte	1
		byte	1
		byte	0
		byte	0
		byte	0
		byte	0
		byte	1
		byte	0
		byte	1
		byte	1
		byte	0
		byte	0x00
		