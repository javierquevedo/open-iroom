;; ----------------------------------------------------------------------------------------------
;; ----------------------------------------------------------------------------------------------
;; MENU DE INTERFAZ DE USUARIO
;; ----------------------------------------------------------------------------------------------
;; ----------------------------------------------------------------------------------------------

	ORG 0700H
	
;; -----------------------------------------------------------------------------------------------	
;; INICIALIZACIÓN DEL MENÚ
;; -----------------------------------------------------------------------------------------------
MENU_INIT:			MOV	MENU_NODO1,#000H
				MOV	MENU_NODO2,#000H
				MOV	MENU_NODO3,#000H
				MOV	MENU_NODO4,#000H
				MOV	MENU_NODO5,#000H
 				SETB	LCD_PEND_MENU 
				SETB	LCD_PEND_INFO
				SETB	LCD_PEND	
				RET

	
;; -----------------------------------------------------------------------------------------------	
;; ACTUALIZACIÓN DEL MENÚ
;; -----------------------------------------------------------------------------------------------
MENU_UPDATE:			LCALL MENU_REALIZAR_MOV

				RET
	

;; -----------------------------------------------------------------------------------------------	
;; REALIZACIÓN DE UN MOVIMIENTO DEL MENÚ
;; Aviso: No comprueba si el movimiento que realiza es válido
;;	  Utiliza el banco de registros 10
;; -----------------------------------------------------------------------------------------------	
MENU_REALIZAR_MOV:		;  PUSH_STATE
				PUSH ACC
				PUSH PSW
				PUSH DPH
				PUSH DPL
				SETB	RS0
				CLR	RS1
				JB	MENU_PEND_LEFT,MENU_MOV_LEFT
				JB	MENU_PEND_UP,MENU_MOV_UP
				JB	MENU_PEND_RIGHT,MENU_MOV_RIGHT
				JB	MENU_PEND_DOWN,MENU_MOV_DOWN
				LJMP	MENU_REALIZAR_MOV_EXIT
			
;; -------------------------------------------
;; MOVIMIENTO PENDIENTE HACIA LA IZQUIERDA
;; -------------------------------------------
MENU_MOV_LEFT:			CLR	MENU_PEND_LEFT
				MOV	R1,#MENU_NODO5
MENU_MOV_LEFT_BUC:		MOV	A, @R1
				MOV	R2, A
				CJNE	R2,#0,MENU_MOV_LEFT_END
				DEC	R1
				CJNE	R1,#MENU_NODO1,MENU_MOV_LEFT_BUC
				MOV	A, @R1
				MOV	R2, A
				CJNE	R2,#0,MENU_MOV_LEFT_END
				MOV	@R1,#1				;; Si estamos en raíz, vamos a 1.0.0.0.0
				LJMP	MENU_REALIZAR_MOV_EXIT
MENU_MOV_LEFT_END:		MOV	@R1,#0
				LJMP	MENU_REALIZAR_MOV_EXIT

;; -------------------------------------------
;; MOVIMIENTO PENDIENTE HACIA ARRIBA
;; -------------------------------------------
MENU_MOV_UP:			CLR	MENU_PEND_UP
				MOV	R1,#MENU_NODO5
MENU_MOV_UP_BUC:		MOV	A, @R1
				MOV	R2, A
				CJNE	R2,#0,MENU_MOV_UP_ST1
				DEC	R1
				CJNE	R1,#MENU_NODO1,MENU_MOV_UP_BUC
				MOV	A, @R1
				MOV	R2, A
				CJNE	R2,#0,MENU_MOV_UP_ST1
				MOV	@R1,#1				;; Si estamos en raíz, vamos a 1.0.0.0.0
				LJMP	MENU_REALIZAR_MOV_EXIT						
MENU_MOV_UP_ST1:		CJNE	R2,#1,MENU_MOV_UP_ST2
				LJMP	MENU_REALIZAR_MOV_EXIT		
