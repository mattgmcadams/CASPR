.arch rhody		;use Rhody.cfg
.outfmt hex		;output format is hex
.memsize 1024		;specify 1K words
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Memory addresses for Rhody System I/O devices
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;				
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
;Program variables in System Data memory
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Define part to be included in user's program
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define tx	0x0900	;text video X (0 - 99)
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
.define string	0x0911	;pointer to string
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Define part not to be included in user's program
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define deltax	0x0912	;parameters for line
.define deltay	0x0913
.define error	0x0914
.define ystep	0x0915
.define steep	0x0916
.define cf	0x0917	;parameters for circle
.define ddfx	0x0918
.define ddfy	0x0919
.define tmp0	0x091A	;temp holders for reg0-2
.define tmp1	0x091B
.define tmp2	0x091C
.define tmpx	0x091D	;temp holder for TX
.define tmpy	0x091E	;temp holder for TY
.define tmpa	0x091F	;temp holder for TASCII
.define tmpn	0x0920	;temp holder for TNUM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Library function constants for Rhody System Video
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define ttop 	0x02000		;text video address
.define gtop 	0x100000	;graphic video address	
.define	gwidth	800		;graphic screen width
.define gheight	480		;graphic screen height
.define ginc	224		;graphic scren increment: 1024-800
.define gshift	22		;graphic address shift: 32-10
;For VGA1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;			
.define twidth	50		;text screen width
.define theight	30		;text screen height
.define thm1	29		;text screen height minus 1
.define tinc	14		;text screen increment: 64-50
.define tshift	26		;text address shift: 32-6
.define tmw	64		;text memory width
.define	tmw1	65		;text memory width + 1
.define tmw2	0xFFC0		;text memory width negative
.define tmw3	49		;text screen widthh - 1
.define tdumpw	35		;Sys dump: twidth - 15
.define tdumpw1	36		;Sys dump: tdumpw + 1
.define tdumph	21		;Sys dump: theight - 9
;For VGA2;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define xwidth	100		;text screen width
.define xheight	60		;text screen height
.define xhm1	59		;text screen height minus 1
.define xinc	28		;text screen increment: 128-100
.define xshift	25		;text address shift: 32-7
.define xmw	128		;text memory width
.define	xmw1	129		;text memory width + 1
.define xmw2	0xFF80		;text memory width negative
.define xmw3	99		;text screen widthh - 1
.define xdumpw	85		;Sys dump: twidth - 15
.define xdumpw1	86		;Sys dump: tdumpw + 1
.define xdumph	51		;Sys dump: theight - 9
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.offset 0x000FFC00		;Library ROM starting address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sys instruction will land on one of
;the following targets according to 
;the sys call number. $FFC00 - $FFC0F
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys:	jmp	sys0	;sys getln: input a line from keyboard
	jmp	sys1	;sys clear: clear text video
	jmp	sys2	;sys clearg: clear graphic video
	jmp	sys3	;sys textp: get text video address
	jmp	sys4	;sys graphp: get graphic video address
	jmp	sys5	;sys putchar: put one char on text video
	jmp	sys6	;sys pixel: draw one pixel on graphic video
	jmp	sys7	;sys getchar: get one char from keyboard
	jmp	sys8	;sys getnum: get a number (decimal or hex)
	jmp	sys9	;sys printn: print a number (decimal or hex)
	jmp	sysA	;sys prints: print a string
	jmp	sysB	;sys line: draw a line
	jmp	sysC	;sys rect: draw a rectangle
	jmp	sysD	;sys circle: draw a circle
	jmp	sysE	;sys scircle: draw a solid circle
	jmp	sysF	;sys dump: dump register contents
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sys0: Keyboard input a line
;inputs: TX, TY (cursor position), CURSOR
;output: keyins are echoed on text video
;X and Y are updated to last input position
;The last cursor position holds 'cursor" when 
;CR or 'enter' is pressed.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys0:	push	r0		;save affected regs
	push	r3
get0:	sys	getchar		;get one char from keyboard
	ldm	r0, tascii	;get TASCII
	cmpi	r0, 13		;is it CR=0x0D=13?
	jz	get1		
	sys	putchar		;put char on screen if not CR
	sys	textp		;get text address
	ldm	r3, taddr
	ldm	r0, cursor	;print cursor
	str	r3, r0
	jmp	get0		;continue getchar from keyboard
get1:	pop	r3
	pop	r0
	reti
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sys1: clear the text video screen
;address: 0x2000 -- 0x3fff
;no input or output
;no register is affected
;VGA1: 50x30 (64x32=2K) text screen
;VGA2: 100x60 (128x64=8K)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys1:	push	r0		;save affected regs
	push	r1
	push	r2
	push	r3
	ldm	r0, vcntrl	;check VGA ID
	cmpi	r0, 1
	jnz	sys1a		;For VGA2
	ldi	r0, ttop
	ldi	r1, 0x20	;ASCII space
	ldi	r3, theight	;Y count
cl0:	ldi	r2, twidth	;X count
cl1:	str	r0, r1
	adi	r0, 1		;inc address
	adi	r2, 0xFFFF	;dec X count
	jnz	cl1
	adi	r0, tinc	;advance to next line (64-50)
	adi	r3, 0xFFFF	;dec Y count 
	jnz	cl0
	pop 	r3		;restore regs
	pop	r2
	pop	r1
	pop	r0
	reti
