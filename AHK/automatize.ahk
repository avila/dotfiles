
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

#IfWinActive ahk_exe sublime_text.exe
    Numpad1::
        SendInput, ^d
        SendInput, ^c
        if WinExist("ahk_id" . UniqueStataID) {
            WinActivate,
            ;MsgBox, , Title, %Command%, 
            Sleep, 99
            SendInput, {CtrlDown}{Sleep, 22}{a}{Sleep, 22}{CtrlUp}{CtrlUp}
            SendInput, desc {Space}
            Sleep, 99
            SendInput, ^v
            Sleep, 99
            SendInput, {Up}{End}{Delete}{Space}{Up}{End}{Delete}{Space}{Up}{End}{Delete}{Space}{Up}{End}{Delete}{Space}{Up}{End}{Delete}{Space}{Up}{End}{Delete}{Space}{Up}{End}{Delete}{Space}{Up}{End}{Delete}{Space}{Up}{End}{Delete}{Space}{Enter}
            Sleep, 99
            ;WinActivate, ahk_exe sublime_text.exe
            ;SendInput, {Ctrl Up}
            WinActivate, ahk_exe sublime_text.exe
        }
        else {
            MsgBox, , StataSend, Failed to find Stata's ID`, try again !, 3
        }
    Return


#IfWinActive