#SingleInstance Force
#NoEnv
#NoTrayIcon
#Persistent
#usehook ; possibly intercept windows binds

SendMode Input
SetTitleMatchMode 2
DetectHiddenWindows, On

SetCapsLockState, AlwaysOff

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

;;;;;;;;;;;;;;;;;;;;;;;
;;; Skype shortcuts ;;;
;;;;;;;;;;;;;;;;;;;;;;;
;
; Map Capslock + 1/2 as Skype default shortcut Alt + 1/2
;
#IfWinActive ahk_class tSkMainForm ahk_exe Skype.exe
Capslock & 1::Send !1
Capslock & 2::Send !2
#IfWinActive

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
#include YABT.ahk
#include AppShortcut.ahk
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
