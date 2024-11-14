.586
.MODEL FLAT, C


; Funcions definides en C
printChar_C PROTO C, value:SDWORD
gotoxy_C PROTO C, value:SDWORD, value1: SDWORD
getch_C PROTO C


;Subrutines cridades des de C
public C showCursor, showPlayer, showBoard, moveCursor, moveCursorContinuous, putPiece, put2Players, Play
                         
;Variables utilitzades - declarades en C
extern C row: DWORD, col: BYTE, rowScreen: DWORD, colScreen: DWORD, rowScreenIni: DWORD, colScreenIni: DWORD 
extern C carac: BYTE, tecla: BYTE, colCursor: BYTE, player: DWORD, mBoard: BYTE, pos: DWORD
extern C inaRow: DWORD, row4Complete: DWORD

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Les subrutines que heu de modificar per la pràctica nivell bàsic son:
; showCursor, showPlayer, showBoard, moveCursor, moveCursorContinuous, calcIndex, putPiece
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.code   
   
;;Macros que guardan y recuperan de la pila los registros de proposito general de la arquitectura de 32 bits de Intel    
Push_all macro
	
	push eax
   	push ebx
    push ecx
    push edx
    push esi
    push edi
endm


Pop_all macro

	pop edi
   	pop esi
   	pop edx
   	pop ecx
   	pop ebx
   	pop eax
endm
   
   


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NO LA PODEU MODIFICAR AQUESTA RUTINA.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Situar el cursor en una fila i una columna de la pantalla
; en funció de la fila i columna indicats per les variables colScreen i rowScreen
; cridant a la funció gotoxy_C.
;
; Variables utilitzades: 
; Cap
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxy proc
   push ebp
   mov  ebp, esp
   Push_all

   ; Quan cridem la funció gotoxy_C(int row_num, int col_num) des d'assemblador 
   ; els paràmetres s'han de passar per la pila
      
   mov eax, [colScreen]
   push eax
   mov eax, [rowScreen]
   push eax
   call gotoxy_C
   pop eax
   pop eax 
   
   Pop_all

   mov esp, ebp
   pop ebp
   ret
gotoxy endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NO LA PODEU MODIFICAR AQUESTA RUTINA.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar un caràcter, guardat a la variable carac
; en la pantalla en la posició on està  el cursor,  
; cridant a la funció printChar_C.
; 
; Variables utilitzades: 
; carac : variable on està emmagatzemat el caracter a treure per pantalla
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printch proc
   push ebp
   mov  ebp, esp
   ;guardem l'estat dels registres del processador perqué
   ;les funcions de C no mantenen l'estat dels registres.
   
   
   Push_all
   

   ; Quan cridem la funció  printch_C(char c) des d'assemblador, 
   ; el paràmetre (carac) s'ha de passar per la pila.
 
   xor eax,eax
   mov  al, [carac]
   push eax 
   call printChar_C
 
   pop eax
   Pop_all

   mov esp, ebp
   pop ebp
   ret
printch endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NO LA PODEU MODIFICAR AQUESTA RUTINA.   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Llegir un caràcter de teclat   
; cridant a la funció getch_C
; i deixar-lo a la variable tecla.
;
; Variables utilitzades: 
; tecla: Variable on s'emmagatzema el caracter llegit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getch proc
   push ebp
   mov  ebp, esp
    
   Push_all

   call getch_C
   mov [tecla],al
 
   Pop_all

   mov esp, ebp
   pop ebp
   ret
