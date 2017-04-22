#Include ..\..\includes\TrayIcon.ahk

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
; Register Alt-k, Alt-j as Up, Down
; for a given ahk_class / ahk_exe
;
registerUpDown(pattern)
{
  Hotkey, IfWinActive, %pattern%
  Hotkey, ^!#j, SendDown, On
  Hotkey, ^!#k, SendUp, On
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
; Register Alt-k, Alt-j, Alt-h, Alt-l as Up, Down, Left, Right
; for a given ahk_class / ahk_exe
;
registerArrows(pattern)
{
  Hotkey, IfWinActive, %pattern%
  Hotkey, !j, ArrowDown, On
  Hotkey, !k, ArrowUp, On
  Hotkey, !h, ArrowLeft, On
  Hotkey, !l, ArrowRight, On
  Hotkey, IfWinActive
  return

  ArrowDown:
  Send {Down}
  return

  ArrowUp:
  Send {Up}
  return

  ArrowLeft:
  Send {Left}
  return

  ArrowRight:
  Send {Right}
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

multipleClickAndBack(positions, n = 1)
{
  MouseGetPos, x0, y0
  for index, position in positions
  {
    x := position[1]
    y := position[2]
    Click %x%, %y%, %n%
  }
  MouseMove, x0, y0
}

; --------------------------------------------------------------------
; Toggle app window visibility for apps that can be hidden to system tray
;
toggleAppWindowWithTray(sExeName, isDoubleClick := false)
{
  Process, Exist, %sExeName%
  targetPid = %ErrorLevel%

  if (targetPid == 0)
    return

  IfWinActive, ahk_pid %targetPid%
    ; 0x112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
    PostMessage, 0x112, 0xF060
  else IfWinNotActive, ahk_pid %targetPid%
  {
    TrayIcon_Button(targetPid, "L", isDoubleClick)
    WinActivate
  }
}

; --------------------------------------------------------------------
; Minimize / restore app window
; for a given ahk_class / ahk_exe
;
toggleAppWindow(pattern)
{
  IfWinNotExist, %pattern%
    return

  IfWinActive, %pattern%
    WinMinimize
  else IfWinNotActive, %pattern%
    WinActivate
}
