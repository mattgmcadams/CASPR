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
;Program variables;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define	x3d1	0x0800	;for 3d line subroutine
.define y3d1	0x0801
.define	z3d1	0x0802
.define	x3d2	0x0803
.define	y3d2	0x0804
.define	z3d2	0x0805	
.define PRNG	0x0806	;LFSR random number
.define b3dx	0x0807	;base X for 3d plots
.define pmt	0x080D	;ASCII for prompt
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
.define h0	0x0869	;hash value 0
.define h1	0x086A	;hash value 1
.define h2	0x086B	;hash value 2
.define h3	0x086C	;hash value 3
.define h4	0x086D	;hash value 4
.define h5	0x086E	;hash value 5
.define h6	0x086F	;hash value 6
.define h7	0x0870	;hash value 7
.define t1	0x0871	;temporary value 1
.define t2	0x0872	;temporary value 2
;Program constants;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define vmode	4	;text only video mode
.define gmode	6	;graphic only mode
.define svmode	7	;text XOR graphic video mode
.define up	0x10	;gesture up
.define left	0x14	;gesture left
.define down	0x18	;gesture down
.define right	0x1C	;gesture right
.define zin	0x48	;gesture zoom in
.define zout	0x49	;gesture zoom out
.define hmin	518	;frame corners
.define hmax	778
.define vmin	182
.define vmax	442
.define basex	520	;screen X of (0,0)
.define basey	440	;screen Y of (0,0)
.define hmin2	208	;frame corners #2
.define hmax2	468
.define basex2	210	;screen X of (0,0) #2
.define b3dx1	599	;screen X of (0,0,0)
.define b3dy	440	;screen Y of (0,0,0)
.define b3dx2	200	;screen X of (0,0,0) # 2
.define fmin	0	;0 for frame min
.define fmax	199	;200 for frame max
.define white	0xFF	;white color
.define gray	0x92	;gray color
.define seed	0xABC	;LFSR seed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
init:	ldi	r0, svmode	;system video mode
	stm	vcntrl, r0	;video=text XOR graphic
	ldi	r0, 0
	stm	format, r0	;format=Decimal
	ldi	r0, 0x7F
	stm	cursor, r0	;cursor=0x7F
	ldi	r0, 0x3E
	stm	pmt, r0		;initial prompt='>'
	sys	clear		;clear text video
	sys	clearg		;clear graphic screen
	ldi	r1, 0		;initial screen position	
	stm	tx, r1		;TX=0
	stm	ty, r1		;TY=0
	ldi	r1, 7
	stm	prompt, r1	;prompt length=7
top:	ldi	r0, name	;r0 = *name
	stm	string, r0
	sys	prints
	ldm	r0, pmt		;
	stm	tascii, r0	;print pmt
	sys	putchar
	ldi	r0, 0x20
	stm	tascii, r0	;print space
	sys	putchar		;prompt is "> "
	sys	textp		;get next text video pointer
	ldm	r2, taddr
	ldm	r0, cursor	;put cursor on screen
	str	r2, r0		;do not use sys putchar
kbd:	sys	getln		;input a line
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Examine input for legal commands
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r0, tx
	stm	tmpx, r0	;save current TX
	ldi	r5, cmd		;r5 = *cmd
chk1:	ldr	r2, r5		;r2 = mem(cmd)
	cmpi	r2, 0		;end of command table
	jz	done
	ldm	r3, prompt
	stm	tx, r3		;move TX to PROMPT position
	sys	textp
	ldm	r1, taddr	;get screen pointer
	call	strcmp
	cmpi	r7, 0
	jnz	chk2		;get number if match
	adi	r5, 1		;next tablel entry (command)
	jmp	chk1
chk2:	cmpi	r5, cmd		;command 1? prompt
	jz	ex1
	adi	r5, 0xFFFF	;decrement r5
	cmpi	r5, cmd		;command 2? cursor
	jz	ex2
	adi	r5, 0xFFFF		
	cmpi	r5, cmd		;command 3? home
	jz	ex3	
	adi	r5, 0xFFFF		
	cmpi	r5, cmd		;command 4? clear
	jz	ex4
	adi	r5, 0xFFFF		
	cmpi	r5, cmd		;command 5? color
	jz	ex5
	adi	r5, 0xFFFF		
	cmpi	r5, cmd		;command 6? line
	jz	ex6
	adi	r5, 0xFFFF		
	cmpi	r5, cmd		;command 7? rect
	jz	ex7
	adi	r5, 0xFFFF			
	cmpi	r5, cmd		;command 8? srect
	jz	ex8
	adi	r5, 0xFFFF		
	cmpi	r5, cmd		;command 9? circle
	jz	ex9
	adi	r5, 0xFFFF		
	cmpi	r5, cmd		;command 10? scircle
	jz	exa
	adi	r5, 0xFFFF		
	cmpi	r5, cmd		;command 11? calculator
	jz	exb
	adi	r5, 0xFFFF		
	cmpi	r5, cmd		;command 12? hash
	jz	exc
	adi	r5, 0xFFFF		
	cmpi	r5, cmd		;command 13? rand2d
	jz	exd
	adi	r5, 0xFFFF		
	cmpi	r5, cmd		;command 14? rand3d
	jz	exe
	adi	r5, 0xFFFF		
	cmpi	r5, cmd		;command 15? paint
	jz	exf
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
done:	ldm	r0, tmpx
	stm	tx, r0		;restore TX
	ldi	r0, 0x0D		
	stm	tascii, r0	;CR=0x0D
	sys	putchar		;print the CR manually
	jmp	top		;TX is reset back to 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;subroutine to compare two strings
;inputs: 	r1=string pointer from screen
;		r2=string pointer #2 in upper-case
;outputs:	r7=0 for no match; =1 for match
;		r4=matched string length+1
;register used: r0, r1, r2, r3, r4, r7
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strcmp:
	ldi	r4, 0		;count length
	ldi	r7, 0		;match flag (=0 no match, 1=match)
str0:	ldr	r0, r1		;get char from screen
	ldr	r3, r2		;get char from string
	cmpi	r3, 0x00	;reach null?
	jz	str3
	cmp	r0, r3
	jnz	str2
str5:	adi	r1, 1		;next char on screen
	adi	r2, 1		;next char from string
	adi	r4, 1		;inc length count
	jmp	str0
str2:	adi	r3, 0x20	;+0x20 to check lower-case
	cmp	r0, r3
	jz	str5		;match lower-case	
	jmp	str4		;no match is found
str3:	adi	r4, 1		;add 1 to skip to next string
	adi	r7, 1		;found a match
str4:	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Executions of commands are aggregated here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ex1:	call	gt1		;prompt
	stm	pmt, r1		;update new prompt
	jmp	done
ex2:	call	gt1		;cursor
	stm	cursor, r1	;update new cursor
	jmp	done
ex3:	ldi	r0, 0x7F	;Home
	stm	cursor, r0	;cursor=0x7F
	ldi	r0, 0x3E
	stm	pmt, r0		;initial prompt='>'
	sys	clear		;clear text video
	ldi	r1, 0		;initial screen position	
	stm	tx, r1		;TX=0
	stm	ty, r1		;TY=0
	ldi	r1, 7
	stm	prompt, r1	;prompt length=7
	jmp	top
ex4:	sys	clearg		;clear
	jmp	done
ex5:	call	gt1		;color n
	stm	color, r1	;update new color
	jmp	done
ex6:	call	gt4		;line x1 y1 x2 y2
	sys	line
	jmp	done
