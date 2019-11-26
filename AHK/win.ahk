; UTF-8 with BOM

; --- Open App
#IfWinActive
#f:: ;firefox
    if !WinExist("ahk_class MozillaWindowClass") {
        Run, firefox.exe 
    }
    Else {
        WinActivate, ahk_class MozillaWindowClass    ; activates firefox windows, if program already opened
    }
Return

#s::Run, R:\stata15-64\StataSE-64.exe stata_temp.do

; --- /Media   -----------------------------------------------------------------

; Custom volume buttons
#NumpadAdd:: Send {Volume_Up} ;shift + numpad plus
#NumpadSub:: Send {Volume_Down} ;shift + numpad minus
break::Send {Volume_Mute} ; Break key mutes
return


; --- Move window with Lwin and Lbutton ---
Lwin & LButton::
    CoordMode, Mouse  ; Switch to screen/absolute coordinates.
    MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
    WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
    WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin%
    if EWD_WinState = 0  ; Only if the window isn't maximized
        SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
Return

EWD_WatchMouse:
    GetKeyState, EWD_LButtonState, LButton, P
    if EWD_LButtonState = U  ; Button has been released, so drag is complete.
    {
        SetTimer, EWD_WatchMouse, off
        Return
    }
    
    GetKeyState, EWD_EscapeState, Escape, P
    if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
    {
        SetTimer, EWD_WatchMouse, off
        WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
        Return
    }
    
    ; Otherwise, reposition the window to match the change in mouse coordinates
    ; caused by the user having dragged the mouse:
    CoordMode, Mouse
    MouseGetPos, EWD_MouseX, EWD_MouseY
    WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
    SetWinDelay, -1   ; Makes the below move faster/smoother.
    WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
    EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
    EWD_MouseStartY := EWD_MouseY
Return


; --- Windows 7 ----------------------------------------------------------------

#if WinActive("ahk_exe Explorer.EXE") and (!win10) 
    ;NOTE: in win10 renamed to lower case explorer.exe
    ; ctrl + l builtin in windows 10, so only runs in win 7!
    ^l::SendInput,{f4}
#if




; --- Print Screen  ---
; runs the snip program (windows 10) and snippingtool in windows 7
printscreen::
    If (win10) 
        Run, explorer ms-screenclip:
    Else 
        IfWinExist, ahk_exe SnippingTool.exe
        {
            WinActivate, ahk_exe SnippingTool.exe
            Sleep, 300
            SendInput,^n
        }
        else
            Run, snippingtool
return

; for some thinkpads models where the printscreen is where the Menu Key should be
+printscreen::SendInput, {AppsKey}
CapsLock & PrintScreen::SendInput, {AppsKey}


; --- change windown of the same app

!^:: ; Last window
    WinGet, ActiveProcess, ProcessName, A
    WinGet, WinClassCount, Count, ahk_exe %ActiveProcess%
    IF WinClassCount = 1
        Return
    Else
    WinGet, List, List, % "ahk_exe " ActiveProcess
    Loop, % List
    {
        index := List - A_Index + 1
        WinGet, State, MinMax, % "ahk_id " List%index%
        if (State <> -1)
        {
            WinID := List%index%
            break
        }
    }
    WinActivate, % "ahk_id " WinID
Return

#IfWinActive, ahk_exe StataSE-64.exe 

Return
!^::
    WinGet, ActiveProcess, PID, A
    WinGet, WinClassCount, Count, ahk_pid  %ActiveProcess%
    IF WinClassCount = 1
        Return
    Else
    WinGet, List, List, % "ahk_pid " ActiveProcess
    Loop, % List
    {
        index := List - A_Index + 1
        WinGet, State, MinMax, % "ahk_pid " List%index%
        if (State <> -1)
        {
            WinID := List%index%
            break
        }
    }
    WinActivate, % "ahk_id " WinID
Return


#IfWinActive ahk_class CabinetWClass
!^:: ; Next window
WinGetClass, ActiveClass, A
WinGet, WinClassCount, Count, ahk_class %ActiveClass%
IF WinClassCount = 1
    Return
Else
WinGet, List, List, % "ahk_class " ActiveClass
Loop, % List
{
    index := List - A_Index + 1
    WinGet, State, MinMax, % "ahk_id " List%index%
    if (State <> -1)
    {
        WinID := List%index%
        break
    }
}
WinActivate, % "ahk_id " WinID
return


; backward / forward browse 
#IfWinActive
~RButton & WheelUp::SendInput, !{Left}
~RButton & WheelDown::SendInput, !{Right}