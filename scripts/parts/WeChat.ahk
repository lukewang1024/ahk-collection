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

#include Utils.ahk

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
}

clickWechatChatItem(index)
{
  chatListPosX := 60
  chatListPosY := 62
  chatItemW := 240
  chatItemH := 63
  chatItemClickX := chatListPosX + chatItemW / 2
  chatItemClickY := chatListPosY + chatItemH / 2
  clickAndBack(chatItemClickX, chatItemClickY + index * chatItemH)
}

sendSticker()
{
  clickAndBack(A_CaretX + 2, A_CaretY - 2)
  WinActivate, ahk_class WeChatMainWndForPC
}

#IfWinActive ahk_class WeChatMainWndForPC
!s::sendSticker()
!x::clickAndBack(175, 37)
!n::clickAndBack(284, 37)
!c::clickFirstToggle()
!g::
PixelGetColor, testColor, 150, 380
if testColor <> 0xDEDEDE
{
  clickFirstToggle()
  return
}
clickAndBack(260, 380)
return
^1::clickAndBack(30, 90)
^2::clickAndBack(30, 145)
^3::clickAndBack(30, 190)

^,::
WinGetPos, , , , h, A
click1 := [30, h - 25]
click2 := [70, 65]
multipleClickAndBack([ click1, click2 ])
return

!1::clickWechatChatItem(0)
!2::clickWechatChatItem(1)
!3::clickWechatChatItem(2)
!4::clickWechatChatItem(3)
!5::clickWechatChatItem(4)
!6::clickWechatChatItem(5)
!7::clickWechatChatItem(6)
!8::clickWechatChatItem(7)
!9::clickWechatChatItem(8)

#IfWinActive ahk_class ChatWnd
!s::sendSticker()

#IfWinActive ahk_class AddMemberWnd
!x::clickAndBack(50, 25)

#IfWinActive, ahk_class SelectContactWnd
!x::clickAndBack(50, 25)

#IfWinActive ahk_class ImagePreviewWnd
r::
WinGetPos, , , w, h, A
clickAndBack(w / 2 + 60, h - 40)
return

s::Send ^s
j::Send {Right}
k::Send {Left}

#IfWinActive ahk_class CefWebViewWnd
!x::
WinGetPos, , , w
clickAndBack(w - 25, 65)
return

; Clean up the directive to avoid messing up with other code
#ifwinactive
