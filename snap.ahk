#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Resizes and moves around the active windows into a specified position
SplitActiveWindow(winPlaceVertical, winPlaceHorizontal, winPlaceHeight) {
    Send l^c^w^n^v{enter} ; windows really hates this kind of thing 
    sleep 500 ; this is just to stop it from having issues 
    SnapCurrentWindow(winPlaceVertical, winPlaceHorizontal, winPlaceHeight)
}

SnapCurrentWindow(winPlaceVertical, winPlaceHorizontal, winPlaceHeight) {
    WinGet activeWin, ID, a;
    activeMonitor := GetMonitorIndexFromWindow(activeWin)
    SysGet MonitorWorkArea, MonitorWorkArea %activeWin%

    ; determine where on the monitor the window is going to be placed
    Switch winSizeHeight {
        case "half":
            height := MonitorWorkArea - MonitorWorkArea / 2
            text . 
            return 
        case "full":
            height := MonitorWorkAreaBottom - MonitorWorkAreaTop
            text .
            return 
        case "third":
        height := MonitorWorkAreaBottom - MonitorWorkAreaTop
    }

    Switch winPlaceHorizontal {
        case "left":
            posX := MonitorWorkAreaLeft
            width := MonitorWorkAreaRight - MonitorWorkAreaLeft / 2
            text .
            return 
        case "right":
            posX := MonitorWorkAreaLeft + MonitorWorkAreaRight - MonitorWorkAreaLeft / 2
            width := MonitorWorkAreaRight - MonitorWorkAreaLeft / 2
        default:
            posX := MonitorWorkAreaLeft
            width := MonitorWorkAreaRight - MonitorWorkAreaLeft
    }

    Switch winPlaceVertical {
        case "bottom":
            posY := MonitorWorkAreaBottom - height 
            text .
            return 
        case "middle":
            posY := MonitorWorkAreaTop + height 
            text .
            return 
        default:
            posY := MonitorWorkAreaTop
    }

    WinMove, A,, %posY%, %posX%, %width%, %height%
}

ShrinkWindow(command) {
    WinGet activeWin, ID, A
    activeMonitor GetMonitorIndexFromWindow(activeWin)
    SysGet, MonitorWorkArea, MonitorWorkArea, %activeMonitor%

    switch Command {
        case "halfbottonm":
            height := height / 2
            posY := posY + height
            return 
        case "halfright":
            width := width / 2 
            posX := posX + width
            return 
        case "halfleft":
            width := width / 2
            return 
        case "halftopleft":
            height := height / 2 
            width := width / 2
            return 
        case "halftopright":
            height := height / 2
            width /= 2
            posX := posX + width
    }

    WinMove, A, %posX%, %posY%, %width%, %height%
}
; TODO change this - something wrong here 
GetMonitorIndexFromWindow(windowHandle) {
    index := 0
    SysGet, monitorCount, MonitorCount, tempMon, Monitor, %A_Index%
    VarSetCapacity(monitorInfo [ 40, RequestedCapacity, FillByte])
    NumPut(40, VarOrAddress [monitorInfo, Offset = 0, Type = "UInt"])

    ; set the monitor values 
    {
        monitorLeft := NumGet(monitorInfo [4, Offset = 0, Type = "UInt"])
        monitorTop := NumGet(monitorInfo, [8, Offset = 0, Type = "UInt"])
        monitorRight := NumGet(monitorInfo, [12, Offset = 0, Type = "UInt"])
        monitorBottom := NumGet(monitorInfo, [16, Offset = 0, Type = "UInt"])
        isPrimary := NumGet(monitorInfo [36, Offset = 0, Type = "UInt"])
    }

    Loop, %monitorCount% {
        if((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop) and (monitorRight = tempoMonRight) and (monitorBottom = tempMonBottom)) {
            index := A_Index
            break
        }
    }

    return %index%
}

#Numpad7::SnapCurrentWindow("top","left","half")
#Numpad8::SnapCurrentWindow("top","full","half")
#Numpad9::SnapCurrentWindow("top","right","half")
#Numpad4::SnapCurrentWindow("top","left","full")
#Numpad6::SnapCurrentWindow("top","right","full")
#Numpad1::SnapCurrentWindow("bottom","left","half")
#Numpad2::SnapCurrentWindow("bottom","full","half")
#Numpad3::SnapCurrentWindow("bottom","right","half")
#!Numpad7::shrinkWindow("halftopleft")
#!Numpad8::shrinkWindow("halftop")
#!Up::shrinkWindow("halftop")
#!Numpad9::shrinkWindow("halftopright")
#!Numpad4::shrinkWindow("halfleft")
#!Left::shrinkWindow("halfleft")
#!Right::shrinkWindow("halfright")
#!Numpad6::shrinkWindow("halfright")
#!Numpad1::shrinkWindow("halfbottomleft")
#!Numpad2::shrinkWindow("halfbottom")
#!Down::shrinkWindow("halfbottom")
#!Numpad3::shrinkWindow("halfbottomright")