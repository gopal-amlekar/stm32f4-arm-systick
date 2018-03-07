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

; Export functions so they can be called from other file

	EXPORT SystemInit
	EXPORT __main

	AREA	MYCODE, CODE, READONLY
		
; ******* Function SystemInit *******
; * Called from startup code
; * Calls - None
; * Enables GPIO clock 
; * Configures GPIO-D Pins 12 to 15 as:
; ** Output
; ** Push-pull (Default configuration)
; ** High speed
; ** Pull-up enabled
; **************************

SystemInit FUNCTION

	; Enable GPIO clock
	LDR		R1, =RCC_AHB1ENR	;Pseudo-load address in R1
	LDR		R0, [R1]			;Copy contents at address in R1 to R0
	ORR.W 	R0, #0x08			;Bitwise OR entire word in R0, result in R0
	STR		R0, [R1]			;Store R0 contents to address in R1

	; Set mode as output
	LDR		R1, =GPIOD_MODER	;Two bits per pin so bits 24 to 31 control pins 12 to 15
	LDR		R0, [R1]			
	ORR.W 	R0, #0x55000000		;Mode bits set to '01' makes the pin mode as output
	AND.W	R0, #0x55FFFFFF		;OR and AND both operations reqd for 2 bits
	STR		R0, [R1]

	; Set type as push-pull	(Default)
	LDR		R1, =GPIOD_OTYPER	;Type bit '0' configures pin for push-pull
	LDR		R0, [R1]
	AND.W 	R0, #0xFFFF0FFF	
	STR		R0, [R1]
	
	; Set Speed slow
	LDR		R1, =GPIOD_OSPEEDR	;Two bits per pin so bits 24 to 31 control pins 12 to 15
	LDR		R0, [R1]
	AND.W 	R0, #0x00FFFFFF		;Speed bits set to '00' configures pin for slow speed
	STR		R0, [R1]	
	
	; Set pull-up
	LDR		R1, =GPIOD_PUPDR	;Two bits per pin so bits 24 to 31 control pins 12 to 15
	LDR		R0, [R1]
	AND.W	R0, #0x00FFFFFF		;Clear bits to disable pullup/pulldown
	STR		R0, [R1]

	LDR		R1, =SYSTICK_RELOADR
	LDR		R2,	=SYST_RELOAD_500MS
	STR		R2, [R1]

	MOV	R7, #0x00
	
	LDR		R1, =SYSTICK_CONTROLR
	LDR 	R0, [R1]
	ORR.W	R0, #ENABLE_SYSTICK
	STR		R0, [R1]

	BX		LR					;Return from function
	
	ENDFUNC
	

; ******* Function SystemInit *******
; * Called from startup code
; * Calls - None
; * Infinite loop, never returns

; * Turns on / off GPIO-D Pins 12 to 15
; * Implements blinking delay 
; ** A single loop of delay uses total 6 clock cycles
; ** One cycle each for CBZ and SUBS instructions
; ** 3 cycles for B instruction
; ** B instruction takes 1+p cycles where p=pipeline refil cycles
; **************************

__main FUNCTION
	
	
	B	.

	ENDFUNC
	
	ALIGN 4
SYST_RELOAD_500MS	EQU 0x007A1200
ENABLE_SYSTICK		EQU	0x07		
	
	END
