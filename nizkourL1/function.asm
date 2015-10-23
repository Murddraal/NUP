.386
.MODEL FLAT, STDCALL
OPTION CASEMAP: NONE
; прототипы внешних функций (процедур) описываются директивой EXTERN, после знака @ указывается общая длина передаваемых параметров, 
																		;после двоеточия указывается тип внешнего объекта – процедура
EXTERN  GetStdHandle@4: PROC
EXTERN  WriteConsoleA@20: PROC
EXTERN  CharToOemA@8: PROC
EXTERN  ReadConsoleA@20: PROC
EXTERN  ExitProcess@4: PROC; функция выхода из программы
EXTERN  lstrlenA@4: PROC; функция определения длины строки

.DATA; сегмент данных
STRN1 DB "Введите строку: ",0; выводимая строка, в конце добавлены управляющие символы: 13 – возврат каретки, 10 – переход на новую  строку, 
																	;0 – конец строки; с использованием директивы DB  резервируется массив байтов
STRN2 DB "Строки не совпадают",0
STRN3 DB "Строки совпадают",0

DIN DD ?; дескриптор ввода; директива DD резервирует память объемом 32 бита (4 байта), знак «?» используется для неинициализированных данных
DOUT DD ?; дескриптор вывода
BUF  DB 200 dup (?); буфер для вводимых/выводимых строк длиной 200 байтов
INVERT  DB 200 dup (?)
LGT_M DD ?; переменная для количества выведенных символов
LGT_L DD ?
ETH DD 8
TEN DD 10
FLAG DD 0
FLAG2 DD 0
TEMP1 DD ?
TEMP2 DD ?
.CODE; сегмент кода 

MAIN PROC; 

;____________________Вывод строки приглашения для ввода первого числа__________________________________________________

MOV  EAX, OFFSET STRN1;	командой MOV  значение второго операнда  перемещается в первый, OFFSET – операция, возвращающая адрес
PUSH EAX; параметры функции помещаются в стек командой PUSH
PUSH EAX

CALL CharToOemA@8; вызов функции получим дескриптор ввода 
PUSH -10
CALL GetStdHandle@4
MOV DIN, EAX 	; переместить результат из регистра EAX  в ячейку памяти с именем DIN получим дескриптор вывода
PUSH -11
CALL GetStdHandle@4
MOV DOUT, EAX  ; определим длину строки STRN
PUSH OFFSET STRN1; в стек помещается адрес строки
CALL lstrlenA@4; длина в EAX вызов функции WriteConsoleA для вывода строки STRN
PUSH 0; в стек помещается 5-й параметр
PUSH OFFSET LGT_M; 4-й параметр
PUSH EAX; 3-й параметр
PUSH OFFSET STRN1; 2-й параметр
PUSH DOUT; 1-й параметр
CALL WriteConsoleA@20; ввод строки

;_______________________Ввод строки____________________________________________________________

PUSH 0; в стек помещается 5-й параметр
PUSH OFFSET LGT_M; 4-й параметр
PUSH 200; 3-й параметр
PUSH OFFSET BUF; 2-й параметр
PUSH DIN; 1-й параметр
CALL ReadConsoleA@20 

;________________________Инвертирование строки_____________________________________________________
MOV ESI, LGT_M
MOV LGT_L, ESI

SUB LGT_L, 2
MOV ECX, LGT_L
MOV ESI, OFFSET BUF
ADD ESI, LGT_L
SUB ESI, 1
MOV EDI, OFFSET INVERT
INVERTISE:
	MOV BL, [ESI]
	MOV [EDI], BL
	DEC ESI
	INC EDI
LOOP INVERTISE
MOV BL, 13
MOV [EDI], BL
INC EDI
MOV BL, 10
MOV [EDI], BL

;_____________________Вывод инвертированной строки__________________

MOV  EAX, OFFSET INVERT;	командой MOV  значение второго операнда  перемещается в первый, OFFSET – операция, возвращающая адрес
PUSH EAX; параметры функции помещаются в стек командой PUSH
PUSH EAX

CALL CharToOemA@8; вызов функции получим дескриптор ввода 


PUSH 0; в стек помещается 5-й параметр
PUSH OFFSET LGT_M; 4-й параметр
PUSH LGT_M; 3-й параметр
PUSH OFFSET INVERT; 2-й параметр
PUSH DOUT; 1-й параметр
CALL WriteConsoleA@20; ввод строки
;_______________________Сравнение строк_________________
CLD
MOV ECX, LGT_L
MOV ESI, OFFSET BUF
MOV EDI, OFFSET INVERT
REPE CMPS BUF, INVERT
CMP ECX, 0
JE NOCHANGES
CMP ECX, 0
JNE CHANGES


NOCHANGES:
MOV  EAX, OFFSET STRN3;	командой MOV  значение второго операнда  перемещается в первый, OFFSET – операция, возвращающая адрес
PUSH EAX; параметры функции помещаются в стек командой PUSH
PUSH EAX

CALL CharToOemA@8; вызов функции получим дескриптор ввода 
PUSH -10
CALL GetStdHandle@4
MOV DIN, EAX 	; переместить результат из регистра EAX  в ячейку памяти с именем DIN получим дескриптор вывода
PUSH -11
CALL GetStdHandle@4
MOV DOUT, EAX  ; определим длину строки STRN
PUSH OFFSET STRN3; в стек помещается адрес строки
CALL lstrlenA@4; длина в EAX вызов функции WriteConsoleA для вывода строки STRN
PUSH 0; в стек помещается 5-й параметр
PUSH OFFSET LGT_L; 4-й параметр
PUSH EAX; 3-й параметр
PUSH OFFSET STRN3; 2-й параметр
PUSH DOUT; 1-й параметр
CALL WriteConsoleA@20; ввод строки

JMP PAUS

CHANGES:
MOV  EAX, OFFSET STRN2;	командой MOV  значение второго операнда  перемещается в первый, OFFSET – операция, возвращающая адрес
PUSH EAX; параметры функции помещаются в стек командой PUSH
PUSH EAX

CALL CharToOemA@8; вызов функции получим дескриптор ввода 
PUSH -10
CALL GetStdHandle@4
MOV DIN, EAX 	; переместить результат из регистра EAX  в ячейку памяти с именем DIN получим дескриптор вывода
PUSH -11
CALL GetStdHandle@4
MOV DOUT, EAX  ; определим длину строки STRN
PUSH OFFSET STRN2; в стек помещается адрес строки
CALL lstrlenA@4; длина в EAX вызов функции WriteConsoleA для вывода строки STRN
PUSH 0; в стек помещается 5-й параметр
PUSH OFFSET LGT_L; 4-й параметр
PUSH EAX; 3-й параметр
PUSH OFFSET STRN2; 2-й параметр
PUSH DOUT; 1-й параметр
CALL WriteConsoleA@20; ввод строки




PAUS:
;_______________________________Пауза_________________________________

	PUSH 0; в стек помещается 5-й параметр
	PUSH OFFSET LGT_L; 4-й параметр
	PUSH 200; 3-й параметр
	PUSH OFFSET BUF; 2-й параметр
	PUSH DIN; 1-й параметр
	CALL ReadConsoleA@20 ; 

	PUSH 0; параметр: код выхода
	CALL ExitProcess@4
MAIN ENDP; завершение описания процедуры с именем MAIN
END MAIN; завершение описания модуля с указанием первой выполняемой процедуры
