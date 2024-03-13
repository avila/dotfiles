; UTF-8 with BOM


 ; run stata or regain connection with stata ID
#s::get_stata_id() ;#a ä

; --- sublime stata editor no admin --------------------------------------------------------------------
#IfWinActive ahk_exe sublime_text.exe
!d::
^Enter::

    ; copy selected content to a temp file 
    global call_type := "do"
    write_clip_to_temp_file()

    ; if stata not opened or connection not made yet (UniqueStataID undefined)->get id
    if not WinExist("Stata/(IC|SE|MP)? 1[0-9]\.[0-9]") or (!UniqueStataID) {
        get_stata_id()
    }

    ; call stata_do function
    stata_do(call_type)
Return

!+r::
^+Enter::
    ; run == quietly do
    global call_type := "run"
    Content := Clip() ; will store any selected text in %Var%
    tempfile := A_Temp . "\st_tmp" . %counter% . ".do"
    write_clip_to_temp_file()

    ; if stata not opened or connection not made yet (UniqueStataID undefined)->get id
    if not WinExist("Stata/(IC|SE|MP)? 1[0-9]\.[0-9]") or (!UniqueStataID) {
        get_stata_id()
    }

    stata_do(call_type)
Return


global counter := 0
; sysuse auto
; --- stata functions  --------------------------------------------------------------------
write_clip_to_temp_file() {
    global tempfile
    
    counter++

    Content := Clip() ; will store any selected text in %Var%
    tempfile := A_Temp  "\st_tmp_"  Format("{:04}", counter) ".do"
    file := FileOpen(tempfile, "w", "utf-8-raw") ; ä
    file.Write(Content)
    file.Close()
}

stata_do(call_type="do") {
    global UniqueStataID
    global tempfile
    global counter
    if WinExist("ahk_id" . UniqueStataID) {
        WinActivate,
        WinWaitActive, Stata,, 3
        if ErrorLevel {
            MsgBox, WinWait timed out, Probably Stata is busy. Try Again :)
            return
        }
        Sleep, 99
        SendInput, {CtrlDown}{Sleep, 22}{a}{Sleep, 22}{CtrlUp}{CtrlUp}
        SendInput, %call_type% %tempfile% {Enter}
        Sleep, 99
        WinActivate, ahk_exe sublime_text.exe
        SendInput, {Ctrl Up}
    }
    else {
        MsgBox, , StataSend, Failed to find Stata's ID`, try again !, 3
    }
}

get_stata_id() {
    global UniqueStataID
    MsgBox, , StataSend, Trying to stablish connection with Stata's Windows, 3
    ; open stata if not running. if running gets id of window for sending code
    if UniqueStataID := WinExist("Stata/(IC|SE|MP)? 1[0-9]\.[0-9]") {
        MsgBox, , StataSend, Stata connected! (hopefully)
    }
    else {
        MsgBox, , StataSend, Stata not opened. Opening new instance on "R:\stata17\StataMP-64.exe",
        
        Run, R:\stata17\StataMP-64.exe, , Min, UniqueStataID       
        
        WinWait, "Stata/(IC|SE|MP)? 1[0-9]\.[0-9]", , 4
        if UniqueStataID := WinExist("Stata/(IC|SE|MP)? 1[0-9]\.[0-9]") {
            MsgBox, , StataSend, Stata connected! (hopefully)
        }

    }
    ;UniqueStataID
    ;WinGet, UniqueStataID, ID , "Stata/(IC|SE|MP)? 1[0-9]\.[0-9]"
    /*
    WinWait, ahk_id %UniqueStataID%,,2
    WinGetTitle, Title, ahk_id %UniqueStataID%
    SplashTextOn , 500 , 100 , StataSend,  Connecting with %Title% (ID: %UniqueStataID%)]
    Sleep, 0666
    SplashTextOff 
    */

}


stata_call(Command) { 
    global UniqueStataID

    if WinExist("ahk_id" . UniqueStataID) {
        WinActivate,
        ;MsgBox, , Title, %Command%, 
        Sleep, 99
        SendInput, {CtrlDown}{Sleep, 22}{a}{Sleep, 22}{CtrlUp}{CtrlUp}
        SendInput, %Command% {Enter}
        Sleep, 99
        WinActivate, ahk_exe sublime_text.exe
        SendInput, {Ctrl Up}
    }
    else {
        MsgBox, , StataSend, Failed to find Stata's ID`, try again !, 3
    }
}

; <^>!f::
;     Sleep, 50
;     SendInput, {F13} ; F13 is mapped in sublime to select word under cursor
;     Sleep, 50
;     Variable := Clip() ; will store any selected text in %Var%
    ; 
;     Input, IputKey, L1 T1, , ,  ; wait for input: L means Length and T means Timeout
;     switch IputKey {
;         case "f":  
;             full_command = fre %Variable%
;             stata_call(full_command)
;         case "s":  
;             full_command = tab syear %Variable%
;             stata_call(full_command)
;         case "l":  
;             full_command = lookfor %Variable%
;             stata_call(full_command)
;     }
;     return
; return


#IfWinActive
; --- Stata Editor --------------------------------------------------------------------

#IfWinActive, Do-file Editor
    ; define some sane shortcuts for statas editor
    ^w::SendInput, !f{Sleep 33}c
    ^PgUp::SendInput, ^+{TAB}
    ^PgDn::SendInput, ^{TAB}

    LShift & WheelUp::SendInput, {HOME}
    LShift & WheelDown::SendInput, {END}
#IfWinActive

; --- Stata Browse --------------------------------------------------------------------
#IfWinActive, Data Editor (Browse)*
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