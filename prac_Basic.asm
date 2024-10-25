.586
.MODEL FLAT, C


; Funcions definides en C
printChar_C PROTO C, value:SDWORD
gotoxy_C PROTO C, value:SDWORD, value1: SDWORD
getch_C PROTO C


;Subrutines cridades des de C
public C showCursor, showPlayer, showBoard, moveCursor, moveCursorContinuous, putPiece
                         
;Variables utilitzades - declarades en C
extern C row: DWORD, col: BYTE, rowScreen: DWORD, colScreen: DWORD, rowScreenIni: DWORD, colScreenIni: DWORD 
extern C carac: BYTE, tecla: BYTE, colCursor: BYTE, player: DWORD, mBoard: BYTE, pos: DWORD

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Les subrutines que heu de modificar per la pr�ctica nivell b�sic son:
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
; en funci� de la fila i columna indicats per les variables colScreen i rowScreen
; cridant a la funci� gotoxy_C.
;
; Variables utilitzades: 
; Cap
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxy proc
   push ebp
   mov  ebp, esp
   Push_all

   ; Quan cridem la funci� gotoxy_C(int row_num, int col_num) des d'assemblador 
   ; els par�metres s'han de passar per la pila
      
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
; Mostrar un car�cter, guardat a la variable carac
; en la pantalla en la posici� on est� el cursor,  
; cridant a la funci� printChar_C.
; 
; Variables utilitzades: 
; carac : variable on est� emmagatzemat el caracter a treure per pantalla
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printch proc
   push ebp
   mov  ebp, esp
   ;guardem l'estat dels registres del processador perqu�
   ;les funcions de C no mantenen l'estat dels registres.
   
   
   Push_all
   

   ; Quan cridem la funci�  printch_C(char c) des d'assemblador, 
   ; el par�metre (carac) s'ha de passar per la pila.
 
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
; Llegir un car�cter de teclat   
; cridant a la funci� getch_C
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
; Aquesta subrutina posiciona el cursor a la posici� indicada per les
; variables rowScreen i colScreen.
; Per calcular la posici� del cursor a pantalla (rowScreen) i (colScreen)
; cal utilitzar aquestes f�rmules:
;
;            rowScreen=rowScreenIni
;            colScreen=colScreenIni+(colCursor*4)
;
; Tenir en compte que colCursor �s un car�cter (ascii) que s�ha de
; convertir a un valor num�ric per a realitzar l�operaci�.
;
; Variables utilitzades:
; colCursor : columna per a accedir a la matriu
; rowScreen : fila on volem posicionar el cursor a la pantalla.
; colScreen : columna on volem posicionar el cursor a la pantalla.
; rowScreenIni : fila de la primera posici� de la matriu a la pantalla.
; colScreenIni : columna de la primera posici� de la matriu a la pantalla.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showCursor proc
    push ebp
	mov  ebp, esp
	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi

	mov eax, [rowScreenIni] ;rowScreen
	mov [rowScreen], eax
	mov eax, 0
	mov al, [colCursor] ;
	sub al, 'A'
	shl al, 2 ; *4
	add eax, [colScreenIni]
	mov [colScreen], eax

	call gotoxy
	




	;Fi Codi de la pr�ctica
	mov esp, ebp
	pop ebp
	ret

showCursor endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Presenta el n�mero de jugador a la casella Player
; Convertir el valor int de 32 bits de la variable Player
; a un car�cter ascii i mostrar-lo a la posici� indicada per 
; rowScreen i colScreen de la pantalla, [23,19]
; Cal cridar a la subrutina gotoxy per a posicionar el cursor 
; i a la subrutina printch per a mostrar el car�cter.
; La subrutina printch mostra per pantalla el car�cter emmagatzemat
; a la variable carac.
;
; Variables utilitzades:
; rowScreen : fila on volem posicionar el cursor a la pantalla.
; colScreen : columna on volem posicionar el cursor a la pantalla.
; player: variable que indica el jugador al que correspon tirar

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showPlayer proc
    push ebp
	mov  ebp, esp
	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi

	mov eax, [player]
	add eax, '0' 
	mov [rowScreen], 23
	mov [colScreen], 19
	mov ebx, [rowScreen]
	mov ecx, [colScreen]
	mov [carac], al
	call gotoxy
	call printch
	

	;Fi Codi de la pr�ctica
	mov esp, ebp
	pop ebp
	ret

showPlayer endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Escriu el valor de cada casella, emmagatzemat a mBoard, en la posici� corresponent de pantalla
; Anar posicionant el cursor a cada posici� del tauler cridant la gotoxy
; i mostrar el valor corresponent de la matriu mBoard en pantalla cridant
; a la subrutina printch
;
; Per calcular la posici� del cursor a pantalla cal calcular rowScreen i colScreen
; Per fer aquest c�lcul utilitzarem les formules
;          rowScreen=RowScreenIni+(fila*2)+4
;          colScreen=ColScreenIni+(col*4)-1
;
; Variables utilitzades:
; rowScreen : fila on volem posicionar el cursor a la pantalla.
; colScreen : columna on volem posicionar el cursor a la pantalla.
; rowScreenIni : fila de la primera posici� de la matriu a la pantalla.
; colScreenIni : columna de la primera posici� de la matriu a la pantalla.
; mBoard: Matriu que cont� el valor de les diferents posicions del tauler.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

