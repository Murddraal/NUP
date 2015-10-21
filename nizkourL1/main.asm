.386
.MODEL FLAT, STDCALL
OPTION CASEMAP: NONE
; ��������� ������� ������� (��������) ����������� ���������� EXTERN, ����� ����� @ ����������� ����� ����� ������������ ����������, 
																		;����� ��������� ����������� ��� �������� ������� � ���������
EXTERN  GetStdHandle@4: PROC
EXTERN  WriteConsoleA@20: PROC
EXTERN  CharToOemA@8: PROC
EXTERN  ReadConsoleA@20: PROC
EXTERN  ExitProcess@4: PROC; ������� ������ �� ���������
EXTERN  lstrlenA@4: PROC; ������� ����������� ����� ������

.DATA; ������� ������
STRN1 DB "������� ������: ",0; ��������� ������, � ����� ��������� ����������� �������: 13 � ������� �������, 10 � ������� �� �����  ������, 
																	;0 � ����� ������; � �������������� ��������� DB  ������������� ������ ������
STRN2 DB "������ �� ���������",0
STRN3 DB "������ ���������",0

DIN DD ?; ���������� �����; ��������� DD ����������� ������ ������� 32 ���� (4 �����), ���� �?� ������������ ��� �������������������� ������
DOUT DD ?; ���������� ������
BUF  DB 200 dup (?); ����� ��� ��������/��������� ����� ������ 200 ������
INVERT  DB 200 dup (?)
LENS DD ?; ���������� ��� ���������� ���������� ��������
ETH DD 8
TEN DD 10
FLAG DD 0
FLAG2 DD 0
TEMP1 DD ?
TEMP2 DD ?
.CODE; ������� ���� 

MAIN PROC; 

;____________________����� ������ ����������� ��� ����� ������� �����__________________________________________________

MOV  EAX, OFFSET STRN1;	�������� MOV  �������� ������� ��������  ������������ � ������, OFFSET � ��������, ������������ �����
PUSH EAX; ��������� ������� ���������� � ���� �������� PUSH
PUSH EAX

CALL CharToOemA@8; ����� ������� ������� ���������� ����� 
PUSH -10
CALL GetStdHandle@4
MOV DIN, EAX 	; ����������� ��������� �� �������� EAX  � ������ ������ � ������ DIN ������� ���������� ������
PUSH -11
CALL GetStdHandle@4
MOV DOUT, EAX  ; ��������� ����� ������ STRN
PUSH OFFSET STRN1; � ���� ���������� ����� ������
CALL lstrlenA@4; ����� � EAX ����� ������� WriteConsoleA ��� ������ ������ STRN
PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS; 4-� ��������
PUSH EAX; 3-� ��������
PUSH OFFSET STRN1; 2-� ��������
PUSH DOUT; 1-� ��������
CALL WriteConsoleA@20; ���� ������

;_______________________���� ������____________________________________________________________

PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS; 4-� ��������
PUSH 200; 3-� ��������
PUSH OFFSET BUF; 2-� ��������
PUSH DIN; 1-� ��������
CALL ReadConsoleA@20 

;________________________�������������� ������_____________________________________________________
SUB LENS, 2
MOV ECX, LENS
MOV ESI, OFFSET BUF

TOSTACK:
	PUSH [ESI]
	INC ESI
LOOP TOSTACK 

MOV ESI, OFFSET INVERT
MOV ECX, LENS
FROMSTACK:
	POP [ESI]
	INC ESI
LOOP  FROMSTACK
;_____����� ��������������� ������___

MOV  EAX, OFFSET INVERT;	�������� MOV  �������� ������� ��������  ������������ � ������, OFFSET � ��������, ������������ �����
PUSH EAX; ��������� ������� ���������� � ���� �������� PUSH
PUSH EAX

CALL CharToOemA@8; ����� ������� ������� ���������� ����� 


PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS; 4-� ��������
PUSH LENS; 3-� ��������
PUSH OFFSET INVERT; 2-� ��������
PUSH DOUT; 1-� ��������
CALL WriteConsoleA@20; ���� ������
;_______________________��������� �����_________________
CLD
MOV ECX, LENS
REPE CMPS BUF, INVERT
CMP ECX, 0
JE NOCHANGES
CMP ECX, 0
JNE CHANGES


NOCHANGES:
MOV  EAX, OFFSET STRN3;	�������� MOV  �������� ������� ��������  ������������ � ������, OFFSET � ��������, ������������ �����
PUSH EAX; ��������� ������� ���������� � ���� �������� PUSH
PUSH EAX

CALL CharToOemA@8; ����� ������� ������� ���������� ����� 
PUSH -10
CALL GetStdHandle@4
MOV DIN, EAX 	; ����������� ��������� �� �������� EAX  � ������ ������ � ������ DIN ������� ���������� ������
PUSH -11
CALL GetStdHandle@4
MOV DOUT, EAX  ; ��������� ����� ������ STRN
PUSH OFFSET STRN3; � ���� ���������� ����� ������
CALL lstrlenA@4; ����� � EAX ����� ������� WriteConsoleA ��� ������ ������ STRN
PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS; 4-� ��������
PUSH EAX; 3-� ��������
PUSH OFFSET STRN3; 2-� ��������
PUSH DOUT; 1-� ��������
CALL WriteConsoleA@20; ���� ������

JMP PAUS

CHANGES:
MOV  EAX, OFFSET STRN2;	�������� MOV  �������� ������� ��������  ������������ � ������, OFFSET � ��������, ������������ �����
PUSH EAX; ��������� ������� ���������� � ���� �������� PUSH
PUSH EAX

CALL CharToOemA@8; ����� ������� ������� ���������� ����� 
PUSH -10
CALL GetStdHandle@4
MOV DIN, EAX 	; ����������� ��������� �� �������� EAX  � ������ ������ � ������ DIN ������� ���������� ������
PUSH -11
CALL GetStdHandle@4
MOV DOUT, EAX  ; ��������� ����� ������ STRN
PUSH OFFSET STRN2; � ���� ���������� ����� ������
CALL lstrlenA@4; ����� � EAX ����� ������� WriteConsoleA ��� ������ ������ STRN
PUSH 0; � ���� ���������� 5-� ��������
PUSH OFFSET LENS; 4-� ��������
PUSH EAX; 3-� ��������
PUSH OFFSET STRN2; 2-� ��������
PUSH DOUT; 1-� ��������
CALL WriteConsoleA@20; ���� ������




PAUS:
;_______________________________�����_________________________________

	PUSH 0; � ���� ���������� 5-� ��������
	PUSH OFFSET LENS; 4-� ��������
	PUSH 200; 3-� ��������
	PUSH OFFSET BUF; 2-� ��������
	PUSH DIN; 1-� ��������
	CALL ReadConsoleA@20 ; 

	PUSH 0; ��������: ��� ������
	CALL ExitProcess@4
MAIN ENDP; ���������� �������� ��������� � ������ MAIN
END MAIN; ���������� �������� ������ � ��������� ������ ����������� ���������
