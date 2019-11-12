; UTF-8 with BOM

; --- Windows 
#IfWinActive
#f::
    if !WinExist("ahk_class MozillaWindowClass") {
        Run, firefox.exe 
    }
    Else {
        WinActivate, ahk_class MozillaWindowClass    ; activates firefox windows, if program already opened
    }
Return

; --- /Media   -----------------------------------------------------------------

; Custom volume buttons
#NumpadAdd:: Send {Volume_Up} ;shift + numpad plus
#NumpadSub:: Send {Volume_Down} ;shift + numpad minus
break::Send {Volume_Mute} ; Break key mutes
return
