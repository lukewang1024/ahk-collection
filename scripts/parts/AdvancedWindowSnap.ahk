/**
 * Advanced Window Snap
 */
SnapActiveWindow(winPlaceHorizontal, winPlaceVertical, winSizeWidth, winSizeHeight) {
  WinGet activeWin, ID, A
  activeMon := GetMonitorIndexFromWindow(activeWin)

  SysGet, MonitorWorkArea, MonitorWorkArea, %activeMon%

  width := MonitorWorkAreaRight - MonitorWorkAreaLeft
  if (winSizeWidth == "half") {
    width := width / 2
  } else if (winSizeWidth == "third") {
    width := width / 3
  } else if (winSizeWidth == "2third") {
    width := width / 3 * 2
  }

  height := MonitorWorkAreaBottom - MonitorWorkAreaTop
  if (winSizeHeight == "half") {
    height := height / 2
  } else if (winSizeHeight == "third") {
    height := height / 3
  } else if (winSizeHeight == "2third") {
    height := height / 3 * 2
  }

  if (winPlaceHorizontal == "right") {
    posX := MonitorWorkAreaRight - width
  } else if (winPlaceHorizontal == "middle") {
    posX := MonitorWorkAreaLeft + width
  } else {
    posX := MonitorWorkAreaLeft
  }

  if (winPlaceVertical == "bottom") {
    posY := MonitorWorkAreaBottom - height
  } else {
    posY := MonitorWorkAreaTop
  }

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

; Directional Arrow Hotkeys
#!Up::    SnapActiveWindow("left", "top", "full", "half")
#!Down::  SnapActiveWindow("left", "bottom", "full", "half")
^#!Up::   SnapActiveWindow("left", "top", "full", "third")
^#!Down:: SnapActiveWindow("left", "bottom", "full", "third")
+#!Up::   SnapActiveWindow("left", "top", "full", "2third")
+#!Down:: SnapActiveWindow("left", "bottom", "full", "2third")
#!Left::  SnapActiveWindow("left", "top", "half", "full")
#!Right:: SnapActiveWindow("right", "top", "half", "full")
^#!Left:: SnapActiveWindow("left", "top", "third", "full")
^#!Right::SnapActiveWindow("right", "top", "third", "full")
+#!Left:: SnapActiveWindow("left", "top", "2third", "full")
+#!Right::SnapActiveWindow("right", "top", "2third", "full")

; Numberpad Hotkeys (Landscape)
^#!Numpad7::SnapActiveWindow("left", "top", "third", "half")
^#!Numpad8::SnapActiveWindow("middle", "top", "third", "half")
^#!Numpad9::SnapActiveWindow("right", "top", "third", "half")
^#!Numpad4::SnapActiveWindow("left", "top", "third", "full")
^#!Numpad5::SnapActiveWindow("middle", "top", "third", "full")
^#!Numpad6::SnapActiveWindow("right", "top", "third", "full")
^#!Numpad1::SnapActiveWindow("left", "bottom", "third", "half")
^#!Numpad2::SnapActiveWindow("middle", "bottom", "third", "half")
^#!Numpad3::SnapActiveWindow("right", "bottom", "third", "half")

; For keyboards without NumberPad keys
+#!i::SnapActiveWindow("left", "top", "third", "half")
+#!o::SnapActiveWindow("middle", "top", "third", "half")
+#!p::SnapActiveWindow("right", "top", "third", "half")
+#!k::SnapActiveWindow("left", "top", "third", "full")
+#!l::SnapActiveWindow("middle", "top", "third", "full")
+#!;::SnapActiveWindow("right", "top", "third", "full")
+#!,::SnapActiveWindow("left", "bottom", "third", "half")
+#!.::SnapActiveWindow("middle", "bottom", "third", "half")
+#!/::SnapActiveWindow("right", "bottom", "third", "half")
