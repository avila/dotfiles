; UTF-8 with BOM

; --- Globals ------------------------------------------------------------------
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force
SetTitleMatchMode RegEx

#MaxHotkeysPerInterval 333


SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetKeyDelay, 20, 1
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
;SetCapsLockState, AlwaysOff ; disables CAPSLock
global win10 := % substr(a_osversion, 1, 2) = 10 ; defines a global (1 if win10, 0 otherwise)


; ---------------------------------------------------------------------
; ---------------------------------------------------------------------
; Main part
; ---------------------------------------------------------------------
; ---------------------------------------------------------------------

; run stata or regain connection with stata ID
#s::get_stata_id()

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
    tempfile := A_Temp . "\st_tmp.do"
    write_clip_to_temp_file()

    ; if stata not opened or connection not made yet (UniqueStataID undefined)->get id
    if not WinExist("Stata/(IC|SE|MP)? 1[0-9]\.[0-9]") or (!UniqueStataID) {
        get_stata_id()
    }

    stata_do(call_type)
Return


; sysuse auto
; --- stata functions  --------------------------------------------------------------------
write_clip_to_temp_file() {
    global tempfile
    Content := Clip() ; will store any selected text in %Var%
    tempfile := A_Temp . "\st_tmp.do"
    file := FileOpen(tempfile, "w", "utf-8-raw") ; ä
    file.Write(Content)
    file.Close()
}

stata_do(call_type="do") {
    global UniqueStataID
    global tempfile
    if WinExist("ahk_id" . UniqueStataID) {
        WinActivate,
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
; ---------------------------------------------------------------------
; ---------------------------------------------------------------------

; --- Dates -----------------------------------------------------------

#IfWinActive
:?0C*:dddd:: ; 13.09.2019 (18:30)
    FormatTime, CurrentDateTime,, dd.MM.yyyy
    SendInput %CurrentDateTime% 
Return
:?0C*:ddda:: ; 2019_11_06
    FormatTime, CurrentDateTime,, yyyy_MM_dd 
    SendInput %CurrentDateTime% 
Return
:?0C*:dddm:: ; 2019_11_06_11_49
    FormatTime, CurrentDateTime,, yyyy_MM_dd_HH_mm
    SendInput %CurrentDateTime% 
Return
:?0C*:dddh:: ; 06.11.2019 (11:49)
    FormatTime, CurrentDateTime,, dd.MM.yyyy (HH:mm)
    SendInput %CurrentDateTime% 
Return
:?0C*:ddde:: ; 06/11/2019 (11:49)
    FormatTime, CurrentDateTime,, dd/MM/yyyy
    SendInput %CurrentDateTime% 
Return
:?0C*:dddt:: ; 11:49
    FormatTime, CurrentDateTime,, HH:mm
    SendInput %CurrentDateTime% 
Return


;#IfWinActive, .*autohotkey\.ahk.*
#IfWinActive, .*\.ahk.*
; if editing the autohotkey file, ctrl+s saves the file and reloads the script
; the script needs to have a name that will be captured by the regex after
; the #IfWinActive condtition
$^s::
    SendInput,^s
    Sleep, 99
    SplashTextOn, 300, 50, AHK, Updating the script.
    sleep 300
    Reload
    SplashTextOff
Return
#IfWinActive
