; "Focus Skype" shortcut could put Skype on focus and minimize Skype
; if it is already focused. This snippet is to remap it to close the
; window when it is already focused so nothing would be left in the
; task bar.
; Assumption - "Focus Skype" is set to `Alt-O`

#IfWinActive ahk_class tSkMainForm
!o::
  Send !{F4}
return
#IfWinActive
