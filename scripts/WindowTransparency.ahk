; changing window transparencies

#NoTrayIcon
#SingleInstance Force

; Increments transparency up by 3.375% (with wrap-around)
^#WheelUp::
  DetectHiddenWindows, on
  WinGet, curtrans, Transparent, A
  if ! curtrans
    curtrans = 255
  newtrans := curtrans + 8
  if newtrans > 0
  {
    WinSet, Transparent, %newtrans%, A
  }
  else
  {
    WinSet, Transparent, OFF, A
    WinSet, Transparent, 255, A
  }
return

; Increments transparency down by 3.375% (with wrap-around)
^#WheelDown::
  DetectHiddenWindows, on
  WinGet, curtrans, Transparent, A
  if ! curtrans
    curtrans = 255
  newtrans := curtrans - 8
  if newtrans > 0
  {
    WinSet, Transparent, %newtrans%, A
  }
  else
  {
   WinSet, Transparent, 255, A
   WinSet, Transparent, OFF, A
  }
return

; Reset Transparency Settings by Ctrl+Win+o
^#o::
  WinSet, Transparent, 255, A
  WinSet, Transparent, OFF, A
return

; Press Ctrl+Win+G to show the current settings of the window under the mouse.
^#g::
  MouseGetPos,,, MouseWin
  WinGet, Transparent, Transparent, ahk_id %MouseWin%
  ToolTip Translucency:`t%Transparent%`n
  Sleep 2000
  ToolTip
return