ex7:	call	gt4		;rect(angle) x1 y1 x2 y2
	sys	rect
	jmp	done
ex8:	call	gt4		;srect (solid rec) x1 y1 x2 y2
	ldm	r0, x1
	ldm	r1, y1
	ldm	r2, x2
	ldm	r3, y2
sr:	stm	x1, r0
	stm	y1, r1
	stm	x2, r2
	stm	y2, r1
	sys	line
	adi	r1, 1
	cmp	r3, r1
	jns	sr
	jmp	done
ex9:	call	gt3		;circle x1 y1 rad
	sys	circle
	jmp	done
exA:	call	gt3		;solid circle x1 y1 rad
	sys	scircle
	jmp	done
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;subrountine to get one number after command
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gt1:	ldm	r3, prompt
	add	r3, r4
	stm	tx, r3		;advanced to the number
	sys	getnum
	ldm	r1, tnum
	ret	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;subrountine to get three numbers after command
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gt3:	ldm	r3, prompt
	add	r3, r4
	stm	tx, r3		;advanced to the number
	sys	getnum
	ldm	r1, tnum
	stm	x1, r1		;obtained X1
	ldm	r3, tx
	adi	r3, 1		;skip one space
	stm	tx, r3
	sys	getnum
	ldm	r1, tnum
	stm	y1, r1		;obtained Y1
	ldm	r3, tx
	adi	r3, 1		;skip one space
	stm	tx, r3
	sys	getnum
	ldm	r1, tnum
	stm	rad, r1		;obtained RAD
	ret	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;subrountine to get four numbers after command
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gt4:	ldm	r3, prompt
	add	r3, r4
	stm	tx, r3		;advanced to the number
	sys	getnum
	ldm	r1, tnum
	stm	x1, r1		;obtained X1
	ldm	r3, tx
	adi	r3, 1		;skip one space
	stm	tx, r3
	sys	getnum
	ldm	r1, tnum
	stm	y1, r1		;obtained Y1
	ldm	r3, tx
	adi	r3, 1		;skip one space
	stm	tx, r3
	sys	getnum
	ldm	r1, tnum
	stm	x2, r1		;obtained X2
	ldm	r3, tx
	adi	r3, 1		;skip one space
	stm	tx, r3
	sys	getnum
	ldm	r1, tnum
	stm	y2, r1		;obtained Y2
	ret	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Strings and lookup table definitions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
name:	byte	R		;string name="Rhody"
	byte	0x68		;'h'
	byte	0x6F		;'o'
	byte	0x64		;'d'
	byte	0x79		;'y'
	byte	0x00		;null character to terminate string
quit:	byte	Q		;string "QUIT" for calculator
	byte	U
	byte	I
	byte	T
	byte	0x00
error:				;string "ERROR" for calculator
	byte	E
	byte	R
	byte	R
	byte	O
	byte	R
	byte	0x00
cmd1:	byte	P		;cmd1=PROMPT
	byte	R
	byte	O
	byte	M
	byte	P
	byte	T
	byte	0x00
cmd2:	byte	C		;cmd2=CURSOR
	byte	U
	byte	R
	byte	S
	byte	O
	byte	R
	byte	0x00
cmd3:	byte	H		;cmd3=HOME
	byte	O
	byte	M
	byte	E
	byte	0x00
cmd4:	byte	C		;cmd4=CLEAR
	byte	L
	byte	E
	byte	A
	byte	R
	byte	0x00
cmd5:	byte	C		;cmd5=COLOR
	byte	O
	byte	L
	byte	O
	byte	R
	byte	0x00
cmd6:	byte	L		;cmd6=LINE
	byte	I
	byte	N
	byte	E
	byte	0x00
cmd7:	byte	R		;cmd7=RECT
	byte	E
	byte	C
	byte	T
	byte	0x00
cmd8:	byte	S		;cmd8=SRECT
	byte	R
	byte	E
	byte	C
	byte	T
	byte	0x00
cmd9:	byte	C		;cmd9=CIRCLE
	byte	I
	byte	R
	byte	C
	byte	L
	byte	E
	byte	0x00
cmdA:	byte	S		;cmdA=SCIRCLE
	byte	C
	byte	I
	byte	R
	byte	C
	byte	L
	byte	E
	byte	0x00
cmdB:	byte	C		;cmdB=CALCULATOR
	byte	A
	byte	L
	byte	C
	byte	U
	byte	L
	byte	A
	byte	T
	byte	O
	byte	R
	byte	0x00
cmdC:	byte	H		;cmdC=HASH
	byte	A
	byte	S
	byte	H
	byte	0x00
cmdD:	byte	R		;cmdD=RAND2D
	byte	A
	byte	N
	byte	D
	byte	0x32
	byte	D
	byte	0x00
cmdE:	byte	R		;cmdE=RAND3D
	byte	A
	byte	N
	byte	D
	byte	0x33
	byte	D
	byte	0x00
cmdF:	byte	P		;cmdF=PAINT
	byte	A
	byte	I
	byte	N
	byte	T
	byte	0x00
cmd:	word	cmd1		;address of cmd1
	word	cmd2		;address of cmd2
	word	cmd3		;address of cmd3
	word	cmd4		;address of cmd4
	word	cmd5		;address of cmd5
	word	cmd6		;address of cmd6
	word	cmd7		;address of cmd7
	word	cmd8		;address of cmd8
	word	cmd9		;address of cmd9
	word	cmdA		;address of cmdA
	word	cmdB		;address of cmdB
	word	cmdC		;address of cmdC
	word	cmdD		;address of cmdD
	word	cmdE		;address of cmdE
	word	cmdF		;address of cmdF
	byte	0x00		;null character to terminate table
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Calculator: command line calculator Environment
;	input format: operand1 operator operand2
;	operators: +, -, *
;	next line: results, or ERROR
;Exit on command "QUIT" -> return to Rhody CLI environment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
exB:	ldm	r0, tmpx
	stm	tx, r0		;restore TX
	ldi	r0, 0x0D		
	stm	tascii, r0	;CR=0x0D
	sys	putchar		;print the CR manually
	sys	putchar		;extra line for result
	ldi	r1, 12		;change prompt length
	stm	prompt, r1	;prompt length=12
	ldm	r1, cursor
	stm	tmpc, r1	;save original cursor
	ldi	r1, 0x5F
	stm	cursor, r1	;forced cursor to '_'
exa1:	ldi	r0, cmdB	;r0 = *cmdB
	stm	string, r0
	sys	prints
	ldi	r0, 0x3F	;forced prompt to '?'
	stm	tascii, r0	;print '?'
	sys	putchar
	ldi	r0, 0x20
	stm	tascii, r0	;print space
	sys	putchar		;prompt is "? "
	sys	textp		;get next text video pointer
	ldm	r2, taddr
	ldm	r0, cursor	;put cursor on screen
	str	r2, r0		;do not use sys putchar
kbdc:	sys	getln		;input a line for calculator
	ldm	r0, tx
	stm	tmpx, r0	;save current TX
	ldm	r3, prompt
	stm	tx, r3		;move TX to PROMPT position
	sys	textp
	ldm	r1, taddr	;get screen pointer
	ldi	r2, quit	;r2 = *quit
	call	strcmp
	cmpi	r7, 0
	jnz	exaE		;quit calculator if match
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r3, prompt	;reset screen pointer
	stm	tx, r3		;move TX to PROMPT position
	sys	textp
	ldm	r1, taddr	;get screen pointer
