;#AutoIt3Wrapper_Run_Debug_Mode=y
#include <Misc.au3>

; Press Esc to terminate script, Pause/Break to "pause"

HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")

Global $active = False
Global $held = False
Global $lastHeldKeyPressed = "none"

Global $paused = False

; order matters
Global $keys = [ _
	"a", _
	"x", _
	"b", _
	"y", _
	"ltrigger", _
	"lbumper", _
	"rtrigger", _
	"rbumper", _
	"select", _
	"start", _
	"downleft", _
	"downright", _
	"upleft", _
	"upright", _
	"down", _
	"left", _
	"right", _
	"up" _
]

Local $keyMap[]

Func LoadKeyMap()
	$preloadedConfig = False
	For $key in $keys
		$x = IniRead(@ScriptDir & "\config.ini", $key, "x", "none")
		$y = IniRead(@ScriptDir & "\config.ini", $key, "y", "none")
		If ($x = "none" Or $y = "none") Then

			$msg = MsgBox(1,"Setup", "Move mouse to " & $key & " and then press enter")
			If ($msg = 2) Then
				Return
			EndIf

			$x = MouseGetPos(0)
			$y = MouseGetPos(1)
			IniWrite(@ScriptDir & "\config.ini", $key, "x", $x)
			IniWrite(@ScriptDir & "\config.ini", $key, "y", $y)
		Else
			$preloadedConfig = True
		EndIf
		Local $map[]
		$map["x"] = $x
		$map["y"] = $y
		$keyMap[$key] = $map
	Next

	If $preloadedConfig Then
		$msg = MsgBox(3, "Setup", "Your button locations are configured. Do you want to reconfigure your button locations?")
		If $msg = 6 Then ; yes
			For $key in $keys
				IniWrite(@ScriptDir & "\config.ini", $key, "x", "none")
				IniWrite(@ScriptDir & "\config.ini", $key, "y", "none")
			Next
			LoadKeyMap()
			Return
		ElseIf $msg = 7 Then ; no
			; do nothing, it's running now
		ElseIf $msg = 2 Then ; cancel
			Exit
		EndIf

	EndIf
EndFunc


Func TogglePause()
	$paused = Not $paused
	If $paused Then
		DisableHotKeys()
	Else
		EnableHotKeys()
	EndIf

	While $paused
		Sleep(100)
		ToolTip('Program is "Paused"', 0, 0)
	WEnd
	ToolTip("")
EndFunc

Func Terminate()
	Exit
EndFunc

Func EnableHotKeys()
	; keyboard 's' maps to the controller 'down' button, and so on
	HotKeySet("s", "HotKeyPressed") ; down		44
	HotKeySet("d", "HotKeyPressed") ; left		53
	HotKeySet("f", "HotKeyPressed") ; right		46
	HotKeySet("e", "HotKeyPressed") ; up		45
	HotKeySet("k", "HotKeyPressed") ; a			4B
	HotKeySet("j", "HotKeyPressed") ; x			4A
	HotKeySet("l", "HotKeyPressed") ; b			4C
	HotKeySet("i", "HotKeyPressed") ; y			49
	HotKeySet("w", "HotKeyPressed") ; LTrigger	57
	HotKeySet("r", "HotKeyPressed") ; LBumper	52
	HotKeySet("o", "HotKeyPressed") ; RTrigger	4F
	HotKeySet("u", "HotKeyPressed") ; RBumper	55
	HotKeySet("g", "HotKeyPressed") ; Select	47
	HotKeySet("h", "HotKeyPressed") ; Start		48
EndFunc

Func DisableHotKeys()
	HotKeySet("s")
	HotKeySet("d")
	HotKeySet("f")
	HotKeySet("e")
	HotKeySet("k")
	HotKeySet("j")
	HotKeySet("l")
	HotKeySet("i")
	HotKeySet("w")
	HotKeySet("r")
	HotKeySet("o")
	HotKeySet("u")
	HotKeySet("g")
	HotKeySet("h")
EndFunc

Func IsKeyPressed($key)
	$result = False
	Switch $key
		Case "down"
			$result = _IsPressed("44")
		Case "left"
			$result = _IsPressed("53")
		Case "right"
			$result = _IsPressed("46")
		Case "up"
			$result = _IsPressed("45")
		Case "downleft"
			$result = _IsPressed("44") And _IsPressed("53")
		Case "downright"
			$result = _IsPressed("44") And _IsPressed("46")
		Case "upleft"
			$result = _IsPressed("45") And _IsPressed("53")
		Case "upright"
			$result = _IsPressed("45") And _IsPressed("46")
		Case "a"
			$result = _IsPressed("4B")
		Case "x"
			$result = _IsPressed("4A")
		Case "b"
			$result = _IsPressed("4C")
		Case "y"
			$result = _IsPressed("49")
		Case "ltrigger"
			$result = _IsPressed("57")
		Case "lbumper"
			$result = _IsPressed("52")
		Case "rtrigger"
			$result = _IsPressed("4F")
		Case "rbumper"
			$result = _IsPressed("55")
		Case "select"
			$result = _IsPressed("47")
		Case "start"
			$result = _IsPressed("48")
	EndSwitch
	return $result
EndFunc

Func KeyIsDirectional($key)
	Return StringInStr($key, "up") Or StringInStr($key, "down") Or StringInStr($key, "left") Or StringInStr($key, "right")
EndFunc

Func MousePressKey($key)
	; If last key pressed is the same as key pressed, then continue holding key down
	If ($key = $lastHeldKeyPressed) Then
		Return
	EndIf

	ConsoleWrite("Pressed " & $key & @CRLF)

	$newDirectionalClicked = KeyIsDirectional($key) And KeyIsDirectional($lastHeldKeyPressed)

	; Stop holding down mouse unless key and last key pressed are both directional
	If Not $newDirectionalClicked Then
		ConsoleWrite("Mouse Unclicked - new key pressed" & @CRLF)
		MouseUp("primary")
	EndIf

	; Move mouse to new key
	ConsoleWrite("MouseMove to " & $key & " at [" & $keyMap[$key].x & "," & $keyMap[$key].y & "]" & @CRLF)
	MouseMove($keyMap[$key].x, $keyMap[$key].y, 0)

	; begin holding down mouse unless key and last key pressed are both directional
	If Not $newDirectionalClicked Then
		ConsoleWrite("Mouse Clicked" & @CRLF)
		MouseDown("primary")
	EndIf

	$lastHeldKeyPressed = $key
EndFunc

Func HotKeyPressed()
	If ($active) Then
		return ; already running
	EndIf
	$active = True

	Do
		$held = False
		; order matters
		; check for non directional presses
		; check for dual directional presses
		; check for single direcitonal presses
		For $key In $keys
			If IsKeyPressed($key) Then
				MousePressKey($key)
				$held = True
				ExitLoop
			EndIf
		Next

		If $held = False Then
			ConsoleWrite("Mouse Unclicked - no keys pressed" & @CRLF & @CRLF)
			MouseUp("primary")
		EndIf

		Sleep(10)
	Until $held = False

	$active = False
	$lastHeldKeyPressed = "none"

EndFunc

; Start of script

LoadKeyMap()
EnableHotKeys()

While 1
	Sleep(100)
WEnd