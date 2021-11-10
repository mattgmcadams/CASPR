.arch rhody		;use rhody.cfg
.outfmt hex		;output format is hex
.memsize 1024		;specify 1K words
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Memory addresses for Rhody System I/O devices
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define kcntrl	0xf0000	;keyboard control register
.define kascii	0xf0001	;keyboard ASCII code
.define time0	0xf0003	;Timer 0
.define inport 	0xf0005	;GPIO read address
.define outport	0xf0005	;GPIO write address
.define rand	0xf0006	;random number
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
.define gx	0x0908	;graphic video X (0 - 639)
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
;SHA256 Program variables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define count	0x0800	;hash count
.define m512	0x0810	;16 words M 0x810-0x81F
.define buffer	0x0820	;64 words W 0x820-0x85F
.define wva	0x0860	;working variable a
.define wvb	0x0861	;working variable b
.define wvc	0x0862	;working variable c
.define wvd	0x0863	;working variable d
.define wve	0x0864	;working variable e
.define wvf	0x0865	;working variable f
.define wvg	0x0866	;working variable g
.define wvh	0x0867	;working variable h
.define h0	0x0868	;hash value 0
.define h1	0x0869	;hash value 1
.define h2	0x086A	;hash value 2
.define h3	0x086B	;hash value 3
.define h4	0x086C	;hash value 4
.define h5	0x086D	;hash value 5
.define h6	0x086E	;hash value 6
.define h7	0x086F	;hash value 7
.define t1	0x0870	;temporary value 1
.define t2	0x0871	;temporary value 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SHA256_verification
;Use randomly generated message for SHA-256
;count how many hashes per seconds
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
SHA256_verification:
	ldi	r0, 0
	stm	format, r0
	sys	clear	
	ldi	r0, m512
	ldi	r1, test_message
	ldi	r2, 16
test1:	
	ldr	r3, r1		;copy test message to buffer
	str	r0, r3
	adi	r0, 1
	adi	r1, 1
	adi	r2, 0xffff
	jnz	test1
	call	HASH		;produce hash for the test message
	ldi	r0, h0
	ldi	r1, answer
	ldi	r2, 8
test2:	
	ldr	r3, r0
	ldr	r4, r1
	cmp	r3, r4
	jnz	wrong		;subroutine HASH is wrong
	adi	r0, 1
	adi	r1, 1
	adi	r2, 0xffff
	jnz	test2
;prepare hash count and timer
	ldi	r0, 0
	stm	count, r0
	stm	time0, r0	;start timer
;Prepare the random inputs;;;;;;;;;;;;;;;;;;;;;;;;
sha1:	ldi	r5, m512	;pointer to message buffer
	ldi	r2, 8
sha2:	ldm	r0, rand	;get random number
	str	r5, r0	
	adi	r5, 1
	adi	r2, 0xFFFF
	jnz	sha2
	ldh	r0, 0x8000
	ldl	r0, 0x0000
	str	r5, r0		;stop byte in 9th word
	ldi	r0, 0
	adi	r5, 1
	ldi	r2, 6		;fill in '0'
sha3:	str	r5, r0	
	adi	r5, 1
	adi	r2, 0xFFFF
	jnz	sha3
	ldi	r0, 0x0100	;length=256
	str	r5, r0
	call	HASH
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r0, count
	adi	r0, 1
	stm	count, r0	;inc hash count
	ldm	r0, time0
	ldm	r1, timeup
	cmp	r0, r1		;>= time up?
	js	sha1
	ldi	r0, 0
	stm	tx, r0
	stm	ty, r0
	ldm	r0, count
	stm	tnum, r0
	sys	printn
	ldi	r0, hashps
	stm	string, r0
	sys	prints
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
halt:	jmp	halt		;print count and stop
timeup:	word	1000000		;1sec = 1000000us
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;HASH subroutine produced wrong hash
;print "dead" on 7-segment displays and stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wrong:
	ldi	r0, 0xdead
	stm	outport, r0
wrong_stop:
	jmp	wrong_stop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;pre-defined test message: this is a test
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
test_message:
	dword	0x7468697320697320	;this is
	dword	0x6120746573748000	;a test
	dword	0x00000000
	dword	0x00000000
	dword	0x00000000
	dword	0x00000000
	dword	0x00000000
	dword	0x00000070	;message lenth in bits
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Hash for pre-define test message
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
answer:
	dword	0x2e99758548972a8e
	dword	0x8822ad47fa1017ff
	dword	0x72f06f3ff6a01685
	dword	0x1f45c398732bc50c
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Hash per second
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hashps:
	byte	0x20
	byte	0x68		;h
	byte	0x61		;a
	byte	0x73		;s
	byte	0x68		;h
	byte	0x2F		;/
	byte	0x73		;s
	byte	0x00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
