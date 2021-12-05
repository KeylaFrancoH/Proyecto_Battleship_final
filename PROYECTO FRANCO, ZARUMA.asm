name "BATLESHIP BY FRANCO KEYLA, ZARUMA RICARDO"  

.model small
.stack 100h
.data

;MATRIZ PARA EL JUGADOR
matriz_navios_comp db 36 dup(0)

;VARIABLES PARA LA MATRIZ
linha db 00h                            
coluna db 00h
sentido dw 00h
endereco_lin_col dw 00h
simbolo db 00h 
tamanhobarco db 00h

;COLUMNAS VALIDAS
columnas_mayus db 'A', 'B', 'C', 'D', 'E', 'F'
columnas_minus db 'a', 'b', 'c', 'd', 'e', 'f'
cabecera_matriz db "  A B C D E F", 10, 13, "$"

;VARIABLES PARA EL MANEJO DEL CURSOR
colcursor db 00h
lincursor db 00h
pagcursor db 00h 

;VARIABLES PARA CONTABILIZAR LOS TIROS
tiros db 00h
tiros_repetidos db 20 dup(100)
coltiros EQU 73
lintiros EQU 5
acertos db 00h 
linacertos EQU 6

;BANDERAS PARA UBICAR 'P', 'C' Y 'S'
ubicando_portaviones db 0
ubicando_crucero db 0
ubicando_submarino db 0

;CONTADORES PARA CONFIRMAR BARCOS HUNDIDOS (ENCERAR AL FINAL DEL JUEGO)
tamano_p db 0
tamano_c db 0
tamano_s db 0


CR EQU 13    ; ENTER
LF EQU 10    ; LINEA

;---------------------Mensagens do JUEGO---------------------
   TELA_INICIAL1 DB 0C9h,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0BBh,'$' 
   TELA_INICIAL2 DB 0BAh,'          B A T A L L A    N A V A L             ',0BAh,'$' 
   TELA_INICIAL3 DB 0BAh,'Presiona ENTER para iniciar y s para salir       ',0BAh,'$'
   TELA_INICIAL4 DB 0BAh,'          Franco Keyla, Zaruma Ricardo           ',0BAh,'$' 
   TELA_INICIAL5 DB 0C8h,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0BCh,'$'
   
   COLUNA_TELA_INICIAL EQU 22

   COLUNA_CONFIG EQU 30   
    
   MSG_CONFIG21 DB '                    ','$'
   MSG_CONFIG22 DB '                   COLOCANDO EMBARCACIONES       ','$'
; 
;------------------------Tela do JUEGO-----------------------  

    COLUNA_TIRO EQU 1 
    COLUNA_STATS EQU 58
    
    MSG_JOGO_TIRO1 DB   0DAh,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0BFh,'$'
    MSG_JOGO_TIRO2 DB   0B3h,'  BATTLESHIP ',0B3h,'$'
    MSG_JOGO_TIRO3 DB   0C3h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0B4h,'$'
    MSG_JOGO_TIRO4 DB   0B3h,'  A',0B3h,'B',0B3h,'C',0B3h,'D',0B3h,'E',0B3h,'F',0B3h,'$'
    MSG_JOGO_TIRO6 DB   0B3h,'1            ',0B3h,'$'
    MSG_JOGO_TIRO7 DB   0B3h,'2            ',0B3h,'$'
    MSG_JOGO_TIRO8 DB   0B3h,'3            ',0B3h,'$'
    MSG_JOGO_TIRO9 DB   0B3h,'4            ',0B3h,'$'                                                   
    MSG_JOGO_TIRO10  DB 0B3h,'5            ',0B3h,'$'
    MSG_JOGO_TIRO11  DB 0B3h,'6            ',0B3h,'$'
    MSG_JOGO_TIRO15  DB 0C0h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0D9h,'$'
    
    MSG_QUADRO_STATS1 DB  0DAh,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0BFh,'$'
    MSG_QUADRO_STATS2 DB  0B3h,'Jugador           ',0B3h,'$'
    MSG_QUADRO_STATS3 DB  0B3h,'  Tiros:          ',0B3h,'$'
    MSG_QUADRO_STATS4 DB  0B3h,'  Aciertos:       ',0B3h,'$'  
    MSG_QUADRO_STATS5 DB  0C3h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0B4h,'$'
     
    COLUNA_COORDENADAS EQU 23
    COLUNA_MENSAGENS EQU 39
    
    MSG_QUADRO_INPUT1 DB 0DAh,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C2h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0BFh,'$' 
    MSG_QUADRO_INPUT2 DB 0B3h,'MISIL EN COORDENADA:      ',0B3h,'MENSAJE:                                        ',0B3h,'$'
    MSG_QUADRO_INPUT3 DB 0C0h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C1h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0D9h,'$' 
