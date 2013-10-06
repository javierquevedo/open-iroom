;; ----------------------------------------------------------------------------------------------
;; ----------------------------------------------------------------------------------------------
;; RTI´s
;; ----------------------------------------------------------------------------------------------
;; ----------------------------------------------------------------------------------------------

;; -----------------------------------------------------------------------------------------------
;; SALTO A LA RTI CORRESPONDIENTE
;; -----------------------------------------------------------------------------------------------
	
;ORG 0003h			 
;LJMP RTI_EXT0	

ORG 000BH 
LJMP RTI_TIMER0

;ORG 0013h
;LJMP RTI_EXT1	

;ORG 001Bh
;LJMP RTI_TIMER1

org 0023H
LJMP	RTI_RS232


ORG 002Bh
LJMP RTI_TIMER2 


	
;; -----------------------------------------------------------------------------------------------
;; CÓDIGO DE LAS RTÌ´s
;; -----------------------------------------------------------------------------------------------	
	
ORG	200H
	
;; --------------------
;; RTI_RS232
;; --------------------

RTI_RS232:	PUSH	PSW
		PUSH	ACC
		SETB	RS0
		SETB	RS1
		JNB	RI,RTI_RS_WRITE
RTI_RS_READ:	CLR	RI	
		MOV	A,SBUF
		MOV	RS232_CHAR_REC,A
		SETB	RS232_REC_READY
		LJMP	RTI_RS_EXIT

RTI_RS_WRITE:	CLR	TI
		SETB	RS232_TRANS_READY
		
RTI_RS_EXIT:	POP	ACC
		POP	PSW
		RETI	
	

;; --------------------
;; RTI_EXT0
;; --------------------

;; --------------------
;; RTI_TIMER0
;; --------------------
rti_timer0:
		PUSH	ACC
		PUSH	PSW
		PUSH	DPL
		PUSH	DPH
		CLR	TF0
		MOV	TH0,#HIGH TECLADO_TIME
		MOV	TL0,#LOW TECLADO_TIME
		DJNZ	SENSORES_COUNT,RTI_TIMER0_1
		MOV	SENSORES_COUNT,#SENSORES_ESPERAR
		SETB	SENSORES_PEND
RTI_TIMER0_1:	
		DJNZ	TECLADO_COUNT,TIMER0_EXIT
		MOV	TECLADO_COUNT,#TECLADO_ESPERAR
		SETB	TECLADO_PEND
TIMER0_EXIT:	
		POP DPH
		POP DPL
		POP PSW
		POP ACC
		;POP_STATE
		RETI
;; --------------------
;; RTI_EXT1
;; --------------------


;; --------------------
;; RTI_TIMER1
;; --------------------


	
;; --------------------
;; RTI_TIMER2
;; --------------------
RTI_TIMER2:		;PUSH_STATE
			PUSH ACC
			PUSH PSW
			PUSH DPL
			PUSH DPH
			CLR	TF2			; Clear timer2 overflow flag 
			DJNZ	CLK_COUNT,CLK_NEXT
			LCALL	CLK_UPDATE
CLK_NEXT:		
			POP DPH
			POP DPL
			POP PSW
			POP ACC
			;POP_STATE
			RETI

		
;; -----------------------------------------------------------------------------------------------	
;; INICIALIZACIÓN DE INTERRUPCIONES
;; -----------------------------------------------------------------------------------------------	

INTERRUPT_INIT:		CLR IP.1			; Niveles de prioridad	
			CLR IP.2
			CLR  IP.3
			SETB IP.5
			MOV	TMOD,#021H	; TIMER1 = autoreload
						; TIMER0 = 16BIT manual reload 
		;; INIT DE RS232
			MOV	TH1,#243
			MOV	PCON,#080H
			MOV	SCON,#050H
			SETB	RS232_PEND_MENU
			SETB	TR1
			SETB	ES
			SETB	RS232_TRANS_READY 
		;; INIT DE TECLADO Y SENSORES
			CLR	TECLADO_PEND
			CLR	SENSORES_PEND
			MOV	SENSORES_COUNT,#SENSORES_ESPERAR
			MOV	TECLADO_COUNT,#TECLADO_ESPERAR
			MOV	TH0,#0
			MOV	TL0,#0
			SETB	TR0		

							
			CLR	EX0			; Interrupciones individuales
			CLR	EX1
			SETB	ET0
			CLR	ET1
			SETB	ET2

			SETB EA				; Permito interrupciones generales
			RET