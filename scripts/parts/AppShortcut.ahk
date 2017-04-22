; Toggle ST3 visibility: Capslock (Ctrl-Alt-Win) + s
^!#s::
toggleAppWindow("ahk_class PX_WINDOW_CLASS ahk_exe sublime_text.exe")
return

; Toggle Atom visibility: Capslock (Ctrl-Alt-Win) + a
^!#a::
toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe atom.exe")
return

; Toggle VS Code visibility: Capslock (Ctrl-Alt-Win) + v
^!#v::
toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe")
return

; Toggle Chrome visibility: Capslock (Ctrl-Alt-Win) + c
^!#c::
toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe")
return

; Toggle WeChat visibility: Capslock (Ctrl-Alt-Win) + h
^!#h::
toggleAppWindowWithTray("WeChat.exe")
return

; Toggle Skype visibility: Capslock (Ctrl-Alt-Win) + o
^!#o::
toggleAppWindowWithTray("Skype.exe", true)
return

; Toggle Slack visibility: Capslock (Ctrl-Alt-Win) + u
^!#u::
toggleAppWindow("ahk_class Chrome_WidgetWin_1 ahk_exe slack.exe")
return

; Toggle Whatsapp visibility: Capslock (Ctrl-Alt-Win) + i
^!#i::
toggleAppWindow("WhatsApp ahk_exe WhatsApp.exe")
return

; Toggle Postman visibility: Capslock (Ctrl-Alt-Win) + y
^!#y::
toggleAppWindow("Postman ahk_class Chrome_WidgetWin_1")
return
