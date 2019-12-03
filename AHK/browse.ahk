; UTF-8 with BOM
; Description: The browse functions make usage of firefox (or chrome) keyword search, 
;   where the user can set a character or word to perform the required search
;   Its possible to define everythin in AHK, though.
; -----------------------------------------------------------------------------------
~RButton & s::browse_this("sp")
~RButton & g::browse_this("g")
~RButton & t::browse_this("gt")
~RButton & v::browse_this("gt") ;TODO: update gitlab


; define browse function
browse_this(keyword="") {
    if !WinExist("ahk_class MozillaWindowClass") {
        MsgBox, , Eita, Open Firefox first., 1000
    } else {
        Sleep, 30
        SendInput, ^c
        Sleep, 50
        WinActivate, ahk_class MozillaWindowClass
        Sleep, 50
        SendInput, ^t{sleep 30}^l{Sleep 30}
        SendInput, %keyword% %clipboard%
        Sleep, 30
        SendInput, {Enter}
        Return
    }
}

;RButton::SendInput, {RButton} ; Important -> send RButton if pressed alone



; keyboard browse 
$^+Y::browse_this("g ")



#IfWinActive, ahk_exe firefox.exe
; google sites
Capslock & s::
    ; searches inside the current website.
    SendInput,{Home}site:{CtrlDown}{ShiftDown}{Right}{CtrlUp}{ShiftUp}{Del}{End}
return


#IfWinActive, .*Google Sheets.*
LAlt & 1::SendInput, ^{Tab}
LAlt & 2::SendInput, ^{Tab}
LAlt & 3::SendInput, ^{Tab}
LAlt & 4::SendInput, ^{Tab}
LAlt & 5::SendInput, ^{Tab}
LAlt & 6::SendInput, ^{Tab}
LAlt & 7::SendInput, ^{Tab}
LAlt & 8::SendInput, ^{Tab}
LAlt & 9::SendInput, ^{Tab}
LAlt & 0::SendInput, ^{Tab}
#IfWinActive

#IfWinActive ahk_exe firefox.exe
LAlt & 1::SendInput, ^1
LAlt & 2::SendInput, ^2
LAlt & 3::SendInput, ^3
LAlt & 4::SendInput, ^4
LAlt & 5::SendInput, ^5
LAlt & 6::SendInput, ^6
LAlt & 7::SendInput, ^7
LAlt & 8::SendInput, ^8
LAlt & 9::SendInput, ^9
LAlt & 0::SendInput, ^0
;~Alt & sc029::SendInput, ^{Tab}

