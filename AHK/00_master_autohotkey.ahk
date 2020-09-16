; UTF-8 with BOM

; --- Globals ------------------------------------------------------------------
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force
SetTitleMatchMode RegEx

#MaxHotkeysPerInterval 333


;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetKeyDelay, 10, 1
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetCapsLockState, AlwaysOff ; disables CAPSLock
global win10 := % substr(a_osversion, 1, 2) = 10 ; defines a global (1 if win10, 0 otherwise)


#Include, %A_ScriptDir%/vim_mode.ahk
 
#Include, %A_ScriptDir%/remaps.ahk

#Include, %A_ScriptDir%/office.ahk

#Include, %A_ScriptDir%/stata.ahk

#Include, %A_ScriptDir%/math_latex.ahk
; Work in Progress

#Include, %A_ScriptDir%/browse.ahk


#Include, %A_ScriptDir%/win.ahk




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


; --- auto completes -----------------------------------------------------------
:R*?:m@::m.rainho.avila@gmail.com
; attention sign 
:R?0C*:attt::<!>


#IfWinActive, .*autohotkey\.ahk.*
; if editing the autohotkey file, ctrl+s saves the file and reloads the script
; the script needs to have a name that will be captured by the regex after
; the #IfWinActive condtition
$^s::
    SendInput,^s
    Sleep, 33
    SplashTextOn, 300, 50, AHK, Updating the script.
    Sleep, 666
    SplashTextOff
    Reload
Return
#IfWinActive