exa2:	ldr	r0, r1
	cmpi	r0, 0x20	;skip all spaces
	jnz	exa3
	adi	r1, 1		;inc screen pointer
	adi	r3, 1		;inc temporary TX holder
	jmp	exa2
exa3:	stm	tx, r3		;TX of the first non-space char
	sys	getnum		;get operand1
	ldm	r5, tnum	;r5=operand1
	ldm	r3, tx		;r3=temporary TX holder
	sys	textp
	ldm	r1, taddr	;get screen pointer
exa4:	ldr	r0, r1
	cmpi	r0, 0x20	;skip all spaces
	jnz	exa5
	adi	r1, 1		;inc screen pointer
	adi	r3, 1		;inc temporary TX holder
	jmp	exa4
exa5:	mov	r7, r0		;r7=operator
	adi	r3, 1
	stm	tx, r3		;TX points to after operator
	sys	textp
	ldm	r1, taddr	;get screen pointer
exa6:	ldr	r0, r1
	cmpi	r0, 0x20	;skip all spaces
	jnz	exa7
	adi	r1, 1		;inc screen pointer
	adi	r3, 1		;inc temporary TX holder
	jmp	exa6
exa7:	stm	tx, r3		;TX of the first non-space char
	sys	getnum		;get operand2
	ldm	r6, tnum	;r6=operand2
	ldm	r0, tmpx
	stm	tx, r0		;restore TX
	ldi	r0, 0x0D		
	stm	tascii, r0	;CR=0x0D
	sys	putchar		;print the CR manually
	ldi	r0, 0x20
	stm	tascii, r0	
	ldi	r1, 0
exa8:	sys	putchar		;print 12 leading spaces
	adi	r1, 1
	cmpi	r1, 12
	jnz	exa8
	cmpi	r7, 0x2B	;operator="+"?
	jz	exaA
	cmpi	r7, 0x2D	;operator="-"?
	jz	exaB
	cmpi	r7, 0x2A	;operator="*"?
	jz	exaC
	ldi	r0, error	;print error message
	stm	string, r0
	sys	prints
exa9:	ldi	r0, 0x0D		
	stm	tascii, r0	;CR=0x0D
	sys	putchar		;print the CR manually
	sys	putchar		;extra line for result
	jmp	exa1		;continue
exaA:	add	r5, r6
	jmp	exaD
exaB:	sub	r5, r6
	jmp	exaD
exaC:	mul	r5, r6
exaD:	ldi	r0, 0x3D	
	stm	tascii, r0	
	sys	putchar		;print '='
	ldi	r0, 0x20		
	stm	tascii, r0	
	sys	putchar		;print space
	stm	tnum, r5
	sys	printn		;print the result
	jmp	exa9		;operation completes
exaE:	ldm	r0, tmpx
	stm	tx, r0		;restore TX
	ldi	r0, 0x0D		
	stm	tascii, r0	;CR=0x0D
	sys	putchar		;print the CR manually
	sys	putchar		;extra line for result
	ldi	r1, 7		;change prompt length back
	stm	prompt, r1	;prompt length=7
	ldm	r1, tmpc
	stm	cursor, r1	;restore original cursor
	jmp	top
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SHA256: command line SHA-256 Environment
;	input format: ASCII string ends with 0x0D
;	return: 256-bit message diget
;Exit on command "QUIT" -> return to Rhody environment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
exC:	ldm	r0, tmpx
	stm	tx, r0		;restore TX
	ldi	r0, 0x0D		
	stm	tascii, r0	;CR=0x0D
	sys	putchar		;print the CR manually
	sys	putchar		;extra line for result
	ldm	r1, cursor
	stm	tmpc, r1	;save original cursor
	ldi	r1, 0x5F
	stm	cursor, r1	;forced cursor to '_'
	ldi	r1, 9
	stm	prompt, r1	;prompt length=9
has1:	ldi	r0, SHA		;r0 = *SHA
	stm	string, r0
	sys	prints
	ldi	r0, 0x23	;prompt is '#'
	stm	tascii, r0	;print '#'
	sys	putchar
	ldi	r0, 0x20
	stm	tascii, r0	;print space
	sys	putchar		;prompt is "# "
	sys	textp		;get next text video pointer
	ldm	r2, taddr
	ldm	r0, cursor	;put cursor on screen
	str	r2, r0		;do not use sys putchar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	sys	getln		;input a line to hash
	ldm	r0, tx
	stm	tmpx, r0	;save current TX
	sys	textp
	ldm	r0, taddr
	stm	lend, r0	;save end of line screen address
	ldm	r3, prompt
	stm	tx, r3		;move TX to PROMPT position
	sys	textp
	ldm	r1, taddr	;get screen pointer
	ldi	r2, hquit	;r2 = *hquit
	call	strcmp
	cmpi	r7, 0
	jnz	exaE		;use quit in "calculator"
	call	preprocess	;message check length and preprocessing
	cmpi	r7, 0
	jz	has2
	call	too_long	;message is too long
	jmp	has1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;At this point, we have the message padded to 512-bit message format
;m512 is the 16-words input buffer
;Call the actual HASH subroutine
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
has2:	call	HASH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Put the CR out finally and print out the hash
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r0, tmpx
	stm	tx, r0		;restore TX
	ldi	r0, 0x0D		
	stm	tascii, r0	;CR=0x0D
	sys	putchar		;print the CR manually
	sys	putchar		;extra line for HASH values
	call	printhash	
	sys	putchar		;extra line
	jmp	has1		;operation completes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;subroutine to preprocess input text
;common to both HASH and BITCOIN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
preprocess:
	ldm	r3, prompt	;reset screen pointer
	stm	tx, r3		;move TX to PROMPT position
	sys	textp
	ldm	r1, taddr	;get screen pointer
sha2:	ldr	r0, r1
	cmpi	r0, 0x20	;skip all spaces
	jnz	sha3
	adi	r1, 1		;inc screen pointer
	adi	r3, 1		;inc temporary TX holder
	jmp	sha2
;clear message buffer;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sha3:	ldi	r5, m512
	ldi	r2, 16
	ldi	r0, 0
cbf:	str	r5, r0		;clear message buffer	
	adi	r5, 1
	adi	r2, 0xFFFF
	jnz	cbf
;check message length;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	stm	tx, r3		;TX of the first non-space char
	sys	textp
	ldm	r3, taddr	;r3=input line starting address
	ldm	r4, lend	;r4=end of line screen address
	mov	r0, r4
	sub	r0, r3		;calculate message length
	jz	empty
	cmpi	r0, 33
	jns	too_long1	;message too long
	jmp	normal		;normal operations
;if the string is empty fill in 0x80 and go to "schedule"
empty:
	ldh	r0, 0x8000	;add "end" bit
	ldl	r0, 0x0000
	stm	m512, r0	;rest of the message are all '0's
	jmp	mpd5		;go directly to hashing schedule
;if message is too long set R7=1
too_long1:
	ldi	r7, 1
	ret			;retuen R7=1
;Preprocessing the 512-bit message
normal:
	ldi	r1, 8		;8-bit per character
	mul	r0, r1
	ldi	r5, m512
	adi	r5, 0xF		;last message buffer location
	str	r5, r0
	ldi	r5, m512	;512-bit message buffer pointer
sha4:	ldi	r2, 4		;count for four byte
	ldi	r0, 0		;r0=four-byte container
sha5:	ldr	r1, r3		;r1=on screen ASCII
	ror	r0, 24		;r0=rotate left by 8
	or	r0, r1
	adi	r3, 1		;inc screen pointer
	cmp	r3, r4
	jz	sha6		;exit when end of line
	adi	r2, 0xFFFF	;count=count-1
	jnz	sha5
	str	r5, r0		;save to message buffer
	adi	r5, 1
	jmp	sha4
