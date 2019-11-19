; UTF-8 with BOM

; --- Stata --------------------------------------------------------------------

StataWindow := "ahk_class Afx:0000000140000000:0:0000000000000000:0000000000000000:0000000003970829" 

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

#IfWinActive, ^.stmd 
^+i::SendInput, ````````````{Left 3}{{}s{}}{Enter 2}{Up}

#IfWinActive
