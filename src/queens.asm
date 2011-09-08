		section .text

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; find_queens:	recursively solves the 8-queens problem
; arguments:	found_callback: void (*)(int board[]), where board is an array
;		of the column positions (1-8) in which a queen is located for
;		each of the 8 rows of the board.
; returns:	number of solutions found.
;	
		global find_queens
find_queens:	enter 8*4, 0
		mov ebx, esp		; array of 8 queen positions
		mov esi, [ebp+8]	; found solution callback
		push dword 0		; occupied columns
		push dword 0		; occupied SW diagonals
		push dword 0		; occupied SE diagonals
		mov edi, 0		; edi = row index (0-7)
		call .recurse		; recursively find solutions
		leave			; unwind stack
		ret			; return count of solutions found
.recurse	cmp edi, 8
		jl .cont_recurse	; check if solution found
		push esi		; save esi
		push ebx		; save ebx (also first arg)
		call esi		; call found solution callback
		pop ebx			; restore ebx
		pop esi			; restore esi
		mov edi, 8		; restore edi
		mov eax, 1
		ret			; return solution found
.cont_recurse	push dword 0		; count of solutions found
		mov ecx, 8		; ecx = column index (1-8)
.col_loop	enter 0, 0
		mov eax, 0x80
		rol al, cl
		mov edx, eax
		and eax, [ebp+20]
		jnz .col_loop_brk	; reject if column occupied
		or edx, [ebp+20]
		push edx		; new occupied columns
		push ecx
		add ecx, edi
		mov eax, 0x8000
		rol ax, cl
		pop ecx
		mov edx, eax
		and eax, [ebp+16]
		jnz .col_loop_brk	; rej if SW diagonal occupied
		or edx, [ebp+16]
		push edx		; new occupied SW diagonal
		push ecx
		add ecx, 7
		sub ecx, edi
		mov eax, 0x8000
		rol ax, cl
		pop ecx
		mov edx, eax
		and eax, [ebp+12]
		jnz .col_loop_brk	; reject if diagonal occupied
		or edx, [ebp+12]
		push edx		; new occupied SE diagonal
		mov [ebx+(edi*4)], ecx	; update board
		inc edi
		call .recurse		; recurse into next row
		add [ebp+4], eax	; update solutions count
		dec edi			; restore edi
		mov ecx, [ebx+(edi*4)]	; restore ecx
.col_loop_brk	leave
		loop .col_loop		; next column
		pop eax
		ret			; return solutions count
