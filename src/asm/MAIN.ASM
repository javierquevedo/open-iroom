;; -------------------------------------------------------------------------------------------------------	
;; -------------------------------------------------------------------------------------------------------	
;;					PROGRAMA PRINCIPAL
;; -------------------------------------------------------------------------------------------------------
;; -------------------------------------------------------------------------------------------------------

	$NOMOD51
$INCLUDE(8052.MCU)		; Símbolos 8052
$INCLUDE(macros.asm)		; Macros
$INCLUDE(labels.asm)		; Etiquetas
$INCLUDE(rtis.asm)		; Interrupciones	-->  0200H
$INCLUDE(timer.asm)		; Real timer		-->  0300H
$INCLUDE(lcd.asm)		; LCD			-->  0400H
$INCLUDE(menu.asm)		; Menú			-->  0700H
$INCLUDE(acciones.asm)		; Acciones		-->  0900H
$INCLUDE(teclado.asm)		; Teclado Matricial	-->  1100H
$INCLUDE(alarma.asm)		; Alarma		-->  1200H
$INCLUDE(rs232.asm)		; Rs232			-->  1300H
$INCLUDE(sensores.asm)		; Sensores		-->  1500H
$INCLUDE(motor.asm)		; Motores		-->  1580H
$INCLUDE(menudata.asm)		; Menú data		-->  1700H	
	ORG 0000H

			LJMP START
	
	ORG 0100H
	
START:			MOV	SP,#80H
			CLR	RS0
			SETB	RS1
			ANL	P1,#00FH
			
			LCALL REAL_TIME_INIT
			LCALL MENU_INIT
			LCALL INTERRUPT_INIT
			LCALL LCD_INIT
			LCALL ALARMA_INIT
			LCALL MOTOR_INIT
	
	

	
		
BUCLE_CENTRAL:		JNB	MENU_PEND, BC_STAGE1
			LCALL	MENU_UPDATE  
BC_STAGE1:		JNB	LCD_PEND, BC_STAGE2
			LCALL	LCD_UPDATE
BC_STAGE2:		JNB	ACCION_PEND, BC_STAGE3
			LCALL	ACCION_UPDATE
BC_STAGE3:		JNB	TECLADO_PEND, BC_STAGE4
			LCALL	TECLADO_UPDATE
BC_STAGE4:		JNB	RS232_REC_READY,BC_STAGE5
			LCALL	RS232_RECIVE_CHAR
BC_STAGE5:		JNB	RS232_PEND_MENU,BC_STAGE6
			LCALL	RS232_REFRESH_MENU
BC_STAGE6:		JNB	ALARMA_PEND,BC_STAGE7
			LCALL	ALARMA_UPDATE
BC_STAGE7:		JNB	SENSORES_PEND,BC_STAGE8
			LCALL	SENSORES_UPDATE
	
BC_STAGE8:		LJMP	BUCLE_CENTRAL
			
			END