sys1a:	ldi	r0, ttop
	ldi	r1, 0x20	;ASCII space
	ldi	r3, xheight	;Y count
cl2:	ldi	r2, xwidth	;X count
cl3:	str	r0, r1
	adi	r0, 1		;inc address
	adi	r2, 0xFFFF	;dec X count
	jnz	cl3
	adi	r0, xinc	;advance to next line (64-50)
	adi	r3, 0xFFFF	;dec Y count 
	jnz	cl2
	pop 	r3		;restore regs
	pop	r2
	pop	r1
	pop	r0
	reti
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sys2: clear the graphic video screen
;address: 0x100000 -- 0x17FFFF
;no input or output
;no register is affected
;support 800x480 (1024x512=512K) resolution
;Hardware 6-bit color emulating software 8-bit color
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys2:	push	r0		;save affected regs
	push	r1
	push 	r2
	push	r3
	ldi	r1, 0		;r1=black color
	ldh	r0, 0x0010	;
	ldl	r0, 0x0000	;r0=00100000
	ldi	r3, gheight	;Y count
gc0:	ldi	r2, gwidth	;X count
gc1:	str	r0, r1		;write blank to graphic video
	adi	r0, 1		;inc address	
	adi	r2, 0xFFFF	;dec X count
	jnz	gc1
	adi	r0, ginc	;advance to next line (1024-800)
	adi	r3, 0xFFFF	;dec Y count
	jnz	gc0
	pop	r3		;restore registers
	pop	r2
	pop	r1
	pop	r0
	reti
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sys3: calculates the memory address of text video
;base address: 0x2000
;inputs: TX, TY
;return: TADDR=memory address
;VGA1: (50x30) TAADR = 2^6 TY + TX
;VGA2: (100x60) TADDR = 2^7 TY + TX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys3:	push	r1
	push	r2
	ldm	r1, vcntrl
	cmpi	r1, 1
	jnz	sys3a		;VGA2
	ldm	r1, TX		;r1=TX
	ldm	r2, TY		;r2=TY
	ror	r2, tshift	;rotate TY left by 6
	add	r2, r1		;r2=2**6*TY+TX
	adi	r2, ttop	;add base address
	stm	taddr, r2	;save to TADDR
	pop	r2
	pop	r1
	reti
sys3a:	ldm	r1, TX		;r1=TX
	ldm	r2, TY		;r2=TY
	ror	r2, xshift	;rotate TY left by 7
	add	r2, r1		;r2=2**7*Y+TX
	adi	r2, ttop	;add base address
	stm	taddr, r2	;save to TADDR
	pop	r2
	pop	r1
	reti
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sys4: calculates the memory address of graphic video
;base address: 0x00100000
;inputs: GX, GY
;return: GADDR=meory address
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys4:	push	r1
	push	r2
	ldm	r1, GX		;r1=GX
	ldm	r2, GY		;r2=GY
	ror	r2, gshift	;rotate GY left by 10
	add	r2, r1		;r2=2**10*GY+GX
	ldi	r1, 0x0010	
	ror	r1, 16		;r3=00100000
	add	r2, r1		;add base address
	stm	gaddr, r2	;save to GADDR
	pop	r2
	pop	r1
	reti
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sys5: put one char (including CR) on text video screen
;inputs: TASCII, TX, TY, PROMPT
;outputs: TX and TY holds new 'next' position on screen
;		CR: TX=0, inc TY, scroll if necessary
;		BS: dec TX, stop when reach PROMPT limit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys5:	push	r0
	push	r1
	push	r2
	push	r3
	sys	textp
	ldm	r1, taddr	;r1=TADDR
	ldm	r0, tascii	;r0=TASCII
	cmpi 	r0, 0x0D	;r0=0x0D carriage return?
	jnz	put1		;put new character on screen
incy:	ldi	r2, 0x20	;r2=ASCII space
	str	r1, r2		;blank out old cursor
inc1:	ldi	r2, 0	
	stm	tx, r2		;TX=0
	ldm	r2, ty
	adi	r2, 1		
	stm	ty, r2		;TY=TY+1
	ldm	r0, vcntrl
	cmpi	r0, 1
	jnz	inc2	
	cmpi	r2, theight	;check if TY=30
	jnz	put3		;return if TY/=30
	call	scroll		;perform scroll
	ldi	r2, thm1
	stm	ty, r2		;TY=29
	jmp	put3
inc2:
	cmpi	r2, xheight	;check if TY=60
	jnz	put3		;return if TY/=60
	call	scroll		;perform scroll
	ldi	r2, xhm1
	stm	ty, r2		;TY=59
	jmp	put3
;not CR, check BS next;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
put1:	cmpi	r0, 0x08	;r0=08 Back space?	
	jnz	put2		;put new character on screen
	ldm	r2, tx		;r2=TX
	ldm	r3, prompt
	cmp	r2, r3
	jz	put3		;no further BS when TX=PROMPT
	ldi	r3, 0x20	;space to erase old cursor
	str	r1, r3
	adi	r2, 0xFFFF	;r2=TX-1
	stm	tx, r2		;update TX=TX-1
	jmp	put3
;not CR and BS, print new character;;;;;;;;;;;;;;;;
put2:	str	r1, r0          ;print to screen
	ldm	r2, tx
	adi	r2, 1	
	stm	tx, r2		;TX=TX+1
	ldm	r0, vcntrl
	cmpi	r0, 1
	jnz	put4
	cmpi	r2, twidth	;check if TX=50
	jz	inc1		;line wrap
	jmp	put3
