
#IfWinActive,    Untitled 1 - LibreOffice Calc
    ; Horizon Scroll In Excel With Shift + Scroll Wheel
    Numpad1::
    	Sleep, 30
    	SendInput, ^c
    	ClipWait
    	Sleep, 130
    	WinActivate, generations.csv
    	Sleep, 130
    	SendInput, ^f
    	Sleep, 230
    	SendInput, ^v
    	SendInput, {Enter}
    	SendInput, {Esc}
    	SendInput, {Esc}
    	Sleep, 130
    	SendInput, !y
    	SendInput, {AltUp}
    	Sleep, 30
    	SendInput, 2
    	Sleep, 30
    	
    	SendInput, {Down}
    return

#IfWinActive,    generations.csv
    Numpad2::
    	Sleep, 30
    	SendInput, ^c
    	ClipWait
    	Sleep, 30
    	WinActivate, Untitled 1 - LibreOffice Calc
    	SendInput, {Right 3}
    	SendInput, ^v
    	Sleep, 30
    	SendInput, {Enter 1}
    	SendInput, {Down}{Left 3}
    return

#IfWinActive

Numpad8::SendInput, fre psample if inrange(^v{Backspace}, 0, 999)