;Message ends; add end bit;;;;;;;;;;;;;;;;;;;;;;;;;
sha6:	cmpi	r2, 4
	jz	mpd4
	cmpi	r2, 3
	jz	mpd3
	cmpi	r2, 2
	jz	mpd2
	str	r5, r0		;message length divisible by 4
	ldh	r0, 0x8000
	ldl	r0, 0		;end bit added
	adi	r5, 1
	jmp	sha7
mpd2:	ror	r0, 24
	adi	r0, 0x80	;add end bit to last byte
	jmp	sha7
mpd3:	ror	r0, 24
	adi	r0, 0x80
	ror	r0, 24		;add end bit to 2nd to last byte
	jmp	sha7		
mpd4:	ror	r0, 24
	adi	r0, 0x80
	ror	r0, 16		;add end bit to 2nd byte
	jmp	sha7
sha7:	str	r5, r0
mpd5:	ldi	R7, 0		;return R7=0 for empty or normal
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Print error message if the input message is too long
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
too_long:
	ldm	r0, tmpx
	stm	tx, r0		;restore TX
	ldi	r0, 0x0D		
	stm	tascii, r0	;CR=0x0D
	sys	putchar		;print the CR manually
	sys	putchar		;extra line for result
	ldi	r0, long	;print error message
	stm	string, r0
	sys	prints
	ldi	r0, 0x0D		
	stm	tascii, r0	;CR=0x0D
	sys	putchar		;print the CR manually
	sys	putchar		;extra line for result
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Print 256-bit message diget or hash values
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printhash:
	ldi	r0, 0x30	;print '0'
	stm	tascii, r0
	sys	putchar
	ldi	r0, 0x78	;print 'x'
	stm	tascii, r0
	sys	putchar
	ldi	r5, h0		;Final hash are in h0-h7
	ldi	r2, 8
prnh1:	ldr	r0, r5		
	stm	tnum, r0
	call	hex		;use customized print hex
	adi	r5, 1		;for the 256-bit (64-digit) number
	adi	r2, 0xFFFF
	jnz	prnh1
	ldi	r0, 0x0D		
	stm	tascii, r0	;CR=0x0D
	sys	putchar		;print the CR manually
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SHA:	byte	S		;SHA*=SHA-256
	byte	H
	byte	A
	byte	0x2D
	byte	0x32
	byte	0x35
	byte	0x36
	byte	0x00
BITC:	byte	B		;BITC*=Bitcoin
	byte	0x69
	byte	0x74
	byte	0x63
	byte	0x6F
	byte	0x69
	byte	0x6E
	byte	0x00
long:	byte	M		;long*=:Message too long"
	byte	E
	byte	S
	byte	S
	byte	A
	byte	G
	byte	E
	byte	0x20
	byte	T
	byte	O
	byte	O
	byte	0x20
	byte	L
	byte	O
	byte	N
	byte	G
	byte	0x00
hquit:				;hquit*="QUIT" to exit
	byte	Q
	byte	U
	byte	I
	byte	T
	byte	0x00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
K256:	word	0x428a2f98	;k0	K Constant
	word	0x71374491	;k1
	word	0xb5c0fbcf	;k2
	word	0xe9b5dba5	;k3
	word	0x3956c25b	;k4
	word	0x59f111f1	;k5
	word	0x923f82a4	;k6
	word	0xab1c5ed5	;k7
	word	0xd807aa98	;k8
	word	0x12835b01	;k9
	word	0x243185be	;k10
	word	0x550c7dc3	;k11
	word	0x72be5d74	;k12
	word	0x80deb1fe	;k13
	word	0x9bdc06a7	;k14
	word	0xc19bf174	;k15
	word	0xe49b69c1	;k16
	word	0xefbe4786	;k17
	word	0x0fc19dc6	;k18
	word	0x240ca1cc	;k19
	word	0x2de92c6f	;k20
	word	0x4a7484aa	;k21
	word	0x5cb0a9dc	;k22
	word	0x76f988da	;k23
	word	0x983e5152	;k24
	word	0xa831c66d	;k25
	word	0xb00327c8	;k26
	word	0xbf597fc7	;k27
	word	0xc6e00bf3	;k28
	word	0xd5a79147	;k29
	word	0x06ca6351	;k30
	word	0x14292967	;k31
	word	0x27b70a85	;k32
	word	0x2e1b2138	;k33
	word	0x4d2c6dfc	;k34
	word	0x53380d13	;k35
	word	0x650a7354	;k36
	word	0x766a0abb	;k37
	word	0x81c2c92e	;k38
	word	0x92722c85	;k39
	word	0xa2bfe8a1	;k40
	word	0xa81a664b	;k41
	word	0xc24b8b70	;k42
	word	0xc76c51a3	;k43
	word	0xd192e819	;k44
	word	0xd6990624	;k45
	word	0xf40e3585	;k46
	word	0x106aa070	;k47
	word	0x19a4c116	;k48
	word	0x1e376c08	;k49
	word	0x2748774c	;k50
	word	0x34b0bcb5	;k51
	word	0x391c0cb3	;k52
	word	0x4ed8aa4a	;k53
	word	0x5b9cca4f	;k54
	word	0x682e6ff3	;k55
	word	0x748f82ee	;k56
	word	0x78a5636f	;k57
	word	0x84c87814	;k58
	word	0x8cc70208	;k59
	word	0x90befffa	;k60
	word	0xa4506ceb	;k61
	word	0xbef9a3f7	;k62
	word	0xc67178f2	;k63
	byte	0x00
Hinit:
	word	0x6a09e667	;H0	initial Hash
	word	0xbb67ae85	;H1
	word	0x3c6ef372	;H2
	word	0xa54ff53a	;H3
	word	0x510e527f	;H4
	word	0x9b05688c	;H5
	word	0x1f83d9ab	;H6
	word	0x5be0cd19	;H7
	byte	0x00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function Ch(x, y, z)
