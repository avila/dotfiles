#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
;#Warn  ; Enable warnings to assist with detecting common errors.
#SingleInstance force
SetTitleMatchMode 2

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; --- Scroll Shift and Lock Behaviour ------------------------------------------
SetCapsLockState, AlwaysOff
+CapsLock::
    SetScrollLockState % !GetKeyState("ScrollLock", "T")
    while(getKeyState("ScrollLock","T")){
        ToolTip, .`nScrollLock`nis`nOn`n .
        ;TODO: make nicer tooltip
        sleep, 3
    }
    ToolTip
return

#If (GetKeyState("CapsLock", "P") | GetKeyState("ScrollLock", "T"))
    *h::SendInput,{Blind}{Left}
    *j::SendInput,{Blind}{Down}
    *k::SendInput,{Blind}{Up}
    *l::SendInput,{Blind}{Right}
    *d::SendInput,{Blind}{Del}
    *b::SendInput,{Blind}{Backspace}
    *u::SendInput,{Blind}{Home}
    *i::SendInput,{Blind}{End}
    *p::SendInput,{Blind}{PgUp}
    *ö::SendInput,{Blind}{PgDn}
#If

#if GetKeyState("ScrollLock", "T")
    q::SetScrollLockState, Off
    Esc::SetScrollLockState, Off
    CapsLock::
        SetScrollLockState, Off
        ScrollShiftState := 1
    return
    CapsLock Up::
        ScrollShiftState := 0
    return
    <+CapsLock::SetScrollLockState % !GetKeyState("ScrollLock", "T")
#If

; --- Third layer (AltGr) ------------------------------------------------------

<^>!s::SendInput,{ß}                    ; altGr+s           -> "ß"
<^>!+s::SendInput,{§}                   ; alt+shift+s       -> "§"
<^>!w::SendInput,{?}                    ; alt+W             -> "?" 
<^>!+w::SendInput,{\}                   ; alt+W             -> "?" 
<^>!+q::SendInput,{/}
<^>!-::SendInput,{/}
<^>!+-::SendInput,{\}
<^>!c::SendInput,{ç}                    ; alt+c             -> "ç" 
<^>!+c::SendInput,{Ç}                   ; alt+C             -> "ç" 
<^>!a::SendInput,{ã}                    ; alt+C             -> "ç" 
<^>!+A::SendInput,{Ã}                   ; alt+C             -> "ç" 
<^>!+8::SendInput,{{}                   ; curly brackets
<^>!+9::SendInput,{}}                   ; curly brackets



; /--- Right Click -------------------------------------------------------------
#IfWinActive
RButton & s::
    Sleep, 30
    SendInput, ^c{Sleep 10}                      ; sends cntrl x
    WinActivate, ahk_class MozillaWindowClass    ; activates firefox windows, if program already opened
    Sleep, 30
    ClipWait, 1                                  ; wait for clipboard to be populated   Sleep 30
    Send, ^t{sleep 30}^l{Sleep 30}
    SendInput, sp %clipboard%                    ; do the magic
    SendInput, {Enter}
return

RButton & w::
    Sleep, 30
    SendInput, ^c{Sleep 10}              		; sends cntrl x
    Sleep, 30
    ClipWait                                     ; wait for clipboard to be populated
    WinActivate, ahk_class MozillaWindowClass    ; activates firefox windows, if program already opened
    Sleep 30
    Send, ^t{sleep 30}^l{Sleep 30}
    SendInput, wikipedia %clipboard%				; do the magic
    SendInput, {Enter}
return
    
#If !WinActive("ahk_class AcrobatSDIWindow")
RButton & g::
    Sleep, 30
    SendInput, ^c{Sleep 30}                      ; sends cntrl x
    ClipWait                                     ; wait for clipboard to be populated
    Sleep, 30
    WinActivate, ahk_class MozillaWindowClass    ; activates firefox windows, if program already opened
    Sleep 30
    Send, ^t{sleep 30}
    SendInput, gt {Space} %clipboard%            ; do the magic
    SendInput, {Enter}
return 

