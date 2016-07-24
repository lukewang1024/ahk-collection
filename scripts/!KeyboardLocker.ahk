;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; THE KEYBOARD LOCKER                                       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This script will disable the keyboard when the user       ;
; presses Ctrl+Alt+L. The keyboard is reenabled if the user ;
; types in the string "unlock".                             ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Originally written by Lexikos:                            ;
;  http://www.autohotkey.com/forum/post-147849.html#147849  ;
; Modifications by Trevor Bekolay for the How-To Geek       ;
;  http://www.howtogeek.com/                                ;
; Further modified by Luke Wang with new menu entry to      ;
; toggle the keyboard lock                                  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#NoEnv
#Persistent
#SingleInstance Force
FileInstall, icons\kl-enabled.ico, %A_ScriptDir%\icons\kl-enabled.ico, 0
FileInstall, icons\kl-disabled.ico, %A_ScriptDir%\icons\kl-disabled.ico, 0
Init()

ToggleTray:
  ToggleTray()
return

Exit:
  ExitApp
return

; This can only execute if the keyboard is NOT blocked,
; so it can't be used to unblock the keyboard.
^!l::
  KeyWait, Ctrl ; don't block Ctrl key-up
  KeyWait, Alt  ; or Alt key-up
  KeyWait, l    ; or l-up
  ToggleLock()
return

Init()
{
  global notray = 0
  global locked = 0
  Menu, Tray, Icon, %A_ScriptDir%\icons\kl-enabled.ico
  Menu, Tray, NoStandard
  Menu, Tray, Tip, Press Ctrl+Alt+L to lock your keyboard
  Menu, Tray, Add, Lock the keyboard, ToggleLock
  Menu, Tray, Add, Hide tray notifications, ToggleTray
  Menu, Tray, Add, Exit, Exit
  TrayTip,,To lock your keyboard press Ctrl+Alt+L.,10,1
}

ToggleLock()
{
  global locked

  if (locked = 0) {
    locked = 1
    Menu, Tray, Rename, Lock the keyboard, Unlock the keyboard
  } else {
    locked = 0
    Menu, Tray, Rename, Unlock the keyboard, Lock the keyboard
  }
  BlockKeyboard()
}

ToggleTray()
{
  global notray

  if (notray = 0) {
    notray = 1
    Menu, Tray, Rename, Hide tray notifications, Show tray notifications
  } else {
    notray = 0
    Menu, Tray, Rename, Show tray notifications, Hide tray notifications
  }
}

BlockKeyboard(block=-1) ; -1, true or false.
{
  static hHook = 0, cb = 0
  global notray

  if !cb ; register callback once only.
    cb := RegisterCallback("BlockKeyboard_HookProc")

  if (block = -1) ; toggle
    block := (hHook=0)

  if ((hHook!=0) = (block!=0)) ; already (un)blocked, no action necessary.
    return

  if (block) {
    if (notray = 0) {
      ; Show TrayTip to remind user of unlock string
      TrayTip,
        ,Your keyboard is now locked.`nType in "unlock" to unlock it.
        ,10,1
    }

    Menu, Tray, Icon, %A_ScriptDir%\icons\kl-disabled.ico ; Change tray icon
    Menu, Tray, Tip, Type "unlock" to unlock your keyboard
    hHook := DllCall("SetWindowsHookEx"
      , "int", 13  ; WH_KEYBOARD_LL
      , "uint", cb ; lpfn (callback)
      , "uint", 0  ; hMod (NULL)
      , "uint", 0) ; dwThreadId (all threads)
  }
  else {
    if (notray = 0) {
      TrayTip,
        ,Your keyboard is now unlocked.`nPress Ctrl+Alt+L to lock it again.
        ,10,1
    }

    Menu, Tray, Icon, %A_ScriptDir%\icons\kl-enabled.ico ; Change tray icon
    Menu, Tray, Tip, Press Ctrl+Alt+L to lock your keyboard
    DllCall("UnhookWindowsHookEx", "uint", hHook)
    hHook = 0
  }
}

; FIXME - "unlock" sequence doesn't work on Windows 10
BlockKeyboard_HookProc(nCode, wParam, lParam)
{
    static count = 0

    ; Unlock keyboard if "unlock" typed in
    if (NumGet(lParam+8) & 0x80) { ; key up

      if (count = 0 && NumGet(lParam+4) = 0x16) {        ; 'u'
        count = 1
      } else if (count = 1 && NumGet(lParam+4) = 0x31) { ; 'n'
        count = 2
      } else if (count = 2 && NumGet(lParam+4) = 0x26) { ; 'l'
        count = 3
      } else if (count = 3 && NumGet(lParam+4) = 0x18) { ; 'o'
        count = 4
      } else if (count = 4 && NumGet(lParam+4) = 0x2E) { ; 'c'
        count = 5
      } else if (count = 5 && NumGet(lParam+4) = 0x25) { ; 'k'
        count = 0
        ToggleLock()
      } else {
        count = 0
      }
    }

    return 1
}