put4:	cmpi	r2, xwidth	;check if TX=100
	jz	inc1		;line wrap
put3:	pop	r3
	pop	r2
	pop	r1
	pop	r0
	reti			;Return from sys#5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;subroutine to scroll screen up by one line
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scroll:
	ldm	r0, vcntrl
	cmpi	r0, 1
	jnz	scrolla		;VGA2
	ldi	r0, ttop	;
	adi	r0, tmw		;r0=address of (0,1)
	ldi	r3, thm1	;Y count
sc0:	ldi	r2, twidth	;X count
sc1:	ldr	r1, r0		;read from (r2, r3)
	adi	r0, tmw2	;-tmw for previous line
	str	r0, r1		;print at previous line
	adi	r0, tmw1	;inc address (tmw+1)
	adi	r2, 0xFFFF	;dec X count
	jnz	sc1
	adi	r0, tinc	;advance to next line (64-50)
	adi	r3, 0xFFFF	;dec Y count
	jnz	sc0
	adi	r0, tmw2	;-tmw; go back to last line
	ldi	r1, 0x20	;prepare to print space
	ldi	r2, twidth	;blanking last line
sc2:	str	r0, r1		;print at last line
	adi	r0, 1		;inc address
	adi	r2, 0xFFFF	;dec X count
	jnz	sc2
	ret
scrolla:
	ldi	r0, ttop	;
	adi	r0, xmw		;r0=address of (0,1)
	ldi	r3, xhm1	;Y count
sc3:	ldi	r2, xwidth	;X count
sc4:	ldr	r1, r0		;read from (r2, r3)
	adi	r0, xmw2	;-tmw for previous line
	str	r0, r1		;print at previous line
	adi	r0, xmw1	;inc address (tmw+1)
	adi	r2, 0xFFFF	;dec X count
	jnz	sc4
	adi	r0, xinc	;advance to next line (64-50)
	adi	r3, 0xFFFF	;dec Y count
	jnz	sc3
	adi	r0, xmw2	;-tmw; go back to last line
	ldi	r1, 0x20	;prepare to print space
	ldi	r2, xwidth	;blanking last line
sc5:	str	r0, r1		;print at last line
	adi	r0, 1		;inc address
	adi	r2, 0xFFFF	;dec X count
	jnz	sc5
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sys6: draw one pixel on graphic video screen
;base address: 00100000
;inputs: GX, GY, COLOR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys6:	push	r0
	push	r1
	sys	graphp		;get address in gaddr
	ldm	r0, color	;get COLOR
	ldm	r1, gaddr	;get GADDR		
	str	r1, r0
	pop	r1
	pop	r0
	reti
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sys7: get a keyboard input
;no input
;output: TASCII
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys7:	push	r0
	push	r3
kbd:	ldm	r3, kcntrl	;
	adi	r3, 0		;check keyboard ready
	jz	kbd		;wait until ready=1
	ldm	r0, kascii	;r0=ASCII
	ldi	r3, 0x0001
	stm	kcntrl, r3	;ack=1
ack:	ldm	r3, kcntrl
	adi	r3, 0
	jnz	ack		;wait until ready=0
	ldi	r3, 0
	stm	kcntrl, r3	;ack=0
	stm	tascii, r0	;save to TASCII
	pop	r3
	pop	r0
	reti
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sys8:get a number from input line
;inputs: TX, TY of text video
;outputs:	tnum = number converted from string
;		TX and TY point at first non-number char
;numbers start with '-' or 0-9 are decimal
;numbers start with '0x' is hexadecimal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys8:	push	r0
	push	r1
	push	r2
	push	r3
	push	r4
	sys	textp		;get text video address
	ldm	r3, taddr
	ldi	r1, 0		;negative flag=0
	ldr	r0, r3
	cmpi	r0, 0x2D	;'-'?
	jz	getn
	cmpi	r0, 0x30	;'0'?
	jnz	getd		;use get decimal to continue
	ldi	r2, 0		;prepare for the worst
	ldm	r4, tx		;update tx
	adi	r4, 1
	cmpi	r4, twidth	;end of screen?
	jz	gd2		;exit with TNUM=0
	stm	tx, r4		;inc TX
	adi	r3, 1		;next char
	ldr	r0, r3
	cmpi	r0, X		;'X'?
	jz	geth
	cmpi	r0, 0x78	;'x'?
	jz	geth		;starts with '0x': hex
	jmp	getd		;format is decimal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;get a decimal number
;r3=input buffer pointer
;negative number starts with an '-'
;A number is terminated by a non-decimal-digital char
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getn:	adi	r3, 1		;pointer to next char
	ldm	r4, tx
	adi	r4, 1
	stm	tx, r4		;update tx
	ldi	r1, 1		;negaive flag=1
getd:	ldi	r2, 0		;r2=accumulator
gd0:	ldr	r0, r3		;get char
	cmpi	r0, 0x30
	js	gd1		;< ASCII "0"
	cmpi	r0, 0x3A
	jns	gd1		;>= ASCII ":" 
	ldi	r4, 0xF
	and	r0, r4		;get 0-9
	ldi	r4, 10
	mul	r2, r4		;advance one decimal digit
	add	r2, r0		;accumulate
	adi	r3, 1		;inc pointer
	ldm	r0, vcntrl
	cmpi	r0, 1
	jnz	gdA		;VGA2
	ldm	r0, tx
	adi	r0, 1
	cmpi	r0, twidth	;exceed screen X limit
	jz	gd1
	stm	tx, r0		;inc TX
	jmp	gd0		;continue scanning