RButton & l::
    Sleep, 30
    SendInput, ^c{Sleep 30}                      ; sends cntrl x
    ClipWait                                     ; wait for clipboard to be populated
    Sleep, 30
    WinActivate, ahk_class MozillaWindowClass    ; activates firefox windows, if program already opened
    Sleep 30
    Send, ^t{sleep 30}
    SendInput, leo {Space} %clipboard%           ; do the magic
    SendInput, {Enter}
return 
RButton::Send, {RButton} ; Important -> keey rbutton working

; --- Right Click --------------------------------------------------------------


; --- To Delete ----------------------------------------------------------------

; --- /To Delete ---------------------------------------------------------------
;
; --- WORD ---------------------------------------------------------------------

 #IfWinActive ahk_exe WINWORD.EXE
; home end on word
XBUTTON1::SendInput,{Home}
XBUTTON2::SendInput,{End}

#IfWinActive

; /------------------------------------## /WORD --------------------------------
; /------------------------------------## Excel --------------------------------

#IfWinActive, ahk_class  XLMAIN
    ; Horizon Scroll In Excel With Shift + Scroll Wheel
    LShift & WheelUp::ComObjActive("Excel.Application").ActiveWindow.SmallScroll(0,0,0,3)
    LShift & WheelDown::ComObjActive("Excel.Application").ActiveWindow.SmallScroll(0,0,3)

    ; Cycle Through Worksheet with Left ALt + Scroll Wheel
    LAlt & WheelUp::Send, ^{PgUp}
    LAlt & WheelDown::Send, ^{PgDn}

    NumpadDot::.

#IfWinActive


; --- Firefox ------------------------------------------------------------------
#IfWinActive
$^+Y::
    SendInput,{Sleep 10}^c{Sleep 10}
    ClipWait
    WinActivate, ahk_class MozillaWindowClass
    Sleep 13
    Send, ^t{sleep 13}^l{Sleep 13}
    Send, g {Space}
    SendInput, %clipboard%
    SendInput,{Enter}
return 

#IfWinActive, ahk_exe firefox.exe
; google sites
Capslock & s::
    SendInput,{Home}site:{CtrlDown}{ShiftDown}{Right}{CtrlUp}{ShiftUp}{Del}{End}
return


#IfWinActive, Google Sheets
~Alt & 1::SendInput, ^{PgUp}
~Alt & 2::SendInput, ^{PgUp}
~Alt & 3::SendInput, ^{PgUp}
~Alt & 4::SendInput, ^{PgUp}
~Alt & 5::SendInput, ^{PgUp}
~Alt & 6::SendInput, ^{PgUp}
#IfWinActive

#IfWinActive ahk_exe firefox.exe
~Alt & 1::SendInput, ^1
~Alt & 2::SendInput, ^2
~Alt & 3::SendInput, ^3
~Alt & 4::SendInput, ^4
~Alt & 5::SendInput, ^5
~Alt & 6::SendInput, ^6



; --- Stata --------------------------------------------------------------------

StataWindow := "ahk_class Afx:0000000140000000:0:0000000000000000:0000000000000000:0000000003970829" 

#IfWinActive ahk_exe sublime_text.exe
f1::
    ; Send, {Home Down}{Home Up}{ShiftDown}{End}{ShiftUp}
    Send, ^c
    ClipWait, 5
    if WinExist("ahk_class Afx:0000000140000000:0:0000000000000000:0000000000000000:0000000003970829")
    {
        WinActivate ;
        Send, ^1
        Send, ^v
    }
    Else
    {
        return
    }

return
#IfWinActive

RButton & t::
    ; in stata: CTRL+T -> activates main window and aks for tab, m
    Sleep, 30
    SendInput, ^c{Sleep 10}
    ClipWait, 10
    WinActivate, ahk_class ahk_class Afx:0000000140000000:0:0000000000000000:0000000000000000:0000000003970829
    Sleep 30
    Send, ^1
    Sleep 30
    SendInput, tab %clipboard% ,missing
    SendInput, {Enter}
return 

#IfWinActive, Do-file Editor
    ; define some sane shortcuts for statas editor
    ^w::SendInput, !f{Sleep 33}c
    ^PgUp::SendInput, ^+{TAB}
    ^PgDn::SendInput, ^{TAB}

    LShift & WheelUp::SendInput, {HOME}
    LShift & WheelDown::SendInput, {END}