;---------------------Mensagens de Acao---------------------
    MSG_TURNO1 db "SU TURNO$"

    MSG_HIT db "IMPACTO$"
    
    MSG_P_HUNDIDO db "  PORTAVIONES HUNDIDO$"
    
    MSG_C_HUNDIDO db "  CRUCERO HUNDIDO$"
    
    MSG_S_HUNDIDO db "  SUBMARINO HUNDIDO$"

    MSG_MISS db "SIN IMPACTO$"

    MSG_DOUBLE db "POSICION REPETIDA$"
    
    MSG_LIMPA_MSG db '                                   $'

    MSG_LIMPA_COOR db '   $'

    ;---------------------Mensagens de Fim---------------------
    MSG_VITORIA db "HAS GANADO$"

    MSG_DERROTA db "HAS PERDIDO, 20 MISILES AGOTADOS$" 

;--------------------------Tela Final-----------------------
    MSG_FINAL1 db 0C9h,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0BBh,'$'
    MSG_FINAL2 db 0BAh,'               FIM  DE  JUEGO                ',0BAh,'$'
    MSG_FINAL3 db 0BAh,'                                            ',0BAh,'$'
    MSG_FINAL4 db 0BAh,'   [R]einiciar   [J]ogar de novo   [S]air   ',0BAh,'$'
    MSG_FINAL5 db 0C8h,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0BCh,'$'

    LINHA_FINAL EQU 10
    COLUNA_FINAL EQU 17
.code
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
push_all MACRO  ; macro para salvar o contexto
    push ax
    push bx
    push cx
    push dx
    ;;;;;;;
    push si
    push di
    push bp
endm
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
pop_all MACRO      ; macro para restaurar o contexto
    pop bp
    pop di
    pop si
    ;;;;;;
    pop dx
    pop cx
    pop bx
    pop ax
endm
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
readkeyboard proc ; ler um caractere sem eco em AL
    mov ah, 7
    int 21H   
    ret       
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
writechar proc    ;escreve um char
    push ax       
    mov ah, 02H
    int 21H
    pop ax
    ret
endp 
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
writedirect proc    ;escreve um char
    push ax       
    mov ah, 06H
    int 21H
    pop ax
    ret
endp 
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
posicionacursor proc  ;Posiciona cursor, precisa de p?gina no BH, coluna no DL e linha no DH
    push ax 
    mov ah,02h     
    int 10h 
    pop ax 
    ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
printstring proc ;printa string terminada em $ , precisa do OFFSET em DX
    push ax
    mov ah,09h
    int 21h
    pop ax
    ret
endp  
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
getcursorposition proc ;pega posicao do cursor, por enquanto so precisa da coluna, entao e so o que salva 
    push_all
    mov ah,03h
    mov bh,pagcursor
    int 10h
    mov colcursor,DL 
    pop_all
    ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________ 
drawsymbol proc    ;desenha o simbolo das embarcacoes
    push ax 
    push cx
    mov ah,09h
    mov cx,1
    int 10h
    pop cx
    pop ax
    ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________ 
drawhit proc    ;desenha o simbolo de um hit na matriz de tiros
    push_all 
    mov bh,02
    mov AH,09h
    mov AL,031h ;1 si es correcto
    mov CX,1
    mov BL,0Ah
    int 10h
    pop_all
    ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________ 
drawmiss proc    ;desenha o simbolo de um miss na matriz de tiros
    push_all 
    mov bh,02
    mov AH,09h
    mov AL,030h
    mov CX,1
    mov BL,04h
    int 10h
    pop_all
    ret
endp
       
;;_________________________________________________________________________________________________________________________________
;;_________________________________________________________________________________________________________________________________
desenhaquadrado proc 
    push_all
    mov bh,02
    mov AH,09h
    mov AL,0FEh
    mov CX,1
    mov BL,09h
    int 10h
    pop_all
    ret
endp  

;_________________________________________________________________________________________________________________________________ 
;_________________________________________________________________________________________________________________________________
victorymsg proc 
    push_all
    ;Limpa a linha
    mov bh,02
    mov dh,22   ;linha para mandar mensagens
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_LIMPA_MSG
    call printstring

    ;manda a mensagem
    mov bh,02
    mov dh,22 
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_VITORIA   ;"Voce venceu"
    call printstring

    ;espera 5 segundos
    mov ah,86h
    mov cx,4Ch
    mov Dh,04Bh
    mov dl,040h
    int 15h
    pop_all
    ret
endp  
;_________________________________________________________________________________________________________________________________ 
;_________________________________________________________________________________________________________________________________
defeatmsg proc 
    push_all
    ;Limpa a linha
    mov bh,02
    mov dh,22   ;linha para mandar mensagens
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_LIMPA_MSG
    call printstring

    ;manda a mensagem
    mov bh,02
    mov dh,22 
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_DERROTA   ;"HAS PERDIDO, MISILES AGOTADOS"
    call printstring
    
    ;espera 5 segundos
    mov ah,86h
    mov cx,4Ch
    mov Dh,04Bh
    mov dl,040h
    int 15h
    pop_all
    ret
