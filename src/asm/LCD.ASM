;; -----------------------------------------------------------------------------------------------
;; -----------------------------------------------------------------------------------------------
;;  LCD. RUTINAS
;; -----------------------------------------------------------------------------------------------
;; -----------------------------------------------------------------------------------------------
	
	ORG 400H

;; -----------------------------------------------------------------------------------------------
;; RUTINA QUE LEE UNA LÍNEA DE OCHO BITS EN DOS VECES, LEYENDO 4 BITS CADA VEZ (DB4-DB7)
;; -----------------------------------------------------------------------------------------------

LCD_READ_2_NIBBLES:	ORL	DAT,#0F0H		; Leemos la parte alta y la guardamos en ACC
			SETB	EN			
			NOP				; NECESEARIO PARA QUE FUNCIONE!!!
			MOV	A,DAT			
			CLR	EN
			ANL	A,#0F0h		
			PUSH	ACC
			
			SETB	EN			; Leemos la parte baja y la guardamos en ACC
			MOV	A,DAT			
			CLR	EN 
			ANL	A,#0F0h			
			SWAP	A				
			MOV	R7,A 
			POP	ACC 
			ORL	A,R7
			RET

;; -----------------------------------------------------------------------------------------------
;; RUTINA QUE ESCRIBE UNA LÍNEA DE OCHO BITS EN DOS VECES, ESCRIBIENDO 4 BITS CADA VEZ (DB4-DB7)
;; -----------------------------------------------------------------------------------------------

LCD_WRITE_2_NIBBLES:	PUSH	ACC			;Save A for low nibble
			ORL	DAT,#0F0h		;Bits 4..7 <- 1
			ORL	A,#0Fh			;Don't affect bits 0-3
			ANL	DAT,A			;High nibble to display
			SETB	EN 
			CLR	EN 
			POP	ACC			;Prepare to send
			SWAP	A			;...second nibble
			ORL	DAT,#0F0h		;Bits 4...7 <- 1
			ORL	A,#0Fh			;Don't affect bits 0...3
			ANL	DAT,A			;Low nibble to display
			SETB	EN 
			CLR	EN 
			RET
 
;; -----------------------------------------------------------------------------------------------
;; RUTINA DE ESPERA ACTIVA PARA FINALIZACION DE COMANDO
;; -----------------------------------------------------------------------------------------------
LCD_WAIT:		CLR	RS			;It's a command
			SETB	RW			;It's a read command
			LCALL	LCD_READ_2_NIBBLES	;Take two nibbles from LCD in A
			JB	ACC.7,LCD_WAIT		;If bit 7 high, LCD still busy
			CLR	RW			;Turn off RW for future commands
			RET

	
;; -----------------------------------------------------------------------------------------------
;; ESCRITURA DE UN CARACTER
;; AVISO: El puntero se desplaza una unidad a la derecha.
;; -----------------------------------------------------------------------------------------------
LCD_WRITE_TEXT:		SETB	RS
			LCALL	LCD_WRITE_2_NIBBLES
			LCALL	LCD_WAIT
			RET
	
;; -----------------------------------------------------------------------------------------------
;; LIMPIAR EL LCD
;; -----------------------------------------------------------------------------------------------
LCD_CLEAR:		CLR	RS
			MOV	A,#01h
			LCALL	LCD_WRITE_2_NIBBLES	;Write A as two separate nibbles to LCD
			LCALL	LCD_WAIT
			RET
		
;; -----------------------------------------------------------------------------------------------
;; INICIALIZACION DEL LCD
;; EL CURSOR SE DESPLAZA HACIA LA DERECHA
;; -----------------------------------------------------------------------------------------------
LCD_INIT:		CLR	EN
			
			CLR	RS			; Mandamos la instrucción "0011", 1ª vez
			CLR	RW
			CLR	DB7
			CLR	DB6
			SETB	DB5
			SETB	DB4
			SETB	EN			
			CLR	EN
			LCALL	LCD_WAIT_5ms

			SETB	EN			; Mandamos la instrucción "0011", 2ª vez			
			CLR	EN
			LCALL	LCD_WAIT_5ms
	
			SETB	EN			; Mandamos la instrucción "0011", 3ª vez
			CLR	EN
			LCALL	LCD_WAIT_5ms

			CLR	RS			; Mandamos la instrucción "0010", 4 bits mode
			CLR	RW
			CLR	DB7
			CLR	DB6
			SETB	DB5
			CLR	DB4
			SETB	EN			
			CLR	EN
 			LCALL	LCD_WAIT_5ms  

			MOV	A,#28h
			LCALL	LCD_WRITE_2_NIBBLES
			LCALL	LCD_WAIT
	
			MOV	A,#0Ch
			LCALL	LCD_WRITE_2_NIBBLES
			LCALL	LCD_WAIT
			
			MOV	A,#06h
			LCALL	LCD_WRITE_2_NIBBLES
			LCALL	LCD_WAIT
			LCALL	LCD_CLEAR
			RET