MENU_MOV_UP_ST2:		MOV	A,@R1
				DEC	A
				MOV	@R1,A
				LJMP	MENU_REALIZAR_MOV_EXIT			


;; -------------------------------------------
;; MOVIMIENTO PENDIENTE HACIA LA DERECHA
;; -------------------------------------------
MENU_MOV_RIGHT:			CLR	MENU_PEND_RIGHT
				MOV	R1,#MENU_NODO1
MENU_MOV_RIGHT_BUC:		MOV	A, @R1
				MOV	R2, A
				CJNE	R2,#0,MENU_MOV_RIGHT_ST1
				LJMP	MENU_MOV_RIGHT_END
MENU_MOV_RIGHT_ST1:		INC	R1
				CJNE	R1,#MENU_NODO5,MENU_MOV_RIGHT_BUC
				MOV	A, @R1
				MOV	R2, A
				CJNE	R2,#0,MENU_REALIZAR_MOV_EXIT
				MOV	@R1,#1
				LJMP	MENU_REALIZAR_MOV_EXIT			
MENU_MOV_RIGHT_END:		MOV	@R1,#1
				LJMP	MENU_REALIZAR_MOV_EXIT		

	
;; -------------------------------------------
;; MOVIMIENTO PENDIENTE HACIA ABAJO
;; -------------------------------------------
MENU_MOV_DOWN:			CLR	MENU_PEND_DOWN	
				MOV	R1,#MENU_NODO5
MENU_MOV_DOWN_BUC:		MOV	A, @R1
				MOV	R2, A
				CJNE	R2,#0,MENU_MOV_DOWN_ST1
				DEC	R1
				CJNE	R1,#MENU_NODO1,MENU_MOV_DOWN_BUC
				MOV	A, @R1
				MOV	R2, A
				CJNE	R2,#0,MENU_MOV_DOWN_ST1
				MOV	@R1,#1				;; Si estamos en raíz, vamos a 1.0.0.0.0		
				LJMP	MENU_REALIZAR_MOV_EXIT
MENU_MOV_DOWN_ST1:		MOV	A,@R1
				INC	A
				MOV	@R1,A
				LJMP	MENU_REALIZAR_MOV_EXIT
	

;; -------------------------------------------
;; MENU_REALIZAR_MOV_EXIT
;; -------------------------------------------

MENU_REALIZAR_MOV_EXIT:
				LJMP	MENU_COMPROBAR_MOV
MENU_REALIZAR_MOV_EXIT_ST1:		
				POP DPL
				POP DPH
				POP PSW
				POP ACC
				
				; POP_STATE 
				RET
	

;; -----------------------------------------------------------------------------------------------	
;; VERIFICACIÓN DEL MOVIMIENTO DEL MENÚ
;; Aviso: Utiliza MENU_MOV_VALIDO y el banco de registros 
;; -----------------------------------------------------------------------------------------------

MENU_COMPROBAR_MOV:		LCALL	MENU_MOV_VALIDO
				CJNE	R0,#1,MENU_MOV_NO_VALIDO
				MOV	A,R1
				CJNE	A,#MENU_NODO1,MENU_C_M_01
				LCALL	MENU_NODO_CHECK
				SETB	LCD_PEND_INFO
MENU_C_M_01:			SETB	LCD_PEND_MENU
				SETB	LCD_PEND
				SETB	RS232_PEND_MENU	
				LJMP	MENU_COMPROBAR_MOV_EXIT
MENU_MOV_NO_VALIDO:		MOV	A,R2
				MOV	@R1,A
MENU_COMPROBAR_MOV_EXIT:	CLR	MENU_PEND 

				; POP_STATE
			
				LJMP	MENU_REALIZAR_MOV_EXIT_ST1


