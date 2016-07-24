#Persistent
#SingleInstance force

SetWorkingDir %A_ScriptDir%\scripts\

DetectHiddenWindows On
SetTitleMatchMode 2

scriptCount = 0

OnExit ExitSub

Menu scripts_unopen, Add, Start script, Menu_Tray_Exit
Menu scripts_unopen, ToggleEnable, Start script
Menu scripts_unopen, Default, Start script
Menu scripts_unopen, Add
Menu scripts_unclose, Add, Stop script, Menu_Tray_Exit
Menu scripts_unclose, ToggleEnable, Stop script
Menu scripts_unclose, Default, Stop script
Menu scripts_unclose, Add
Menu scripts_edit, Add, Edit script, Menu_Tray_Exit
Menu scripts_edit, ToggleEnable, Edit script
Menu scripts_edit, Default, Edit script
Menu scripts_edit, Add
Menu scripts_reload, Add, Reload script, Menu_Tray_Exit
Menu scripts_reload, ToggleEnable, Reload script
Menu scripts_reload, Default, Reload script
Menu scripts_reload, Add

; Traverse ahk files under scripts folder
Loop, %A_ScriptDir%\scripts\*.ahk
{
    StringRePlace menuName, A_LoopFileName, .ahk

    scriptCount += 1
    scripts%scriptCount%0 := A_LoopFileName

    IfWinExist %A_LoopFileName% - AutoHotkey    ; Already open
    {
        Menu scripts_unclose, add, %menuName%, tsk_close
        scripts%scriptCount%1 = 1
    }
    else
    {
        Menu scripts_unopen, add, %menuName%, tsk_open
        scripts%scriptCount%1 = 0
    }
    Menu scripts_edit, add, %menuName%, tsk_edit
    Menu scripts_reload, add, %menuName%, tsk_reload
}


; Add management buttons
Menu, Tray, Icon, %A_ScriptDir%\resources\ahk.ico
Menu, Tray, Click, 1
Menu, Tray, Tip, AHK Script Manager
Menu, Tray, Add, AHK Script Manager, Menu_Show
Menu, Tray, ToggleEnable, AHK Script Manager
Menu, Tray, Default, AHK Script Manager
Menu, Tray, Add
Menu, Tray, Add, Start all scripts(&A)`tCtrl + Alt + Shift + Q, tsk_openAll
Menu, Tray, Add, Start script(&O)`tCtrl + Alt + Shift + W, :scripts_unopen
Menu, Tray, Add, Stop all scripts(&L)`tCtrl + Alt + Shift + A, tsk_closeAll
Menu, Tray, Add, Stop script(&C)`tCtrl + Alt + Shift + S, :scripts_unclose
Menu, Tray, Add
Menu, Tray, Add, Edit script(&I)`tCtrl + Alt + Shift + E, :scripts_edit
Menu, Tray, Add, Reload script(&S)`tCtrl + Alt + Shift + D, :scripts_reload
Menu, Tray, Add
Menu, Tray, Add, Open AHK Manager folder(&D)`t%A_ScriptDir%, Menu_Tray_OpenDir
Menu, Tray, Add
Menu, Tray, Add, Restart AHK Manager(&R), Menu_Tray_Reload
Menu, Tray, Add
Menu, Tray, Add, Edit AHK Manager code(&E), Menu_Tray_Edit
Menu, Tray, Add
Menu, Tray, Add, Exit(&X)`tCtrl + Alt + Shift + X, Menu_Tray_Exit
Menu, Tray, NoStandard

GoSub tsk_openAll

Return

tsk_openAll:
Loop, %scriptCount%
{
    thisScript := scripts%A_index%0
    If scripts%A_index%1 = 0    ; not open
    {
        ifinstring, thisScript, !
	    continue
        IfWinNotExist %thisScript% - AutoHotkey    ; not open
            Run %A_ScriptDir%\scripts\%thisScript%

        scripts%A_index%1 = 1

        StringRePlace menuName, thisScript, .ahk
        Menu scripts_unclose, add, %menuName%, tsk_close
        Menu scripts_unopen, delete, %menuName%
    }
}
Return

tsk_open:
Loop, %scriptCount%
{
    thisScript := scripts%A_index%0
    If thisScript = %A_thismenuitem%.ahk  ; match found.
    {
        IfWinNotExist %thisScript% - AutoHotkey    ; not open
            Run %A_ScriptDir%\scripts\%thisScript%

        scripts%A_index%1 := 1

        Menu scripts_unclose, add, %A_thismenuitem%, tsk_close
        Menu scripts_unopen, delete, %A_thismenuitem%

        Break
    }
}
Return

tsk_close:
Loop, %scriptCount%
{
    thisScript := scripts%A_index%0
    If thisScript = %A_thismenuitem%.ahk  ; match found.
    {
        WinClose %thisScript% - AutoHotkey
        scripts%A_index%1 := 0

        Menu scripts_unopen, add, %A_thismenuitem%, tsk_open
        Menu scripts_unclose, delete, %A_thismenuitem%

        Break
    }
}
Return

tsk_closeAll:
Loop, %scriptCount%
{
    thisScript := scripts%A_index%0
    If scripts%A_index%1 = 1  ; Already open
    {
        WinClose %thisScript% - AutoHotkey
        scripts%A_index%1 = 0

        StringRePlace menuName, thisScript, .ahk
        Menu scripts_unopen, add, %menuName%, tsk_open
        Menu scripts_unclose, delete, %menuName%
    }
}
Return

tsk_edit:
Run, edit %A_ScriptDir%\scripts\%A_thismenuitem%.ahk
Return

tsk_reload:
Loop, %scriptCount%
{
    thisScript := scripts%A_index%0
    If thisScript = %A_thismenuitem%.ahk  ; match found.
    {
        WinClose %thisScript% - AutoHotkey
        Run %A_ScriptDir%\scripts\%thisScript%
        Break
    }
}
Return

+^!Z::
    Menu, Tray, Show
Return

+^!X::
	Goto Menu_Tray_Exit
Return

+^!Q::
	Goto tsk_openAll
Return

+^!W::
	Menu, scripts_unopen, Show
Return

+^!A::
	Goto tsk_closeAll
Return

+^!S::
	Menu, scripts_unclose, Show
Return

+^!E::
	Menu, scripts_edit, Show
Return

+^!D::
	Menu, scripts_reload, Show
Return

Menu_Tray_OpenDir:
	Run %A_ScriptDir%
Return

Menu_Tray_Exit:
	ExitApp
Return

Menu_Tray_Reload:
	Reload
Return

Menu_Tray_Edit:
	Edit
Return

ExitSub:
    Loop, %scriptCount%
    {
        thisScript := scripts%A_index%0
        If scripts%A_index%1 = 1  ; Already open
        {
            WinClose %thisScript% - AutoHotkey
            scripts%A_index%1 = 0

            StringRePlace menuName, thisScript, .ahk
        }
    }
	Menu, Tray, NoIcon
    ExitApp
Return

Menu_Show:
    Menu, Tray, Show
Return