;; -----------------------------------------------------------------------------------------------
;; RUTINA DE ESPERA ACTIVA DE UNOS 5 ms
;; -----------------------------------------------------------------------------------------------
LCD_WAIT_5ms:		PUSH	ACC		;  Espera algo más de 256*20 us (aprox. 5ms)
			PUSH	PSW
			PUSH	B
			MOV	ACC,#0
			MOV	B,#20
WAIT1:			DJNZ	ACC,WAIT1
			DJNZ	B,WAIT1
			POP	B
			POP	PSW
			POP	ACC
			RET

	
;; -----------------------------------------------------------------------------------------------	
;; REFRESCA LA HORA EN LA PANTALLA
;; -----------------------------------------------------------------------------------------------
LCD_REFRESH_TIME:	 ;PUSH_STATE 
			PUSH	ACC
			PUSH	PSW
			PUSH	DPH
			PUSH	DPL
			CLR	RS0
			SETB	RS1
		
			MOV	A,#0CCH	;; COLOCAMOS EL PUNTERO EN LA SEGUNDA LINEA, PARA EL CLK		
			LCALL	LCD_WRITE_2_NIBBLES
			LCALL	LCD_WAIT
 	
			MOV	A,CLK_HORAS
			LCALL	TIME_CONV

			MOV	A,#':'
			LCALL	LCD_WRITE_TEXT

			MOV	A,CLK_MIN
			LCALL	TIME_CONV

			MOV	A,#':'
			LCALL	LCD_WRITE_TEXT
				
			MOV	A,CLK_SEG
			LCALL	TIME_CONV

			POP	DPL
			POP	DPH
			POP	PSW
			POP	ACC
			; POP_STATE 
			CLR	LCD_PEND_TIME
			RET
	

TIME_CONV:		MOV	B,#10
			DIV	AB
			ADD	A,#'0'
			LCALL	LCD_WRITE_TEXT
			MOV	A,#0
			ADD	A,B
			ADD	A,#'0'
			LCALL	LCD_WRITE_TEXT
			RET

	
;; -----------------------------------------------------------------------------------------------	
;; REFRESCA LA POSICIÓN ACTUAL DEL MENU EN LA PANTALLA
;; UTILIZA EL BANCO DE REGISTROS 01
;; -----------------------------------------------------------------------------------------------
LCD_REFRESH_MENU:	; PUSH_STATE
			PUSH	ACC
			PUSH	PSW
			PUSH	DPH
			PUSH	DPL

	
			SETB	RS0
			CLR	RS1
	
			MOV	A,#80H		;; COLOCAMOS EL PUNTERO EN LA PRIMERA LINEA, PRIMER CARACTER
			LCALL	LCD_WRITE_2_NIBBLES
			LCALL	LCD_WAIT

			LCALL	MENU_MOV_VALIDO
			MOV	R0,#5
REFRESH_MENU_INC:	INC	DPTR
			DJNZ	R0,REFRESH_MENU_INC
			MOV	R1,#20
REFRESH_MENU_BUC:	MOV	A,#0		
			MOVC	A,@A+DPTR
			LCALL	LCD_WRITE_TEXT
			INC	DPTR
			DJNZ	R1,REFRESH_MENU_BUC
			CLR	LCD_PEND_MENU
			
	
			POP	DPL	
			POP	DPH
			POP	PSW
			POP	ACC
			; POP_STATE  
			RET

LCD_REFRESH_ALARM:	PUSH	ACC

			
			MOV	A,#0C0H
			LCALL	LCD_WRITE_2_NIBBLES
			LCALL	LCD_WAIT
		
			MOV	A,ALARMA_HORA
			LCALL	TIME_CONV
			MOV	A,#':'
			LCALL	LCD_WRITE_TEXT
			
			MOV	A,ALARMA_MINUTO
			LCALL	TIME_CONV	
			
			MOV	A,#0C6H
			LCALL	LCD_WRITE_2_NIBBLES
			LCALL	LCD_WAIT

LCD_RA_01:		JNB	ALARMA_MOTOR_01,LCD_RA_01_OFF
			MOV	A,#'L'
			LCALL	LCD_WRITE_TEXT
			
			LJMP	LCD_RA_02
LCD_RA_01_OFF:		MOV	A,#' '
			LCALL	LCD_WRITE_TEXT