showBoard proc
    push ebp
	mov  ebp, esp
	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi

	mov esi, 0 ; iterador i
	mov edi, 0 ; iterador j

bucleESI:
	cmp esi, 6
	jge fin ; mas adelante
bucleEDI:
	
	mov eax, esi;
	shl eax, 1
	add eax, 4
	add eax, [RowScreenIni]
	mov [rowScreen], eax

	cmp edi, 7
	jge fin ; mas adelante

	mov eax, edi
	shl eax, 2
	sub eax, 1
	add eax, [ColScreenIni]
	mov [colScreen], eax

	mov al, [mBoard] 
	mov [carac], al
	call gotoxy
	call printch

	inc edi;incrementamos j
	jmp  bucleEDI; mas adelante al cmp edi
	
	inc esi; incrementamos i
	mov edi, 0 ; iterador j
	jmp bucleESI ; cmp esi

fin:

	;Fi Codi de la pr�ctica
	mov esp, ebp
	pop ebp
	ret

showBoard endp



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que implementa el moviment del cursor a dreta �k� i esquerra �j�.
; Cridar a la subrutina getch per a llegir una tecla
; fins que pitgem una de les tecles v�lides (�j�, �k�, � � o 'q'<Quit>).
; La tecla �j� mou el cursor a l�esquerra,
; la tecla �k� mou el cursor a la dreta.
; S�ha de controlar que no surti de l�mits.
; Si pitgem una tecla no v�lida, ha d�esperar a una tecla v�lida.
;
; Variables utilitzades:
; tecla: variable on s�emmagatzema el car�cter llegit
; colCursor: Variable que indica l columna en la que es troba el cursor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveCursor proc
   push ebp
   mov  ebp, esp 

	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi
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
    je inicio      
izquierda:
	mov bl, [colCursor]
	cmp bl, 0
	je inicio
	dec bl
	mov [colCursor], bl
	call showCursor
	jmp inicio

derecha: 
	mov cl, [colCursor]
	cmp cl, 7
	je inicio
	inc cl
	mov [colCursor],cl
	call showCursor
	jmp inicio

fin:


	;Fi Codi de la pr�ctica

   mov esp, ebp
   pop ebp
   ret

moveCursor endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que implementa el moviment continu
; S�ha d�anar cridant a la subrutina moveCursor 
; fins que pitgem � � o 'q'<Quit>.
; La tecla �j� mou el cursor a l�esquerra,
; la tecla �k� mou el cursor a la dreta.
; Si pitgem una tecla no v�lida, ha d�esperar a una tecla v�lida.
;
; Variables utilitzades:
; tecla: variable on s�emmagatzema el car�cter llegit
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveCursorContinuous proc
	push ebp
	mov  ebp, esp

	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi
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



	;Fi Codi de la pr�ctica

	mov esp, ebp
	pop ebp
	ret

moveCursorContinuous endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina serveix per a poder accedir a les components de la matriu.
; Calcula l��ndex per a accedir a la matriu mBoard en assemblador.
; mBoard[row][col] en C, �s [mBoard+pos] en assemblador.
; on pos = (row*7 + col (convertida a n�mero)).
;
; Variables utilitzades:
; row: fila per a accedir a la matriu mBoard
; col: columna per a accedir a la matriu mBoard
; pos: �ndex per a accedir a la matriu mBoard
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
calcIndex proc
	push ebp
	mov  ebp, esp

	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi





	;Fi Codi de la pr�ctica

	mov esp, ebp
	pop ebp
	ret

calcIndex endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Situa una fitxa en una posici� lliure del tauler de joc
; S�ha de cridar a movCursorContinuous per a triar la columna de la casella desitjada.
; Un cop som a la columna de casella desitjada premem al tecla � � (espai "tirar" la fitxa)
; Calcular la posici� de la matriu corresponent a la posici� m�s baixa de la columna que 
; ocupa el cursor, cridant a la subrutina calcIndex.
; Anar pujant per al columna fins a trobar una posici� buida i posar la fitxa en aquella posici� de mBoard. 
; Cridar a la subrutina showBoard per a mostrar com queda el tauler.
; Si hem pitjat 'q'<Quit>, no hem d�introduir fitxa.
;
; Variables utilitzades:
; row : fila per a accedir a la matriu mBoard
; col : columna per a accedir a la matriu mBoard
; colCursor: Columna en la que tenim el cursor
; pos : �ndex per a accedir a la matriu mBoard 
; mBoard : matriu 6x7 on tenim el tauler
; carac : car�cter per a escriure a pantalla
; tecla: codi ascii de la tecla pitjada

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
putPiece proc
	push ebp
	mov  ebp, esp

	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi





	;Fi Codi de la pr�ctica

	mov esp, ebp
	pop ebp
	ret

putPiece endp


END