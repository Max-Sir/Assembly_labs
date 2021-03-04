.model small
.stack 100h
.data
	
	;;;Messages that will be out to the screen;;;
	
	msg1 db "Input string:", 0dh, 0ah, '$' 
	msg2 db 0dh, 0ah, "Enter the substring you want to replace:", 0dh, 0ah, '$'
	msg3 db 0dh, 0ah, "Result: $" 
	msg4 db 0dh, 0ah, "Enter new substring: $";
	
	
	string db 200 dup("$");tmp str as known as buffer
	sbstrToRemove db 200 dup("$");str which we'll replacing by another str
	sbstrToInsert db 200 dup("$");string which we0 shall be insert instead of old
	capacity EQU 200 ;const sizeof buffer
	flag dw 0 ;flag to detect direction flag changing

.code    
	FuckingDos:			;Entry point of program
	
		call main  ;calling of main procedure
		
		main proc
			mov ax, @data
			mov ds, ax
			mov es, ax 		;;;loads @data into ES && DS segment registers, this manipul needed to model samll == .exe work properly
			
			mov ah, capacity ;; load max size of buffer in the fact it is simple 
			mov string[0], ah    ;first byte - max srting size
			mov sbstrToRemove[0], ah ;;load capacity as 1st byte of all manip strings
			mov sbstrToInsert[0], ah     
			
			lea dx, msg1;load adress of msg1
			call puts;;out this str
			lea dx, string;;In buffer to input operation
			call gets;;fun analog to C but written by myosa
			
			lea dx, msg2;;etc repeat inp for other manip
			call puts
			lea dx, sbstrToRemove
			call gets            
			
			lea dx, msg4
			call puts
			lea dx, sbstrToInsert
			call gets
			
			xor cx, cx;;set Counter to NULL cx:=0
			mov cl, string[1];;load length of str to c low for indexing on this str
			sub cl, sbstrToRemove[1];;decreasing of main str len
			jb _End;;jump bellow 
			inc cl;;cl++
			cld;;clear direction flag DF known as setting DF==0
			
			lea si, string[2];;loading adresses of 1st chars to indexing registers
			lea di, sbstrToRemove[2]
			
			call ReplaceSubstring
			
			_End:   
			lea dx, msg3
			call puts
			lea dx, string[2];;begin of changed result str
			call puts
			
			mov ah, 4ch      ;;end procees/pprogram   
			int 21h;;call interuption
			ret
		endp main  
		
		
		ReplaceSubstring proc
			Cycle:
				mov flag, 1
				push si;;save condition of si & di
				push di
				push cx
				
				mov bx, si
				
				xor cx, cx;;CX=NULL=0
				mov cl, sbstrToRemove[1]
				
				repe cmpsb;;compare str of bytes
				je FOUND
				jne NOT_FOUND
			
			
			FOUND:;;if substring was found
				call DeleteSubstring
				mov ax, bx
				call InsertSubstring
				mov dl, sbstrToInsert[1] 
				add string[1], dl        
				mov flag, dx     
			
			
			NOT_FOUND:;;if substr is appsent
				pop cx
				pop di
				pop si
				add si, flag
			
			Loop Cycle
			
			ret
		endp ReplaceSubstring  
		
		DeleteSubstring proc
			push si;;save indexes to stack
			push di;;
			mov cl, string[1];;lenght
			mov di, bx
			
			repe movsb;;copying every byte from si to di
			
			pop di
			pop si;;load prev saveded indexes from stack
			
			ret                
		endp DeleteSubstring
		
		InsertSubstring proc
			lea cx, string[2]   ; string 1st symbol address
			add cl, string[1]   ; add string length to get to next symbol after the last
			mov si, cx          ; last symbol as a source 
			dec si              ; at the last symbol
			mov bx, si          ; save last symbol in bx
			add bl, sbstrToInsert[1] ; now there is the last symbol of new string in bx
			mov di, bx          ; new last symbol is reciever
			;inc bx             
			
			mov dx, ax          ; ax is a place to insert
			sub cx, dx          ; after last symbol -= place to insert
			std                 ; moving backward
			repe movsb
			
			lea si, sbstrToInsert[2] ; source is sbstr 1st symbol
			mov di, ax          ; reciever is a place to insert
			xor cx, cx          ; set cx to zero
			mov cl, sbstrToInsert[1] ; sbstr length to cx
			cld                 ; moving forward
			repe movsb            ;;repeat equals
			
			ret
		endp InsertSubstring                
		
		; I/O procedures
		
		gets proc   ;;define proc gets
			mov ah, 0Ah;;input interuption
			int 21h
			ret
		endp gets
		
		puts proc ;;define proc puts
			mov ah, 9 
			int 21h
			ret;;retun to callback side
		endp puts
		
	end FuckingDos;;end of code section