LCD_RA_02:		JNB	ALARMA_MOTOR_02,LCD_RA_02_OFF
			MOV	A,#'P'
			LCALL	LCD_WRITE_TEXT
			LJMP	LCD_RA_03
LCD_RA_02_OFF:		MOV	A,#' '
			LCALL	LCD_WRITE_TEXT
LCD_RA_03:		JNB	ALARMA_LUZ_01,LCD_RA_03_OFF
			MOV	A,#'1'
			LCALL	LCD_WRITE_TEXT
			LJMP	LCD_RA_04
LCD_RA_03_OFF:		MOV	A,#' '
			LCALL	LCD_WRITE_TEXT
LCD_RA_04:		JNB	ALARMA_LUZ_02,LCD_RA_04_OFF
			MOV	A,#'2'
			LCALL	LCD_WRITE_TEXT
			LJMP	LCD_RA_05
LCD_RA_04_OFF:		MOV	A,#' '
			LCALL	LCD_WRITE_TEXT
LCD_RA_05:		MOV	A,#' '
			LCALL	LCD_WRITE_TEXT
			JNB	ALARMA_STATUS,LCD_RA_OFF
LCD_RA_ON:		MOV	A,#'A'
			LJMP	LCD_RA_EXIT
LCD_RA_OFF:		MOV	A,#' '
LCD_RA_EXIT:		LCALL	LCD_WRITE_TEXT
			CLR	LCD_PEND_ALARM
			POP	ACC
			RET

LCD_BORRAR_INFO:	MOV	A,#0C0H
			LCALL	LCD_WRITE_2_NIBBLES
			LCALL	LCD_WAIT
			MOV	R4,#10
			MOV	A,#' '
			LCALL	LCD_WRITE_TEXT
			DJNZ	R4,$-5
			RET

LCD_REFRESH_STATUS:	MOV	A,#0C8H
			LCALL	LCD_WRITE_2_NIBBLES
			LCALL	LCD_WAIT
			JNB	LUZ_01,LCD_RS_01_OFF
			MOV	A,#'1'
			LCALL	LCD_WRITE_TEXT
			LJMP	LCD_RS_02
LCD_RS_01_OFF:		MOV	A,#' '
			LCALL	LCD_WRITE_TEXT	
LCD_RS_02:		JNB	LUZ_02,LCD_RS_02_OFF
			MOV	A,#'2'
			LCALL	LCD_WRITE_TEXT
			LJMP	LCD_RS_03
LCD_RS_02_OFF:		MOV	A,#' '
			LCALL	LCD_WRITE_TEXT
LCD_RS_03:		RET
	
	
	
LCD_REFRESH_INICIAL:	LCALL	LCD_BORRAR_INFO
			LCALL	LCD_REFRESH_STATUS
			RET	
LCD_REFRESH_PERSIANA:	LCALL	LCD_BORRAR_INFO
			LCALL	LCD_REFRESH_STATUS
			RET		
LCD_REFRESH_RELOJ:	LCALL	LCD_BORRAR_INFO
			LCALL	LCD_REFRESH_STATUS
			RET
LCD_REFRESH_LUZ:	LCALL	LCD_BORRAR_INFO
			LCALL	LCD_REFRESH_STATUS
			RET
LCD_REFRESH_INFO:
			JNB	MENU_NODO_INICIAL,BG_RI1
			LCALL	LCD_REFRESH_INICIAL
BG_RI1:			JNB	MENU_NODO_ALARMA,BG_RI2
			LCALL	LCD_REFRESH_ALARM		
BG_RI2:			JNB	MENU_NODO_LUZ,BG_RI3
			LCALL	LCD_REFRESH_LUZ
BG_RI3:			JNB	MENU_NODO_PERSIANA,BG_RI4
			LCALL	LCD_REFRESH_PERSIANA
BG_RI4:			JNB	MENU_NODO_RELOJ,BG_RI5
			LCALL	LCD_REFRESH_RELOJ
BG_RI5:			CLR	LCD_PEND_INFO
			RET
;; -----------------------------------------------------------------------------------------------	
;; REFRESCA LA PANTALLA ENTERA
;; -----------------------------------------------------------------------------------------------
LCD_UPDATE:		CLR	LCD_PEND
			JNB	LCD_PEND_TIME, BG_RE1
			LCALL	LCD_REFRESH_TIME  
BG_RE1:			JNB	LCD_PEND_MENU, BG_RE2
			LCALL	LCD_REFRESH_MENU
BG_RE2:			JNB	LCD_PEND_INFO,BG_RE_EXIT
			LCALL	LCD_REFRESH_INFO
	
BG_RE_EXIT:		RET
