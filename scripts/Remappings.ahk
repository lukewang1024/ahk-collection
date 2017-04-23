#SingleInstance Force
#NoEnv
#NoTrayIcon
#Persistent
#usehook ; possibly intercept windows binds

SendMode Input
SetTitleMatchMode 2
DetectHiddenWindows, On

SetCapsLockState, AlwaysOff

#Include ..\includes\TrayIcon.ahk

; --------------------------------------------------------------------
; Toggle app window visibility for apps that can be hidden to system tray
;
toggleAppWindowWithTray(sExeName, isDoubleClick := false)
{
  Process, Exist, %sExeName%
  targetPid = %ErrorLevel%

  if (targetPid == 0) {
    return
  }

  IfWinActive, ahk_pid %targetPid%
  {
    ; 0x112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
    PostMessage, 0x112, 0xF060
  }
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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; auto-execute section end ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Make Win Key + Capslock work like Capslock
#Capslock::
If GetKeyState("CapsLock", "T") = 1
    SetCapsLockState, AlwaysOff
Else
    SetCapsLockState, AlwaysOn
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; vim-like navigations ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Capslock & j::Send {Down}
Capslock & k::Send {Up}
Capslock & h::Send {Left}
Capslock & l::Send {Right}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Application shortcuts ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ST3: Capslock + s
Capslock & s::toggleAppWindow("ahk_class PX_WINDOW_CLASS ahk_exe sublime_text.exe")
; Atom: Capslock + a
Capslock & a::toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe atom.exe")
; VS Code: Capslock + v
Capslock & v::toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe")
; Chrome: Capslock + c
Capslock & c::toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe")
; Lingoes: Capslock + d
Capslock & d::toggleAppWindowWithTray("Lingoes.exe")
; WeChat: Capslock + m
Capslock & m::toggleAppWindowWithTray("WeChat.exe")
; Skype: Capslock + o
Capslock & o::toggleAppWindowWithTray("Skype.exe", true)
; Slack: Capslock + u
Capslock & u::toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe slack.exe")
; Whatsapp: Capslock + i
Capslock & i::toggleAppWindow("WhatsApp ahk_exe WhatsApp.exe")
; Postman: Capslock + y
Capslock & y::toggleAppWindow("Postman ahk_class Chrome_WidgetWin_1")

;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ConEmu workarounds ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Override the issue of mintty capturing keystrokes would make ConEmu unable to switch tabs
; Win-Z somehow doesn't work in Win8 onward, that is why Ctrl-Alt-Z is used instead...
;
ConEmuSwitchFocus(key)
{
  ; switch focus by Ctrl-Alt-Z (configured in ConEmu)
  Send ^!z
  Send %key%
}

#IfWinActive ahk_class VirtualConsoleClass
^1::ConEmuSwitchFocus("^1")
^2::ConEmuSwitchFocus("^2")
^3::ConEmuSwitchFocus("^3")
^4::ConEmuSwitchFocus("^4")
^5::ConEmuSwitchFocus("^5")
^6::ConEmuSwitchFocus("^6")
^7::ConEmuSwitchFocus("^7")
^8::ConEmuSwitchFocus("^8")
^9::ConEmuSwitchFocus("^9")
#!p::ConEmuSwitchFocus("!p")
#IfWinActive

;;;;;;;;;;;;;;;;;;;;;;;
;;; Other shortcuts ;;;
;;;;;;;;;;;;;;;;;;;;;;;

#include %A_ScriptDir%\parts
#include AdvancedWindowSnap.ahk
#include WeChat.ahk

; Remap Ctrl-Q to Alt-F4
^q::Send !{F4}
return

; Color picker by Ctrl-Win-C
^#c::
  MouseGetPos, mouseX, mouseY
  PixelGetColor, color, %mouseX%, %mouseY%, RGB
  StringRight color, color, 6
  clipboard = %color%
return

; Copy file path by Ctrl-Shift-C
^+c::
  send ^c
  sleep, 200
  clipboard = %clipboard% ;%null%
  tooltip, %clipboard%
  sleep, 500
  tooltip,
return
