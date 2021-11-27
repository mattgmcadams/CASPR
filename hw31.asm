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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				
;User program begins at 0x00000000
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
top:

	ldi	r0, 0
	stm	tx, r0
	stm	ty, r0
	stm	format, r0	;decimal format
	sys	clear
	sys 	clearg
	ldi 	r5, 0		;start timer
	ldi 	r6, 11		;n starts at 11
	ldi 	r4, 6		;start prime number count at 6
	ldh 	r2, 0x000F	;count to 1M
	ldl 	r2, 0x423F
	ldi 	r5, 0		;start timer
	stm 	time0, r5

nloop:
	adi 	r6, 2
	cmp 	r6, r2
	jns 	done
	call 	PRIME
	jmp 	nloop
	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;function is_prime(n : integer)
; R6 = a 32-bit sign number to be determine for prime
;output:
; R4 = R4 + 1 if R6 is a prime; 0 otherwise
; R6 content is not affected
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRIME:
	
	push 	r0
	push 	r1
	ldi 	r7, 3 	;divide by 3
	modu 	r6, r7 	;test remainder
	jz 	return_false
	ldi 	r1, 5 	;R1 = i

prime1:

	mov 	r0, r1
	mul 	r0, r0 	;r0 = i^2
	cmp 	r6, r0
	js 	return_true
	mov 	r0, r6
	modu 	r6, r1 	;n mod i = 0?
	jz 	return_false
	mov 	r7, r1
	adi 	r7, 2 	;R7 = i+2
	modu 	r6, r7 	;n mod (i+2) = 0?
	jz 	return_false
	adi 	r1, 6
	jmp 	prime1

return_true:

	mov 	r3, r6	;store prime number in r3
	adi 	r4, 1

return_false:

	pop 	r1
	pop 	r0
	ret
timing:

	byte	0x20	;ASCII space
	byte	0x0B
	byte	S
	byte	0x00	;null character to terminate string

cr:

	byte	0x0D	;carraige return
	byte	0x00

last:

	byte	0x4C	;L
	byte	0x41	;A
	byte	0x53	;S
	byte	0x54	;T
	byte	0x20	;ASCII Space
	byte	0x50	;P
	byte	0x52	;R
	byte	0x49	;I
	byte	0x4D	;M
	byte	0x45	;E
	byte	0x20	;ASCII Space
	byte	0x23	;#
	byte	0x20	;ASCII Space
	byte	0x00	;null character to terminate string

count:

	byte	0x50	;P
	byte	0x52	;R
	byte	0x49	;I
	byte	0x4D	;M
	byte	0x45	;E
	byte	0x20	;ASCII Space
	byte	0x23	;#
	byte	0x20	;ASCII Space
	byte	0x43	;C
	byte	0x4F	;O
	byte	0x55	;U
	byte	0x4E	;N
	byte	0x54	;T
	byte	0x20	;ASCII Space
	byte	0x00	;null character to terminate string
	
done:
				;stop timer
	ldm 	r2, time0			
	ldi 	r5, last

	stm 	string, r5 	;Print last prime number
	sys 	prints
	stm 	tnum, r3
	sys 	printn
	ldi 	r5, cr
	stm 	string, r5
	sys 	prints
		
	ldi 	r5, count 	;Print number of prime numbers
	stm 	string, r5
	sys 	prints
	stm 	tnum, r4
	sys 	printn
	ldi 	r5, cr
	stm 	string, r5
	sys 	prints
			
	stm 	tnum, r2 	;Print runtime
	sys	printn
	ldi 	r5 timing
	stm 	string, r5
	sys 	prints
	jmp 	exit

exit:
	jmp 	exit

