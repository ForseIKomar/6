;************************************************************************
;*��������� ��� �� AT90S8515:
;*���������� ������������ ����������� (��) ��� ������� �� START,
;* ����� ������� STOP ������������ ������������ � ���������� � �����
;*  ��������� ��� ��������� ������� �� START
;************************************************************************
.include "8515def.inc"
.def num = r16			;�����, ��������������� ������ ����������� ��
.def k1 = r17					;k1,k2,k3 - ���������
.def k2 = r18					; ����� ��������
.def k3 = r19
.def temp = r20				;��������� �����
.equ START = 0				;0-�� ����� ����� PD

;***������� ����������***

	rjmp INIT			;��������� ������
	rjmp STOP_PRESSED	;��������� �������� ���������� INT0 - ������� STOP			
;***������������� ��***

INIT:
		ldi num,0x7F

		ldi temp,$5F			;���������
		out SPL,temp			; ��������� �����
		ldi temp,$02			; �� ���������
		out SPH,temp			; ������ ���

		sec				;C=1
		set				;T=1		
		ser temp			;������������� ������� 
		out DDRB,temp		; ����� PB �� �����
		out PORTB,temp		;�������� ��
		clr temp			;������������� 0-��� � 2-��� �������
		out DDRD,temp		; ����� PD �� ����
		ldi temp,0x05			;��������� ������������� 
		out PORTD,temp		; ���������� ����� PD

		ldi temp,0x7F			;����������
		out GIMSK,temp		; ���������� INT0
		ldi temp,0x00			;��������� ���������� INT0 
		out MCUCR,temp		; �� ������� ������
		sei				;���������� ���������� ����������	
WAITSTART:				;��������
		sbic PIND,START		; �������
		rjmp WAITSTART		;  ������ START
LOOP:
		out PORTB,num		;��������� ��
		rcall DELAY			;��������
		ser temp			;����������
		out PORTB,temp		; �����������
		brts right			;�������, ���� ���� T ����������
		sbrs num,7			;������� ����. �������, ���� 0-� ������ 
						;num ����������
		set				;T=1
		sbrs num,7
		rjmp right
		rol num			;����� num ������ �� 1 ������ � ������ ����� C
		rol num
		rjmp LOOP			;������� � ��������� ���������� ������������
right:	sbrs num,3				;������� ����. �������, ���� 7-� ������ 
						;num ����������
		clt				;T=0
		
		

		ror num			;����� num ����� �� 1 ������ � ������ ����� C	
	    ror num
		rjmp LOOP			; ��� �������� ������� START

;***��������� ���������� �� ������ STOP***

STOP_PRESSED:
WAITSTART_2:				;��������
		sbic PIND,START		; �������
		rjmp WAITSTART_2	;  ������ START
		reti

;***�������� (��� ��������� �����)***

DELAY:
		ldi k1,8
d1:		ldi k2,255
d2:		ldi k3,254
d3:		nop
		dec k3
		brne d3
		nop
		dec k2
		brne d2
		dec k1
		brne d1
		ret