;; ------------------------------------
;; MENU NODO CHECK
;; ------------------------------------
MENU_NODO_CHECK:	PUSH	ACC
			CLR	MENU_NODO_INICIAL
			CLR	MENU_NODO_LUZ
			CLR	MENU_NODO_PERSIANA
			CLR	MENU_NODO_ALARMA
			CLR	MENU_NODO_RELOJ
			MOV	A,MENU_NODO1
			CJNE	A,#MENU_INICIAL,MENU_CHECK_ST1
			SETB	MENU_NODO_INICIAL
			LJMP	MENU_CHECK_EXIT
MENU_CHECK_ST1:		CJNE	A,#MENU_PERSIANA,MENU_CHECK_ST2
			SETB	MENU_NODO_PERSIANA
			LJMP	MENU_CHECK_EXIT
MENU_CHECK_ST2:		CJNE	A,#MENU_LUZ,MENU_CHECK_ST3
			SETB	MENU_NODO_LUZ
			LJMP	MENU_CHECK_EXIT
MENU_CHECK_ST3:		CJNE	A,#MENU_ALARMA,MENU_CHECK_ST4
			SETB	MENU_NODO_ALARMA
			LJMP	MENU_CHECK_EXIT
MENU_CHECK_ST4:		CJNE	A,#MENU_RELOJ,MENU_CHECK_EXIT
			SETB	MENU_NODO_RELOJ
			LJMP	MENU_CHECK_EXIT

MENU_CHECK_EXIT:	POP	ACC
			RET


;; ------------------------------------------------------------------------
;; RUTINA que comprueba si el movimiento es válido con los nodos actuales. 
;; Si existe,	 R0=1 ,DPTR = DIR (en R0 del banco 11)
;; Si no existe, R0=0		  (en R0 del banco 11)
;; ------------------------------------------------------------------------
MENU_MOV_VALIDO:		;  PUSH_STATE
				PUSH ACC
				PUSH PSW
				
				SETB	RS1
				SETB	RS0
	
				MOV	DPTR,#MENU_ELEMENTS
				MOV	A,#0
				MOVC	A,@A+DPTR
				MOV	R4,A			; R4 = NUMERO DE ELEMENTOS EN EL MENU	
				INC	DPTR
MENU_MOV_VALIDO_BUC:		MOV	R1,#MENU_NODO1		; PUNTERO AL NODO-i
				MOV	R2,#0			; R2 = CONTADOR DE NODOS
MENU_MOV_VALIDO_ST1:		MOV	A,R2
				MOVC	A,@A+DPTR
				CLR	OV
				CLR	C
				SUBB	A,@R1		
				JNZ	MENU_VL_NEXT_ENTRY	; COMPROBAMOS SI LA ENTRADA Y NODOI SON IGUALES
				CJNE	R1,#MENU_NODO5,MENU_VL_SIG
				LJMP	MENU_VL_ESVALIDO
MENU_VL_SIG:			INC	R2
				INC	R1
				LJMP	MENU_MOV_VALIDO_ST1
MENU_VL_ESVALIDO:		LJMP	MENU_VL_EXIT_ESVAL 	;; EL ELEMENTO EXISTE Y ES VALIDO
				
				LJMP	MENU_VL_EXIT
MENU_VL_NEXT_ENTRY:		MOV	R5,#27	;; EL ELEMENTO DEL MENU NO EXISTE. INCREMENTAR DPTR EN +23
MENU_VL_INC_27:			INC	DPTR
				DJNZ	R5,MENU_VL_INC_27
				DJNZ	R4,MENU_MOV_VALIDO_BUC	;; HEMOS TERMINADO DE RECORRER TODAS LAS ENTRADAS DEL MENU
			
MENU_VL_EXIT:			;  POP_STATE
				
				POP PSW
				POP ACC
				MOV	R0,#0			;; POR LO TANTO LA ENTRADA NO ES VALIDA.
				RET
MENU_VL_EXIT_ESVAL:		
				POP PSW
				POP ACC
				MOV	R0,#1			;; POR LO TANTO LA ENTRADA NO ES VALIDA.
				RET

	


	
