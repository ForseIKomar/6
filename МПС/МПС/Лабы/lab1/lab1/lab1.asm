
.include "8515def.inc"
.def num = r16			;число, соответствующее номеру включённого СД
.def k1 = r17				;k1,k2,k3 - параметры
.def k2 = r18				; цикла задержки
.def k3 = r19
.def temp = r20			;временный буфер
.equ START = 0			;0-ой вывод порта PD
.equ STOP = 1			;1-ый вывод порта PD

;***Инициализация***

		ldi num,0x7F		;разряд, соответствующий 1-ому СД сброшен
					;СД будет светиться
		sec			;C=1
		set			;T=1
		ser temp		;инициализация выводов 
		out DDRB,temp	; порта PB на вывод
		out PORTB,temp	;погасить СД
		clr temp		;инициализация 0-ого и 1-ого выводов
		out DDRD,temp	; порта PD на ввод
		ldi temp,0x03		;включение подтягивающих 
		out PORTD,temp	; резисторов порта PD	
WAITSTART:			;ожидание
		sbic PIND,START	; нажатия
		rjmp WAITSTART	;  кнопки START
WAITSTOP:
		out PORTB,num	;включение СД
		
;***Задержка***

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
		ser temp		;выключение
		out PORTB,temp	; светодиодов
		brts right		;переход, если флаг T установлен
    	sbrs num,7		;пропуск след. команды, 
					;если 0-й разряд num установлен
		set			;T=1
		sbrs num,7
		rjmp right
		brts CHECK
left:	rol num		;сдвиг num вправо на 1 разряд с учётом флага C
		rol num
		rjmp CHECK		;переход на проверку нажатия STOP
right:	sbrs num,1		;пропуск след. команды, если 7-й разряд 
					;num установлен
		clt			;T=0
		sbrs num,1
		rjmp left
		brtc CHECK
		ror num		;сдвиг num влево на 1 разряд с учётом флага C
		ror num
CHECK:
		sbic PIND,STOP	;если нажата 
		rjmp WAITSTOP	;кнопка STOP, то переход
		rjmp WAITSTART	;для ожидания нажатия START