K256:
	dword	0x428a2f9871374491	;k 0- 1	K Constant
	dword	0xb5c0fbcfe9b5dba5	;k 2- 3
	dword	0x3956c25b59f111f1	;k 4- 5
	dword	0x923f82a4ab1c5ed5	;k 6- 7
	dword	0xd807aa9812835b01	;k 8- 9
	dword	0x243185be550c7dc3	;k10-11
	dword	0x72be5d7480deb1fe	;k12-13
	dword	0x9bdc06a7c19bf174	;k14-15
	dword	0xe49b69c1efbe4786	;k16-17
	dword	0x0fc19dc6240ca1cc	;k18-19
	dword	0x2de92c6f4a7484aa	;k20-21
	dword	0x5cb0a9dc76f988da	;k22-23
	dword	0x983e5152a831c66d	;k24-25
	dword	0xb00327c8bf597fc7	;k26-27
	dword	0xc6e00bf3d5a79147	;k28-29
	dword	0x06ca635114292967	;k30-31
	dword	0x27b70a852e1b2138	;k32-33
	dword	0x4d2c6dfc53380d13	;k34-35
	dword	0x650a7354766a0abb	;k36-37
	dword	0x81c2c92e92722c85	;k38-39
	dword	0xa2bfe8a1a81a664b	;k40-41
	dword	0xc24b8b70c76c51a3	;k42-43
	dword	0xd192e819d6990624	;k44-45
	dword	0xf40e3585106aa070	;k46-47
	dword	0x19a4c1161e376c08	;k48-49
	dword	0x2748774c34b0bcb5	;k50-51
	dword	0x391c0cb34ed8aa4a	;k52-53
	dword	0x5b9cca4f682e6ff3	;k54-55
	dword	0x748f82ee78a5636f	;k56-57
	dword	0x84c878148cc70208	;k58-59
	dword	0x90befffaa4506ceb	;k60-61
	dword	0xbef9a3f7c67178f2	;k62-63
	byte	0x00
Hinit:
	word	0x6a09e667bb67ae85	;H0-1	initial Hash
	word	0x3c6ef372a54ff53a	;H2-3
	word	0x510e527f9b05688c	;H4-5
	word	0x1f83d9ab5be0cd19	;H6-7
	byte	0x00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;HASH subroutine to generate the 256-bit message digest from 
;M = m512 is the 16-words input buffer
;W = buffer is the 64-word message schedule 
;h0 to h7 = hash values
;wva, wvb, ..., wvh = working variables a to h
;K = K256 the 64-words constant
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
HASH:	ldi	r2, 	0
sch1:	ldix	r0, 	r2, 	m512
	stix	r2, 	r0, 	buffer
	adi	r2, 	1
	cmpi	r2, 	16
	jnz	sch1
;Process the next 48 entrances
;R7 is currently the pointer to buffer (W)
sch2:	mov	r1, 	r2		; r1 = buffer[i]
	adi	r1, 	0xFFFE		;t-2			
	ldix	r0, 	r1, 	buffer  ;r0=W(t-2)	
	sig1	r0			;r0=sig1(W(t-2)) 
	adi	r1, 	0xFFFB		;t-7
	ldix	r3, 	r1, 	buffer	;r3=W(t-7)
	add	r3, 	r0		;r3=sig1(W(t-2))+W(t-7)
	adi	r1, 	0xFFF8		;t-15
	ldix	r0, 	r1, 	buffer	;r0=W(t-15)
	sig0	r0			;r0=sig0(W(t-15))
	adi	r1, 	0xFFFF		;t-16
	ldix	r4, 	r1, 	buffer
	add	r4, 	r0		;r4=sig1(W(t-15))+W(t-16)
	add	r3, 	r4		
;;;;;;;;;r3=sig1(W(t-2))+W(t-7)+sig1(W(t-15))+W(t-16)
	stix	r2, 	r3, 	buffer
	adi	r2,	1
	cmpi	r2, 	64
	jnz	sch2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;At this point, we have prepared the 64 32-bit 
;message schedule: W
;Use R3 as the loop count since R2 will be use by functions
;initialize the working variables with initial H
;The working variables are defined in sequence and 
;work like a table
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	ldi	r3, 	0		;index
sch3:	ldix	r0, 	r3, 	Hinit
	stix	r3, 	r0, 	wva
	stix	r3, 	r0, 	h0
	adi	r3, 	1
	cmpi	r3, 	8
	jnz	sch3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Begin the big loop of 0 to 63
