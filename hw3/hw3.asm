


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; function is_prime(n : integer)
;; input:
;; 	r6 = a 32-bit sign number to be determined for prime
;; output:
;; 	r7 = 1 if R6 is a prime; 0 otherwise
;; 	r6 content is not affected
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

prime:	push 	r0
	push	r1
	ldi	r7,	3	;divide by 3
	modu	r6,	r7	;test remainder
	jz	return_false

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; let i = 5
;; while i * i <= n
;; 	if n mod i = 0 or n mod (i + 2) = 0
;; 
;; 
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
