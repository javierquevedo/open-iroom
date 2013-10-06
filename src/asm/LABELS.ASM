;; ---------------------------------------------------------------------------------------
;; ---------------------------------------------------------------------------------------
;; ETIQUETAS
;; ---------------------------------------------------------------------------------------
;; ---------------------------------------------------------------------------------------

;; ---------------------------------------------------------------------------------------
;; VARIABLES DE LA RAM
;; ---------------------------------------------------------------------------------------

;; --------------------
;; MEMORIA DE BIT
;; --------------------
LCD_PEND		BIT	000H	; LCD -- GLOBAL
LCD_PEND_TIME		BIT	001H	; LCD
LCD_PEND_MENU		BIT	002H	; LCD
LCD_PEND_MOTOR		BIT	003H	; LCD

MENU_PEND		BIT	004H	; MENU -- GLOBAL
MENU_PEND_UP		BIT	005H	; MENU
MENU_PEND_LEFT		BIT	006H	; MENU
MENU_PEND_RIGHT		BIT	007H	; MENU
MENU_PEND_DOWN		BIT	008H	; MENU

ACCION_PEND		BIT	009H	; ACCIÓN -- GLOBAL

TECLADO_PEND		BIT	000CH   ; BARRIDO DEL TECLADO
RS232_PEND_MENU		BIT	000DH   ; RS232 
RS232_TRANS_READY	BIT	000EH	; RS232 TRANSMIT
RS232_REC_READY		BIT	000FH   ; RS232 RECEIVED

ALARMA_PEND		BIT	0010H   ; ALARM PEND
ALARMA_STATUS		BIT	0011H   ; ESTADO ALARMA
ALARMA_LUZ_01		BIT	0012H
ALARMA_LUZ_02		BIT	0013H
ALARMA_MOTOR_01		BIT	0014H
ALARMA_MOTOR_02		BIT	0015H

LCD_PEND_ALARM		BIT	0016H
MENU_NODO_INICIAL	BIT	0017H
MENU_NODO_ALARMA	BIT	0018H
MENU_NODO_PERSIANA	BIT	0019H
MENU_NODO_RELOJ		BIT	001AH
MENU_NODO_LUZ		BIT	001BH
LCD_PEND_INFO		BIT	001CH
SENSORES_PEND		BIT	001DH
MOTOR1_STATUSI		BIT	001EH
MOTOR1_STATUSD		BIT	001FH
MOTOR2_STATUSI		BIT	0020H
MOTOR2_STATUSD		BIT	0021H
	
;; --------------------
;; MEMORIA
;; --------------------
CLK_HORAS		IDATA	0030H	; RELOJ 
CLK_MIN			IDATA	0031H
CLK_SEG			IDATA	0032H
CLK_COUNT		IDATA	0033H
		
MENU_NODO1		IDATA	0034H	; MENU
MENU_NODO2		IDATA	0035H
MENU_NODO3		IDATA	0036H
MENU_NODO4		IDATA	0037H
MENU_NODO5		IDATA	0038H

MOTOR_ACTUAL		IDATA	0039H

TECLADO_COUNT		IDATA	003AH
RS232_CHAR_REC		IDATA	003BH
ALARMA_HORA		IDATA	003CH
ALARMA_MINUTO		IDATA	003DH
SENSORES_COUNT		IDATA	003EH
	

;; -----------------------------------------------------------------------------------------------
;; CONSTANTES 
;; -----------------------------------------------------------------------------------------------
TIME			EQU	15536	; 65536 - 50000	
TECLADO_TIME		EQU	40000
TECLADO_PULSADO		EQU	10
TECLADO_ESPERAR		EQU	1
SENSORES_ESPERAR	EQU	1
TECLADO_REBOTES		EQU	6
;; -----------------------------------------------------------------------------------------------
;; PUERTOS/"PATILLAS"
;; -----------------------------------------------------------------------------------------------
	;	SIMBOLOS 

		;; controlador de servos
MEN	BIT	P1.0
D1	BIT	P1.1
D2	BIT	P1.2
M1	BIT	P1.3
M2	BIT	P1.4
M3	BIT	P1.5

		;; teclado
COL1	BIT	P3.4
COL2	BIT	P3.3
COL3	BIT	P3.2
FIL1	BIT	P3.5
FIL2	BIT	P3.6
FIL3	BIT	P3.7

		;; luces
LUZ_01			EQU	P1.6
LUZ_02			EQU	P1.7  

		;; lcd
DAT			EQU	P2	
RS			EQU	P2.1
RW			EQU	P2.2
EN			EQU	P2.3
DB4		 	EQU 	P2.4
DB5			EQU 	P2.5
DB6			EQU 	P2.6
DB7			EQU 	P2.7

MENU_INICIAL		EQU	0
MENU_PERSIANA		EQU	1
MENU_LUZ		EQU	2
MENU_ALARMA		EQU	3
MENU_RELOJ		EQU	4
MENU_RS232		EQU	5
		;; sensores
LTOP			EQU	P0.2
LBOTTOM			EQU	P0.3
PTOP			EQU	P0.0
PBOTTOM			EQU	P0.1

TESTIGO_MOTOR_1		EQU	'L'
TESTIGO_MOTOR_2		EQU	'P'
TESTIGO_LUZ_1		EQU	'1'
TESTIGO_LUZ_2		EQU	'2'
TESTIGO_ALARMA		EQU	'A'	