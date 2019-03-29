
.include "8515def.inc"
.def num = r16			;�����, ��������������� ������ ����������� ��
.def k1 = r17				;k1,k2,k3 - ���������
.def k2 = r18				; ����� ��������
.def k3 = r19
.def temp = r20			;��������� �����
.equ START = 0			;0-�� ����� ����� PD
.equ STOP = 1			;1-�� ����� ����� PD

;***�������������***

		ldi num,0x7F		;������, ��������������� 1-��� �� �������
					;�� ����� ���������
		sec			;C=1
		set			;T=1
		ser temp		;������������� ������� 
		out DDRB,temp	; ����� PB �� �����
		out PORTB,temp	;�������� ��
		clr temp		;������������� 0-��� � 1-��� �������
		out DDRD,temp	; ����� PD �� ����
		ldi temp,0x03		;��������� ������������� 
		out PORTD,temp	; ���������� ����� PD	
WAITSTART:			;��������
		sbic PIND,START	; �������
		rjmp WAITSTART	;  ������ START
WAITSTOP:
		out PORTB,num	;��������� ��
		
;***��������***

		ldi k1,8
d1:		ldi k2,254
d2:		ldi k3,254
d3:		nop
		dec k3
		brne d3
		nop
		dec k2
		brne d2
		dec k1
		brne d1		
		;**************
		ser temp		;����������
		out PORTB,temp	; �����������
		brts right		;�������, ���� ���� T ����������
    	sbrs num,7		;������� ����. �������, 
					;���� 0-� ������ num ����������
		set			;T=1
		sbrs num,7
		rjmp right
		brts CHECK
left:	rol num		;����� num ������ �� 1 ������ � ������ ����� C
		rol num
		rjmp CHECK		;������� �� �������� ������� STOP
right:	sbrs num,1		;������� ����. �������, ���� 7-� ������ 
					;num ����������
		clt			;T=0
		sbrs num,1
		rjmp left
		brtc CHECK
		ror num		;����� num ����� �� 1 ������ � ������ ����� C
		ror num
CHECK:
		sbic PIND,STOP	;���� ������ 
		rjmp WAITSTOP	;������ STOP, �� �������
		rjmp WAITSTART	;��� �������� ������� START
