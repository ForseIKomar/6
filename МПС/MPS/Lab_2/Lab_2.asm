;********************************************************************* 
;Программа 2.1 для поочерёдного переключения светодиодов (СД) 
;при нажатии на кнопку START (SW0).
;После нажатия на кнопку STOP (SW2) переключение прекращается и  
;возобновляется с места остановки при повторном нажатии ;на кнопку START. 
;Соединения: SW0-PD0, SW2-PD2, LED-PB 
;********************************************************************* 

;.include "8515def.inc"  	;файл определений для AT90S8515 
.include "m8515def.inc"  	;файл определений для ATmega8515 
.def temp = r16    			;временный регистр 
.def reg_led = r20   		;состояние регистра светодиодов 
.equ START = 0    			;0-ой вывод порта PD 
 
.org $000  					;***Векторы прерываний***  
rjmp INIT    				;обработка сброса  
rjmp STOP_PRESSED  			;обработка внешнего прерывания INT0(STOP)  
;***Инициализация МК*** 
INIT:  ldi reg_led,0xFE   
ldi temp,$5F  				;установка   
out SPL,temp  				; указателя стека   
ldi temp,$02  				; на последнюю   
out SPH,temp  				; ячейку ОЗУ   
sec    						;C=1   
set    						;T=1     
ser temp   					;инициализация выводов    
out DDRB,temp  				;порта PB на вывод   
out PORTB,temp  			;погасить СД   
clr temp   					;инициализация 0-ого и 2-ого выводов   
out DDRD,temp  				; порта PD на ввод   
ldi temp,0x05  				;включение 'подтягивающих'    
out PORTD,temp  			; резисторов порта PD   
ldi temp,(1<<INT0) 			;разрешение прерывания INT0   
out GICR,temp  				; (6 бит GICR или GIMSK)   
ldi temp,0x00  				;обработка прерывания INT0    
out MCUCR,temp  			; по низкому уровню   
sei    						;глобальное разрешение прерываний  
WAITSTART: sbic PIND,START  ; ожидание нажатия   
rjmp WAITSTART  			;  кнопки START LOOP:  
out PORTB,reg_led 			;включение СД
 

 
 rcall DELAY  				;задержка   
 ser temp   				;выключение   
 out PORTB,temp  			; светодиодов   
 brts LEFT   				;переход, если флаг T установлен   
 sbrs reg_led,0  			;пропуск следующей команды,       
 							; если 0-й разряд reg_led установлен   
 set    					;T=1   
 ror reg_led  				;сдвиг reg_led вправо на 1 разряд    
 rjmp LOOP    
 LEFT:  sbrs reg_led,7  	;пропуск следующей команды,        
 							;если 7-й разряд reg_led установлен   
 clt    					;T=0   
 rol reg_led  				;сдвиг reg_led влево на 1 разряд     
 rjmp LOOP    				;***Обработка прерывания от кнопки STOP*** 
 STOP_PRESSED: 
 WAITSTART_2:    			;ожидание   
 sbic PIND,START  			; нажатия   
 rjmp WAITSTART_2  			; кнопки START   
 reti 						;*** Задержка *** 
 DELAY: ldi r17,8 
 d1: ldi r18,255 
 d2: ldi r19,255 
 d3: dec r19   
 brne d3   
 dec r18   
 brne d2   
 dec r17   
 brne d1   
 ret 
