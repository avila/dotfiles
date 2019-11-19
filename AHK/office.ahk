; UTF-8 with BOM

#IfWinActive ahk_exe WINWORD.EXE
; home end on word
XBUTTON1::SendInput,{Home}
XBUTTON2::SendInput,{End}

#IfWinActive, ahk_class  XLMAIN
    ; Horizon Scroll In Excel With Shift + Scroll Wheel
    LShift & WheelUp::ComObjActive("Excel.Application").ActiveWindow.SmallScroll(0,0,0,3)
    LShift & WheelDown::ComObjActive("Excel.Application").ActiveWindow.SmallScroll(0,0,3)

    ; Cycle Through Worksheet with Left ALt + Scroll Wheel
    LAlt & WheelUp::Send, ^{PgUp}
    LAlt & WheelDown::Send, ^{PgDn}

    NumpadDot::.

#If !WinActive("ahk_class AcrobatSDIWindow")
RButton & t::
    Sleep, 30
    SendInput, ^c{Sleep 30}                      ; sends cntrl x
    ClipWait                                     ; wait for clipboard to be populated
    Sleep, 30
    WinActivate, ahk_class MozillaWindowClass    ; activates firefox windows, if program already opened
    Sleep 30
    Send, ^t{sleep 30}
    SendInput, gt {Space} %clipboard%            ; do the magic
    SendInput, {Enter}
return 

#IfWinActive


~Numpad0 & NumpadDot::SendInput,.{left}{backspace}{right}       ; "0" + "," = "."