getch endp



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Posicionar el cursor a la columna indicada per la variable colCursor, 
; dins la fila M que hi ha per sobre del tauler.
; Per a posicionar el cursor cridar a la subrutina gotoxy que es dona feta.
; Aquesta subrutina posiciona el cursor a la posició indicada per les
; variables rowScreen i colScreen.
; Per calcular la posició del cursor a pantalla (rowScreen) i (colScreen)
; cal utilitzar aquestes fórmules:
;
;            rowScreen=rowScreenIni-2
;            colScreen=colScreenIni+(colCursor*4)
;
; Tenir en compte que colCursor és un caràcter (ascii) que s’ha de
; convertir a un valor numèric per a realitzar l’operació.
;
; Variables utilitzades:
; colCursor : columna per a accedir a la matriu
; rowScreen : fila on volem posicionar el cursor a la pantalla.
; colScreen : columna on volem posicionar el cursor a la pantalla.
; rowScreenIni : fila de la primera posició de la matriu a la pantalla.
; colScreenIni : columna de la primera posició de la matriu a la pantalla.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showCursor proc
    push ebp
	mov  ebp, esp
	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi

	mov eax, [rowScreenIni] ;rowScreen
	mov [rowScreen], eax
	mov eax, 0
	mov al, [colCursor] ;
	sub al, 'A'
	shl al, 2 ; *4
	add eax, [colScreenIni]
	mov [colScreen], eax

	call gotoxy


	;Fi Codi de la pràctica
	mov esp, ebp
	pop ebp
	ret

showCursor endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Presenta el número de jugador a la casella Player
; Convertir el valor int de 32 bits de la variable Player
; a un caràcter ascii i mostrar-lo a la posició indicada per 
; rowScreen i colScreen de la pantalla, [23,19]
; Cal cridar a la subrutina gotoxy per a posicionar el cursor 
; i a la subrutina printch per a mostrar el caràcter.
; La subrutina printch mostra per pantalla el caràcter emmagatzemat
; al registre dil.
;
; Variables utilitzades:
; rowScreen : fila on volem posicionar el cursor a la pantalla.
; colScreen : columna on volem posicionar el cursor a la pantalla.
; player: variable que indica el jugador al que correspon tirar

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showPlayer proc
    push ebp
	mov  ebp, esp
	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi

	mov eax, [player]
	add eax, '0' 
	mov [rowScreen], 23
	mov [colScreen], 19
	mov ebx, [rowScreen]
	mov ecx, [colScreen]

	mov [carac], al
	call gotoxy
	call printch
	

	;Fi Codi de la pràctica
	mov esp, ebp
	pop ebp
	ret

showPlayer endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Escriu el valor de cada casella, emmagatzemat a mBoard, en la posició corresponent de pantalla
; Anar posicionant el cursor a cada posició del tauler cridant la gotoxy
; i mostrar el valor corresponent de la matriu mBoard en pantalla cridant
; a la subrutina printch
;
; Per calcular la posició del cursor a pantalla cal calcular rowScreen i colScreen
; Per fer aquest càlcul utilitzarem les formules
;          rowScreen=RowScreenIni+(fila*2)+4
;          colScreen=ColScreenIni+(col*4)-1
;
; Variables utilitzades:
; rowScreen : fila on volem posicionar el cursor a la pantalla.
; colScreen : columna on volem posicionar el cursor a la pantalla.
; rowScreenIni : fila de la primera posició de la matriu a la pantalla.
; colScreenIni : columna de la primera posició de la matriu a la pantalla.
; mBoard: Matriu que conté el valor de les diferents posicions del tauler.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

showBoard proc
    push ebp
	mov  ebp, esp
	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi

	mov esi, 0 ; iterador i
	mov edi, 0 ; iterador j
	mov ecx, 0 ; para posicion

bucleESI:
	cmp esi, 6
	jge fin ; mas adelante

	mov eax, esi;
	shl eax, 1
	add eax, 4
	add eax, [RowScreenIni]
	mov [rowScreen], eax
		
	inc esi; incrementamos i
	mov edi, 0 ; iterador j

bucleEDI:
	cmp edi, 7
	jge bucleESI ; saltamos al bucle

	mov eax, edi
	shl eax, 2
	sub eax, 1
	add eax, [ColScreenIni]
	mov [colScreen], eax

	mov al, [mBoard + ecx] 
	inc ecx
	mov [carac], al
	call gotoxy
	call printch

	inc edi;incrementamos j
	jmp  bucleEDI; mas adelante al cmp edi


fin:

	;Fi Codi de la pràctica
	mov esp, ebp
	pop ebp
	ret

