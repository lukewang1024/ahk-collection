; FWT - Fullscreen window toggle
; https://autohotkey.com/boards/viewtopic.php?p=123166#p123166
FWT(hwnd:="") {
  static MONITOR_DEFAULTTONEAREST := 0x00000002
  static WS_CAPTION               := 0x00C00000
  static WS_SIZEBOX               := 0x00040000
  static WindowStyle              := WS_CAPTION|WS_SIZEBOX
  static A                        := []

  ; If no window handle is supplied, use the window under the mouse
  if (!hwnd) {
    MouseGetPos,,, hwnd
  }
  Win := "ahk_id " hwnd   ; Store WinTitle
  WinGet, S, Style, % Win ; Get window style

  ; If not borderless
  if (S & WindowStyle) {
    A[Win, "Style"] := S & WindowStyle ; Store existing style
    WinGet, IsMaxed, MinMax, % Win     ; Get/store whether the window is maximized

    if (A[Win, "Maxed"] := IsMaxed = 1 ? true : false) {
      WinRestore, % Win
    }

    WinGetPos, X, Y, W, H, % Win         ; Store window size/location
    A[Win, "X"] := X, A[Win, "Y"] := Y, A[Win, "W"] := W, A[Win, "H"] := H
    WinSet, Style, % -WindowStyle, % Win ; Remove borders
    hMon := DllCall("User32\MonitorFromWindow", "Ptr", hwnd, "UInt", MONITOR_DEFAULTTONEAREST)
    VarSetCapacity(monInfo, 40), NumPut(40, monInfo, 0, "UInt")
    DllCall("User32\GetMonitorInfo", "Ptr", hMon, "Ptr", &monInfo)
    ; Move and resize window
    WinMove, % Win,,  monLeft   := NumGet(monInfo,  4, "Int")
                   ,  monTop    := NumGet(monInfo,  8, "Int")
                   , (monRight  := NumGet(monInfo, 12, "Int")) - monLeft
                   , (monBottom := NumGet(monInfo, 16, "Int")) - monTop
  }
  ; If borderless
  else if A[Win] {
    ; Reapply borders
    WinSet, Style, % "+" A[Win].Style, % Win

    ; Return to original position
    WinMove, % Win,, A[Win].X, A[Win].Y, A[Win].W, A[Win].H

    ; Maximize if required
    if (A[Win].Maxed) {
      WinMaximize, % Win
    }

    A.Delete(Win)
  }
}

#If GetKeyState("Alt", "P")

; Capslock+Alt+W to fullscreen the window under the mouse
Capslock & w::FWT()

#If

; Win+W to fullscreen the active window
Capslock & w::FWT(WinExist("A"))