endp  

;_________________________________________________________________________________________________________________________________ 
;_________________________________________________________________________________________________________________________________ 
missedshot proc 
    push_all
    ;Limpa a linha
    mov bh,02
    mov dh,22   ;linha para mandar mensagens
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_LIMPA_MSG
    call printstring

    ;manda a mensagem
    mov bh,02
    mov dh,22 
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_MISS   ;"Errou o tiro"
    call printstring
    pop_all
    ret
endp  
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________ 
hitshot proc 
    push_all
    ;Limpa a linha
    mov bh,02
    mov dh,22   ;linha para mandar mensagens
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_LIMPA_MSG
    call printstring

    ;manda a mensagem
    mov bh,02
    mov dh,22   ;linha para mandar mensagens
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_HIT   ;"Acertou o tiro"
    call printstring
    cmp tamano_p, 4
    je P_HUNDIDO
    cmp tamano_c, 3
    je C_HUNDIDO
    cmp tamano_s, 2
    je S_HUNDIDO
    jne FIN_HITSHOT
  P_HUNDIDO:
    lea DX,MSG_P_HUNDIDO   ;"Acertou o tiro"
    call printstring
    mov tamano_p, 0
    jmp FIN_HITSHOT
  C_HUNDIDO:
    lea DX,MSG_C_HUNDIDO   ;"Acertou o tiro"
    call printstring
    mov tamano_c, 0
    jmp FIN_HITSHOT
  S_HUNDIDO:
    lea DX,MSG_S_HUNDIDO   ;"Acertou o tiro"
    mov tamano_s, 0
    call printstring    
  FIN_HITSHOT:
    pop_all
    ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
doublehit proc
    push_all
    ;Limpa a linha
    mov bh,02
    mov dh,22   ;linha para mandar mensagens
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    mov DX,OFFSET MSG_LIMPA_MSG
    call printstring

    ;manda a mensagem
    mov BH,02
    mov DH,22
    mov DL,COLUNA_MENSAGENS
    call posicionacursor
    mov DX, OFFSET MSG_DOUBLE
    call printstring
    pop_all
    ret
endp

;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________

RNG proc
    push_all
    mov ah, 00h  ; pega tempo do sistema        
    int 1AH      ; CX:DX = numero de ticks desde a meia-noite      

    mov  ax, dx  ;move valor pra dividir
    xor  dx, dx  
    mov  cx, 36;dividir por 100 pro restante ser de 0 a 99  
    div  cx       ; DX tem o restante da divisao 
    mov endereco_lin_col, dx

    push dx
    mov ax,dx
    xor dx,dx
    mov cx, 6 ;dividir por 10 pra pegar valor da coluna
    div cx
    mov coluna,dl
    mov linha,al
    pop dx

    mov ax,dx
    xor dx,dx
    mov cx,2    ;escolha do sentido
    div cx
    cmp dx,1
    je RNGh     ;se for 1 = horizontal
    mov sentido, 'v'
    jmp RNGok
  RNGh:
    mov sentido, 'h'
  RNGok: 
    pop_all
    ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
definemode proc ; define modo
    push ax
    mov al, 03h ; modo texto 80 x 25
    mov ah, 00h ; modo de video
    int 10h
    pop ax
    ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
changepage proc ; muda a pagina, o numero da pagina definido em al
    push ax
    mov ah, 05h ; numero de interrupcao de BIOS
    int 10h
    pop ax
    ret
endp

;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
verificanavio proc ;proc para verificar se nao vai dar overlap de navios ou bordas | precisa do offset da matriz em SI e end_lin_col em BX
    mov cl,tamanhobarco                                    ;Otimizar com pilha se der tempo
    cmp sentido, 'h'
    je VERIFHORIZ 
  VERIFVERT:  
	cmp byte ptr [SI+BX], 0 ;Testa se ha algo na posicao
    ja VERIFICANAVIOINVALIDO     
    cmp BX,36
    jb NELV ;N?o Estourou Linha Vertical
    jmp VERIFICANAVIOINVALIDO
    NELV: 
    add BX,6
    loop VERIFVERT ;Loop baseado no tamanho do barco
    jmp VALIDO
    
  VERIFHORIZ:
    mov cl,tamanhobarco
    mov bl,coluna
  LOOPVERIFHORIZ1: ;testa primeiro se nao estoura linha
    add BX, 1
    cmp BX,6
    jb NELH   ;N?o Estourou Linha Horizontal
    ja VERIFICANAVIOINVALIDO
    NELH:
    loop LOOPVERIFHORIZ1  ;Loop baseado no tamanho do barco
    mov BX,endereco_lin_col
    mov cl,tamanhobarco
  LOOPVERIFHORIZ2:              
    cmp byte ptr[SI+BX], 0 ;Testa se ha algo na posi??o
    ja VERIFICANAVIOINVALIDO
    add BX, 1
    loop LOOPVERIFHORIZ2    
    jmp VALIDO
   
  VERIFICANAVIOINVALIDO:  ;Se for invalido, BX = 100 
    mov BX,100
    jmp FIM_VERIFICACAO   
  VALIDO:   ;Se for valido, so restaura os valores
    mov bx, endereco_lin_col
    mov cl, tamanhobarco
  FIM_VERIFICACAO:
    ret