;input: r0=x, r1=y, r2=z
;output: r0=Ch(x, y, z)
;affects: r5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ch:	push	r6
	mov	r5, r0
	and	r0, r1		;r0=x and y
	ldi	r6, 0xFFFF
	xor	r5, r6		;r5=not x
	and	r5, r2		;r5=not x and z
	xor	r0, r5
	pop	r6
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function Maj(x, y, z)
;input: r0=x, r1=y, r2=z
;output: r0=Maj(x, y, z)
;affects: r5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
maj:	mov	r5, r0
	and	r0, r1		;r0=x and y
	and	r5, r2		;r5=x and z
	and	r1, r2		;r1=y and z
	xor	r0, r5
	xor	r0, r1
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function sum0(x)
;input: r0=x
;output: r0=sum0(x)
;affects: r5, r1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sum0:	mov	r5, r0
	mov	r1, r0
	ror	r0, 2		;r0=ROTR^2(x)
	ror	r5, 13		;r5=ROTR^13(x)
	ror	r1, 22		;r1=ROTR^22(x)
	xor	r0, r5
	xor	r0, r1
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function sum1(x)
;input: r0=x
;output: r0=sum1(x)
;affects: r5, r1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sum1:	mov	r5, r0
	mov	r1, r0
	ror	r0, 6		;r0=ROTR^6(x)
	ror	r5, 11		;r5=ROTR^11(x)
	ror	r1, 25		;r6=ROTR^25(x)
	xor	r0, r5
	xor	r0, r1
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function sig0(x)
;input: r0=x
;output: r0=sig0(x)
;affects: r4, r5, r6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sig0:	mov	r5, r0
	mov	r6, r0
	ror	r0, 7		;r0=ROTR^7(x)
	ror	r5, 18		;r5=ROTR^18(x)
	ror	r6, 3		;r6=ROTR^3(x)
	ldh	r4, 0x1FFF	
	ldl	r4, 0xFFFF	;mask out 3 MSB
	and	r6, r4		;r6=SHR^3(x)
	xor	r0, r5
	xor	r0, r6
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function sig1(x)
;input: r0=x
;output: r0=sig1(x)
;affects: r4, r5, r6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sig1:	mov	r5, r0
	mov	r6, r0
	ror	r0, 17		;r0=ROTR^17(x)
	ror	r5, 19		;r5=ROTR^19(x)
	ror	r6, 10		;r6=ROTR^10(x)
	ldh	r4, 0x003F	
	ldl	r4, 0xFFFF	;mask out 10 MSB
	and	r6, r4		;r6=SHR^10(x)
	xor	r0, r5
	xor	r0, r6
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Print a number in hexadecimal
;Modification of the sys printn hex part
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hex:	ldm	r0, tnum
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
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;subroutine prints one hex digit
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prh:	cmpi	r1, 10
	jns	prh1		;>= 10?
	adi	r1, 0x0030	;print 0-9
prh2:	stm	tascii, r1
	sys	putchar		
	ret	
prh1:	adi	r1, 0x0037	;print A-F
	jmp	prh2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;HASH subroutine to generate the 256-bit message digest from 
;M = m512 is the 16-words input buffer
;W = buffer is the 64-word message schedule 
;h0 to h7 = hash values
;wva, wvb, ..., wvh = working variables a to h
;K = K256 the 64-words constant
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
HASH:	ldi	r5, m512	;copy M to W(0..15)
	ldi	r7, buffer
	ldi	r2, 16
sch1:	ldr	r0, r5
	str	r7, r0		
	adi	r5, 1
	adi	r7, 1
	adi	r2, 0xFFFF
	jnz	sch1
;Process the next 48 entrances
;R7 is currently the pointer to buffer (W)
	ldi	r2, 48		;loop count
sch2:	mov	r1, r7
	adi	r1, 0xFFFE	;t-2
	ldr	r0, r1		;r0=W(t-2)
	call	sig1		;r0=sig1(W(t-2))
	mov	r1, r7
	adi	r1, 0xFFF9	;t-7
	ldr	r3, r1		;r3=W(t-7)
	add	r3, r0		;r3=sig1(W(t-2))+W(t-7)
	mov	r1, r7
	adi	r1, 0xFFF1	;t-15
	ldr	r0, r1		;r0=W(t-15)
	call	sig0		;r0=sig0(W(t-15))
	mov	r1, r7
	adi	r1, 0xFFF0	;t-16
	ldr	r4, r1		;r4=W(t-16)
	add	r4, r0		;r4=sig1(W(t-15))+W(t-16)
	add	r3, r4		
;;;;;;;;;r3=sig1(W(t-2))+W(t-7)+sig1(W(t-15))+W(t-16)
	str	r7, r3
	adi	r7, 1
	adi	r2, 0xFFFF
	jnz	sch2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;At this point, we have prepared the 64 32-bit message schedule: W
;Use R3 as the loop count since R2 will be use by functions
;initialize the working variables with initial H
;The working variables are defined in sequence and work like a table
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldi	r5, Hinit	;r5=pointer to init H
	ldi	r6, wva		;r6=pointer to working variables
	ldi	r7, h0		;r7=pointer to hash values
	ldi	r3, 8		;loop count
sch3:	ldr	r0, r5
	str	r6, r0
	str	r7, r0		
	adi	r5, 1
	adi	r6, 1
	adi	r7, 1
	adi	r3, 0xFFFF
	jnz	sch3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin the big loop of 0 to 63
;From this point on:
;	R6 is reserved as pointer to K
;	R7 is reserved as pointer to W
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldi	r3, 64		;the loop count
	ldi	r7, buffer	;r7=pointer to W
	ldi	r6, k256	;r6=pointer to K
sch4:	ldm	r0, wve		;r0=e
	call	sum1		;r0=sum1(e)
	ldm	r4, wvh		;r4=h
	add	r4, r0		;r4=h+sum1(e)
	ldm	r0, wve		;r0=e
	ldm	r1, wvf		;r1=f
	ldm	r2, wvg		;r2=g
	call	ch		;r0=Ch(e,f,g)
	add	r4, r0		;r4=h+sum1(e)+Ch(e,f,g)
	ldr	r0, r6
	add	r4, r0		;r4=h+sum1(e)+Ch(e,f,g)+K
	ldr	r0, r7
	add	r4, r0		;r4=h+sum1(e)+Ch(e,f,g)+K+W
	stm	t1, r4		;T1=h+sum1(e)+Ch(e,f,g)+K+W
	ldm	r0, wva		;r0=a
	call	sum0		
	mov	r4, r0		;r4=sum0(a)
	ldm	r0, wva		;r0=a
	ldm	r1, wvb		;r1=b
	ldm	r2, wvc		;r2=c
	call	maj		;r0=Maj(a,b,c)
	add	r4, r0		;r4=sum0(a)+Maj(a,b,c)
	stm	t2, r4		;T2=sum0(a)+Maj(a,b,c)
	ldm	r0, wvg
	stm	wvh, r0		;h <= g
	ldm	r0, wvf
	stm	wvg, r0		;g <= f
	ldm	r0, wve
	stm	wvf, r0		;f <= e
	ldm	r0, wvd
	ldm	r1, t1
	add	r0, r1
	stm	wve, r0		;e <= d + T1
	ldm	r0, wvc
	stm	wvd, r0		;d <= c
	ldm	r0, wvb
	stm	wvc, r0		;c <= b
	ldm	r0, wva
	stm	wvb, r0		;b <= a
	ldm	r0, t1
	ldm	r1, t2
	add	r0, r1
	stm	wva, r0		;a <= T1 + T2
	adi	r6, 1		;inc pointer to K
	adi	r7, 1		;inc pointer to W
	adi	r3, 0xFFFF
	jnz	sch4
;calculate the hash values
	ldi	r1, wva		;r1=pointer to working variables
	ldi	r2, h0		;r2=pointer to hash values
	ldi	r5, 8		;loop count
sch5:	ldr	r0, r1
	ldr	r4, r2
	add	r0, r4
	str	r2, r0		
	adi	r1, 1
	adi	r2, 1
	adi	r5, 0xFFFF
	jnz	sch5
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;RAND2D: 2D scatter plots of LFSR and WELL512a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
exD:	sys	clearg		;clear graphic screen
	ldi	r0, seed
	stm	PRNG, r0	;initializing LFSR