gdA:
	ldm	r0, tx
	adi	r0, 1
	cmpi	r0, xwidth	;exceed screen X limit
	jz	gd1
	stm	tx, r0		;inc TX
	jmp	gd0		;continue scanning

gd1:	adi	r1, 0		;test negative flag
	jz	gd2
	ldi	r1, 0
	sub	r1, r2
	mov	r2, r1		;negate r2
gd2:	stm	tnum, r2	;return num in TNUM
	pop	r4
	pop	r3
	pop	r2
	pop	r1
	pop	r0
	reti
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;get a hexadecimal unsigned number
;r3=input buffer pointer
;A number is terminated by a non-hex-digital char
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
geth:	ldi	r2, 0		;r2=accumulator
	adi	r3, 1
	adi	r4, 1
	stm	tx, r4
gd3:	ldr	r0, r3		;get char
	cmpi	r0, 0x30
	js	gd2		;< ASCII "0"
	cmpi	r0, 0x3A
	jns	gd5		;>= ASCII ":" 
	ldi	r4, 0xF
	and	r0, r4		;get 0-9
gd4:	ror	r2, 28		;advance one hex digit
	add	r2, r0		;accumulate
	adi	r3, 1		;inc pointer
	ldm	r0, vcntrl
	cmpi	r0, 1
	jnz	gdB		;VGA2
	ldm	r0, tx
	adi	r0, 1
	cmpi	r0, twidth	;exceed screen X limit
	jz	gd2		;exit if reach end of screen
	stm	tx, r0		;inc TX
	jmp	gd3
gdB:
	ldm	r0, tx
	adi	r0, 1
	cmpi	r0, xwidth	;exceed screen X limit
	jz	gd2		;exit if reach end of screen
	stm	tx, r0		;inc TX
	jmp	gd3

gd5:	cmpi	r0, A		;< ASCII "A"
	js	gd2
	cmpi	r0, G		;>= ASCII "G"
	jns	gd7
gd6:	ldi	r4, 0xF
	and	r0, r4		;get A-F
	ldi	r4, 9
	add	r0, r4		;add 9 for correct value
	jmp	gd4
gd7:	cmpi	r0, 0x61	;< ASCII "a"
	js	gd2
	cmpi	r0, 0x67	;>= ASCII "g"
	jns	gd2
	jmp	gd6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sys9: Print a number
;inputs: TNUM, TX, TY, FORMAT (0=dec, 1=hex)
;outputs: TX and TY holds new cursor position on screen
;The number display is correct up to (absolute value)
;9999999999 or 10^10 - 1.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sys9:	push	r0
	ldm	r0, format	;check format
	adi	r0, 0
	jnz	hex		;print hex numbers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Print a number in decimal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
dec:	push	r5		;print decimal numbers
	push	r6
	push	r7
	ldm	r5, TNUM	;copy number to r5
	adi	r5, 0		;check if negative number
	jns	pn0
	ldi	r6, 0
	sub	r6, r5
	mov	r5, r6		;negate r5
	ldi	r0, 0x2D
	stm	tascii, r0	;print '-' sign
	sys	putchar		
pn0:	ldi	r7, 1		;leading zero flag
	ldh	r6, 0x3B9A	;r6=current divisor=1000000000
	ldl	r6, 0xCA00	;10^9 digit
	call	pns
	ldh	r6, 0x05F5	;r6=current divisor=100000000
	ldl	r6, 0xE100	;10^8 digit
	call	pns
	ldh	r6, 0x0098	;r6=current divisor=10000000
	ldl	r6, 0x9680	;10^7 digit
	call	pns
	ldh	r6, 0x000F	;r6=current divisor=1000000
	ldl	r6, 0x4240	;10^6 digit
	call	pns
	ldh	r6, 0x0001	;r6=current divisor=100000
	ldl	r6, 0x86A0	;10^5 digit
	call	pns
	ldi	r6, 0x2710	;r6=current divisor=10000, 10^4 digit
	call	pns
	ldi	r6, 0x03E8	;r6=current divisor=1000, 10^3 digit
	call	pns
	ldi	r6, 0x0064	;r6=current divisor=100, 10^2 digit
	call	pns
	ldi	r6, 0x000A	;r6=current divisor=10, 10^1 digit
	call	pns
	adi	r5, 0x30
	stm	tascii, r5
	sys	putchar		;print the ones digit
	pop	r7
	pop	r6
	pop	r5
	pop	r0
	reti
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;subroutine examines and prints one digit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pns:	ldi	r0, 0		;initialize count
pns1:	sub	r5, r6
	js	pns2		;until result is negative
	adi	r0, 1		;not negative, +1
	jmp	pns1	
pns2:	add	r5, r6		;restore
	adi	r7, 0		;check leading zero flag
	jz	pns3
	adi	r0, 0
	jz	pns4		;do not print leading zeros
	ldi	r7, 0		;no more leading zero		
pns3:	adi	r0, 0x30	;make it ASCII
	stm	tascii, r0	;print one digit
	sys	putchar