endp

;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
readinputaction proc                       ; le os dados de entrada do tiro
   push_all
   
    mov cx, 2
  PULOACTION:
    dec cx
    cmp cx, 0
    je LEERFILA
  LEERCOLUMNA:
    call readkeyboard
    cmp al, CR              ; verifica se eh ENTER
    jz LEERCOLUMNA ; je
     
    cmp al, 'a'
    jl INPUT_MAYUS
    jge INPUT_MINUS
    
  INPUT_MAYUS:
    cmp al, 'A'             ; verificar se eh valido
    jb LEERCOLUMNA 
  
    cmp al, 'F'
    ja LEERCOLUMNA
    
    jmp COL_VALIDA    
    
  INPUT_MINUS:
    cmp al, 'a'             ; verificar se eh valido
    jb LEERCOLUMNA 
  
    cmp al, 'f'
    ja LEERCOLUMNA
    
  COL_VALIDA:
    mov bx, 0
    xor ah, ah
    cmp al, 'a'
    jl INDICE_COLMAYUS
    jge INDICE_COLMINUS
    
  INDICE_COLMAYUS:
    mov SI,OFFSET columnas_mayus
    cmp byte ptr [SI+BX], al
    je SETTEAR_INDICECOL
    inc bx
    jmp INDICE_COLMAYUS
      
  INDICE_COLMINUS:
    mov SI,OFFSET columnas_minus
    cmp byte ptr [SI+BX], al
    je SETTEAR_INDICECOL
    inc bx
    jmp INDICE_COLMINUS
       
  SETTEAR_INDICECOL:  
    mov dl,al
    call writechar
    
  VALORCOLUNAACTION:
    mov coluna,bl      ;COLUNA ES LA COLUMNA
    mov cx,1
    jmp PULOACTION
  LEERFILA:
    call readkeyboard
    cmp al,CR              ; verifica se eh ENTER
    jz LEERFILA ; je
     
    cmp al,'1'             ; verificar se eh valido
    jb LEERFILA 
  
    cmp al,'6'
    ja LEERFILA
    mov dl,al
    call writechar
    sub al,'1'
    mov ah,0
    mov linha,al
    mov dl,6
    mul dl
    mov ah, coluna
    add al,ah      ;(linha*10)+coluna
    xor ah,ah
    mov endereco_lin_col,ax  ;move endereco decimal = posicao no vetor
    pop_all  
  ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
addbarco proc  ;precisa do indice em BX, endereco da matriz em SI,e tamanho do barco em CX
    push dx
    push cx
    ;mov dl,1        ;AQUI SE PONE EL VALOR EN LA MATRIZ DE JUEGO
    cmp ubicando_portaviones, 1
    je UBICAR_PORTAVIONES
    cmp ubicando_crucero, 1
    je UBICAR_CRUCERO
    cmp ubicando_submarino, 1
    je UBICAR_SUBMARINO
    
    UBICAR_PORTAVIONES:
        mov dl, 'P'
        jmp DEFINIR_SENTIDO
    UBICAR_CRUCERO:
        mov dl, 'C'
        jmp DEFINIR_SENTIDO
    UBICAR_SUBMARINO:
        mov dl, 'S'
    
    DEFINIR_SENTIDO:
        cmp sentido, 'h'
        je HORIZONTAL
    
  VERTICAL:     
    mov [SI+BX],dl ;Coloca valor de DL na posicao BX da matriz ("vetor")
    add BX, 6
    loop VERTICAL ;LOOP Decrementa o cx
    jmp BARCOOK
  HORIZONTAL:
    mov [SI+BX], dl ;Coloca valor de DL na posicao BX da matriz ("vetor")
    add BX, 1
    loop HORIZONTAL
    jmp BARCOOK
    
  BARCOOK:
    pop cx
    pop dx 
    ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
