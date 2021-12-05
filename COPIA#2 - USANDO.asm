.model small
.stack 100h
.data

;matriz_de_navios db 100 dup(0)     ; Linhas e Colunas da matriz
matriz_navios_comp db 36 dup(0)
matriz_navios_jogo db 36 dup(0)

linha db 00h                            
coluna db 00h
sentido dw 00h
endereco_lin_col dw 00h
simbolo db 00h 
tamanhobarco db 00h

colcursor db 00h
lincursor db 00h
pagcursor db 00h 


tiros db 00h
hundidos db '0'     ;AGREGADO
coltiros EQU 73
lintiros EQU 5
acertos db 00h 
linacertos EQU 6

ubicando_portaviones db 0
ubicando_crucero db 0
ubicando_submarino db 0


CR EQU 13    ; ENTER
LF EQU 10    ; LINEA

;---------------------Mensagens do Jogo---------------------
   TELA_INICIAL1 DB 0C9h,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0BBh,'$' 
   TELA_INICIAL2 DB 0BAh,'          B A T A L L A    N A V A L             ',0BAh,'$' 
   TELA_INICIAL3 DB 0BAh,'Presiona ENTER para iniciar y s para salir       ',0BAh,'$'
   TELA_INICIAL4 DB 0BAh,'          Franco Keyla, Zaruma Ricardo           ',0BAh,'$' 
   TELA_INICIAL5 DB 0C8h,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0BCh,'$'
   
   COLUNA_TELA_INICIAL EQU 22

    COLUNA_CONFIG EQU 30   
    
;    MSG_BARCO1 DB 'Porta Avioes: $'
;    MSG_BARCO2 DB 'Navio de Guerra: $'
;    MSG_BARCO3 DB 'Submarino: $'
;    
;    
    MSG_CONFIG21 DB '                    ','$'
    MSG_CONFIG22 DB '                 Colocando os navios do computador.       ','$'
; 
;------------------------Tela do jogo-----------------------  

    COLUNA_TIRO EQU 1 
    COLUNA_STATS EQU 58
    
    MSG_JOGO_TIRO1 DB   0DAh,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0BFh,'$'
    MSG_JOGO_TIRO2 DB   0B3h,'  BATTLESHIP ',0B3h,'$'
    MSG_JOGO_TIRO3 DB   0C3h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0B4h,'$'
    MSG_JOGO_TIRO4 DB   0B3h,'  0',0B3h,'1',0B3h,'2',0B3h,'3',0B3h,'4',0B3h,'5',0B3h,'$'
    MSG_JOGO_TIRO5 DB   0B3h,'0            ',0B3h,'$'
    MSG_JOGO_TIRO6 DB   0B3h,'1            ',0B3h,'$'
    MSG_JOGO_TIRO7 DB   0B3h,'2            ',0B3h,'$'
    MSG_JOGO_TIRO8 DB   0B3h,'3            ',0B3h,'$'
    MSG_JOGO_TIRO9 DB   0B3h,'4            ',0B3h,'$'
    MSG_JOGO_TIRO10  DB 0B3h,'5            ',0B3h,'$'
    MSG_JOGO_TIRO15  DB 0C0h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0D9h,'$'
    
    MSG_QUADRO_STATS1 DB  0DAh,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0BFh,'$'
    MSG_QUADRO_STATS2 DB  0B3h,'Jogador           ',0B3h,'$'
    MSG_QUADRO_STATS3 DB  0B3h,'  Tiros:          ',0B3h,'$'
    MSG_QUADRO_STATS4 DB  0B3h,'  Acertos:        ',0B3h,'$'  
    MSG_QUADRO_STATS5 DB  0C3h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0B4h,'$'
    ;MSG_QUADRO_STATS6 DB  0B3h,'Misiles usados    ',0B3h,'$'
;    MSG_QUADRO_STATS7 DB  0B3h,'  Misiles:        ',0B3h,'$'
;    MSG_QUADRO_STATS8 DB  0B3h,'                  ',0B3h,'$'  
;    MSG_QUADRO_STATS9 DB 0B3h,'                   ',0B3h,'$'
;    MSG_QUADRO_STATS10 DB 0C0h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0D9h,'$' 
;    
    COLUNA_COORDENADAS EQU 23
    COLUNA_MENSAGENS EQU 39
    
    MSG_QUADRO_INPUT1 DB 0DAh,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C2h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0BFh,'$' 
    MSG_QUADRO_INPUT2 DB 0B3h,'Coordenadas do tiro:      ',0B3h,'Mensagens:                                     ',0B3h,'$'
    MSG_QUADRO_INPUT3 DB 0C0h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C1h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0C4h,0D9h,'$' 
