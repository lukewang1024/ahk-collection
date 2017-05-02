#Include ..\..\includes\TrayIcon.ahk

; --------------------------------------------------------------------
; Toggle app window visibility for apps that can be hidden to system tray
;
toggleAppWindowWithTray(sExeName, isDoubleClick := false, targetClass := "")
{
  Process, Exist, %sExeName%
  targetPid = %ErrorLevel%

  if (targetPid == 0) {
    return
  }

  if (targetClass != "") {
    ; skype.exe will keep itself activated with ahk_class "Internet Explorer_Hidden".
    ; Add specificity in such case to avoid being detected as activated falsely.
    winTitle = ahk_class %targetClass% ahk_pid %targetPid%
  } else {
    winTitle = ahk_pid %targetPid%
  }

  IfWinActive, %winTitle%
  {
    ; 0x112 = WM_SYSCOMMAND, 0xF060 = SC_CLOSE
    PostMessage, 0x112, 0xF060
  }
  else IfWinNotActive, %winTitle%
  {
    TrayIcon_Button(targetPid, "L", isDoubleClick)
    WinActivate
  }
}

; --------------------------------------------------------------------
; Minimize / restore app window
; for a given ahk_class / ahk_exe
;
toggleAppWindow(winTitle)
{
  IfWinNotExist, %winTitle%
    return

  IfWinActive, %winTitle%
    WinMinimize
  else IfWinNotActive, %winTitle%
    WinActivate
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Application shortcuts ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Use Capslock as prefix

; a - Atom
Capslock & a::toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe atom.exe")
; b - Chrome
Capslock & b::toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe")
; d - Lingoes
Capslock & d::toggleAppWindowWithTray("Lingoes.exe")
; e - ST3
Capslock & e::toggleAppWindow("ahk_class PX_WINDOW_CLASS ahk_exe sublime_text.exe")
; i - WeChat
Capslock & i::toggleAppWindowWithTray("WeChat.exe")
; m - Slack
Capslock & m::toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe slack.exe")
; n - OneNote
Capslock & n::toggleAppWindow("ahk_class Framework::CFrame ahk_exe ONENOTE.EXE")
; o - Skype
Capslock & o::toggleAppWindowWithTray("Skype.exe", true, "tSkMainForm")
; p - Spotify
Capslock & p::toggleAppWindow("ahk_class SpotifyMainWindow ahk_exe Spotify.exe")
; u - TIM (QQ)
Capslock & u::toggleAppWindowWithTray("TIM.exe")
; v - VS Code
Capslock & v::toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe")
; y - Postman
Capslock & y::toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe Postman.exe")
; z - Zeplin
Capslock & z::toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe Zeplin.exe")
; , - Whatsapp
Capslock & ,::toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe WhatsApp.exe")