atualizastats proc 
    push_all
    ;Tiros Jogador_______________________________ 
    xor CX, CX
    mov BH, 02
    mov DL, coltiros
    mov DH, lintiros
    call posicionacursor
      xor DX,DX
      xor AX,AX
	  mov DL, tiros
	  add DL, 48
	  REPETETIROS:
	  cmp DL, 58
	  jb ESCREVETIROS
	  sub DL, 10
	  inc AL
	  mov DH, AL
	  loop REPETETIROS 
	  ESCREVETIROS:
	  mov AL, DL
	  mov DL, DH
	  add DL, 48
	  call writedirect
	  mov DL, coltiros+1 
      mov DH, lintiros
    call posicionacursor
      xor DX,DX
      mov DL, AL
      call writedirect	
      
      
    xor AX,AX
    xor CX, CX
    ;Acertos Jogador_____________________________
	mov DL, coltiros
    mov DH,linacertos
    call posicionacursor
      xor DX,DX
	  mov DL, acertos
	  add DL, 48
	  REPETEACERTOS:
	  cmp DL, 58
	  jb ESCREVEACERTOS
	  sub DL, 10
	  inc AL
	  mov DH, AL
	  loop REPETEACERTOS 
	  ESCREVEACERTOS:
	  mov AL, DL
	  mov DL, DH
	  add DL, 48
	  call writedirect
	  mov DL, coltiros+1
      mov DH, linacertos
      call posicionacursor
      xor DX,DX
      mov DL, AL
      call writedirect
      
    pop_all
    ret
endp  

;;_________________________________________________________________________________________________________________________________
;;_________________________________________________________________________________________________________________________________
fireshot proc ;"Atira" o tiro, modificando o vetor, a matriz da tela, e atualizando os stats
; 
   push bx
    mov SI, OFFSET matriz_navios_comp
    mov al, bl
    mov BX, endereco_lin_col
    mov byte ptr[SI+BX], al
    pop bx
    ;Vetor modificado   
    cmp bx, 'P'
    je GOLPE
    cmp bx, 'C'
    je GOLPE
    cmp bx, 'S'
    je GOLPE
    jmp MISS
;  ;Acertou o tiro__________________________________________    
;    
  GOLPE:
    mov bh,coluna       ;posicao 0,0 tem linha 7 e coluna 4
    mov al,2
    mul bh     ;multiplica por 2 pra achar o equivalente "grafico"
    add al,4  ;soma com a coluna inicial
    mov bh,02 ;pagina atual
    mov dh,linha
    add dh,7
    mov dl,al
    call posicionacursor
    call drawhit
    ;Matriz da tela modificada

    inc acertos
    inc tiros   
    jmp FIM_FS

  MISS:
    mov bh,coluna
    mov al,2
    mul bh     ;multiplica por 2 pra achar o equivalente "grafico"
    add al,4  ;soma com a coluna inicial
    mov bh,02 ;pagina atual 
    mov dh,linha
    add dh,7
    mov dl,al
    call posicionacursor
    call drawmiss
    ;Matriz da tela modificada

    inc tiros 
    
  FIM_FS:
    ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
configboardcomputer proc  ;proc para preparar o tabuleiro do computador
    ;"Colocando os barcos do computador."
    mov bh,2
    mov dh,19
    mov dl,COLUNA_CONFIG+1
    call posicionacursor
    mov DX, OFFSET MSG_CONFIG21
    call printstring
    
    mov bh,2
    mov dh,20
    mov dl,COLUNA_CONFIG+1
    call posicionacursor
    mov DX, OFFSET MSG_CONFIG22
    call printstring
   
    ;Posicionamento
  CPU_PORTA_AVIOES:
    mov ubicando_portaviones, 1
    mov ubicando_crucero, 0
    mov ubicando_submarino, 0   
    call RNG ;"input" do computador
    mov bx, endereco_lin_col
    mov tamanhobarco, 5
    mov SI, OFFSET matriz_navios_comp 
    call verificanavio
    cmp BX,100  ;se for 100, a posicao é invalida
    jne CPU_AVALIDO
    jmp CPU_PORTA_AVIOES
  CPU_AVALIDO:
    call addbarco ;adiciona o barco no vetor de barcos

  CPU_NAVIO_GUERRA:
    mov ubicando_portaviones, 0
    mov ubicando_crucero, 1
    mov ubicando_submarino, 0  
    call RNG ;"input" do computador
    mov bx, endereco_lin_col
    mov tamanhobarco, 4
    call verificanavio
    cmp BX,100  ;se for 100, a posicao é invalida
    jne CPU_BVALIDO
    jmp CPU_NAVIO_GUERRA
  CPU_BVALIDO:
    call addbarco ;adiciona o barco no vetor de barcos

  CPU_SUBMARINO:
    mov ubicando_portaviones, 0
    mov ubicando_crucero, 0
    mov ubicando_submarino, 1   
    call RNG ;"input" do computador
    mov bx, endereco_lin_col
    mov tamanhobarco, 3
    call verificanavio
    cmp BX,100  ;se for 100, a posicao é invalida
    jne CPU_SVALIDO
    jmp CPU_SUBMARINO
  CPU_SVALIDO:
    call addbarco ;adiciona o barco no vetor de barcos
 
    ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