;From this point on:
;	R6 is reserved as pointer to K
;	R7 is reserved as pointer to W
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldi	r3, 	0		;index
sch4:	ldm	r0, 	wve		;r0=e
	sum1	r0			;r0=sum1(e)
	ldm	r4, 	wvh		;r4=h
	add	r4, 	r0		;r4=h+sum1(e)
	ldm	r0, 	wve		;r0=e
	ldm	r1, 	wvf		;r1=f
	ldm	r2, 	wvg		;r2=g
	ch	r0, 	r1, 	r2	;r0=Ch(e,f,g)
	add	r4, 	r0		;r4=h+sum1(e)+Ch(e,f,g)
	ldix	r0, 	r3, 	k256
	add	r4, 	r0		;r4=h+sum1(e)+Ch(e,f,g)+K
	ldix 	r0, 	r3, 	buffer
	add	r4, 	r0		;r4=h+sum1(e)+Ch(e,f,g)+K+W
	stm	t1, 	r4		;T1=h+sum1(e)+Ch(e,f,g)+K+W
	ldm	r0, 	wva		;r0=a
	sum0	r0		
	mov	r4, 	r0		;r4=sum0(a)
	ldm	r0, 	wva		;r0=a
	ldm	r1, 	wvb		;r1=b
	ldm	r2, 	wvc		;r2=c
	maj	r0, 	r1, 	r2	;r0=Maj(a,b,c)
	add	r4, 	r0		;r4=sum0(a)+Maj(a,b,c)
	stm	t2, 	r4		;T2=sum0(a)+Maj(a,b,c)
	ldm	r0, 	wvg
	stm	wvh,	r0		;h <= g
	ldm	r0, 	wvf
	stm	wvg,	r0		;g <= f
	ldm	r0, 	wve
	stm	wvf,	r0		;f <= e
	ldm	r0, 	wvd
	ldm	r1, 	t1
	add	r0, 	r1
	stm	wve, 	r0		;e <= d + T1
	ldm	r0, 	wvc
	stm	wvd,	r0		;d <= c
	ldm	r0, 	wvb
	stm	wvc, 	r0		;c <= b
	ldm	r0, 	wva
	stm	wvb,	r0		;b <= a
	ldm	r0, 	t1
	ldm	r1, 	t2
	add	r0, 	r1
	stm	wva,	 r0		;a <= T1 + T2
	adi	r3, 	1
	cmpi	r3, 	64
	jnz	sch4
;calculate the hash values
	ldi	r5, 	0		;index
sch5:	ldix	r0, 	r5, 	wva
	ldix	r4, 	r5, 	h0
	add	r0, 	r4
	stix	r5, 	r0, 	h0
	adi	r5, 	1
	cmpi	r5, 	8
	jnz	sch5	
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function Ch(x, y, z)
;input: r0=x, r1=y, r2=z
;output: r0=Ch(x, y, z)
;affects: r5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ch:	push	r6
	mov	r5, 	r0
	and	r0, 	r1		;r0=x and y
	ldi	r6, 	0xFFFF
	xor	r5, 	r6		;r5=not x
	and	r5, 	r2		;r5=not x and z
	xor	r0, 	r5
	pop	r6
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function Maj(x, y, z)
;input: r0=x, r1=y, r2=z
;output: r0=Maj(x, y, z)
;affects: r5
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
maj:	mov	r5, 	r0
	and	r0, 	r1		;r0=x and y
	and	r5, 	r2		;r5=x and z
	and	r1, 	r2		;r1=y and z
	xor	r0, 	r5	
	xor	r0, 	r1
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function sum0(x)
;input: r0=x
;output: r0=sum0(x)
;affects: r5, r1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sum0:	mov	r5, 	r0
	mov	r1, 	r0
	ror	r0, 	2		;r0=ROTR^2(x)
	ror	r5, 	13		;r5=ROTR^13(x)
	ror	r1, 	22		;r1=ROTR^22(x)
	xor	r0, 	r5
	xor	r0, 	r1
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function sum1(x)
;input: r0=x
;output: r0=sum1(x)
;affects: r5, r1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sum1:	mov	r5, 	r0
	mov	r1, 	r0
	ror	r0, 	6		;r0=ROTR^6(x)
	ror	r5, 	11		;r5=ROTR^11(x)
	ror	r1, 	25		;r6=ROTR^25(x)
	xor	r0, 	r5
	xor	r0, 	r1
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function sig0(x)
;input: r0=x
;output: r0=sig0(x)
;affects: r4, r5, r6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sig0:	mov	r5, 	r0
	mov	r6, 	r0
	ror	r0, 	7		;r0=ROTR^7(x)
	ror	r5, 	18		;r5=ROTR^18(x)
	ror	r6, 	3		;r6=ROTR^3(x)
	ldh	r4, 	0x1FFF	
	ldl	r4, 	0xFFFF		;mask out 3 MSB
	and	r6, 	r4		;r6=SHR^3(x)
	xor	r0, 	r5
	xor	r0, 	r6
	ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Function sig1(x)
;input: r0=x
;output: r0=sig1(x)
;affects: r4, r5, r6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sig1:	mov	r5, 	r0
	mov	r6, 	r0
	ror	r0, 	17		;r0=ROTR^17(x)
	ror	r5, 	19		;r5=ROTR^19(x)
	ror	r6, 	10		;r6=ROTR^10(x)
	ldh	r4, 	0x003F	
	ldl	r4, 	0xFFFF	;mask out 10 MSB
	and	r6, 	r4		;r6=SHR^10(x)
	xor	r0, 	r5
	xor	r0, 	r6
	ret

