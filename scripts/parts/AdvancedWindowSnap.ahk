/**
 * Advanced Window Snap
 */
SnapActiveWindow(winPlaceHorizontal, winPlaceVertical, winSizeWidth, winSizeHeight) {
  WinGet, activeWin, ID, A
  if (activeWin == 0) {
      return
  }

  ; Some apps cannot be moved when maximized
  WinGet, minMax, MinMax, ahk_id %activeWin%
  if (minMax == 1) {
      WinRestore, ahk_id %activeWin%
  }

  activeMon := GetMonitorIndexFromWindow(activeWin)
  SysGet, workArea, MonitorWorkArea, %activeMon%

  workAreaWidth := workAreaRight - workAreaLeft
  workAreaHeight := workAreaBottom - workAreaTop

  width := workAreaWidth * winSizeWidth
  height := workAreaHeight * winSizeHeight
  posX := workAreaLeft + workAreaWidth * winPlaceHorizontal
  posY := workAreaTop + workAreaHeight * winPlaceVertical

  WinMove, A, , %posX%, %posY%, %width%, %height%
}

/**
 * GetMonitorIndexFromWindow retrieves the HWND (unique ID) of a given window.
 * @param {Uint} windowHandle
 * @author shinywong
 * @link http://www.autohotkey.com/board/topic/69464-how-to-determine-a-window-is-in-which-monitor/?p=440355
 */
GetMonitorIndexFromWindow(windowHandle) {
  ; Starts with 1.
  monitorIndex := 1

  VarSetCapacity(monitorInfo, 40)
  NumPut(40, monitorInfo)

  if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2))
    && DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo) {
    monitorLeft   := NumGet(monitorInfo,  4, "Int")
    monitorTop    := NumGet(monitorInfo,  8, "Int")
    monitorRight  := NumGet(monitorInfo, 12, "Int")
    monitorBottom := NumGet(monitorInfo, 16, "Int")
    workLeft      := NumGet(monitorInfo, 20, "Int")
    workTop       := NumGet(monitorInfo, 24, "Int")
    workRight     := NumGet(monitorInfo, 28, "Int")
    workBottom    := NumGet(monitorInfo, 32, "Int")
    isPrimary     := NumGet(monitorInfo, 36, "Int") & 1

    SysGet, monitorCount, MonitorCount

    Loop, %monitorCount% {
      SysGet, tempMon, Monitor, %A_Index%

      ; Compare location to determine the monitor index.
      if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
        and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom)) {
        monitorIndex := A_Index
        break
      }
    }
  }

  return %monitorIndex%
}

#If GetKeyState("Ctrl", "P") and !GetKeyState("Alt", "P")

Capslock & Up::    SnapActiveWindow(  0,  0,  1, .8 )
Capslock & Down::  SnapActiveWindow(  0, .8,  1, .2 )
Capslock & Left::  SnapActiveWindow(  0,  0, .8,  1 )
Capslock & Right:: SnapActiveWindow( .8,  0, .2,  1 )

Capslock & Numpad7::SnapActiveWindow(  0,  0, .2, .5 )
Capslock & Numpad8::SnapActiveWindow(  0,  0,  1, .8 )
Capslock & Numpad9::SnapActiveWindow( .8,  0, .2, .5 )
Capslock & Numpad4::SnapActiveWindow(  0,  0, .8,  1 )
Capslock & Numpad5::SnapActiveWindow(  0,  0,  1,  1 )
Capslock & Numpad6::SnapActiveWindow( .2,  0, .8,  1 )
Capslock & Numpad1::SnapActiveWindow(  0, .5, .2, .5 )
Capslock & Numpad2::SnapActiveWindow(  0, .8,  1, .2 )
Capslock & Numpad3::SnapActiveWindow( .8, .5, .2, .5 )

#If !GetKeyState("Ctrl", "P") and GetKeyState("Alt", "P")

Capslock & Up::    SnapActiveWindow(  0,  0,  1, .6 )
Capslock & Down::  SnapActiveWindow(  0, .6,  1, .4 )
Capslock & Left::  SnapActiveWindow(  0,  0, .6,  1 )
Capslock & Right:: SnapActiveWindow( .6,  0, .4,  1 )

Capslock & Numpad7::SnapActiveWindow(  0,  0, .4, .5 )
Capslock & Numpad8::SnapActiveWindow(  0,  0,  1, .6 )
Capslock & Numpad9::SnapActiveWindow( .6,  0, .4, .5 )
Capslock & Numpad4::SnapActiveWindow(  0,  0, .6,  1 )
Capslock & Numpad5::SnapActiveWindow(  0,  0,  1,  1 )
Capslock & Numpad6::SnapActiveWindow( .4,  0, .6,  1 )
Capslock & Numpad1::SnapActiveWindow(  0, .5, .4, .5 )
Capslock & Numpad2::SnapActiveWindow(  0, .6,  1, .4 )
Capslock & Numpad3::SnapActiveWindow( .6, .5, .4, .5 )

#If GetKeyState("Ctrl", "P") and GetKeyState("Alt", "P")

Capslock & Numpad7::SnapActiveWindow(   0,  0, .33, .5 )
Capslock & Numpad8::SnapActiveWindow( .33,  0, .33, .5 )
Capslock & Numpad9::SnapActiveWindow( .67,  0, .33, .5 )
Capslock & Numpad4::SnapActiveWindow(   0,  0, .33,  1 )
Capslock & Numpad5::SnapActiveWindow( .33,  0, .33,  1 )
Capslock & Numpad6::SnapActiveWindow( .67,  0, .33,  1 )
Capslock & Numpad1::SnapActiveWindow(   0, .5, .33, .5 )
Capslock & Numpad2::SnapActiveWindow( .33, .5, .33, .5 )
Capslock & Numpad3::SnapActiveWindow( .67, .5, .33, .5 )

#If

Capslock & Up::    SnapActiveWindow(  0,  0,  1, .7 )
Capslock & Down::  SnapActiveWindow(  0, .7,  1, .3 )
Capslock & Left::  SnapActiveWindow(  0,  0, .7,  1 )
Capslock & Right:: SnapActiveWindow( .7,  0, .3,  1 )

Capslock & Numpad7::SnapActiveWindow(  0,  0, .3, .5 )
Capslock & Numpad8::SnapActiveWindow(  0,  0,  1, .7 )
Capslock & Numpad9::SnapActiveWindow( .7,  0, .3, .5 )
Capslock & Numpad4::SnapActiveWindow(  0,  0, .7,  1 )
Capslock & Numpad5::SnapActiveWindow(  0,  0,  1,  1 )
Capslock & Numpad6::SnapActiveWindow( .3,  0, .7,  1 )
Capslock & Numpad1::SnapActiveWindow(  0, .5, .3, .5 )
Capslock & Numpad2::SnapActiveWindow(  0, .7,  1, .3 )
Capslock & Numpad3::SnapActiveWindow( .7, .5, .3, .5 )

; For keyboards without NumberPad keys
^#!i::SnapActiveWindow(  0,  0, .3, .5 )
^#!o::SnapActiveWindow(  0,  0,  1, .7 )
^#!p::SnapActiveWindow( .7,  0, .3, .5 )
^#!k::SnapActiveWindow(  0,  0, .7,  1 )
^#!l::SnapActiveWindow(  0,  0,  1,  1 )
^#!;::SnapActiveWindow( .3,  0, .7,  1 )
^#!,::SnapActiveWindow(  0, .5, .3, .5 )
^#!.::SnapActiveWindow(  0, .7,  1, .3 )
^#!/::SnapActiveWindow( .7, .5, .3, .5 )
