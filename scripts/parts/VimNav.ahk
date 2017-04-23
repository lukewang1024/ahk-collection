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
  Hotkey, ^!#j, ArrowDown, On
  Hotkey, ^!#k, ArrowUp, On
  Hotkey, ^!#h, ArrowLeft, On
  Hotkey, ^!#l, ArrowRight, On
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

; WeChat
registerUpDown("ahk_class AddMemberWnd")
registerUpDown("ahk_class WeChatMainWndForPC")
registerUpDown("ahk_class ImagePreviewWnd")
registerUpDown("ahk_class CefWebViewWnd")
registerUpDown("ahk_class SelectContactWnd")
; Skype
registerUpDown("ahk_class tSkMainForm")
; HipChat
registerUpDown("ahk_exe HipChat.exe")
; Chrome
registerArrows("ahk_class Chrome_WidgetWin_1")
; Firefox
registerArrows("ahk_class MozillaWindowClass")
; Foxit Reader
registerArrows("ahk_class classFoxitReader")
; SumatraPDF
registerArrows("ahk_class SUMATRA_PDF_FRAME")
; Lingoes
registerArrows("ahk_exe Lingoes.exe")
; Double Commander
registerArrows("ahk_exe doublecmd.exe")
; Switcherwoo
registerArrows("ahk_exe switcheroo.exe")
