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
top:	ldi		r0, 	0		;clear r0
		ldi		r1, 	0		;clear r1
		stm		format, r0		;format=DECIMAL
    ;initialize first and second terms (r0, r1)
        ldi r0, 1
        ldi r1, 1
    ;initialize n to increment (r2)
        ldi r2, 2
loop:   
    ;increment n
        adi r2, 1
    ;get next term (store in r0)
        add r0, r1
    ;print n, print term
        call print
    ;if overflow has occurred, jump to end:
        jv end    
    ;else, increment n
        adi r2, 1
        ;get next term (store in r1)
        add r1, r0
        ;print n, print term
        call print
    ;if overflow hasn't occurred, jump to loop:
        jnv loop
    ;else, store val of r1 in r0 and proceed to end:
        ldm r0, r1
end:
    ;print "DONE"
        ldi r3, done
        stm string, r3
        sys prints  
print:
    ;store fn to string, print
        ldi r3, fn
        stm string, r3
        sys prints
    ;store r0 to tnum, printn
        stm tnum, r0
        sys printn
    ;store n to string, prints
        ldi r3, justn
        stm string, r3
        sys prints
    ;store r2 to tnum, print
        stm tnum, r2
        sys printn
        ret
done:
    byte 0x0D       ; CR
    byte D
    byte O
    byte N
    byte E
    byte 0x00       ; NULL
fn: 
    byte 0x0D       ; CR
    byte F
    byte n 
    byte 0x3A
    byte 0x20       ; ' '
    byte 0x00       ; NULL
justn:
    byte 0x20       ; ' '
    byte 0x20       ; ' '
    byte 0x20       ; ' '
    byte 0x20       ; ' '
    byte n
    byte 0x3A       ; ':'
    byte 0x20       ; ' '
    byte 0x00       ; NULL