#IfWinActive


; ------ Sublime ------

 
; ------ && ------

~Numpad0 & NumpadDot::SendInput,.{left}{backspace}{right}       ; "0" + "," = "."

; --- CapsLock -----------------------------------------------------------------

Capslock & Space::SendInput,{ENTER}

Capslock & 2::
    SaveThisClip := ClipboardAll                ; saves clipboard into variable
    clipboard =                                 ; clean clipboard
    SendInput,{Sleep 10}^x{Sleep 10}            ; sends cntrl x
    ClipWait                                    ; wait for clipboard to be populated
    SendInput, {"}%clipboard%{"}                ; do the magic
    clipboard := SaveThisClip                   ; replace clipboard with variable       
    SaveThisClip =                          
return 

; Klammer Clam Parentesis and 8 (TO FIX!!!) (TODO:to fix this)
; Capslock & 8::
; SaveThisClip := ClipboardAll                ; saves clipboard into variablea 
; SendInput,{Sleep 10}^x{Sleep 10}
; Sleep, 30
; ClipWait
; SendInput, {(}%clipboard%{)}
; clipboard := SaveThisClip                   ; replace clipboard with variable       
; saved =                                     
; return  

; --- Explorer -----------------------------------------------------------------

#IfWinActive, ahk_exe Explorer.EXE
    ^l::SendInput,{f4}
#IfWinActive


; --- auto completes -----------------------------------------------------------


:?0C*:ddd:: ; 13.09.2019 (18:30)
    FormatTime, CurrentDateTime,, dd.MM.yyyy (HH:mm)
    SendInput %CurrentDateTime% 
return

:R*?:m@::m.rainho.avila@gmail.com 

::lig::Liebe Grüße
::mfg::Mit freundlichen Grüßen
::lf::Liebe Frau
::lh::Lieber Herr
::sgh::Sehr geehrter Herr
::sgf::Sehr geehrte Frau
::sgd::Sehr geehrte Damen und Herren,
::fr::Für weitere Fragen stehe ich gerne zu Ihrer Verfügung.

; --- mathe / equations --------------------------------------------------------

; zeichen
::qqtimes::·
::qqtime::× 
::qqd::÷
::qqpm::±
::qqkg::≤
::qqgg::≥
::pct::%
::sqrt::√
::unend::∞
::qqint::∫
::qqrechts::⇒ 
::qqlinks::{U+21d0}     ; 
::qqrl::⇔
::qqungf::≈
::qqung::≠
::qqup::{U+2191}        ; ↑ 
::qqdown::{U+2193}      ; ↓      
::qqdn::{U+2193}        ; ↓ 


; greek letters α
:R*?:qa::a
:R*?:qbeta::β
:R*?:qgamma::γ
:R*?:qdelta::δ
:R*?:qomega::Ω
:R*?:qlambda::
:R*?:qtheta::θ
:R*?:qsigma::σ
:R*?:qpi::π
:R*?:qtau::{U+03C4} ; 
:R*?:qepsi::ε
::qforall::{U+2200}

; superscripts
:*:^^1::¹
:*:^^2::²
:*:^^3::³
:*:^^4::⁴
:*:^^5::⁵
:*:^^6::⁶
:*:^^7::⁷
:*:^^8::⁸
:*:^^9::⁹
:*:^^0::⁰
:*:^^+::⁺
:*:^^-::⁻
:*:^^(::⁽
:*:^^)::⁾
:*:^^x::ˣ
:*:^^y::ʸ
:*:^^a::ᵃ
:*:^^b::ᵇ
:*:^^n::ⁿ
:*:^^m::ᵐ
:*:^^alpha::ᵅ
:*:^^beta::ᵝ

; ubscript
::sub0::₀
::sub1::₁
::sub2::₂
::sub3::₃
::sub4::₄
::sub5::₅
::sub6::₆
::sub7::₇
::sub8::₈
::sub9::₉
::sub+::₊
::sub-::₋
::sub=::₌
::sub(::₍
::sub)::₎
::suba::ₐ
::subx::ₓ
::ampers::&

