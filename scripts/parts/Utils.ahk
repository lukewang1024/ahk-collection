; --------------------------------------------------------------------
; Return the real process name of the active window (even for UWP apps)
;
; by lexikos (https://autohotkey.com/boards/viewtopic.php?t=13818)
;
WinGetActiveProcessName() {
  WinGet name, ProcessName, A
  if (name = "ApplicationFrameHost.exe") {
    ControlGet hwnd, Hwnd,, Windows.UI.Core.CoreWindow1, A
    if hwnd {
      WinGet name, ProcessName, ahk_id %hwnd%
    }
  }
  return name
}

; --------------------------------------------------------------------
; Register Alt-k, Alt-j as Up, Down for a given ahk_class
;
registerUpDown(ahkClass)
{
  Hotkey, IfWinActive, ahk_class %ahkClass%
  Hotkey, !j, SendDown, On
  Hotkey, !k, SendUp, On
  Hotkey, IfWinActive
  return

  SendDown:
  Send {Down}
  return

  SendUp:
  Send {Up}
  return
}

; --------------------------------------------------------------------
; Click a position and move the pointer back
;
clickAndBack(x, y, n = 1)
{
  MouseGetPos, x0, y0
  Click %x%, %y%, %n%
  MouseMove, x0, y0
}
