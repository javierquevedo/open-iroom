;; -------------------------------------------------------------------------------------------------------	
;; -------------------------------------------------------------------------------------------------------	
;; MENU DATA
;; -------------------------------------------------------------------------------------------------------
;; -------------------------------------------------------------------------------------------------------

	ORG 1700H

MENU_ELEMENTS:		DB	30
STR_INICIO:		DB	0,0,0,0,0,'  iRoom v0.25       '
STR_INICIO_RUT:		DW	00
	
STR_PERSIANA:		DB	MENU_PERSIANA,0,0,0,0,'1. Persiana         '
STR_PERSIANA_RUT:	DW	00
	
STR_SUBIR:		DB	MENU_PERSIANA,1,0,0,0,'1.1 Subir / Parar   '
STR_SUBIR_RUT:		DW	ACCION_SUBIR_PERSIANA
	
STR_BAJAR:		DB	MENU_PERSIANA,2,0,0,0,'1.2 Bajar / Parar   '
STR_BAJAR_RUT:		DW	ACCION_BAJAR_PERSIANA
	
STR_LUZ:		DB	MENU_LUZ,0,0,0,0,'2. Luces            '
STR_LUZ_RUT:		DW	00
	
STR_LUZ_TECHO:		DB	MENU_LUZ,1,0,0,0,'2.1 Luz techo       '
STR_LUZ_TECHO_RUT:	DW	00
	
STR_LUZ_TECHO_ON:	DB	MENU_LUZ,1,1,0,0,'2.1.1 On / Off      '
STR_LUZ_TECHO_ON_RUT:	DW	ACCION_LUZ_TECHO_ON
	
STR_LUZ_ESTUDIO:	DB	MENU_LUZ,2,0,0,0,'2.2 Luz estudio     '
STR_LUZ_ESTUDIO_RUT:	DW	00

STR_LUZ_ESTUDIO_ON:	DB	MENU_LUZ,2,1,0,0,'2.2.1 On / Off      '
STR_LUZ_ESTUDIO_ON_RUT:	DW	ACCION_LUZ_ESTUDIO_ON

STR_LUZ_ESTUDIO_UP:	DB	MENU_LUZ,2,2,0,0,'2.2.2 Subir / Parar '
STR_LUZ_ESTUDIO_UP_RUT:	DW	ACCION_LUZ_ESTUDIO_UP

STR_LUZ_ESTUDIO_DOWN:	DB	MENU_LUZ,2,3,0,0,'2.2.3 Bajar / Parar '
STR_LUZ_ESTUDIO_DOWN_RUT:
			DW	ACCION_LUZ_ESTUDIO_DOWN

STR_ALARMA:		DB	MENU_ALARMA,0,0,0,0,'3. Alarma           '
STR_ALARMA_RUN:		DW	00

STR_ALARMA_ON_OFF:	DB	MENU_ALARMA,1,0,0,0,'3.1 On / Off        '
STR_ALARMA_ON_OFF_RUT:	DW	ACCION_ALARMA_ON_OFF

STR_ALARMA_ESTABLECER:	DB	MENU_ALARMA,2,0,0,0,'3.2 Establecer hora '
STR_ALARMA_ESTABLECER_RUT:
			DW	00
STR_ALARMA_HORAS:	DB	MENU_ALARMA,2,1,0,0,'3.2.1 Horas         '
STR_ALARMA_HORAS_RUT:
			DW	ACCION_ALARMA_HORAS
STR_ALARMA_MINUTOS:	DB	MENU_ALARMA,2,2,0,0,'3.2.2 Minutos       '
STR_ALARMA_MINUTOS_RUT:
			DW	ACCION_ALARMA_MINUTOS
STR_ALARMA_CONFIGURAR:	DB	MENU_ALARMA,3,0,0,0,'3.3 Config acciones '
			DW	00
STR_ALARMA_CONF_L1:	DB	MENU_ALARMA,3,1,0,0,'3.3.1 Luz 01        '
			DW	ACCION_A_LUZ_01
STR_ALARMA_CONF_L2:	DB	MENU_ALARMA,3,2,0,0,'3.3.2 Luz 02        '
			DW	ACCION_A_LUZ_02
STR_ALARMA_CONF_M1:	DB	MENU_ALARMA,3,3,0,0,'3.3.3 Subir Luz     '
			DW	ACCION_A_MOTOR_01

STR_ALARMA_CONF_M2:	DB	MENU_ALARMA,3,4,0,0,'3.3.4 Subir persiana'
			DW	ACCION_A_MOTOR_02
STR_RELOJ:		DB	MENU_RELOJ,0,0,0,0,'4. Reloj            '
			DW	00
STR_RELOJ_HORAS:	DB	MENU_RELOJ,1,0,0,0,'4.1 Horas           '
			DW	ACCION_RELOJ_HORAS
STR_RELOJ_MINUTOS:	DB	MENU_RELOJ,2,0,0,0,'4.2 Minutos         '
			DW	ACCION_RELOJ_MINUTOS
	


