#SingleInstance Force
#NoEnv
#NoTrayIcon
#Persistent ; NEEDED

SetTimer NoScreenSaver, 600000
return

NoScreenSaver:
    Send {Ctrl}
return