;---------------------Mensagens de Acao---------------------
    MSG_TURNO1 db "SUA VEZ$"

    MSG_HIT db "ACERTOU O TIRO$"

    MSG_MISS db "ERROU O TIRO$"

    MSG_DOUBLE db "JA ATIROU NESSA POSICAO$"

   ; MSG_TURNO2 db "COMPUTADOR JOGANDO$" 
    
    MSG_LIMPA_MSG db '                                   $'

    MSG_LIMPA_COOR db '   $'

    ;---------------------Mensagens de Fim---------------------
    MSG_VITORIA db "VOCE VENCEU$"

    MSG_DERROTA db "HAS USADO LOS 20 MISILES, HAS PERDIDO$" 

;--------------------------Tela Final-----------------------
    MSG_FINAL1 db 0C9h,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0CDh,0BBh,'$'
    MSG_FINAL2 db 0BAh,'               FIM  DE  JOGO                ',0BAh,'$'
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
    mov DX,OFFSET MSG_DERROTA   ;"Voce perdeu"
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
 LEITURANUMACTION:
    call readkeyboard
    cmp al, CR              ; verifica se eh ENTER
    jz LEITURANUMACTION ; je
     
    cmp al, '0'             ; verificar se eh valido
    jb LEITURANUMACTION 
  
    cmp al, '5'
    ja LEITURANUMACTION
    mov dl,al
    call writechar
    cmp cx, 0
    je VALORCOLUNAACTION
    sub al,'0'
    mov linha, al
    jmp PULOACTION
 VALORCOLUNAACTION:
    sub al,'0'
    mov coluna, al
    mov al, linha
    mov dl, 6      ;linha * 10
    mul dl
    mov ah, coluna
    add al,ah      ;(linha*10)+coluna
    xor ah,ah
    mov endereco_lin_col, ax  ;move endereco decimal = posicao no vetor 
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
   push bx
    mov SI, OFFSET matriz_navios_comp
    mov BX, endereco_lin_col
    mov byte ptr[SI+BX], 2 ;2 marca que ja atirou na posicao
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
    ;mov CX, 5 ;tamanho do porta avioes
    mov tamanhobarco, 5
    mov SI, OFFSET matriz_navios_comp 
    call verificanavio
    cmp BX,100  ;se for 100, a posicao � invalida
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
    ;mov CX, 4 ;tamanho do navio de guerra
    mov tamanhobarco, 4
    call verificanavio
    cmp BX,100  ;se for 100, a posicao � invalida
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
    ;mov CX, 3 ;tamanho do submarino
    mov tamanhobarco, 3
    call verificanavio
    cmp BX,100  ;se for 100, a posicao � invalida
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
    mov bx, endereco_lin_col   
    mov SI, OFFSET matriz_navios_comp
    cmp byte ptr [SI+BX], 'P'
    je ACERTOU_TIRO
    cmp byte ptr [SI+BX], 'C'
    je ACERTOU_TIRO
    cmp byte ptr [SI+BX], 'S'
    je ACERTOU_TIRO
    
    ;je ACERTOU_TIRO
    ;ja TIRO_DUPLO
    ;jmp TIRO_DUPLO
    ;Errou o tiro
    call missedshot
    mov bx,0   ;Se tiver errado, BX sai da proc com 0
    jmp fimVS
  ACERTOU_TIRO:
    call hitshot
    mov bx,1   ;Se tiver acertado, BX sai da proc com 1
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
    call readinputaction ;Le o input
    call verifyshot ;Verifica o que acontece
    cmp bx,2 ;compara pra saber o resultado da verificacao
    jb ATIRAR  ;se for 2, ler outro input
    jmp LER_OUTRO_INPUT
  ATIRAR:
    call fireshot ;Se for valido, efetua o tiro
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
 ;  call invalidomsg
    jmp LEITURAJOGO
  SAIRDOJOGO:
    call exit

  INICIAROJOGO:
    pop ax
    ret
endp

;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
game_screen proc      ;Desenha a tela principal de jogo
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
    mov DX,OFFSET MSG_JOGO_TIRO5     
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
    ret
endp
;_________________________________________________________________________________________________________________________________
;_________________________________________________________________________________________________________________________________
start proc                          ; proc inicial
    call definemode
    call start_screen                ; chama a proc para escrever a tela inicial e escolher se joga ou sai
  ;  call config_screen              ; chama proc para escrever na tela a tela de configuracao e preparar a board
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
    cmp al, 's'
    je SAIRDOJOGO2
    cmp al, 'r'
    je REINICIAR
    jmp LEITURAFINAL
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
exit proc                           ; proc para sair do jogo
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