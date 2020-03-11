; UTF-8 with BOM

global VimMode = 0 

; --- Scroll Shift and Lock Behaviour ------------------------------------------
LShift & RShift::
    ;use LeftShift+RightShift to toggle CAPS LOCK
    if GetKeyState("CapsLock", "T") = 1
       SetCapsLockState, AlwaysOff
    else if GetKeyState("CapsLock", "F") = 0
       SetCapsLockState, on
Return

/*+CapsLock::
    ;SetScrollLockState % !GetKeyState("ScrollLock", "T") ; toggle ScrollLock state
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
*/

#If (GetKeyState("CapsLock", "P") | VimMode)
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

