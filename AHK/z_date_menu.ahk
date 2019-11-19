
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
    return List
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
