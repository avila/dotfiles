; UTF-8 with BOM

; --- Globals ------------------------------------------------------------------
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force
SetTitleMatchMode RegEx

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetCapsLockState, AlwaysOff ; disables CAPSLock
global win10 := % substr(a_osversion, 1, 2) = 10 ; defines a global (1 if win10, 0 otherwise)


; --- Vim Mode ------------------------------------------------------------------

global VimMode = 0 

+CapsLock:: ; toggle virtual vim mode
    VimMode := 1
    SetTimer, ToolTipTimer, 1
    ToolTipTimer:
        if VimMode {
            ToolTip, Editing Mode is %VimMode%!
        } else {
            ToolTip
            SetCapsLockState, AlwaysOff
        }
Return


#If (GetKeyState("CapsLock", "P") | VimMode) ; if CAPS physically pressed or virtual vim mode on
    ;moving
    *h::SendInput,{Blind}{Left}
    *j::SendInput,{Blind}{Down}
    *k::SendInput,{Blind}{Up}
    *l::SendInput,{Blind}{Right}
    *d::SendInput,{Blind}{Del}
    *b::SendInput,{Blind}{Backspace}
    *u::SendInput,{Blind}{Home}
    *i::SendInput,{Blind}{End}
    *p::SendInput,{Blind}{PgUp}
    *SC027::SendInput,{Blind}{PgDn} ; sc027 => ö in de layout, 
    ; editing
    *z::SendInput,^z
    *x::SendInput,^x
    *c::SendInput,^c
    *v::SendInput,^v

    *m::SendInput, {AppsKey}

    *2::enclose_with("""", """")
    *8::enclose_with("(" , ")")
    *(::enclose_with("[" , "]")
    *7::enclose_with("{" , "}")
    *[::enclose_with("{" , "}")
#If

#if VimMode
    ; ways of exiting vim mode
    q:: 
    Esc::
    CapsLock::
    +CapsLock::VimMode := 0
#If

#If (GetKeyState("CapsLock", "P")) ; only if caps physically pressed
	Space::SendInput,{ENTER}

#If

; helper functions 
enclose_with(bef, aft) {
    ; gets the selected text and wraps with bef and aft
    SaveThisClip := ClipboardAll
    clipboard := ""
    SendInput, ^x
    ClipWait
    SendInput, {%bef%}%clipboard%{%aft%
    clipboard := SaveThisClip
    SaveThisClip := ""
}

; ---  Lock Behaviour 
LShift & RShift::
    ;use LeftShift+RightShift to toggle CAPS LOCK
    if GetKeyState("CapsLock", "T") = 1
       SetCapsLockState, AlwaysOff
    else if GetKeyState("CapsLock", "F") = 0
       SetCapsLockState, on
Return


; --- auto completes -----------------------------------------------------------
; See https://www.autohotkey.com/docs/Hotstrings.htm for explanation on how it works
; ?: (question mark): The hotstring will be triggered even when it is inside another word;
; *: (asterisk): An ending character (e.g. space, ., enter) is not required to trigger the hotstring
; C: Case sensitive

#IfWinActive ;since empty, removes any If Win Active Condition 
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


; --- Updates -----------------------------------------------------------

#IfWinActive, .*AutoHotkeyU64\.ahk.* 
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