desenhabarco proc ;proc para desenhar os barcos na tela
    ;posicaoo 0,0 tem linha 7 e coluna 33     --- posicaoo 9,9 tem linha 16 e coluna 51
    ;preparacaoo das coordenadas
    add linha,7 ;converte de ascii pra decimal e soma 7 da linha inicial
    mov bh,coluna
    mov al,2
    mul bh     ;multiplica por 2 pra achar o equivalente "grafico"
    add al,33  ;soma com a coluna inicial
    mov coluna,al

    ;posicionamento cursor                                                                         
    mov dh,linha 
    mov dl,coluna
  LOOPDESENHO:  
    mov bh,2
    call posicionacursor
    ;desenha s?mbolo
    mov al, simbolo
    mov bh,2 ; p?gina
    mov bl,0Fh  ;cor branca
    call drawsymbol
    ;incremento
    cmp sentido, 'h'
    je DHORIZONTAL
    inc dh ;se for vertical, s? incrementa linha e coluna fica igual
    loop LOOPDESENHO
    jmp FIMDESENHO
  DHORIZONTAL:
    add dl,2 ;se for horizontal, incrementa em 2 porque graficamente 1 coluna tem 2 espa?os
    loop LOOPDESENHO 
    jmp FIMDESENHO
  FIMDESENHO:
    ret
endp

;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
verifyshot proc ;verifica se o tiro do jogador acertou ou nao, mostrando a mensagem adequada
    mov bx,0
    mov cx,20
    mov SI,OFFSET tiros_repetidos
    mov ax,endereco_lin_col
  VERIFICAR_DUPLICADO:
    cmp byte ptr [SI+BX],al
    je TIRO_DUPLO
    inc bx
    loop VERIFICAR_DUPLICADO
    
    mov ax,endereco_lin_col
    mov bh,0
    mov bl,tiros
    mov SI,OFFSET tiros_repetidos
    mov byte ptr [SI+BX],al
    
    mov bx,endereco_lin_col   
    mov SI,OFFSET matriz_navios_comp
    cmp byte ptr [SI+BX], 'P'
    je GOLPEO_PORTAVIONES
    cmp byte ptr [SI+BX], 'C'
    je GOLPEO_CRUCERO
    cmp byte ptr [SI+BX], 'S'
    je GOLPEO_SUBMARINO        
    
    call missedshot
    mov bx,0   ;Se tiver errado, BX sai da proc com 0
    jmp fimVS
  GOLPEO_PORTAVIONES:
    call hitshot
    mov bx,'P'   ;Se tiver acertado, BX sai da proc com 1
    jmp fimVS
  GOLPEO_CRUCERO:
    call hitshot
    mov bx,'C'   ;Se tiver acertado, BX sai da proc com 1
    jmp fimVS
  GOLPEO_SUBMARINO:
    call hitshot
    mov bx,'S'   ;Se tiver acertado, BX sai da proc com 1
    jmp fimVS
  TIRO_DUPLO:
    call doublehit
    mov bx,2   ;Se ja tiver atirado na posicao, BX sai da proc com 2 
  fimVS:
    ret
endp

;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
yourturn proc
    push_all
  LER_OUTRO_INPUT:  
    mov bh,02
    mov dh,22   ;linha para mandar mensagens
    mov dl,COLUNA_MENSAGENS
    call posicionacursor
    push dx
    mov DX, OFFSET MSG_LIMPA_MSG ;Limpa o espaco das mensagens
    call printstring

    pop dx
    call posicionacursor
    mov DX, OFFSET MSG_TURNO1   ;Pede input
    call printstring

    mov dh,22
    mov dl,COLUNA_COORDENADAS
    call posicionacursor
    mov DX, OFFSET MSG_LIMPA_COOR ;Limpa espaco das coordenadas
    call printstring
    mov dh,22
    mov dl,COLUNA_COORDENADAS
    call posicionacursor
    mov columnas_mayus[0], 'A'
    mov columnas_mayus[1], 'B'
    mov columnas_mayus[2], 'C'
    mov columnas_mayus[3], 'D'
    mov columnas_mayus[4], 'E'
    mov columnas_mayus[5], 'F'
    mov columnas_minus[0], 'a'
    mov columnas_minus[1], 'b'
    mov columnas_minus[2], 'c'
    mov columnas_minus[3], 'd'
    mov columnas_minus[4], 'e'
    mov columnas_minus[5], 'f'
    call readinputaction ;Le o input
    call verifyshot ;Verifica o que acontece
    cmp bx,2
    je LER_OUTRO_INPUT
    call fireshot ;Se for valido, efetua o tiro
    cmp bx,0 ;compara pra saber o resultado da verificacao
    jne ATIRAR  ;se for 2, ler outro input
    jmp LER_OUTRO_INPUT    
    
  ATIRAR:
    cmp bl, 'P'
    je INCREMENTAR_CONTADOR_P
    cmp bl, 'C'
    je INCREMENTAR_CONTADOR_C
    cmp bl, 'S'
    je INCREMENTAR_CONTADOR_S    
  INCREMENTAR_CONTADOR_P:
    inc tamano_p
    jmp STATS
  INCREMENTAR_CONTADOR_C:
    inc tamano_c
    jmp STATS
  INCREMENTAR_CONTADOR_S:
    inc tamano_s
  STATS:
    call atualizastats  ;Atualiza o quadro de stats
    pop_all
    ret
