; Wrapper script for RunZ.ahk

#NoEnv
#NoTrayIcon
#Persistent
#SingleInstance force

DetectHiddenWindows On
SetTitleMatchMode 2

Run %A_ScriptDir%\runz\RunZ.ahk
ExitApp