showBoard endp



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que implementa el moviment del cursor a dreta ‘k’ i esquerra ‘j’.
; Cridar a la subrutina getch per a llegir una tecla
; fins que pitgem una de les tecles vàlides (‘j’, ‘k’, ‘ ‘ o 'q'<Quit>).
; La tecla ‘j’ mou el cursor a l’esquerra,
; la tecla ‘k’ mou el cursor a la dreta.
; S’ha de controlar que no surti de límits.
; Si pitgem una tecla no vàlida, ha d’esperar a una tecla vàlida.
;
; Variables utilitzades:
; tecla: variable on s’emmagatzema el caràcter llegit
; colCursor: Variable que indica l columna en la que es troba el cursor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveCursor proc
   push ebp
   mov  ebp, esp 

	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi
inicio:
	
	call getch
	mov al, [tecla]
	cmp al, 'q' ; 81
	je fin 

	cmp al, 'j'          
    je izquierda

    cmp al, 'k'          
    je derecha

    cmp al, ' '          
    je fin    
	jmp inicio
izquierda:
	mov bl, [colCursor]
	cmp bl, 'A'
	je inicio
	dec bl
	mov [colCursor], bl
	call showCursor
	jmp inicio

derecha: 
	mov cl, [colCursor]
	cmp cl, 'G'
	jge inicio
	inc cl
	mov [colCursor], cl
	call showCursor
	jmp inicio

fin:


	;Fi Codi de la pràctica

   mov esp, ebp
   pop ebp
   ret

moveCursor endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que implementa el moviment continu
; S’ha d’anar cridant a la subrutina moveCursor 
; fins que pitgem ‘ ‘ o 'q'<Quit>.
; La tecla ‘j’ mou el cursor a l’esquerra,
; la tecla ‘k’ mou el cursor a la dreta.
; Si pitgem una tecla no vàlida, ha d’esperar a una tecla vàlida.
;
; Variables utilitzades:
; tecla: variable on s’emmagatzema el caràcter llegit
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveCursorContinuous proc
	push ebp
	mov  ebp, esp

	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi
inicio:
	call getch
	mov al, [tecla]
	cmp al, 'q'
	je fin 
	cmp al, ' '
	je fin
	call moveCursor
	jmp inicio
fin:



	;Fi Codi de la pràctica

	mov esp, ebp
	pop ebp
	ret

moveCursorContinuous endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina serveix per a poder accedir a les components de la matriu.
; Calcula l’índex per a accedir a la matriu mBoard en assemblador.
; mBoard[row][col] en C, és [mBoard+pos] en assemblador.
; on pos = (row*7 + col (convertida a número)).
;
; Variables utilitzades:
; row: fila per a accedir a la matriu mBoard
; col: columna per a accedir a la matriu mBoard
; pos: índex per a accedir a la matriu mBoard
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
calcIndex proc
    push ebp
    mov  ebp, esp

    ; Cargar el valor de row en EAX
	mov eax, 0
	mov ebx, 0

    mov eax, [row]           ; EAX = row

    ; Cargar el valor de col en BL y convertirlo a número
    mov bl, [col] ; Cargar col en BL y extender a 32 bits en EBX
    sub ebx, 'A'              ; Convertir de carácter a número (EBX = col - '0')

    ; Multiplicar row por 7
    imul eax, 7          ; EAX = row * 7

    ; Sumar col a row * 7
    add eax, ebx              ; EAX = EAX + col

    ; Guardar el resultado en pos
    mov [pos], eax            ; Guardar el índice calculado en pos

	
    ; Finalizar la subrutina
    mov esp, ebp
    pop ebp
    ret

	calcIndex endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; A partir de la posició en la que ha quedat la fitxa introduïda comprovar si les fitxes 
; que hi ha per sota en vertical coincideixen amb la que acabem d’introduir.
; Si coincideix incrementar el comptador i comprovar si hem arribat a 4.
; Si no hem arribat a 4, seguim baixant.
; Si hem arribat a 4, posem l’indicador row4Complete a 1.
;
; Variables utilitzades:
; mBoard : matriu del taulell on anem inserint les fitxes
; inaRow : comptador per a saber el nombre de fitxes en ratlla
; row4Complete : indicador de si hem arribat a 4 fitxes en ratlla o no
; pos : posició de la matriu mBoard que estem mirant
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

