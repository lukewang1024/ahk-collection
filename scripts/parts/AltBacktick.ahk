; Alt-` -> Next window
#IfWinNotExist, ahk_exe vswitch64.exe

!`::
WinGetClass, ActiveClass, A
if (ActiveClass = "ApplicationFrameWindow") {
  return
}
WinGet, WinClassCount, Count, ahk_class %ActiveClass%
if (WinClassCount = 1) {
  return
}
WinSet, Bottom,, A
WinActivate, ahk_class %ActiveClass%
return

; Alt-Shift-` -> Last window
!+`::
WinGetClass, ActiveClass, A
if (ActiveClass = "ApplicationFrameWindow") {
  return
}
WinActivateBottom, ahk_class %ActiveClass%
return

#IfWinNotExist
