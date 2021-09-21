.arch rhody		;use rhody.cfg
.outfmt hex		;output format is hex
.memsize 2048		;specify 2K words
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
.define time0	0xf0003	;Timer 0
.define nines	0x0800	;variable nines
.define pdigit	0x0801	;variable predigit
.define	tmpq	0x0802	;variable q
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
spigot:	sys	clear		;clear text video
	ldi	r1, 0		;initial screen position	
	stm	tx, r1		;TX=0
	stm	ty, r1		;TY=0
	ldi	r4, 0		;R4 = fist two digits flag
	stm	format, r4	;print numbers in decimal
	stm	time0, r4
	ldi	r0, 0x0F
	stm	tascii, r0	
	sys	putchar		;print "pi"
	ldi	r0, 0x3D
	stm	tascii, r0	
	sys	putchar		;print "="
	ldi	r4, 1		;R4 = skip first two digits flag
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  for j := 1 to len do a[j] := 2; {Start with 2's}
;  nines := 0; predigit := 0 {First predigit is a 0}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
init:	ldi	r0, 0
	stm	nines, r0	;nines = 0
	stm	pdigit, r0	;predigit = 0
	ldm	r3, len		;array length
	ldi	r1, 2		;initialize array to all 2's
	ldi	r2, 1		;loop count
sp1:	stix	r2, r1, array
	adi	r2, 1
	cmp	r2, r3		;end of array?
	js	sp1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Outer loop count R7 = j
;  for j := 1 to n (length) do
;  begin q := 0;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldi	r7, 1		;R7 = j = 1
sp2:	ldi	r0, 0
	stm	tmpq, r0	;q = 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;inner loop count R6 = i 
;    for i := len downto 1 do {Work backwards}
;    begin
;      x := 10*a[i] + q*i;
;      a[i] := x mod (2*i-1);
;      q := x div (2*i-1);
;    end;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r6, len		;R6 = i = len
sp3:	ldix	r1, r6, array	;R1 = A[i]
	ldi	r2, 10
	mul	r1, r2		;R1 = 10 * A[i]
	ldm	r3, tmpq	;R3 = Q	
	mul	r3, r6		;R3 = Q*i
	add	r3, r1		;R3 = X = 10 * A[i] + Q*i
	ldi	r1, 2
	mul	r1, r6		;R1 = 2*i
	adi	r1, 0xFFFF	;R1 = 2*i-1
	div	r3, r1		;R3 = X/2i-1 and R1 = X mod 2i-1	
	stix	r6, r1, array	;A[i] = X mod 2i-1
	stm	tmpq, r3	;Q = X/2i-1 
	adi	r6, 0xFFFF	;dec inner loop count
	jnz	sp3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   a[1] := q mod 10; q := q div 10;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r0, tmpq
	ldi	r1, 10
	div	r0, r1		;R0 = Q/10 and R1 = Q mod 10
	stm	tmpq, r0	;Q = Q/10	
	ldi	r2, 1
	stix	r2, r1, array	;A[1] = Q mod 10
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    if q = 9 then nines := nines + 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	cmpi	r0, 9		;R0 = Q
	jnz	sp4
	ldm	r1, nines
	adi	r1, 1
	stm	nines, r1	;nines = nines + 1
	jmp	sp9
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    else if q = 10 then
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sp4:	cmpi	r0, 10		;R0 = Q
	jnz	sp7
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      begin write(predigit+1);
;        for k := 1 to nines do write(0); {zeros}
;        predigit := 0; nines := 0
;      end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r2, pdigit
	adi	r2, 1
	stm	tnum, r2		
	call	printd		;print predigit+1
	ldm	r2, nines
	cmpi	r2, 0
	jz	sp6
	ldi	r0, 0
	stm	tnum, r0	;print '0'
	ldm	r2, nines
	ldi	r6, 1		;R6 = k = 1 to nines
sp5:	call	printd
	adi	r6, 1
	cmp	r2, r6
	jns	sp5
sp6:	ldi	r0, 0
	stm	pdigit, r0	;predigit = 0
	stm	nines, r0	;nines = 0
	jmp	sp9
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      else begin
;        write(predigit); predigit := q;
;        if nines <> 0 then
;        begin
;          for k := 1 to nines do write(9);
;          nines := 0
;        end
;      end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sp7:	ldm	r2, pdigit
	stm	tnum, r2
	call	printd		;print predigit
	ldm	r0, tmpq
	stm	pdigit, r0	;predigit = Q
	ldm	r2, nines
	cmpi	r2, 0
	jz	sp9		;continue if Q/=0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;inner loop count R6 = k from 1 to nines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldi	r0, 9
	stm	tnum, r0	;print '9'
	ldi	r6, 1		;R6 = k = 1 to nines
sp8:	call	printd
	adi	r6, 1
	cmp	r2, r6
	jns	sp8
	ldi	r0, 0
	stm	nines, r0	;nines = 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Check outer loop count
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sp9:	adi	r7, 1
	ldm	r0, length
	cmp	r7, r0
	js	sp2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Print pdigit before halt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ldm	r0, pdigit
	stm	tnum, r0
	sys	printn		;print predigit
	ldi	r0, 0x0D	;CR
	stm	tascii, r0
	sys	putchar
	ldm	r0, time0
	stm	tnum, r0
	sys	printn
	ldi	r0, 0x0B	;'mu'
	stm	tascii, r0
	sys	putchar
	ldi	r0, S		;'S'
	stm	tascii, r0
	sys	putchar
halt:	jmp	halt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.define array	0x10000
len:	word	19326	;array size = length * 10/3
length:	word	5798	;number of digits (n)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Print pdigit subroutine
;Handles the first two digits and decimal point
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printd:
	cmpi	r4, 0
	jz	print1
	ldm	r0, tnum
	cmpi	r0, 0		;is it 0?
	jnz	print0
	ret			;do nothing for the leading 0
print0:	sys	printn
	ldi	r0, 0x2E
	stm	tascii, r0	
	sys	putchar		;print "."
	ldi	r4, 0		;reset flag
	ret
print1:	sys	printn
	ret


