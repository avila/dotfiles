; UTF-8 with BOM

; --- Globals ------------------------------------------------------------------
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force
SetTitleMatchMode RegEx

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetCapsLockState, AlwaysOff

global win10 := % substr(a_osversion, 1, 2) = 10


#Include, %A_ScriptDir%/vim_mode.ahk
 
#Include, %A_ScriptDir%/remaps.ahk

#Include, %A_ScriptDir%/office.ahk

#Include, %A_ScriptDir%/stata.ahk

#Include, %A_ScriptDir%/math_latex.ahk
; Work in Progress

#Include, %A_ScriptDir%/browse.ahk




; --- auto completes -----------------------------------------------------------

#IfWinActive
:?0C*:dddh:: ; 13.09.2019 (18:30) (h for Human)
    ; input the date and time in the format defined below
    FormatTime, CurrentDateTime,, dd.MM.yyyy (HH:mm)
    SendInput %CurrentDateTime% 
return
:?0C*:dddm:: ; 2019_09_13 (m for Machine, good file names )
    ; input the date and time in the format defined below
    FormatTime, CurrentDateTime,, yyyy_mm_dd
    SendInput %CurrentDateTime% 
return

; text expander with email
:R*?:m@::m.rainho.avila@gmail.com


#IfWinActive, .*autohotkey\.ahk.*
; if editing the autohotkey file, ctrl+s saves the file and reloads the script
; the script needs to have a name that will be captured by the regex after
; the #IfWinActive condtition
$^s::
    SendInput,^s
    Sleep,33
    SplashTextOn, 300, 50, AHK, Updating the script.
    Sleep, 666
    SplashTextOff
    Reload
Return
#IfWinActive



; --- Print Screen  ---
; runs the snip program (windows 10)
printscreen::Run, explorer ms-screenclip:

; for some thinkpads models where the printscreen is where the Menu Key should be
+printscreen::SendInput, {AppsKey}
CapsLock & PrintScreen::SendInput, {AppsKey}



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
    ^l::SendInput,{f4}
#if
