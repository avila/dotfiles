browse.ahk
; UTF-8 with BOM

RButton::Send, {RButton} ; Important -> keey rbutton working


; /--- Right Click -------------------------------------------------------------

browse_this(keyword="") {
    if !WinExist("ahk_class MozillaWindowClass") {
        MsgBox, , Eita, Open Firefox first., 1000
    } else {
        Sleep, 10
        SendInput, ^c
        Sleep, 50
        WinActivate, ahk_class MozillaWindowClass    ; activates firefox windows, if program already opened
        Sleep, 50
        Send, ^t{sleep 30}^l{Sleep 30}
        SendInput, %keyword% %clipboard%                    ; do the magic
        SendInput, {Enter}
        Return
    }
}

RButton & s::browse_this("sp")
RButton & g::browse_this("g")
RButton & t::browse_this("gt")
RButton & v::browse_this("gt") ;TODO: update gitlab


; keyboard browse 
$^+Y::browse_this("g ")






#IfWinActive, ahk_exe firefox.exe
; google sites
Capslock & s::
    SendInput,{Home}site:{CtrlDown}{ShiftDown}{Right}{CtrlUp}{ShiftUp}{Del}{End}
return


#IfWinActive, Google Sheets
~Alt & 1::SendInput, ^{Tab}
~Alt & 2::SendInput, ^{Tab}
~Alt & 3::SendInput, ^{Tab}
~Alt & 4::SendInput, ^{Tab}
~Alt & 5::SendInput, ^{Tab}
~Alt & 6::SendInput, ^{Tab}
~Alt & 7::SendInput, ^{Tab}
~Alt & 8::SendInput, ^{Tab}
~Alt & 9::SendInput, ^{Tab}
~Alt & 0::SendInput, ^{Tab}

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

