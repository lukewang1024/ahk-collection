#SingleInstance Force
#NoEnv
#NoTrayIcon
#usehook ; possibly intercept windows binds

SendMode Input
SetTitleMatchMode 2
DetectHiddenWindows, On

#include %A_ScriptDir%\parts
; Default-directive hotkeys (must stay before Specific-directive ones)
#include VimNav.ahk
; Specific-directive hotkeys
; #include AltBacktick.ahk
#include ConEmu.ahk
#include Skype.ahk
#include WeChat.ahk

; Remap Capslock to Backspace. LAlt-Capslock as original Capslock function
<^Capslock::Capslock
Capslock::Ctrl

; Remap RShift to Escape
; RShift::Escape

; Remap Ctrl-Q to Alt-F4
^q::Send !{F4}
return

; Remap Ctrl-W to Ctrl-F4
; ^w::Send ^{F4}
; return

; Color picker by Ctrl-Win-C
^#c::
  MouseGetPos, mouseX, mouseY
  PixelGetColor, color, %mouseX%, %mouseY%, RGB
  StringRight color,color,6
  clipboard = %color%
return

; Copy file path by Ctrl-Shift-C
^+c::
  send ^c
  sleep,200
  clipboard=%clipboard% ;%null%
  tooltip,%clipboard%
  sleep,500
  tooltip,
return