endp

;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
readinitgame proc                   ; le a entrada ENTER para jugar S - SAIR
    push ax
  LEITURAJOGO:
    call readkeyboard
    cmp al, CR              ; verifica se eh ENTER
    je INICIAROJOGO
    cmp al, 's'
    je SAIRDOJOGO
    cmp al, 'S'
    je SAIRDOJOGO
    jmp LEITURAJOGO
  SAIRDOJOGO:
    call exit

  INICIAROJOGO:
    pop ax
    ret
endp

;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
game_screen proc      ;Desenha a tela principal de JUEGO
    mov ubicando_portaviones, 0
    mov ubicando_crucero, 0
    mov ubicando_submarino, 0
    push_all 
    mov al, 2
    mov PAGCURSOR, al
    call changepage
    ;Desenhar Matriz de Tiros
    mov BL, 3 ; linha inicial
    mov BH,PAGCURSOR
    mov DL,COLUNA_TIRO

    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_JOGO_TIRO1     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_JOGO_TIRO2     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_JOGO_TIRO3     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_JOGO_TIRO4     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_JOGO_TIRO6     
    call printstring
    pop DX  
    inc BL  
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_JOGO_TIRO7     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_JOGO_TIRO8     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_JOGO_TIRO9     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_JOGO_TIRO10     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_JOGO_TIRO11     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_JOGO_TIRO15     
    call printstring
    pop DX  
    inc BL
     
    ;Moldura desenhada, preencher com os quadrados agora
    mov CX,36
    mov DH, 7  ;Primeira linha    posicao 0,0 tem linha 7 e coluna 4 
    mov DL,COLUNA_TIRO+3
  DESENHA_MATRIZ_TIRO:  
    call posicionacursor
    call desenhaquadrado    
    cmp DL,14      ;22 e a ultima posicao de cada linha, se passar, vai pra proxima linha
    je LINHANOVA
    add DL,2       ;incrementa coluna
  PULOQUADRADO:
    loop DESENHA_MATRIZ_TIRO
    jmp FIMMATRIZTIRO  ;pula quando tiver terminado
  LINHANOVA:
    mov DL,COLUNA_TIRO+3
    inc DH
    jmp PULOQUADRADO
    
  FIMMATRIZTIRO:
    ;Matriz de tiro completa,terminar de desenhar a tela
    mov BL,3 ; Linha inicial
    mov DL,COLUNA_STATS 
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_QUADRO_STATS1     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_QUADRO_STATS2     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_QUADRO_STATS3     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_QUADRO_STATS4     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_QUADRO_STATS5     
    call printstring
    pop DX  
    inc BL
    
    call atualizastats
    
    ;Limpar quadro de mensagens
    mov BL, 18 ; Linha Inicial
    mov DL,COLUNA_CONFIG
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_LIMPA_MSG     
    call printstring
    pop DX 
    inc BL 
    
    mov DL,COLUNA_CONFIG
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_LIMPA_MSG    
    call printstring
    pop DX  
    inc BL                                          
    
    mov DL,COLUNA_CONFIG
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_LIMPA_MSG    
    call printstring
    pop DX  
    inc BL 
               
    ;Quadro de estatisticas pronto, falta barra de mensagens
    mov DL,COLUNA_TIRO
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_QUADRO_INPUT1     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_QUADRO_INPUT2     
    call printstring
    pop DX  
    inc BL
    
    mov DH,BL    
    call posicionacursor 
    push DX
    mov DX,OFFSET MSG_QUADRO_INPUT3     
    call printstring
    pop DX  
    inc BL 
    pop_all
    ret
endp

;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
start_screen proc ;Desenha tela inicial -- OK
    push_all
    
    mov AH,02h ;posiciona cursor
    mov DL,COLUNA_TELA_INICIAL
    mov DH,8
    int 10h 
    mov DX,OFFSET TELA_INICIAL1     
    mov ah,09h
    int 21h                 
    
    mov AH,02h ;posiciona cursor
    mov DL,COLUNA_TELA_INICIAL
    mov DH,9
    int 10h 
    mov DX,OFFSET TELA_INICIAL2     
    mov ah,09h
    int 21h
    
    mov AH,02h ;posiciona cursor
    mov DL,COLUNA_TELA_INICIAL
    mov DH,10
    int 10h 
    mov DX,OFFSET TELA_INICIAL3     
    mov ah,09h
    int 21h
    
    mov AH,02h ;posiciona cursor
    mov DL,COLUNA_TELA_INICIAL
    mov DH,11
    int 10h 
    mov DX,OFFSET TELA_INICIAL4     
    mov ah,09h
    int 21h
    
    mov AH,02h ;posiciona cursor
    mov DL,COLUNA_TELA_INICIAL
    mov DH,12
    int 10h 
    mov DX,OFFSET TELA_INICIAL5     
    mov ah,09h
    int 21h    
    call readinitgame
    
    pop_all
    ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
