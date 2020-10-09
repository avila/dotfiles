; UTF-8 with BOM

#s::get_stata_id()

; --- sublime stata editor no admin --------------------------------------------------------------------
#IfWinActive ahk_exe sublime_text.exe
!d::
^Enter::
    global call_type := "do"
    Content := Clip() ; will store any selected text in %Var%
    tempfile := A_Temp . "/st_tmp.do"
    file := FileOpen(tempfile, "w")
    file.Write(Content)
    file.Close()
    stata_do(call_type)
Return

!+r::
    global call_type := "run"
    Content := Clip() ; will store any selected text in %Var%
    tempfile := A_Temp . "/st_tmp.do"
    file := FileOpen(tempfile, "w")
    file.Write(Content)
    file.Close()
    stata_do(call_type)
Return

; sysuse auto
; --- stata functions  --------------------------------------------------------------------

stata_do(type="do") {
    global UniqueStataID
    global tempfile
    if WinExist("ahk_id" . UniqueStataID) {
        WinActivate,
        Sleep, 33
        SendInput, {CtrlDown}{Sleep, 22}{a}{Sleep, 22}{CtrlUp}{CtrlUp}
        SendInput, %type% %tempfile% {Enter}
        ; Sleep, 750
        ; WinActivate, ahk_exe sublime_text.exe
    }
    else {
        SplashTextOn , 500 , 100 , StataSend,  Window not opened.`rTrying to establish connection]
        Sleep, 0666
        SplashTextOff
        get_stata_id() 
    }
}

get_stata_id() {
    global UniqueStataID
    ; open stata if not running. if running gets id of window for sending code
    if UniqueStataID := WinExist("Stata/(IC|SE|MP)? 1[0-9]\.[0-9]") {
        ;pass (window exists)
    }
    else {
        ;MsgBox, , StataSend, Stata not opened. Opening new instance,    
        Run, R:\stata16\StataMP-64.exe, , Min, UniqueStataID
    }
    WinWait, ahk_id %UniqueStataID% 
    WinGetTitle, Title, ahk_id %UniqueStataID%
    SplashTextOn , 500 , 100 , StataSend,  Connecting with %Title% (ID: %UniqueStataID%)]
    Sleep, 0666
    SplashTextOff
    sleep, 300
    stata_do(call_type)
}


#IfWinActive
; --- Stata Editor --------------------------------------------------------------------

#IfWinActive, ^Do-file Editor
    ; define some sane shortcuts for statas editor
    ^w::SendInput, !f{Sleep 33}c
    ^PgUp::SendInput, ^+{TAB}
    ^PgDn::SendInput, ^{TAB}

    LShift & WheelUp::SendInput, {HOME}
    LShift & WheelDown::SendInput, {END}
#IfWinActive

; --- Stata Browse --------------------------------------------------------------------
#IfWinActive, ^Data Editor (Browse)*
    LShift & WheelUp::SendInput, +{Left 3}
    LShift & WheelDown::SendInput, +{Right 3}
    
    !WheelUp::SendInput, +{Left 5}
    !WheelDown::SendInput, +{Right 5}
    
    ; changes Behaviour of Stata Browser scrollwheel

    +WheelDown::SendInput, +{Right}
    +WheelUp::SendInput, +{Left}

    ^+WheelDown::SendInput, +{Right 5}
    ^+WheelUp::SendInput, +{Left 5}

    ^WheelDown::SendInput, {WheelDown 10}
    ^WheelUp::SendInput, {WheelUp 10}

    ; changes Behaviour of Stata Browser arrows
    !Right::SendInput, {Right 5}
    +!Right::SendInput, +{Right 5}

    !Left::SendInput, {Left 5}
    +!Left::SendInput, +{Left 5}

    !Down::SendInput, {Down 10}
    !Up::SendInput, {Up 10}

#IfWinActive

; --- Stata Markdown --------------------------------------------------------------------
#IfWinActive, ^.stmd 
^+i::SendInput, ````````````{Left 3}{{}s{}}{Enter 2}{Up}
#IfWinActive


; Clip() - Send and Retrieve Text Using the Clipboard
; by berban - updated February 18, 2019
; https://www.autohotkey.com/boards/viewtopic.php?f=6&t=62156
Clip(Text="", Reselect="") {
    Static BackUpClip, Stored, LastClip
    If (A_ThisLabel = A_ThisFunc) {
        If (Clipboard == LastClip)
            Clipboard := BackUpClip
        BackUpClip := LastClip := Stored := ""
    } Else {
        If !Stored {
            Stored := True
            BackUpClip := ClipboardAll ; ClipboardAll must be on its own line
        } Else
            SetTimer, %A_ThisFunc%, Off
        LongCopy := A_TickCount, Clipboard := "", LongCopy -= A_TickCount ; LongCopy gauges the amount of time it takes to empty the clipboard which can predict how long the subsequent clipwait will need
        If (Text = "") {
            SendInput, ^c
            ClipWait, LongCopy ? 0.6 : 0.2, True
        } Else {
            Clipboard := LastClip := Text
            ClipWait, 10
            SendInput, ^v
        }
        SetTimer, %A_ThisFunc%, -700
        Sleep 20 ; Short sleep in case Clip() is followed by more keystrokes such as {Enter}
        If (Text = "")
            Return LastClip := Clipboard
        Else If ReSelect and ((ReSelect = True) or (StrLen(Text) < 3000))
            SendInput, % "{Shift Down}{Left " StrLen(StrReplace(Text, "`r")) "}{Shift Up}"
    }
    Return
    Clip:
    Return Clip()
}