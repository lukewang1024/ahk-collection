; Override the issue of mintty capturing keystrokes would make ConEmu unable to switch tabs
; Win-Z somehow doesn't work in Win8 onward, that is why Ctrl-Alt-Z is used instead...
#IfWinActive ahk_class VirtualConsoleClass
^1::
  Send ^!z ;switch focus by Ctrl-Alt-Z
  Send ^1 ;change window
return
^2::
  Send ^!z
  Send ^2
return
^3::
  Send ^!z
  Send ^3
return
^4::
  Send ^!z
  Send ^4
return
^5::
  Send ^!z
  Send ^5
return
^6::
  Send ^!z
  Send ^6
return
^7::
  Send ^!z
  Send ^7
return
^8::
  Send ^!z
  Send ^8
return
^9::
  Send ^!z
  Send ^9
return
#!p::
  Send ^!z
  Send #!p
return
^n::
  Send ^!z
  Send ^n
return
#IfWinActive
