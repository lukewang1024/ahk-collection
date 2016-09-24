#SingleInstance Force
#NoEnv
#NoTrayIcon
#Persistent ; NEEDED

SetTimer NoScreenSaver, 600000

return

NoScreenSaver:
    ; If need to check for existence of a process
    ; Process Exist, Notepad.exe
    ; If (!ErrorLevel)
    ; {
    ;     MsgBox No Notepad!
    ;     return
    ; }
    Send {Ctrl}
return