; --- /Media   -----------------------------------------------------------------

; Custom volume buttons
#NumpadAdd:: Send {Volume_Up} ;shift + numpad plus
#NumpadSub:: Send {Volume_Down} ;shift + numpad minus
break::Send {Volume_Mute} ; Break key mutes
return


; --- Autohotkey ---------------------------------------------------------------
 

#IfWinActive ahk_class Notepad++
f6::
    SaveThisClip := ClipboardAll                ; saves clipboard into variables 
    SendInput,{Sleep 10}^x{Sleep 10}
    Sleep, 30
    ClipWait
    SendInput, {{}%clipboard%{}}
    clipboard := SaveThisClip                   ; replace clipboard with variable       
    saved =
return 
#IfWinActive
$^s::
if WinActive("AutoHotkeyU64.ahk")
    {
        SendInput,^s
        Sleep,33
        SplashTextOn, 300, 50, AHK, Updating the script.
        Sleep, 678
        SplashTextOff
        Reload 
    }
Else 
{
    SendInput, ^s
}
return

#f12::Run, \\hume\soep-data\STUD\mavila\Apps\AHK\WindowSpy.ahk

^+!h::
:*:date#::
  ActWin := WinActive("A") ; for tracking original window—also works with  WinGet, ActWin, ID, A
  ;MsgBox, %ActWin%    ; for testing purposes only
  ; SendInput {Backspace 5}
  Date := A_Now
  List := DateFormats(Date)
  TextMenuDate(List)
Return

DateFormats(Date)
{
    FormatTime, OutputVar , %Date%, HH:mm  ;
    global List := "1. " . OutputVar
    
    FormatTime, OutputVar , %Date%, ShortDate ;
    global List := List . "|2. " . OutputVar
    
    FormatTime, OutputVar , %Date%, dd.MM.yyyy HH:mm ;
    global List := List . "|3. " . OutputVar
    
    FormatTime, OutputVar , %Date%, MMM. d, yyyy
    global List := List . "|4. " . OutputVar
    
    FormatTime, OutputVar , %Date%, MMMM d, yyyy
    global List := List . "|q. " . OutputVar
    
    FormatTime, OutputVar , %Date%, LongDate
    global List := List . "|w. " . OutputVar
    Return List
}
 
TextMenuDate(TextOptions)
{
 StringSplit, MenuItems, TextOptions , |
 Loop %MenuItems0%
  {
    Item := MenuItems%A_Index%
    Menu, MyMenu, add, %Item%, MenuAction
  }
 Menu, MyMenu, Show
 Menu, MyMenu, DeleteAll
}

MenuAction:
 Sleep 33
 WinActivate, ahk_id %ActWin%  ;activate original window
 Sleep 33
 StringFinal := SubStr(A_ThisMenuItem, 4)
 Sleep 33
 Send, %StringFinal%
Return


; ---------------------------------------- Windows management  -----------------

#SPACE::  Winset, Alwaysontop, , A

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

!+^:: ; Last window
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

; --- Print Screen  ---
printscreen::
    IfWinExist, ahk_exe SnippingTool.exe
    {
        WinActivate, ahk_exe SnippingTool.exe
        Sleep, 300
        SendInput,^n
    }
    else
        Run, snippingtool
return

; --- Move window with Lwin and Lbutton ---

Lwin & LButton::
    CoordMode, Mouse  ; Switch to screen/absolute coordinates.
    MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
    WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
    WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin%
    if EWD_WinState = 0  ; Only if the window isn't maximized
        SetTimer, EWD_WatchMouse, 10 ; Track the mouse as the user drags it.
return

EWD_WatchMouse:
    GetKeyState, EWD_LButtonState, LButton, P
    if EWD_LButtonState = U  ; Button has been released, so drag is complete.
    {
        SetTimer, EWD_WatchMouse, off
        return
    }
    
    GetKeyState, EWD_EscapeState, Escape, P
    if EWD_EscapeState = D  ; Escape has been pressed, so drag is cancelled.
    {
        SetTimer, EWD_WatchMouse, off
        WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
        return
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
return