pns4:	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Print a number in hexadecimal
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hex:	push	r1
	push	r2
	ldi	r0, 0x30	;print '0'
	stm	tascii, r0
	sys	putchar
	ldi	r0, 0x78	;print 'x'
	stm	tascii, r0
	sys	putchar
	ldm	r0, tnum
	ldh	r1, 0xF000
	ldl	r1, 0x0000
	and	r1, r0		;get the 8th digit
	ror	r1, 28
	call	prh		;print one digit
	ldh	r1, 0x0F00
	ldl	r1, 0x0000
	and	r1, r0		;get the 7th digit
	ror	r1, 24
	call	prh
	ldh	r1, 0x00F0
	ldl	r1, 0x0000
	and	r1, r0		;get the 6th digit
	ror	r1, 20
	call	prh
	ldh	r1, 0x000F
	ldl	r1, 0x0000
	and	r1, r0		;get the 5th digit
	ror	r1, 16
	call	prh
	ldh	r1, 0x0000
	ldl	r1, 0xF000
	and	r1, r0		;get the 4th digit
	ror	r1, 12
	call	prh
	ldi	r1, 0x0F00
	and	r1, r0		;get the 3rd digit
	ror	r1, 8
	call	prh
	ldi	r1, 0x00F0
	and	r1, r0		;get the 2nd digit
	ror	r1, 4
	call	prh
	ldi	r1, 0x000F
	and	r1, r0		;get the 1st digit
	call	prh
	pop	r2
	pop	r1
	pop	r0
	reti
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;subroutine prints one hex digit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prh:	cmpi	r1, 10
	jns	prh1		;>= 10?
	adi	r1, 0x30	;print 0-9
prh2:	stm	tascii, r1
	sys	putchar		
	ret	
prh1:	adi	r1, 0x37	;print A-F
	jmp	prh2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sysA: print out a string
;inputs: string = string pointer
;no register is affected
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sysA:	push 	r0
	push 	r1
	ldm	r1, string
ps:	ldr	r0, r1		;subroutine to print out a string
	cmpi	r0, 0x00	;check for end of string
	jz	pexit
	stm	tascii, r0
	sys	putchar		;print one character
	adi	r1, 1		;increment message pointer
	jmp	ps
pexit:	pop	r1
	pop	r0
	reti
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sysB: draw a line
;inputs: X1, Y1, X2, Y2, COLOR
;outputs: draw a line between (x1,y1) and (x2,y2)
;	  on graphic screen with color
;no register is affected
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sysB:	push	r0
	push	r1
	push	r2
	push	r4
	push	r5
	push	r6
lin:	ldm	r0, y1		;r0=y1
	ldm	r2, y2		;r2=y2
	sub	r2, r0		;r2=y2-y1
	jz	hln		;horizontal line subroutine
	mul	r2, r2		;r2=r2**2
	ldm	r0, x1		;r0=x1
	ldm	r1, x2		;r1=x2
	sub	r1, r0		;r1=x2-x1
	jz	vln		;vertical line subroutine
	mul	r1, r1		;r1=r1**2
	sub	r2, r1		;r2=(y2-y1)**2-(x2-x1)**2
	jns	ck1
	ldi	r2, 0x0000
	stm	steep, r2	;steep=0
	jmp	ck2
ck1:	ldi	r2, 0x0001
	stm	steep, r2	;steep=1
	ldm	r0, x1
	ldm	r1, y1
	stm	x1, r1
	stm	y1, r0		;swap(x1, y1)
	ldm	r0, x2
	ldm	r1, y2
	stm	x2, r1
	stm	y2, r0		;swap(x2, y2)
ck2:	ldm 	r0, x1
	ldm	r1, x2
	sub 	r0, r1		;r0=x1-x2
	js	lp0
	jz	lp0
	ldm	r0, x1
	ldm	r1, x2
	stm	x1, r1
	stm	x2, r0		;swap(x1, x2)
	ldm	r0, y1
	ldm	r1, y2
	stm	y1, r1
	stm	y2, r0		;swap(y1, y2)
lp0:	ldm	r1, x1
	ldm	r2, x2
	sub	r2, r1		;r2=x2-x1
	stm	deltax, r2
	ldm	r1, y1
	ldm	r2, y2
	sub	r2, r1		;r2=y2-y1
	jns	lp1
	ldi	r0, 0x0000
	sub	r0, r2		;r0=0-r2
	mov	r2, r0		;r2=abs(y2-y1)
lp1:	stm	deltay, r2
	ldm	r0, deltax
	ldh	r1, 0x0000
	ldl	r1, 0xffff
	ror	r0, 0x01
	and	r0, r1
	stm	error, r0
	ldm	r1, y1
	ldm	r2, y2
	sub 	r1, r2		;r1=y1-y2
	js	lp2
	ldi	r0, 0xFFFF
	stm	ystep, r0	;ystep=-1
	jmp	lp3
lp2:	ldi	r0, 0x0001
	stm	ystep, r0	;ystep=1
lp3:	ldm	r6, x2
	adi	r6, 0x0001
	stm	x2, r6		;x2=x2+1 for loop checking
	ldm	r1, x1		;r1=x=x1
	ldm	r2, y1		;r2=y=y1
