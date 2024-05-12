.data

	TestString1 db "Hello World!", 0
	TestString2 db "Hello World!", 0
	TestString3 db "Hello Worfd!", 0
	TestString4 db "Hello World", 0
    DestinationBuffer db 100 dup(0)

.code

align 16

	;
	; takes in a pointer to a null
	; terminated string and returns the
	; length of that string
	;
	; params:
	;  rcx -> string pointer
	;
	strlen proc

		;
		; save the state of rdi
		;
		push rdi

		;
		; rdx will be used as the source
		; for our repne scasb instruction
		;
		mov rdi, rcx

		;
		; save the state of rcx
		;
		push rcx

		;
		; setup max loop iterations
		;   ( this will set rcx to UINT64_MAX )
		;
		mov rcx, -1

		;
		; set al( compare byte ) to '\0' so
		; our loop will break when and if we
		; find a null terminator
		;
		xor al, al

		;
		; perform loop on string
		;
		repne scasb

		;
		; set rax to UINT64_MAX or our starting
		; loop counter
		;
		mov rax, -1

		;
		; subtract from rax value we have left in rcx
		; which will have been subtracted 1 for each loop
		; of repne
		;
		sub rax, rcx

		;
		; restore the state of registers
		;
		pop rcx
		pop rdi

		ret

	strlen endp

	;
	; takes in a pointer to a string
	; and find the first occurence of
	; a specific character
	;
	; params:
	;  rcx -> string pointer
	;  rdx -> character
	;
	strchr proc

		;
		; save state of rdi
		;
		push rdi

		;
		; rdx will be used as the source
		; for our repne scasb instruction
		;
		mov rdi, rcx

		;
		; since this is the "safe" implementation
		; we will only loop for the size of the string
		;
		call strlen

		;
		; save the state of registers
		;
		push rcx

		;
		; setup max loop iterations to size of 
		; string passed in
		;
		mov rcx, rax

		;
		; set al( compare byte ) to lower
		; 16 bits of rdx which should contain
		; the character we want to break on
		;
		mov rax, rdx

		;
		; perform loop on string
		;
		repne scasb

		;
		; rdi will have been incremented for
		; each iteration in the loop so 
		; it will hold the address of the character
		;
		mov rax, rdi

		;
		; this will make sure we return a pointer
		; to the beginning of the character
		;
		sub rax, 1
		
		;
		; restore the state of registers
		;
		pop rcx
		pop rdi

		ret

	strchr endp

	;
	; params:
	;  rcx -> dst
	;  rdx -> src
	;  r8  -> len
	;
	memcpy proc
		
		;
		; save state of registers
		;
		push rsi
		push rdi

		;
		; set source and destination
		; paramaters for movsb
		;
		mov rsi, rdx
		mov rdi, rcx

		;
		; save state of rcx
		;
		push rcx

		;
		;  set loop iteration count
		;
		mov rcx, r8

		;
		; preform memcpy
		;
		rep movsb

		;
		; restore state of registers
		;
		pop rcx
		pop rdi
		pop rsi

		ret

	memcpy endp

	;
	; params:
	;  rcx -> dst
	;  rdx -> val
	;  r8  -> len
	;
	memset proc

		
		;
		; save state of registers
		;
		push rax
		push rdi

		;
		; set source and destination
		; paramaters for stosb
		;
		mov rax, rdx
		mov rdi, rcx

		;
		; save state of rcx
		;
		push rcx

		;
		;  set loop iteration count
		;
		mov rcx, r8

		;
		; preform memset
		;
		rep stosb

		;
		; restore state of registers
		;
		pop rcx
		pop rdi
		pop rax

		ret

	memset endp

	;
	; params:
	;  rcx -> str1
	;  rdx -> str2
	;
	strcmp proc

		;
		; save state of registers
		;
		push rdi
		push rcx

		;
		; get size of str1
		;
		call strlen

		mov rdi, rax

		;
		; save state of rcx
		;
		push rcx

		;
		; set first param to str2
		;
		mov rcx, rdx

		;
		; get size of str2
		;
		call strlen

		;
		; restore state of rcx
		;
		pop rcx

		;
		; compare sizes of strings
		;
		cmp rdi, rax

		;
		; jump to not equal return if
		; strings arent the same size
		;
		jne not_equal

		;
		; set source and destination
		; paramaters for cmpsb
		;
		mov rdi, rcx
		mov rsi, rdx

		;
		;  set loop iteration count
		;
		mov rcx, rax

		;
		; preform strcmp
		;
		cld
		repe cmpsb

		;
		; if ZF flag is set the strings
		; are equal
		;
		jz equal

not_equal:

		mov rax, 1     

		jmp return_label

equal:

		xor rax, rax   

		jmp return_label

return_label:

		;
		; restore state of registers
		;
		pop rcx
		pop rdi

		ret

	strcmp endp
	
	;
	; params:
	;  rcx -> string
	;  rdx -> value
	;  r8  -> len
	;
	strset proc

		call memset

		ret

	strset endp

	main proc

		;
		; set return value to 0
		;
		xor rax, rax

		ret
	
	main endp

end