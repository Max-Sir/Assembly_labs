.model small
        .stack 100h
        .code
        .186
        
LP:
        push    FAR_BSS
        pop     ds
        
        xor     ax,ax 
          int 1Ah
        
        mov     di,320*200+1
rand_gen:
        imul    dx,3425h
        inc     dx
        mov     ax,dx 
        shr     ax,15 
        mov     byte ptr [di],al
        dec     di 
        jnz     rand_gen
 
        mov     ax,0013h
          int 10h
        
lloop:      
        mov     di,320*200+1
        
neighbour:                                              
        mov     al, byte ptr [di+1]
        add     al, byte ptr [di-1]
        add     al, byte ptr [di+320]
        add     al, byte ptr [di-320]
        add     al, byte ptr [di+321]
        add     al, byte ptr [di-321]
        add     al, byte ptr [di+319]
        add     al, byte ptr [di-319]
        
        shl     al,4 
        or      byte ptr [di],al 
        dec     di 
        jnz     neighbour 
 
        mov     di,320*200+1 
        
selection:
        mov     al,byte ptr [di]
        shr     al,4
        cmp     al,3 
        je      birth
        cmp     al,2 
        je      cont
        and     byte ptr [di],0 
        jmp     cont
birth:
        mov     byte ptr [di],1
 
cont:
        and     byte ptr [di],0Fh 
        
        dec     di 
        jnz     selection
 
        mov     si,320*200+1 
        mov     cx,319 
        mov     dx,199
Life:
        mov     ah,0Ch
        mov     al, byte ptr [si]
          int 10h
        dec     si
        dec     cx 
        jns     Life
        
        mov     cx,319 
        dec     dx 
        jns     Life
        
        mov     ah,1
          int 16h
        
        jz      lloop
        
        mov     ax,0003h
          int 10h 
 
        mov     ax,4C00h
          int 21h
          
        .fardata?
        db      320*200+1 dup(?)
          
        end     LP