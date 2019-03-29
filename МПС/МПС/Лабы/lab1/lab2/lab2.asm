;************************************************************************
;*Программа для МК AT90S8515:
;*поочерёдное переключение светодиодов (СД) при нажатии на START,
;* после нажатия STOP переключение прекращается и начинается с места
;*  остановки при повторном нажатии на START
;************************************************************************
.include "8515def.inc"
.def num = r16			;число, соответствующее номеру включённого СД
.def k1 = r17					;k1,k2,k3 - параметры
.def k2 = r18					; цикла задержки
.def k3 = r19
.def temp = r20				;временный буфер
.equ START = 0				;0-ой вывод порта PD

;***Векторы прерываний***

	rjmp INIT			;обработка сброса
	rjmp STOP_PRESSED	;обработка внешнего прерывания INT0 - нажатие STOP			
;***Инициализация МК***

INIT:
		ldi num,0x7F

		ldi temp,$5F			;установка
		out SPL,temp			; указателя стека
		ldi temp,$02			; на последнюю
		out SPH,temp			; ячейку ОЗУ

		sec				;C=1
		set				;T=1		
		ser temp			;инициализация выводов 
		out DDRB,temp		; порта PB на вывод
		out PORTB,temp		;погасить СД
		clr temp			;инициализация 0-ого и 2-ого выводов
		out DDRD,temp		; порта PD на ввод
		ldi temp,0x05			;включение подтягивающих 
		out PORTD,temp		; резисторов порта PD

		ldi temp,0x7F			;разрешение
		out GIMSK,temp		; прерывания INT0
		ldi temp,0x00			;обработка прерывания INT0 
		out MCUCR,temp		; по низкому уровню
		sei				;глобальное разрешение прерываний	
WAITSTART:				;ожидание
		sbic PIND,START		; нажатия
		rjmp WAITSTART		;  кнопки START
LOOP:
		out PORTB,num		;включение СД
		rcall DELAY			;задержка
		ser temp			;выключение
		out PORTB,temp		; светодиодов
		brts right			;переход, если флаг T установлен
		sbrs num,7			;пропуск след. команды, если 0-й разряд 
						;num установлен
		set				;T=1
		sbrs num,7
		rjmp right
		rol num			;сдвиг num вправо на 1 разряд с учётом флага C
		rol num
		rjmp LOOP			;переход к обработке следующего переключения
right:	sbrs num,3				;пропуск след. команды, если 7-й разряд 
						;num установлен
		clt				;T=0
		
		

		ror num			;сдвиг num влево на 1 разряд с учётом флага C	
	    ror num
		rjmp LOOP			; для ожидания нажатия START

;***Обработка прерывания от кнопки STOP***

STOP_PRESSED:
WAITSTART_2:				;ожидание
		sbic PIND,START		; нажатия
		rjmp WAITSTART_2	;  кнопки START
		reti

;***Задержка (три вложенных цикла)***

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