frame:	ldi	r0, 255
	stm	color, r0	;white frame
	ldi	r0, hmin
	ldi	r1, hmax
	ldi	r2, vmin
	ldi	r3, vmax
	stm	x1, r0
	stm	y1, r2
	stm	x2, r0
	stm	y2, r3
	sys	line
	stm	x1, r0
	stm	y1, r2
	stm	x2, r1
	stm	y2, r2
	sys	line
	stm	x1, r1
	stm	y1, r3
	stm	x2, r0
	stm	y2, r3
	sys	line
	stm	x1, r1
	stm	y1, r3
	stm	x2, r1
	stm	y2, r2
	sys	line
	ldi	r0, hmin2
	ldi	r1, hmax2
	ldi	r2, vmin
	ldi	r3, vmax
	stm	x1, r0
	stm	y1, r2
	stm	x2, r0
	stm	y2, r3
	sys	line
	stm	x1, r0
	stm	y1, r2
	stm	x2, r1
	stm	y2, r2
	sys	line
	stm	x1, r1
	stm	y1, r3
	stm	x2, r0
	stm	y2, r3
	sys	line
	stm	x1, r1
	stm	y1, r3
	stm	x2, r1
	stm	y2, r2
	sys	line
plot:	ldi	r2, 0xFF	;8-bit mask
	ldi	r0, 31
	stm	color, r0
	ldi	r0, 20000
ploop:	ldm	r1, rand
	and	r1, r2		;last 8-bit only
	adi	r1, basex	;rand + basex
	stm	gx, r1
	ldm	r1, rand
	and 	r1, r2
	ldi	r3, basey
	sub	r3, r1		;basey - rand
	stm	gy, r3
	sys	pixel
	call	LFSR
	ldm	r1, PRNG
	ror	r1, 16		;use 31:16
	and	r1, r2		;last 8-bit only
	adi	r1, basex2	;PRNG + basex2
	stm	gx, r1
	call	LFSR
	ldm	r1, PRNG
	ror	r1, 16		;use 31:16
	and 	r1, r2
	ldi	r3, basey
	sub	r3, r1		;PRNG - rand
	stm	gy, r3
	sys	pixel
	adi	r0, 0xFFFF
	jnz	ploop
	jmp	done
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;LFSR PRNG 
;X^32 + X^31 + X^29 + X + 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LFSR:	ldm	r4, PRNG
	ldm	r5, mask1
	and	r5, r4		;r5 = bit 31
	ror	r5, 31
	ldm	r6, mask2
	and 	r6, r4		;r6 = bit 30
	ror	r6, 30
	xor	r5, r6		;r5 = 31 xor 30
	ldm	r6, mask3
	and 	r6, r4		;r6 = bit 28
	ror	r6, 28
	xor 	r5, r6		;r5 = 31 xor 30 xor 28
	ldm	r6, mask4
	and 	r6, r4		;r6 = bit 0
	xor 	r5, r6		;r5 = 31 xor 30 xor 28 xor 0
	ldm	r6, mask5
	ror	r4, 31
	and	r4, r6		;remove last bit
	or	r4, r5
	stm	PRNG, r4
	ret
mask1:	word	0x80000000	;bit 31 mask
mask2:	word	0x40000000	;bit 30 mask
mask3:	word	0x10000000	;bit 28 mask
mask4:	word	0x00000001	;bit 0 mask
mask5:	word	0xFFFFFFFE	;bit 0 remove
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;RAND3D: 3D scatter plots of LFSR and WELL512a
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
exE:	sys	clearg		;clear graphic screen
	ldi	r0, white
	stm	color, r0	;white frame
	ldi	r0, seed
	stm	PRNG, r0	;initializing LFSR
	ldi	r0, b3dx2
	stm	b3dx, r0	;base X 2
	ldi	r7, 2
frame1:	ldi	r0, fmin
	stm	x3d1, r0
	stm	y3d1, r0
	stm	z3d1, r0
	stm	y3d2, r0
	stm	z3d2, r0
	ldi	r0, fmax
	stm	x3d2, r0
	call	line3d		;(0,0,0) to (1,0,0)
	ldi	r0, fmin
	stm	x3d2, r0
	ldi	r0, fmax
	stm	y3d2, r0
	call	line3d		;(0,0,0) to (0,1,0)
	ldi	r0, fmax
	stm	x3d1, r0	
	stm	y3d1, r0
	ldi	r0, gray
	stm	color, r0
	call	line3d		;(0,1,0) to (1,1,0)
	ldi	r0, fmin
	stm	x3d1, r0
	ldi	r0, fmax
	stm	z3d1, r0
	ldi	r0, white
	stm	color, r0
	call	line3d		;(0,1,0) to (0,1,1)
	ldi	r0, fmax
	stm	x3d2, r0
	stm	z3d2, r0
	call	line3d		;(0,1,1) to (1,1,1)
	ldi	r0, fmin
	stm	z3d1, r0
	ldi	r0, fmax
	stm	x3d1, r0
	ldi	r0, gray
	stm	color, r0
	call	line3d		;(1,1,1) to (1,1,0)
	ldi	r0, fmin
	stm	y3d2, r0
	stm	z3d2, r0
	call	line3d		;(1,1,0) to (1,0,0)
	ldi	r0, fmax
	stm	z3d1, r0
	ldi	r0, fmin
	stm	y3d1, r0
	ldi	r0, white
	stm	color, r0
	call	line3d		;(1,0,0) to (1,0,1)
	ldi	r0, fmax
	stm	y3d2, r0
	stm	z3d2, r0
	call	line3d		;(1,0,1) to (1,1,1)

	adi	r7, 0xFFFF
	jz	plotw
	ldi	r0, b3dx1
	stm	b3dx, r0	;base X 1
	jmp	frame1

plotw:	ldi	r0, 31
	stm	color, r0
	ldi	r7, 30000
loopw:	ldi	r2, 0xFF	;8-bit mask
	ldi	r3, 200		;scale factor
	ldm	r1, rand
	and	r1, r2		;last 8-bit only
	mul	r1, r3		;scale
	ror	r1, 8
	and	r1, r2
	stm	x3d1, r1
	ldm	r1, rand
	and	r1, r2		;last 8-bit only
	mul	r1, r3		;scale
	ror	r1, 8
	and	r1, r2
	stm	y3d1, r1
	ldm	r1, rand
	and	r1, r2		;last 8-bit only
	mul	r1, r3		;scale
	ror	r1, 8
	and	r1, r2
	stm	z3d1, r1
	call	pixel3d
	adi	r7, 0xFFFF
	jnz	loopw
plotl:	ldi	r0, 31
	stm	color, r0
	ldi	r0, b3dx2
	stm	b3dx, r0	;base X 2
	ldi	r7, 30000