lp4:	ldm	r0, steep
	adi	r0, 0x0000
	jz	draw
	mov	r4, r1
	mov	r1, r2
	mov	r2, r4		;swap x, y
	stm	GX, r1
	stm	GY, r2
	sys	pixel		;draw one pixel		
	mov	r4, r1
	mov	r1, r2
	mov	r2, r4		;swap x, y back
	jmp	lp5
draw:	stm	GX, r1
	stm	GY, r2
	sys	pixel		;draw one pixel
lp5:	ldm	r4, error
	ldm	r5, deltay
	sub	r4, r5		;error=error-deltay
	jns	next
	ldm	r6, ystep
	add	r2, r6		;y=y+ystep if error < 0
	ldm	r5, deltax
	add	r4, r5		;error=error+deltax
next:	stm	error, r4	;save back error
	adi	r1, 0x0001	;x=x+1
	ldm	r4, x2
	sub 	r4, r1
	jnz	lp4
lext:	pop	r6
	pop	r5
	pop	r4
	pop	r2
	pop	r1
	pop	r0
	reti
hln:	call	hlin		;call horizontal ine subroutine
	jmp	lext
vln:	call	vlin		;call vertical line subroutine
	jmp	lext
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;draws a horizontal line between (x1,y1) and (x2,y1)
;line color in "color"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hlin:	ldm	r0, x2		;r0=x2
	ldm	r1, x1		;r1=x1
	ldm	r2, y1		;r2=Y
	stm	GY, r2		;GY=y1=y2
	cmp 	r0, r1		;test x2-x1
	jns	hlp0	
	ldm	r1, x2		;swap(x1, x2)
	ldm	r0, x1		;if x2 < x1
hlp0:	stm	GX, r1		;update GX
	sys	pixel		;draw one pixel
	adi	r1, 0x0001	;x=x+1
	cmp 	r0, r1
	jns	hlp0		;if End point > X
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;draws a vertical line between (x1,y1) and (x1,y2)
;line color in "color"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
vlin:	ldm	r0, y2		;r0=y2
	ldm	r1, x1		;r1=X
	stm	GX, r1		;GX=x1=x2
	ldm	r2, y1		;r2=y1
	cmp 	r0, r2		;test y2-y1
	jns	vlp0	
	ldm	r2, y2		;swap(y1, y2)
	ldm	r0, y1		;if y2 < y1
vlp0:	stm	GY, r2		;update GY
	sys	pixel		;draw one pixel
	adi	r2, 0x0001	;y=y+1
	cmp 	r0, r2
	jns	vlp0		;if End point > Y
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sysC: draw a rectangle
;inputs: X1, Y1, X2, Y2, COLOR
;outputs: draw a rectangle between (x1,y1) and (x2,y2)
;		on graphic screen with color
;no register is affected
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sysC:	push	r0
	push	r1
	push	r2
	push	r3
	call	hlin		;draw line (x1, y1) to (x2, y1)
	ldm	r3, y1		;save y1 to r3
	ldm	r1, y2
	stm	y1, r1		;replace y1 with y2
	call	hlin		;draw line (x1, y2) to (x2, y2)
	stm	y1, r3		;restore y1
	call	vlin		;draw line (x1, y1) to (x1, y2)
	ldm	r3, x1		;save x1 to r3
	ldm	r1, x2
	stm	x1, r1		;replace x1 with x2
	call	vlin		;draw line (x2, y1) to (x2, y2)
	stm	x1, r3		;restore x1
	pop	r3
	pop	r2
	pop	r1
	pop	r0
	reti
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sysD: draw a circle
;inputs: X1, Y1, RAD, COLOR
;outputs: draw a circle with mid-point (x1,y1) and 
;		radius=RAD on graphic screen with color
;no register is affected
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sysD:	push	r0
	push	r1
	push	r2
	push	r4
	push	r5
	push	r6
circ:	ldm	r1, x1		;r1=x1
	ldm	r2, y1		;r2=y1
	ldm	r4, rad		;r4=radius
	add	r2, r4		;r2=y1+radius
	stm	GX, r1
	stm	GY, r2
	sys	pixel		;draw at (x1, y1+rad)
	ldm	r2, y1
	sub	r2, r4		;r2=y1-radius
	stm	GY, r2
	sys	pixel		;draw at (x1, y1-rad)
	ldm	r2, y1
	ldm	r1, x1
	add	r1, r4		;r1=x1+radius
	stm	GX, r1
	stm	GY, r2
	sys	pixel		;draw at (x1+rad, y1)
	ldm	r1, x1
	sub	r1, r4		;r1=x1-radius
	stm	GX, r1
	sys	pixel		;draw at (x1-rad, y1)
	;
	ldi	r5, 0x0000	;r5=x=0
	ldm	r6, rad		;r6=y=radius
	ldi	r0, 0x0001
	sub	r0, r6		;cf=1-radius
	stm	cf, r0
	ldi	r0, 0x0001	;ddfx=1
	stm	ddfx, r0
	ldi	r0, 0xfffe
	mul	r0, r6
	stm	ddfy, r0	;ddfy= -2 * radius
	;
