; UTF-8 with BOM


*!PgUp::SendInput,{Home}
*!PgDn::SendInput,{End}

*!+PgUp::SendInput,+{Home}
*!+PgDn::SendInput,+{End}

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