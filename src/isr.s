;******************** (C) COPYRIGHT 2018 IoTality ********************
;* File Name          : LED.s
;* Author             : Gopal
;* Date               : 07-Feb-2018
;* Description        : A simple code to blink LEDs on STM32F4 discovery board
;*                      - The functions are called from startup code
;*                      - Initialization carried out for GPIO-D pins PD12 to PD15 (connected to LEDs)
;*                      - Blink interval delay implemented in software
;*******************************************************************************
	GET reg_stm32f407xx.inc

	AREA	ISRCODE, CODE, READONLY
		
SysTick_Handler PROC
	EXPORT  SysTick_Handler
	
	LDR		R1, =GPIOD_BSRR

	CBZ		R7, Turn_OFF
Turn_ON
	MOV		R0, #LEDs_ON
	B		Done
Turn_OFF
	MOV		R0, #LEDs_OFF
Done
	STR		R0, [R1]
	EOR		R7, R7, #0x01
	
	BX	LR

	ENDP
		
	ALIGN 4
LEDs_ON		EQU	0x0000F000
LEDs_OFF	EQU	0xF0000000
	
	
	END
