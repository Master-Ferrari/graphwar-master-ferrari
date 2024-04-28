#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%
ScriptDir := A_ScriptDir


Find(war, ImageFile){

    ImageFile := A_ScriptDir . "\elements\" . ImageFile

    CoordMode, Pixel, Screen
    CoordMode, Mouse, Screen
    SysGet, VirtualWidth, 78
    SysGet, VirtualHeight, 79
    if (war[3] != 0) {
        ImageSearch, FoundX, FoundY, 0, 0, VirtualWidth, VirtualHeight, *80 *TransBlack %ImageFile%
        if !ErrorLevel {
            Xfrom0 := FoundX - war[1]
            Yfrom0 := FoundY - war[2]
            return [Xfrom0, Yfrom0]
        }
    }
    ; MsgBox, not found
    return [0, 0]

}

war(){
    WinGetPos, X, Y, Width, Height, Graphwar
    return [X, Y, Width, Height]
}
