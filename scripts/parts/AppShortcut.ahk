#Include ..\..\includes\TrayIcon.ahk

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
    ; Two activate calls to ensure focus
    WinActivate
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

; ST3: Capslock (Ctrl-Alt-Win) + s
^!#s::toggleAppWindow("ahk_class PX_WINDOW_CLASS ahk_exe sublime_text.exe")
; Atom: Capslock (Ctrl-Alt-Win) + a
^!#a::toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe atom.exe")
; VS Code: Capslock (Ctrl-Alt-Win) + v
^!#v::toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe")
; Chrome: Capslock (Ctrl-Alt-Win) + c
^!#c::toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe")
; Lingoes: Capslock (Ctrl-Alt-Win) + d
^!#d::toggleAppWindowWithTray("Lingoes.exe")
; WeChat: Capslock (Ctrl-Alt-Win) + m
^!#m::toggleAppWindowWithTray("WeChat.exe")
; Skype: Capslock (Ctrl-Alt-Win) + o
^!#o::toggleAppWindowWithTray("Skype.exe", true)
; Slack: Capslock (Ctrl-Alt-Win) + u
^!#u::toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe slack.exe")
; Whatsapp: Capslock (Ctrl-Alt-Win) + i
^!#i::toggleAppWindow("WhatsApp ahk_exe WhatsApp.exe")
; Postman: Capslock (Ctrl-Alt-Win) + y
^!#y::toggleAppWindow("Postman ahk_class Chrome_WidgetWin_1")
