#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; ------------------ Информация --------------------------------------------------------------------
; Окно программы должно быть строго:
; - в оконном режиме
; - в разрешении 800x600
; Нажимайте F9, чтобы завершить скрипт

; ------------------ Библиотеки --------------------------------------------------------------------
#Include <HotKey.au3>
#include <ImageSearch.au3>

; ------------------ Переменные --------------------------------------------------------------------
$titleG = '[CLASS:AcrobatSDIWindow]'			;
Global Const $VK_F12 = 0x7B						; Кнопка F12 - Выход
_HotKey_Assign($VK_F12, 'CloseScript')			; Вызов функции 'RunScript' по нажатию клавиши F10

$x = 0											; X - относительно рабочего стола
$y = 0											; Y - относительно рабочего стола

$w = 0											; Ширина окна игры
$h = 0											; Высота окна игры

$xf = 0											; Координаты найденых изображений
$yf = 0											;

$text = ''

$speed = 0


; ------------------ Тело программы ----------------------------------------------------------------
While 1

	State()
	Sleep(100)

WEnd

Func CloseScript()

	Exit

EndFunc

Func Error($text)

	MsgBox(4096+16, 'Внимание!', 'Ошибка скрипта.' & @CR & $text)
	CloseScript()

EndFunc

Func State()

	$stateW = WinGetState($titleG, "")

	If BitAND($stateW, 0) Then
		State()
	Else
		WinActivate($titleG)
		Sleep(500)
		RunScript()
	EndIf

EndFunc

Func RunScript()

	$p = 'img\'

	; Заполнить и подписать
	$img0 = _ImageSearch($p & '0.png',1,$xf,$yf,0)
	$img9 = _ImageSearch($p & '9.png',1,$xf,$yf,0)
	If ($img0 = 1) And ($img9 = 1) Then
		Error('Документ уже подписан.')
	ElseIf $img0 = 1 Then
		MouseClick("left", 392, 97, 2, $speed) ; Подогнать по ширине
		Sleep(500)
		MouseClick("left", $xf+10, $yf+10, 3, $speed)
		CheckP2()
	EndIf

	; Подпись с сертификатом
	$img2 = _ImageSearch($p & '2.png',1,$xf,$yf,0)
	If $img2 = 1 Then
		MouseClick("left", $xf, $yf, 3, $speed)
		Sleep(500)
		MouseClickDrag("left", 90, 170, 650, 405) ; Выбор области
		Sleep(1000)
		$aPos = WinGetPos('Выберите сертификат')
		MouseClick("left", $aPos[0]+100, $aPos[1]+100, 1, $speed)
		ControlClick('Выберите сертификат', '', '[CLASS:Button; INSTANCE:1]', "main", 1)
		Sleep(1000)
		ControlClick('Подписать документ', '', '[CLASS:Button; INSTANCE:9]', "main", 1)
		Sleep(1000)
		CheckG()
	EndIf

EndFunc

Func CheckP()

	$p = 'img\'

	$img9 = _ImageSearch($p & '9.png',1,$xf,$yf,0)

	If $img9 = 1 Then

		ProcessClose("Acrobat.exe")
		Sleep(500)

		$img6 = _ImageSearch($p & '6.png',1,$xf,$yf,1)
		If $img6 = 1 Then

			MouseClick("left", 215, 154, 1, $speed)
			Send("{DELETE}")
			Sleep(2000)
			MouseClick("left", 215, 154, 4, $speed)

		EndIf

	Else
		CheckP()
	EndIf

EndFunc

Func CheckG()

	$p = 'img\'

	; Выбрать папку Готово
	$img6 = _ImageSearch($p & '6.png',1,$xf,$yf,1)

	If $img6 = 1 Then
		MouseClick("left", $xf+0, $yf+3, 2, 5)
		Sleep(1000)
		ControlClick('Сохранить как', '', '[CLASS:Button; INSTANCE:1]', "main", 2)
		Sleep(500)
		CheckP()
	Else
		CheckG()
	EndIf

EndFunc

Func CheckP2()

	$p = 'img\'

	; Выбрать папку Готово
	$img1 = _ImageSearch($p & '1.png',1,$xf,$yf,0)

	If $img1 = 1 Then
		MouseClick("left", $xf+0, $yf+35, 2, $speed)
		Sleep(500)
	Else
		CheckP2()
	EndIf

EndFunc