checkRow proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi
	
	mov eax, [row]
	cmp eax, 2 ; compara si ens trobem a la fila 3
	jg fi

	call calcIndex
	mov esi, [pos] ; inicialitzem les posicions
	mov bl, [mBoard + esi] ;agafem la posicio actual
	
	mov edi, esi ; asignem un iterador que s'anira suma i comparant

bucle:
	add edi, 7
	cmp edi, 42; comparem si ha arribat al final
	jg fi
	mov cl, [mBoard + edi] ; agafem posicio inferior
	cmp ebx, ecx ;comparem si son igual
	jne fi
	inc [inaRow]
	cmp [inaRow], 3
	jne bucle
	mov row4Complete, 1

fi:
	mov [inaRow], 0



	;Fi Codi de la pràctica
	mov esp, ebp
	pop ebp
	ret


checkRow endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Situa una fitxa en una posició lliure del tauler de joc
; S’ha de cridar a movCursorContinuous per a triar la columna de la casella desitjada.
; Un cop som a la columna de casella desitjada premem al tecla ‘ ‘ (espai "tirar" la fitxa)
; Calcular la posició de la matriu corresponent a la posició més baixa de la columna que 
; ocupa el cursor, cridant a la subrutina calcIndex.
; Anar pujant per al columna fins a trobar una posició buida i posar la fitxa en aquella posició de mBoard. 
; Cridar a la subrutina showBoard per a mostrar com queda el tauler.
; Si hem pitjat 'q'<Quit>, no hem d’introduir fitxa.
;
; Variables utilitzades:
; row : fila per a accedir a la matriu mBoard
; col : columna per a accedir a la matriu mBoard
; colCursor: Columna en la que tenim el cursor
; pos : índex per a accedir a la matriu mBoard 
; mBoard : matriu 6x7 on tenim el tauler
; carac : caràcter per a escriure a pantalla
; tecla: codi ascii de la tecla pitjada
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
putPiece proc
	push ebp
	mov  ebp, esp

	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi
    mov eax, 0
	mov esi, 0

    call showBoard
    call showPlayer
    call moveCursorContinuous

    cmp [tecla], 'q'
    je fin

    mov al, [colCursor]
    mov [col], al
    mov [row], 6

bucle:
    dec [row]

    cmp [row], 0
    jl fin
    call calcIndex
    mov esi, [pos]

	mov bl, '.'

    cmp [mBoard + esi], bl
    jne bucle
	mov ebx, [player]
	cmp ebx, 2
	je player2
    mov al, '0'
	jmp pasFitxa
player2:
	mov al, 'X'
pasFitxa:
    mov [mBoard + esi], al
	call showBoard
    
	mov ecx, 0

fin:
 
	;Fi Codi de la pràctica

	mov esp, ebp
	pop ebp
	ret



putPiece endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; S’han de permetre dues tirades, cridant a putPiece, 
; una de cada jugador,
; actualitzant a la casella corresponent de la pantalla
; l’identificador del jugador cridant a showPlayer.
; Si es pitja 'q'<Quit> o s’aconsegueix la ratlla de 4 fitxes
;el procés ha de finalitzar.
;
; Variables utilitzades:
; tecla: codi ascii de la tecla pitjada
; player: Variable que indica quin jugador fa la tirada
; row4Complete: variable que ha actualitzat la subrutina checkRow 
; per a indicar si s’ha aconseguit una ratlla de 4 fitxes.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

put2Players proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi

bucle:
	cmp [row4Complete], 1
	je fi

	mov [player], 1
	call putPiece
	call checkRow

	cmp [row4Complete], 1
	je fi

	inc [player]
	call putPiece
	call checkRow

	jmp bucle
fi:
	mov [row4Complete], 0
	;Fi Codi de la pràctica
	mov esp, ebp
	pop ebp
	ret


put2Players endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Es va cridant a put2Players mentre no es pitgi 'q'<Quit>
; o un jugador aconsegueixi una ratlla de 4 fitxes.
;
; Variables utilitzades:
; tecla: codi ascii de la tecla pitjada
; row4Complete: variable que ha actualitzat la subrutina checkRow 
; per a indicar si s’ha aconseguit una ratlla de 4 fitxes.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Play proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi





	;Fi Codi de la pràctica
	mov esp, ebp
	pop ebp
	ret


Play endp


END