;**********************************************************************
;��������� 1.1 ��� ����������������� ATx8515:
;������������ ����������� (��) ��� ������� �� ������ START (SW0),
;����� ������� ������ STOP (SW1) ������������ ������������ � 
;�������������� c ����� ��������� ��� ��������� ������� �� ������ START
;����������: SW0-PD0, SW1-PD1, LED-PB
;**********************************************************************
;.include "8515def.inc"			;���� ����������� ��� AT90S8515
.include "m8515def.inc"			;���� ����������� ��� ATmega8515
.def temp = r16					;��������� �������
.def reg_led = r20				;��������� �������� �����������
.equ START = 0					;0-� ������ ����� PD
.equ STOP = 1					;1-� ������ ����� PD

.org $000
		rjmp init
;***�������������***
INIT:	ldi reg_led,0xAA 	;����� reg_led.0 ��� ��������� LED0
		sec					;C=1
		set					;T=1 � ���� �����������
		ser temp			;�������������  
		out DDRB,temp		; ����� PB �� �����
		out PORTB,temp		;�������� ��
		clr temp			;������������� 
		out DDRD,temp		; ����� PD �� ����
		ldi temp,0x03		;��������� ������������� 
		out PORTD,temp		; ���������� ����� PD	
WAITSTART:					;��������
		sbic PIND,START		; �������
		rjmp WAITSTART		; ������ START
LOOP:	out PORTB,reg_led	;��������� ��
;***�������� (��� ��������� �����)***
		
		sbic PIND,STOP		;���� �������� ������ STOP, �� 
		rjmp MM				; �������
		rjmp WAITSTART		; ��� �������� ������ START,

MM:		
		brts LEFT			;�������, ���� ���� T ����������
		sbrc reg_led,1		;������� ��������� �������, 
							; ���� 0-� ������ reg_led ����������
		set					;T=1 - ������������ ����� �����������
		ror reg_led			;����� reg_led ������ �� 1 ������ 
		rjmp LOOP			
LEFT:	sbrc reg_led,6		;������� ��������� �������, 
							; ���� 7-� ������ reg_led ����������
		clt					;T=0 � ������������ ����� �����������
		rol reg_led			;����� reg_led ����� �� 1 ������ 
		rjmp LOOP