loopl:	ldi	r2, 0xFF	;8-bit mask
	ldi	r3, 200		;scale factor
	push	r7
	call	LFSR
	ldm	r1, PRNG
	ror	r1, 16
	and	r1, r2		;last 8-bit only
	mul	r1, r3		;scale
	ror	r1, 8
	and	r1, r2
	stm	x3d1, r1
	call	LFSR
	ldm	r1, PRNG
	ror	r1, 16
	and	r1, r2		;last 8-bit only
	mul	r1, r3		;scale
	ror	r1, 8
	and	r1, r2
	stm	y3d1, r1
	call	LFSR
	ldm	r1, PRNG
	ror	r1, 16
	and	r1, r2		;last 8-bit only
	mul	r1, r3		;scale
	ror	r1, 8
	and	r1, r2
	stm	z3d1, r1
	call	pixel3d
	pop	r7
	adi	r7, 0xFFFF
	jnz	loopl
	jmp	done
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
line3d:	ldm	r0, b3dx
	ldm	r1, x3d1
	ldm	r2, y3d1
	ldm	r3, z3d1
	add	r0, r1
	sub	r0, r2		;bx = b3dx + ax - ay
	stm	x1, r0
	ldi	r0, b3dy
	sub	r0, r3
	add	r1, r2
	ldi	r2, 0xFFFE
	and 	r1, r2
	ror	r1, 1		
	sub	r0, r1		;by = b3dy - az - 1/2 (ax + ay)
	stm	y1, r0
	ldm	r0, b3dx
	ldm	r1, x3d2
	ldm	r2, y3d2
	ldm	r3, z3d2
	add	r0, r1
	sub	r0, r2		;bx = b3dx + ax - ay
	stm	x2, r0
	ldi	r0, b3dy
	sub	r0, r3
	add	r1, r2
	ldi	r2, 0xFFFE
	and 	r1, r2
	ror	r1, 1		
	sub	r0, r1		;by = b3dy - az - 1/2 (ax + ay)
	stm	y2, r0
	sys	line
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pixel3d:
	ldm	r0, b3dx
	ldm	r1, x3d1
	ldm	r2, y3d1
	ldm	r3, z3d1
	add	r0, r1
	sub	r0, r2		;bx = b3dx + ax - ay
	stm	gx, r0
	ldi	r0, b3dy
	sub	r0, r3
	add	r1, r2
	ldi	r2, 0xFFFE
	and 	r1, r2
	ror	r1, 1		
	sub	r0, r1		;by = b3dy - az - 1/2 (ax + ay)
	stm	gy, r0
	sys	pixel
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PAINT: finger painting demo
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
exF:
	ldi	r0, gmode
	stm	vcntrl, r0
	sys	clearg		;clear graphic screen
	call	init_new	;draw "new" in menu area
	call	color_palette
	ldi	r6, 1
	ldi	r1, ctable
	add	r1, r6		;init color = 1 (red)
	ldr	r0, r1
	stm	color, r0	;R6 is reserved as "color"
	call	color_ON
	ldi	r7, 5		;init brush radius = 5
	stm	rad, r7		;R7 is reserved as "brush size"
	call	init_brush	;draw init "brush"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wait:	ldm	r0, trdy
	cmpi	r0, 0
	jz	wait
	ldm	r1, gesture
	cmpi 	r1, 0
	jz	touch
	cmpi	r1, up
	jz	gesu
	cmpi	r1, left
	jz	gesl
	cmpi	r1, down
	jz	gesd
	cmpi	r1, right
	jz	gesr
	cmpi	r1, zin
	jz	gesin
	cmpi	r1, zout
	jz	gesout
	jmp	wait
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;gestures "left " and "right" are unused
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gesl:	jmp	wait
gesr:	jmp	wait
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;gestures "up" and "zoom out" increase brush size
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gesu:	
gesout:	ldm	r0, tx1
	cmpi	r0, 720
	js	wait		;if tx1 < 720
	ldm	r0, ty1
	cmpi	r0, 94
	js	wait		;if ty1 < 94
	cmpi	r0, 221
	jns	wait		;if ty1 >= 221
	cmpi	r7, 35		;max brush size = 35
	jns	wait
	ldi	r0, 0
	stm	color, r0
	call	init_brush	;erase menu brush
	adi	r7, 1		;brush radius+1
	stm	rad, r7
	ldi	r1, ctable
	add	r1, r6
	ldr	r0, r1
	stm	color, r0
	call	init_brush	;re-draw menu brush
	jmp	wait
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;gestures "down" and "zoom in" decrease brush size
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gesd:	
gesin:	ldm	r0, tx1
	cmpi	r0, 720
	js	wait		;if tx1 < 720
	ldm	r0, ty1
	cmpi	r0, 94
	js	wait		;if ty1 < 94
	cmpi	r0, 221
	jns	wait		;if ty1 >= 221
	cmpi	r7, 0		;min brush size = 0
	jz	wait
	ldi	r0, 0
	stm	color, r0
	call	init_brush	;erase menu brush
	ldi	r0, 1
	sub	r7, r0		;brush radius-1
	stm	rad, r7
	ldi	r1, ctable
	add	r1, r6
	ldr	r0, r1
	stm	color, r0
	call	init_brush	;re-draw menu brush
	jmp	wait
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
touch:	ldm	r0, tx1
	cmpi	r0, 720
	js	touch0
	ldm	r0, ty1
	cmpi	r0, 222
	jns	color0		;if "color" button?
	cmpi	r0, 36
	js	power		;if "power" button?
	cmpi	r0, 62
	js	wait		;not "new" if ty1 < 62
	cmpi	r0, 94
	jns	wait		;not "new" if ty1 >= 94	
	call	clear_draw
	jmp	wait		;clear drawing space
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;return to Rhody CLI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
power:	jmp	init
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
touch0:	ldm	r1, tcnt
	cmpi	r1, 5
	jz	touch5
	cmpi	r1, 4
	jz	touch4
	cmpi	r1, 3
	jz	touch3
	cmpi	r1, 2
	jz	touch2
	cmpi	r1, 1
	jz	touch1
	jmp	wait
touch5:
	ldm	r0, tx5
	stm	x1, r0
	add	r0, r7		
	cmpi	r0, 719
	jns	touch4
	ldm	r0, ty5
	stm	y1, r0
	sys	scircle
touch4:
	ldm	r0, tx4
	stm	x1, r0
	add	r0, r7		
	cmpi	r0, 719
	jns	touch3
	ldm	r0, ty4
	stm	y1, r0
	sys	scircle
touch3:
	ldm	r0, tx3
	stm	x1, r0
	add	r0, r7		
	cmpi	r0, 719
	jns	touch2
	ldm	r0, ty3
	stm	y1, r0
	sys	scircle
touch2:
	ldm	r0, tx2
	stm	x1, r0
	add	r0, r7		
	cmpi	r0, 719
	jns	touch1
	ldm	r0, ty2
	stm	y1, r0
	sys	scircle
touch1:
	ldm	r0, tx1
	stm	x1, r0
	add	r0, r7		
	cmpi	r0, 719
	jns	wait
	ldm	r0, ty1
	stm	y1, r0
	sys	scircle
	jmp	wait
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Determine new color selection
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
color0:	cmpi	r0, 479		;bottom of color palette
	jns	wait
	ldi	r4, 239		;color 0 bottom
	ldi	r3, 0		;tentative color number
color1:	cmp	r0, r4
	js	color2		;found match
	adi	r3, 1
	adi	r4, 16
	jmp	color1
color2:	call	color_OFF
	mov	r6, r3
	call	color_ON
	ldi	r1, ctable
	add	r1, r6
	ldr	r0, r1
	stm	color, r0
	call	init_brush
	jmp	wait
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;custom clear graphics screen: 719x380
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clear_draw:
	ldi	r1, 0		;r1=black color
	ldh	r0, 0x0010	;
	ldl	r0, 0x0000	;r0=00100000
	ldi	r3, 480		;Y count