mostrar_barcos proc
    mov ah,02h
    mov dl,32
    int 21h
    int 21h
    mov dl,'A'
    int 21h
    mov dl,32
    int 21h
    mov dl,'B'
    int 21h
    mov dl,32
    int 21h
    mov dl,'C'
    int 21h
    mov dl,32
    int 21h
    mov dl,'D'
    int 21h
    mov dl,32
    int 21h
    mov dl,'E'
    int 21h
    mov dl,32
    int 21h
    mov dl,'F'
    int 21h
    mov dl,10
    int 21h
    mov dl,13      
    int 21h
    
    mov di,0
    mov si,0
    
    mov bl, '1'
  NUMEROFILA:
    mov dl,bl
    int 21h
    mov cx,6
       
  CELDAS:
    mov dl,32
    int 21h
    mov dl,matriz_navios_comp[si]
    int 21h
    inc si
    loop CELDAS
    mov dl,10
    int 21h
    mov dl,13      
    int 21h
    inc bl          
    inc di      
    cmp di,6       
    jl  NUMEROFILA
  ret
endp    
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
finalscreen proc  ;desenha a tela final
    mov al,3
    call changepage
    mov bh,al
    
    mov AH,02h ;posiciona cursor
    mov DL,COLUNA_FINAL
    mov DH,10
    int 10h 
    mov DX,OFFSET MSG_FINAL1     
    mov ah,09h
    int 21h                 
    
    mov AH,02h ;posiciona cursor
    mov DL,COLUNA_FINAL
    mov DH,11
    int 10h 
    mov DX,OFFSET MSG_FINAL2     
    mov ah,09h
    int 21h
    
    mov AH,02h ;posiciona cursor
    mov DL,COLUNA_FINAL
    mov DH,12
    int 10h 
    mov DX,OFFSET MSG_FINAL3     
    mov ah,09h
    int 21h
    
    mov AH,02h ;posiciona cursor
    mov DL,COLUNA_FINAL
    mov DH,13
    int 10h 
    mov DX,OFFSET MSG_FINAL4     
    mov ah,09h
    int 21h
    
    mov AH,02h ;posiciona cursor
    mov DL,COLUNA_FINAL
    mov DH,14
    int 10h 
    mov DX,OFFSET MSG_FINAL5     
    mov ah,09h
    int 21h
    
    mov ah,02h
    mov dx,10
    int 21h
    mov dx,13
    int 21h
    call mostrar_barcos           
    ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
start proc                          ; proc inicial
    call definemode
    call start_screen                ; chama a proc para escrever a tela inicial e escolher se joga ou sai
  
  JOGAR_DE_NOVO:
	xor AX, AX                 
	mov DI, OFFSET matriz_navios_comp    
	mov cx, 100                 
	rep stosw 
    call configboardcomputer        ; chama a proc para preparar a board do computador
    call game_screen 
GAMESTART:
    call yourturn
    cmp tiros, 20
    je TELA_FINAL
       
    cmp acertos,12 ;5+4+3 = 12       ;12 aciertosgana    
    je USERGANHOU
    jmp GAMESTART
    
    
USERGANHOU:
    call victorymsg
    call finalscreen   
COMPGANHOU:
    call defeatmsg
    call finalscreen    
    
TELA_FINAL:
    call finalscreen
  LEITURAFINAL:
    call readkeyboard
    cmp al, 'j'
    je JOGAR_DE_NOVO  
    cmp al, 'J'
    je M_JUGAR
    cmp al, 's'
    je SAIRDOJOGO2
    cmp al, 'S'
    je S_SALIR
    cmp al, 'r'
    je REINICIAR 
    cmp al, 'R' 
    je R_REINICIAR
    jmp LEITURAFINAL
      
   M_JUGAR:
    jmp JOGAR_DE_NOVO
    
   S_SALIR:
    jmp SAIRDOJOGO2 
   
   R_REINICIAR:
    jmp REINICIAR 
    
    
  SAIRDOJOGO2:
    call exit
  REINICIAR:
    call restart
ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________  
restart proc
	push_all                  
	
	xor AX, AX                 
	mov DI, OFFSET matriz_navios_comp    
	mov cx, 100                 
	rep stosw                  
	
	
	mov tiros, 0
	mov acertos, 0  
	
	call start

	pop_all
ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
exit proc                           ; proc para sair do JUEGO
    mov ax, 41h
    int 21h ;DOS interrupts.
ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
inicio:
    mov ax,@data                    ; ax aponta para segmento de dados
    mov ds,ax                       ; copia para ds
    mov es,ax                       ; copia para es tambem

    call start                       
end inicio