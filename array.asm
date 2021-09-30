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
.define array_C 0x0800
.define array_A 0x0808
.define array_B 0x0810
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
;cpy
		ldi  r1, array_A
		;ldi  r2, valsA
		;ldi	 r7, 0x08 ;r7=i
lp1:	ldi r2, 0x01
		str r1, r2
		adi r1, 1
		ldi r2, 0x03
		str r1, r2
		adi r1, 1
		ldi r2, 0x05
		str r1, r2
		adi r1, 1
		ldi r2, 0x07
		str r1, r2
		adi r1, 1
		ldi r2, 0x0b
		str r1, r2
		adi r1, 1
		ldi r2, 0x0d
		str r1, r2
		adi r1, 1
		ldi r2, 0x11
		str r1, r2
		adi r1, 1
		ldi r2, 0x13
		str r1, r2 
		;
		;ldr r0, r2 ;r0=vals[i]
		;str r1, r0 ;A[i]=r0
		;adi r1, 1
		;adi r2, 1
		;adi r7, 0xFFFF
		;jns lp1
        ;call    arr_add
;print
        ldi		r0, array_A
		ldi		r1, 0
		ldi		r2, 0
		;ldi		r3, arrBeg
		;stm		string, r3
		;sys		prints
		
lp3:    ldr		r1, r0 
        stm 	tnum, r1
        sys 	printn
		ldi		r3, arrMid
		stm		string, r3
		sys		prints
        adi 	r0, 1
		adi		r2, 1
        cmpi	r2, 0x08
        jnz 	lp3
;end loop
		;ldi		r3, arrEnd
		;stm		string, r3
		;sys		prints
exit:	jmp		exit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				
;ADD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
arr_add:
        push 	r0 
        push 	r1
        push 	r7 
        ldi 	r7, 0x08
lp2:    ldix 	r0, r7, array_A
        ldix 	r1, r7, array_B
        add 	r0, r1 
        stix 	r7, r0, array_C
        adi 	r7, 0xFFFF
        jns 	lp2
        pop 	r7 
        pop 	r1 
        pop 	r0 
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				
;PRINT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
arr_print:
        push 	r0 ;index
        push 	r1 ;num
		push	r3 
		
        pop 	r7 
		pop		r3 
        pop 	r1
        pop 	r0 
        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				
;Const, values
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
valsA:
        byte    0x01
        byte    0x03
        byte    0x05
        byte    0x07
        byte    0x0B
        byte    0x0D
        byte    0x11
        byte    0x13
        byte    0x00
valsB:
        byte    0x01
        byte    0x01
        byte    0x02
        byte    0x03
        byte    0x05
        byte    0x08
        byte    0x0D
        byte    0x15
        byte    0x00
arrBeg:
		byte	0x5b ; [
		byte	0x20
		byte	0x00
arrMid:
		;byte	0x2C ; ,
		byte	0x20
		byte	0x00
arrEnd:
		byte	0x5D ; ]
		byte	0x00
