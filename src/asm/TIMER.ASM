;; -----------------------------------------------------------------------------------------------
;; -----------------------------------------------------------------------------------------------
;;  RELOJ EN TIEMPO REAL
;; -----------------------------------------------------------------------------------------------
;; -----------------------------------------------------------------------------------------------

	ORG 300H

;; -----------------------------------------------------------------------------------------------	
;; INICIALIZACIÓN DEL REAL TIMER
;; -----------------------------------------------------------------------------------------------

REAL_TIME_INIT:		MOV	CLK_HORAS,#0
			MOV	CLK_MIN,#0
			MOV	CLK_SEG,#0
			MOV	CLK_COUNT,#20
			CLR	CPRL2			; Autoreload con overflow
			MOV	TL2,#LOW TIME
			MOV	TH2,#HIGH TIME
			MOV	RCAP2L,#LOW TIME
			MOV	RCAP2H,#HIGH TIME
			SETB	TR2			; Timer2 activado
			SETB	LCD_PEND_TIME
			SETB	LCD_PEND
			RET


;; -----------------------------------------------------------------------------------------------	
;; ACTUALIZA EL RELOJ CADA SEGUNDO
;; -----------------------------------------------------------------------------------------------

CLK_UPDATE:		MOV	CLK_COUNT,#20
			MOV	A,CLK_SEG
			CJNE	A,#59,CLK_INC_SEG
			MOV	CLK_SEG,#0
			MOV	A,CLK_MIN
			CJNE	A,#59,CLK_INC_MIN
			MOV	CLK_MIN,#0
			MOV	A,CLK_HORAS
			CJNE	A,#23,CLK_INC_HORAS
			MOV	CLK_HORAS,#0
			JMP	CLK_EXIT
CLK_INC_SEG:		INC	CLK_SEG
			JMP	CLK_EXIT
CLK_INC_MIN:		INC	CLK_MIN
			LCALL	ALARMA_CHECK
			JMP	CLK_EXIT
CLK_INC_HORAS:		INC	CLK_HORAS
			LCALL	ALARMA_CHECK
CLK_EXIT:		SETB	LCD_PEND_TIME
			SETB	LCD_PEND
			RET
;; -----------------------------------------------------------------------------------------------	
;; INICIALIZACIÓN DEL TIMER PARA MOVER UN MOTOR
;; -----------------------------------------------------------------------------------------------