cir1:	mov	r0, r5
	sub	r0, r6		;r0=x-y
	jns	done		;done if x-y>=0
	ldm	r4, cf
	adi	r4, 0x0000
	jns	yinc		;if cf >= 0
	;
	adi	r5, 0x0001	;x++
	ldm	r0, ddfx
	adi	r0, 0x0002	;ddf_x += 2
	stm	ddfx, r0
	ldm	r4, cf
	add	r4, r0		;cf += ddf_x
	stm	cf, r4
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
drw:	ldm	r1, x1		;r1=x1
	ldm	r2, y1		;r2=y1
	add	r1, r5		;X=x1+x
	add	r2, r6		;Y=y1+y
	stm	GX, r1
	stm	GY, r2
	sys	pixel		;draw at (x1+x, y1+y)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r1, x1
	sub	r1, r5		;X=x1-x
	stm	GX, r1
	sys	pixel		;draw at (x1-x, y1+y)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r1, x1
	ldm	r2, y1
	add	r1, r5		;X=x1+x
	sub	r2, r6		;Y=y1-y
	stm	GX, r1
	stm	GY, r2
	sys	pixel		;draw at (x1+x, y1-y)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r1, x1
	sub	r1, r5		;X=x1-x
	stm	GX, r1
	sys	pixel		;draw at (x1-x, y1-y)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r1, x1		;r1=x1
	ldm	r2, y1		;r2=y1
	add	r1, r6		;X=x1+y
	add	r2, r5		;Y=y1+x
	stm	GX, r1
	stm	GY, r2
	sys	pixel		;draw at (x1+y, y1+x)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r1, x1
	sub	r1, r6		;X=x1-y
	stm	GX, r1
	sys	pixel		;draw at (x1-y, y1+x)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r1, x1
	ldm	r2, y1
	add	r1, r6		;X=x1+y
	sub	r2, r5		;Y=y1-x
	stm	GX, r1
	stm	GY, r2
	sys	pixel		;draw at (x1+y, y1-x)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r1, x1
	sub	r1, r6		;X=x1-y
	stm	GX, r1
	sys	pixel		;draw at (x1-y, y1-x)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	jmp	cir1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
yinc:	adi	r6, 0xffff	;y--
	ldm	r0, ddfy
	adi	r0, 0x0002	;ddf_y += 2
	stm	ddfy, r0
	ldm	r4, cf
	add	r4, r0		;f += dff_y
	stm	cf, r4
	jmp	drw
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
done:	pop	r6
	pop	r5
	pop	r4
	pop	r2
	pop	r1
	pop	r0
	reti			;circle complete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sysE: draw a solid circle
;inputs: X1, Y1, RAD, COLOR
;outputs: draw a solid circle with mid-point (x1,y1) and 
;	  radius=RAD on graphic screen with filled color
;no register is affected
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sysE:	push	r0
	push	r1
	push	r2
	push	r4
	push	r5
	push	r6
scrc:	ldm	r1, x1		;r1=x1
	stm	tmpx, r1
	ldm	r2, y1		;r2=y1
	stm	tmpy, r2
	ldm	r4, rad		;r4=radius
	add	r2, r4		;r2=y1+radius
	stm	GX, r1
	stm	GY, r2
	sys	pixel		;draw at (x1, y1+rad)
	ldm	r2, y1
	sub	r2, r4		;r2=y1-radius
	stm	GY, r2
	sys	pixel		;draw at (x1, y1-rad)
	ldm	r1, x1
	add	r1, r4
	stm	x2, r1		;x2=x1+radius	
	ldm	r1, x1
	sub	r1, r4
	stm	x1, r1		;x1=x1-radius	
	call	hlin		;hline (x1-rad, y1) to (x1+rad, y1)
	;
	ldi	r5, 0x0000	;r5=x=0
	ldm	r6, rad		;r6=y=radius
	ldi	r0, 0x0001
	sub	r0, r6		;cf=1-radius
	stm	cf, r0
	ldi	r0, 0x0001	;ddfx=1
	stm	ddfx, r0
	ldi	r0, 0xfffe
	mul	r0, r6
	stm	ddfy, r0	;ddfy= -2 * radius
	;
scr1:	mov	r0, r5
	sub	r0, r6		;r0=x-y
	jns	scd		;done if x-y>=0
	ldm	r4, cf
	adi	r4, 0x0000
	jns	syi		;if cf >= 0
	;
	adi	r5, 0x0001	;x++
	ldm	r0, ddfx
	adi	r0, 0x0002	;ddf_x += 2
	stm	ddfx, r0
	ldm	r4, cf
	add	r4, r0		;cf += ddf_x
	stm	cf, r4
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sdrw:	ldm	r1, tmpx	;r1=x1
	ldm	r2, tmpy	;r2=y1
	add	r1, r5		;X=x1+x
	add	r2, r6		;Y=y1+y
	stm	x2, r1
	stm	y1, r2
	ldm	r1, tmpx
	sub	r1, r5		;X=x1-x
	stm	x1, r1
	call	hlin		;hline (x1-x, y1+y) to (x1+x, y1+y)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r2, tmpy
	sub	r2, r6		;Y=y1-y
	stm	y1, r2
	call	hlin		;hline (x1-x, y1-y) to (x1+x, y1-y)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r1, tmpx	;r1=x1
	ldm	r2, tmpy	;r2=y1
	add	r1, r6		;X=x1+y
	add	r2, r5		;Y=y1+x
	stm	x2, r1
	stm	y1, r2
	ldm	r1, tmpx
	sub	r1, r6		;X=x1-y
	stm	x1, r1
	call	hlin		;hline (x1-y, y1+x) to (x1+y, y1+x)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r2, tmpy
	sub	r2, r5		;Y=y1-x
	stm	y1, r2
	call	hlin		;hline (x1-y, y1-x) to (x1+y, y1-x)
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	jmp	scr1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
syi:	adi	r6, 0xffff	;y--
	ldm	r0, ddfy
	adi	r0, 0x0002	;ddf_y += 2
	stm	ddfy, r0
	ldm	r4, cf
	add	r4, r0		;f += dff_y
	stm	cf, r4
	jmp	sdrw
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
scd:	ldm	r1, tmpx
	stm	x1, r1		;restore x1
	ldm	r2, tmpy
	stm	y1, r2		;restore y1
	pop	r6
	pop	r5
	pop	r4
	pop	r2
	pop	r1
	pop	r0
	reti			;solid circle complete
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;sysF: dump all register contents
;input: FORMAT (0=dec, 1=hex)
;display on bottom right corner of text video
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sysF:	push	r0
	push	r1
	push	r2
	stm	tmp0, r0	;save r0, r1 and r2
	stm	tmp1, r1
	stm	tmp2, r2
	ldm	r0, TX		;save TX
	stm	tmpx, r0
	ldm	r0, TY		;save TY
	stm	tmpy, r0
	ldm	r0, tascii
	stm	tmpa, r0	;save TASCII
	ldm	r0, tnum
	stm	tmpn, r0	;save TNUM
	ldi	r0, 0x20	;space to erase
	stm	tascii, r0
	ldi	r1, 0		
	stm	ty, r1		;starts from TY=0

	ldm	r0, vcntrl
	cmpi	r0, 1
	jnz	regA		;VGA2
