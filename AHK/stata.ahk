; UTF-8 with BOM

; --- sublime stata editor no admin --------------------------------------------------------------------
#IfWinActive ahk_exe sublime_text.exe
^Enter::
^r::
    WinGet, winid
    if WinExist("Do-file Editor - stata_temp.do") | WinExist("Do-file Editor - Untitled[0-9].do") {
        SendInput, ^c
        Sleep, 55
        stata_do() 
    }
    else {
        MsgBox, , Error, Do-File Editor with stata_temp or Untitled[0-9].do not found
    }
Return

stata_do() {
    WinActivate,
    Sleep, 55
    Send, {CtrlDown}{Sleep, 22}{a}{Sleep, 22}v{Sleep, 22}d{CtrlUp}{CtrlUp}{Ctrl}
    Sleep, 55
    WinActivate, ahk_exe sublime_text.exe
    WinActivate, ^Stata/SE 15.1
}

; --- Stata --------------------------------------------------------------------

#IfWinActive, ^Do-file Editor
    ; define some sane shortcuts for statas editor
    ^w::SendInput, !f{Sleep 33}c
    ^PgUp::SendInput, ^+{TAB}
    ^PgDn::SendInput, ^{TAB}

    LShift & WheelUp::SendInput, {HOME}
    LShift & WheelDown::SendInput, {END}
#IfWinActive

#IfWinActive, ^Data Editor
    ; changes Behaviour of Stata Browser scrollwheel
    +WheelDown::SendInput, +{Right}
    +WheelUp::SendInput, +{Left}

    ^+WheelDown::SendInput, +{Right 5}
    ^+WheelUp::SendInput, +{Left 5}

    ^WheelDown::SendInput, {WheelDown 5}
    ^WheelUp::SendInput, {WheelUp 5}

    ; changes Behaviour of Stata Browser arrows
    !Right::SendInput, {Right 5}
    +!Right::SendInput, +{Right 5}

    !Left::SendInput, {Left 5}
    +!Left::SendInput, +{Left 5}
#IfWinActive

; --- Stata Markdown --------------------------------------------------------------------
#IfWinActive, ^.stmd 
^+i::SendInput, ````````````{Left 3}{{}s{}}{Enter 2}{Up}
#IfWinActive
