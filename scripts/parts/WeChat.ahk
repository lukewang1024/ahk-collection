; Set of keyboard shortcuts for WeChat common use cases
;
; ===== List of key bindings =====
;
; [ Shared between different window types if applicable ]
; Alt+x: Focus on search box
; Alt+j: Down
; Alt+k: Up
;
; [ Main Window ]
; Alt+s: Send the hint sticker
; Ctrl+1~3: Switch to Chats, Contacts, and Favorites respectively
; Ctrl+,: Open settings
; Alt+1~8: Switch to the 1~8-th conversation from the top of the list
; Alt+c: Expand/Collapse all contacts in search results
; Alt+g: Expand/Collapse all groups in search results
;
; [ Image Preview ]
; j: Right
; k: Left
; s: Save as
; r: Rotate image
;
; [ WebView ]
; Alt+x: Open the hamburger menu
;

SetDefaultMouseSpeed, 0

#IfWinActive ahk_class WeChatMainWndForPC
!s::
clickAndBack(A_CaretX + 2, A_CaretY - 2)
return
!x::
clickAndBack(80, 30)
return
!n::
clickAndBack(275, 30)
return
!c::
clickFirstToggle()
return
!g::
PixelGetColor, testColor, 150, 380
if testColor <> 0xDEDEDE
{
  clickFirstToggle()
  return
}
clickAndBack(260, 380)
return
^1::
clickAndBack(25, 70)
return
^2::
clickAndBack(25, 120)
return
^3::
clickAndBack(25, 160)
return
^,::
WinGetPos, , , , h, A
clickAndBack(25, h - 25)
return
!1::
clickAndBack(180, 70)
return
!2::
clickAndBack(180, 130)
return
!3::
clickAndBack(180, 200)
return
!4::
clickAndBack(180, 260)
return
!5::
clickAndBack(180, 330)
return
!6::
clickAndBack(180, 390)
return
!7::
clickAndBack(180, 450)
return
!8::
clickAndBack(180, 520)
return
!9::
clickAndBack(180, 570)
return

#IfWinActive ahk_class AddMemberWnd
!x::
clickAndBack(50, 25)
return

#IfWinActive, ahk_class SelectContactWnd
!x::
clickAndBack(50, 25)
return

#IfWinActive ahk_class ImagePreviewWnd
r::
WinGetPos, , , w, h, A
clickAndBack(w / 2 + 60, h - 40)
return
s::
Send ^s
return
j::
Send {Right}
return
k::
Send {Left}
return

#IfWinActive ahk_class CefWebViewWnd
!x::
WinGetPos, , , w
clickAndBack(w - 25, 65)
return

; Clean up the directive to avoid messing up with other code
#ifwinactive

;
; Util functions
;

clickFirstToggle()
{
  PixelGetColor, testColor, 150, 60
  if testColor <> 0xDEDEDE
  {
    return
  }
  clickAndBack(260, 60)
  return
}
