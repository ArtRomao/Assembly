; ===========================================================================
;	=-=-=-=-=-=-=-   DISCIPLINA SISTEMAS MICROPROCESSADOS   -=-=-=-=-=-=-=-=
;	PROGRAMA-BASE PARA MICROCONTROLADOR PIC18F4520/4550
;	MAURICIO DOS SANTOS KASTER
;	SET/2014
; ===========================================================================

; --- 18f4520 ---
#INCLUDE <P18F4520.INC>
	CONFIG OSC = HS
	CONFIG PWRT = ON
	CONFIG WDT = OFF
	CONFIG MCLRE = ON
	CONFIG LVP = ON
	CONFIG DEBUG = OFF

; --- 18f4550 ---
;#INCLUDE <P18F4550.INC>
;	CONFIG FOSC = HSPLL_HS
;	CONFIG LVP = OFF
;	CONFIG MCLRE = ON
;	CONFIG WDT = OFF
;	CONFIG DEBUG = OFF
;	CONFIG PWRT = ON
;	;CONFIG PLLDIV = 4
;	;CONFIG CPUDIV = OSC3_PLL4
;	;CONFIG USBDIV = 1

; ===========================================================================
; *                         DEFINIO DAS VARIVEIS
; ===========================================================================

	CBLOCK	0x20
		W_TEMP
		STATUS_TEMP
		BSR_TEMP
		CONT
		LIMITE_INFERIOR
		LIMITE_SUPERIOR
	ENDC

; ===========================================================================
; *                   VETOR DE RESET DO MICROCONTROLADOR
; ===========================================================================

		ORG		0X0000		; ENDEREO DO VETOR DE RESET
		GOTO	INICIO		; DESVIA PARA O INCIO DO PROGRAMA

; ===========================================================================
; *                             INTERRUPES
; ===========================================================================

		ORG		0x0008		; VETOR DE INTERRUPES DE ALTA PRIORIDADE
		MOVWF	W_TEMP			; SALVAMENTO DE CONTEXTO
		MOVFF	STATUS,STATUS_TEMP
		MOVFF	BSR,BSR_TEMP
		GOTO	HIGH_PRIORITY

; ===========================================================================

		ORG		0x0018		; VETOR DE INTERRUPES DE BAIXA PRIORIDADE
		MOVWF	W_TEMP			; SALVAMENTO DE CONTEXTO
		MOVFF	STATUS,STATUS_TEMP
		MOVFF	BSR,BSR_TEMP
		;GOTO	LOW_PRIORITY

LOW_PRIORITY
		GOTO	FIMINT

; ---------------------------------------------------------------------------
HIGH_PRIORITY
		GOTO	FIMINT

; ---------------------------------------------------------------------------
FIMINT
		MOVFF	BSR_TEMP,BSR	; RESTAURACAO DE CONTEXTO
		MOVF	W_TEMP,W
		MOVFF	STATUS_TEMP,STATUS
		RETFIE

; ===========================================================================
;                           PROGRAMA PRINCIPAL
; ===========================================================================

INICIO
	
	MOVLW D'0' ;W = 0
	MOVWF CONT ;CONT = W

	;CALL ITEM_A ;Conta de 0 a 9
	;CALL ITEM_B ;Conta de 9 a 0
	CALL ITEM_C ;Conta de 0 a 9, de 9 a 1, de 1 a 10, de 10 a 2, de 2 a 11, etc...


; ===========================================================================
; *                            SUBROTINAS
; ===========================================================================

ITEM_A
	
	L1
	    INCF CONT, F ;CONT++
	    MOVF CONT, W ;W = CONT
	    SUBLW D'9' ;W = 9-W
	    BTFSS STATUS, Z ;if(W == 0) (Caso W seja 0 a próxima instrução é pulada)
	    GOTO L1 ;Retornar em L1
		
	L2
	    MOVLW D'0' ;W = 0
	    MOVWF CONT ;CONT = W (0)
		GOTO L1 ;Retornar para L1
	
ITEM_B

	L3
	    MOVLW D'9' ;W = 9
	    MOVWF CONT ;CONT = W (9)
		
	L4
	    DECFSZ CONT, F ;CONT-- (Caso CONT seja 0 a próxima instrução é pulada)
	    GOTO L4 ;Retornar em L4
		GOTO L3 ;Retornar em L3

ITEM_C
		MOVLW D'1' ;W = 1
		MOVWF LIMITE_INFERIOR ;LIMITE_INFERIOR = W (1)
		MOVLW D'9' ;W = 9
		MOVWF LIMITE_SUPERIOR ;LIMITE_SUPERIOR = W (9)

	L5
	    INCF CONT, F ;CONT++
	    MOVF CONT, W ;W = CONT
	    SUBWF LIMITE_SUPERIOR, W ;W = LIMITE_SUPERIOR - W
	    BTFSS STATUS, Z ;if(W == 0) (Caso W seja 0 a próxima instrução é pulada)
	    GOTO L5 ;Retornar em L5

	L6
	    DECF CONT, F ;CONT--
		MOVF CONT, W ;W = CONT
		SUBWF LIMITE_INFERIOR, W ;W = LIMITE_INFERIOR - W
	    BTFSS STATUS, Z ;if(W == 0) (Caso W seja 0 a próxima instrução é pulada)
	    GOTO L6 ;Retornar em L6

		INCF LIMITE_INFERIOR, F ;LIMITE_INFERIOR++
		INCF LIMITE_SUPERIOR, F ;LIMITE_SUPERIOR++
		GOTO L5 ;Retornar em L5
	

; ===========================================================================
; *                            FIM DO PROGRAMA
; ===========================================================================

		END				; FIM DO PROGRAMA
