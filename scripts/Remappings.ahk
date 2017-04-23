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

; --------------------------------------------------------------------
; Enable / disable no-modifier version of vim navigation keys
;
setVimNavKeys(state)
{
  Hotkey, j, %state%
  Hotkey, k, %state%
  Hotkey, h, %state%
  Hotkey, l, %state%
}

handleCapslockSend(newKey, oldKey)
{
  GetKeyState, state, CapsLock, P
  if state = D
  {
    Send %newKey%
    setVimNavKeys("on")
    Keywait, CapsLock
    setVimNavKeys("off")
    return
  }
  Send %oldKey%
}

handleCapslockToggleAppWindow(match, oldKey)
{
  GetKeyState, state, CapsLock, P
  if state = D
  {
    toggleAppWindow(match)
    return
  }
  Send %oldKey%
}

handleCapslockToggleAppWindowWithTray(sExeName, oldKey, isDouble := false)
{
  GetKeyState, state, CapsLock, P
  if state = D
  {
    toggleAppWindowWithTray(sExeName, isDouble)
    return
  }
  Send %oldKey%
}

setVimNavKeys("off")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; auto-execute section end ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Remap Capslock to Control.
CapsLock::Control

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

j::Send {Down}
k::Send {Up}
h::Send {Left}
l::Send {Right}
$^j::handleCapslockSend("{Down}", "^j")
$^k::handleCapslockSend("{Up}", "^k")
$^h::handleCapslockSend("{Left}", "^h")
$^l::handleCapslockSend("{Right}", "^l")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Application shortcuts ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; ST3: Capslock + s
$^s::handleCapslockToggleAppWindow("ahk_class PX_WINDOW_CLASS ahk_exe sublime_text.exe", "^s")
; Atom: Capslock + a
$^a::handleCapslockToggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe atom.exe", "^a")
; VS Code: Capslock + v
$^v::handleCapslockToggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe", "^v")
; Chrome: Capslock + c
$^c::handleCapslockToggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe", "^c")
; Lingoes: Capslock + d
$^d::handleCapslockToggleAppWindowWithTray("Lingoes.exe", "^d")
; WeChat: Capslock + m
$^m::handleCapslockToggleAppWindowWithTray("WeChat.exe", "^m")
; Skype: Capslock + o
$^o::handleCapslockToggleAppWindowWithTray("Skype.exe", "^o", true)
; Slack: Capslock + u
$^u::handleCapslockToggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe slack.exe", "^u")
; Whatsapp: Capslock + i
$^i::handleCapslockToggleAppWindow("WhatsApp ahk_exe WhatsApp.exe", "^i")
; Postman: Capslock + y
$^y::handleCapslockToggleAppWindow("Postman ahk_class Chrome_WidgetWin_1", "^y")

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