gc0:	ldi	r2, 719		;X count
gc1:	str	r0, r1		;write blank to graphic video
	adi	r0, 1		;inc address	
	adi	r2, 0xFFFF	;dec X count
	jnz	gc1
	adi	r0, 305
	adi	r3, 0xFFFF	;dec Y count
	jnz	gc0
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;draw power, border and "new" symbol
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
init_new:
	ldi	r0, 0xF2	;power button
	stm	color, r0
	ldi	r0, 760		;X=760
	stm	x1, r0
	ldi	r0, 20
	stm	y1, r0		;Y=20
	ldi	r0, 15
	stm	rad, r0
	sys	scircle
	ldi	r0, 0x18	;Green
	stm	color, r0
	ldi	r0, 10
	stm	rad, r0
	sys	circle
	ldi	r0, 9
	stm	rad, r0
	sys	circle
	ldi	r0, 8
	stm	rad, r0
	sys	circle

	ldi	r0, 759		;X=759
	stm	x1, r0
	ldi	r0, 20
	stm	y1, r0		;Y=20
	ldi	r0, 759		;X=759
	stm	x2, r0
	ldi	r0, 7
	stm	y2, r0		;Y=7
	sys	line
	ldi	r0, 760		;X=760
	stm	x1, r0
	ldi	r0, 20
	stm	y1, r0		;Y=20
	ldi	r0, 760		;X=760
	stm	x2, r0
	ldi	r0, 7
	stm	y2, r0		;Y=7
	sys	line
	ldi	r0, 761		;X=761
	stm	x1, r0
	ldi	r0, 20
	stm	y1, r0		;Y=20
	ldi	r0, 761		;X=761
	stm	x2, r0
	ldi	r0, 7
	stm	y2, r0		;Y=7
	sys	line

	ldi	r0, 0xF2	;power button
	stm	color, r0
	ldi	r0, 757	
	stm	x1, r0
	ldi	r0, 20
	stm	y1, r0	
	ldi	r0, 757	
	stm	x2, r0
	ldi	r0, 7
	stm	y2, r0	
	sys	line
	ldi	r0, 758	
	stm	x1, r0
	ldi	r0, 20
	stm	y1, r0	
	ldi	r0, 758	
	stm	x2, r0
	ldi	r0, 7
	stm	y2, r0	
	sys	line
	ldi	r0, 762	
	stm	x1, r0
	ldi	r0, 20
	stm	y1, r0
	ldi	r0, 762
	stm	x2, r0
	ldi	r0, 7
	stm	y2, r0
	sys	line
	ldi	r0, 763	
	stm	x1, r0
	ldi	r0, 20
	stm	y1, r0
	ldi	r0, 763
	stm	x2, r0
	ldi	r0, 7
	stm	y2, r0
	sys	line

	ldi	r0, white	;color white
	stm	color, r0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;border x=720, Y=0 to 479
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldi	r0, 720		
	stm	x1, r0
	stm	x2, r0
	ldi	r0, 0
	stm	y1, r0
	ldi	r0, 479
	stm	y2, r0
	sys	line
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;draw "new" symbol: 7 lines
;X = 748, 763, 771
;Y = 62, 70, 93
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldi	r0, 748		;X1=X2=748
	stm	x1, r0
	stm	x2, r0	
	ldi	r1, 93		
	stm	y1, r1		;Y1=93
	ldi	r1, 62
	stm	y2, r1		;Y2=62
	sys	line		;line#1
	stm	y1, r1		;Y1=62
	adi	r0, 15
	stm	x2, r0		;X2=763
	sys	line		;line#2
	stm	x1, r0		;X1=763
	ldi	r1, 70
	stm	y1, r1		;Y1=70
	sys	line		;line#3
	ldi	r0, 771
	stm	x1, r0		;X1=771
	sys	line		;line#4
	ldi	r0, 763
	stm	x1, r0		;X1=763
	ldi	r0, 771
	stm	x2, r0		;X2=771
	ldi	r1, 70
	stm	y1, r1		;Y1=70
	stm	y2, r1		;Y2=70
	sys	line		;line#5
	stm	x1, r0		;X1=771
	ldi	r1, 93
	stm	y2, r1		;Y2=93
	sys	line		;line#6
	ldi	r0, 748
	stm	x1, r0		;X1=748
	ldi	r1, 93
	stm	y1, r1
	sys	line		;line#7
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;draw initial brush at X=760, Y=160
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
init_brush:
	ldi	r0, 760
	stm	x1, r0
	ldi	r1, 160
	stm	y1, r1
	sys	scircle
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;draw color menu at X=744-776, Y=222-478
;Each color element:
;  white outline: X=744, 776; Y=222+16i, 238+16i
;  Color block: X=747, 773; Y=225+16i, 235+16i
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
color_palette:
	ldi	r7, 0		;R7=loop count
cp0:	ldi	r0, 744
	stm	X1, r0
	ldi	r0, 776
	stm	X2, r0
	ldi	r0, white	;white color
	stm	color, r0
	mov	r1, r7
	ror	r1, 28		;ROL by 4 = *16
	adi	r1, 222
	stm	Y1, r1
	adi	r1, 16
	stm	Y2, r1
	sys	rect		;white outline
	;
	ldi	r6, ctable
	add	r6, r7
	ldr	r0, r6
	stm	color, r0	;color = loopcount
	ldi	r0, 747		;X1
	ldi	r2, 773		;X2
	mov	r1, r7
	ror	r1, 28		;ROL by 4 = *16
	mov	r3, r1
	adi	r1, 225		;Y1
	adi	r3, 235		;Y2
	call	srect		;solid color block
	adi	r7, 1
	cmpi	r7, 16
	jnz	cp0
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ON/OFF indicators: two white squares
;  1st: X=745, 775; Y=223+16i, 237+16i
;  2nd: X=746, 774; Y=224+16i, 236+16i
;R6 => color block number
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
color_ON:
	ldm	r5, color
	ldi	r0, 745
	stm	X1, r0
	ldi	r0, 775
	stm	X2, r0
	ldi	r0, white	;white color
	stm	color, r0
	mov	r1, r6
	ror	r1, 28		;ROL by 4 = *16
	adi	r1, 223
	stm	Y1, r1
	adi	r1, 14
	stm	Y2, r1
	sys	rect		;white outline
	ldi	r0, 746
	stm	X1, r0
	ldi	r0, 774
	stm	X2, r0
	ldi	r0, white	;white color
	stm	color, r0
	mov	r1, r6
	ror	r1, 28		;ROL by 4 = *16
	adi	r1, 224
	stm	Y1, r1
	adi	r1, 12
	stm	Y2, r1
	sys	rect		;white outline
	stm	color, r5	;restore color
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
color_OFF:
	ldm	r5, color
	ldi	r0, 745
	stm	X1, r0
	ldi	r0, 775
	stm	X2, r0
	ldi	r0, 0x0		;black color
	stm	color, r0
	mov	r1, r6
	ror	r1, 28		;ROL by 4 = *16
	adi	r1, 223
	stm	Y1, r1
	adi	r1, 14
	stm	Y2, r1
	sys	rect		;remove outline
	ldi	r0, 746
	stm	X1, r0
	ldi	r0, 774
	stm	X2, r0
	ldi	r0, 0x0		;black color
	stm	color, r0
	mov	r1, r6
	ror	r1, 28		;ROL by 4 = *16
	adi	r1, 224
	stm	Y1, r1
	adi	r1, 12
	stm	Y2, r1
	sys	rect		;remove outline
	stm	color, r5	;restore color
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;draw a solid rectangle
;inputs: r0=X1, r1=Y1, r2=X2, r3=Y2
;outputs: draw a rectangle between (x1,y1) and (x2,y2)
;		on graphic screen filled with color
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
srect:	stm	x1, r0
	stm	y1, r1
	stm	x2, r2
	stm	y2, r1
	sys	line
	adi	r1, 1
	cmp	r3, r1
	jns	srect
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;color table
;Only 16 colors are available
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ctable:
	byte	0x00	;black
	byte	0xE0	;red
	byte	0xE2
	byte	0xF0
	byte	0xF2
	byte	0xE3
	byte	0x1C	;green
	byte	0x9C
	byte	0x1E
	byte	0xFC
	byte	0x03	;blue
	byte	0x13
	byte	0x1F
	byte	0x93
	byte	0x92
	byte	0xFF
	byte	0x00	;null