rg10:	ldi	r1, tdumpw	;erase from X=twidth - 15		
	stm	tx, r1
rg11:	sys	putchar
	ldm	r1, tx
	cmpi	r1, 0		;end of line? (wrap around to next line)
	jnz	rg11
	ldm	r1, ty
	cmpi	r1, thm1	;theight - 1
	jnz	rg10		;stop at last line to avoid scroll
	ldi	r2, 0		;register # count
	jmp	reg0
regA:
rg20:	ldi	r1, xdumpw	;erase from X=twidth - 15		
	stm	tx, r1
rg21:	sys	putchar
	ldm	r1, tx
	cmpi	r1, 0		;end of line? (wrap around to next line)
	jnz	rg21
	ldm	r1, ty
	cmpi	r1, xhm1	;theight - 1
	jnz	rg20		;stop at last line to avoid scroll
	ldi	r2, 0		;register # count

reg0:	ldm	r0, vcntrl
	cmpi	r0, 1
	jnz	regB		;VGA2
	ldi	r1, tdumpw
	stm	tx, r1
	ldi	r1, tdumph	;tdumph = theight - 9
	add	r1, r2		;print at bottom right
	stm	ty, r1
	ldi	r0, 0x20	;space to erase
	stm	tascii, r0
	ldi	r1, 0	
rg1:	sys	putchar
	ldm	r1, tx
	cmpi	r1, tmw3	;end of line?
	jnz	rg1
	ldi	r1, tdumpw1	;tdumpw+1
	stm	tx, r1
	jmp	rg1b
regB:
	ldi	r1, xdumpw
	stm	tx, r1
	ldi	r1, xdumph	;tdumph = theight - 9
	add	r1, r2		;print at bottom right
	stm	ty, r1
	ldi	r0, 0x20	;space to erase
	stm	tascii, r0
	ldi	r1, 0	
rg1a:	sys	putchar
	ldm	r1, tx
	cmpi	r1, xmw3	;end of line?
	jnz	rg1a
	ldi	r1, xdumpw1	;tdumpw+1
	stm	tx, r1

rg1b:	ldi	r0, R		;'R'
	stm	tascii, r0		
	sys	putchar
	ldi	r0, 0x30
	add	r0, r2
	stm	tascii, r0	;register number
	sys	putchar			
	ldi	r0, 0x3D	;'='
	stm	tascii, r0
	sys	putchar
	cmpi	r2, 0
	jnz	reg1
	ldm	r0, tmp0
	stm	tnum, r0	;restore r0 to print
	jmp	reg8
reg1:	cmpi	r2, 1		;switch(r2)
	jnz	reg2
	ldm	r0, tmp1
	stm	tnum, r0	;restore r1 to print
	jmp	reg8
reg2:	cmpi	r2, 2
	jnz	reg3
	ldm	r0, tmp2
	stm	tnum, r0	;restore r2 to print
	jmp	reg8
reg3:	cmpi	r2, 3
	jnz	reg4
	stm	tnum, r3
	jmp	reg8
reg4:	cmpi	r2, 4
	jnz	reg5
	stm	tnum, r4
	jmp	reg8
reg5:	cmpi	r2, 5
	jnz	reg6
	stm	tnum, r5
	jmp	reg8
reg6:	cmpi	r2, 6
	jnz	reg7
	stm	tnum, r6
	jmp	reg8
reg7:	stm	tnum, r7
reg8:	sys	printn		;print register content
	adi	r2, 1
	cmpi	r2, 8
	jnz	reg0
reg9:	ldm	r0, tmpy	;restore TY
	stm	ty, r0
	ldm	r0, tmpx	;restore TX
	stm	tx, r0
	ldm	r0, tmpa
	stm	tascii, r0	;restore TASCII
	ldm	r0, tmpn
	stm	tnum, r0	;restore TNUM
	pop	r2
	pop	r1
	pop	r0
	reti
