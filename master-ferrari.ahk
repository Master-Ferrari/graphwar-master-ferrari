liness := []
Xo := 1
Yo := -21

Menu, Tray, Icon, %A_WorkingDir%\elements\icon.png, , 1

#singleinstance,force
setbatchlines,-1
settitlematchmode,2

#include shinsoverlayclass.ahk
#Include vision.ahk

if (!WinExist("Graphwar")) {
    msgbox % "Please open a Graphwar window and press OK to reload"
    reload
}
WinActivate, Graphwar

overlay := new ShinsOverlayClass("Graphwar")

settimer,draw,10

war := war()
me := Find(war, "me.png")
if (me!=[0,0])
    liness.Push([me[1]+Xo,me[2]+Yo,me[1]+Xo,me[2]+Yo])

draw:
    if (overlay.BeginDraw()) {

        l:=liness.MaxIndex()

        if (l>0) {

            for k, i in liness
            {
                overlay.DrawLine(liness[k][1],liness[k][2],liness[k][3],liness[k][4],0x6000FF00, 4)
            }

            if (overlay.GetMousePos(x,y))
            {
                if (x>liness[l][3]){
                    overlay.DrawCircle(x,y,9,0xFF00FF00,2)
                    overlay.DrawLine(x,15,x,465,0xFF00FF00, 1)
                    overlay.DrawLine(liness[l][3],liness[l][4],x,y,0xFF00FF00, 1)
                }
                else{
                    overlay.DrawCircle(x,y,3,0xFFFF0000,5)
                    overlay.DrawLine(liness[l][3],liness[l][4],x,y,0xFFFF0000, 1)
                }

                if (l==1){
                    overlay.DrawLine(liness[l][3],liness[l][2]-20,liness[l][3],liness[l][2]+20,0xFFFF0000, 1)
                    overlay.DrawLine(liness[l][3]-20,liness[l][2],liness[l][3]+20,liness[l][2],0xFFFF0000, 1)
                }
                else{
                    overlay.DrawLine(liness[l][3],15,liness[l][3],465,0xFFFF0000, 1)
                }
            }

        }
        overlay.EndDraw()
    }
return

pasteTEXT(TEXT){
    SAVED := Clipboard
    Clipboard := TEXT
    Sleep, 500
    Send, ^v
    Clipboard := SAVED
}

adaptX(x){
    return (x-15)/770*50-25
}
adaptY(y){
    return -((y+15)/460*30-15)+2
}

#IfWinActive Graphwar

    ~~Space::
        toggle := !toggle
        if (toggle) {
            settimer,draw,10
        } else {
            settimer,draw,off
            overlay.BeginDraw()
            overlay.EndDraw()
        }
    return

    esc::exitapp

    ~~LButton::
        if (overlay.GetMousePos(x,y))
        {
            l:=liness.MaxIndex()
            if (x>liness[l][3])
            {
                liness.Push([liness[l][3],liness[l][4],x,y])
            }
            else
            {
                liness.Pop()
            }
        }
    return
    ~~RButton::
        liness.Pop()
    return

    Backspace::
        liness :=[]
        overlay.Clear()

        war := war()
        if (me!=[0,0])
            me := Find(war, "me.png")

        liness.Push([me[1]+Xo,me[2]+Yo,me[1]+Xo,me[2]+Yo])

    Return

    Enter::

        ans:=""
        for k, i in liness
        {
            if (k!=0){
                X1 := adaptX(liness[k][1])
                Y1 := adaptY(liness[k][2])
                X2 := adaptX(liness[k][3])
                Y2 := adaptY(liness[k][4])

                A := (Y2-Y1)/(X2-X1)
                p := A . "(abs(x-(" . X1 . "))+x-(" . X1 . "))/2"
                n := A . "(abs(" . X2 . "-x)+x-(" . X2 . "))/2"
                ans:= ans . " +" . p . "-(" . n . ")"
            }
        }

        ; liness :=[]
        ; overlay.Clear()
        CoordMode, Mouse, Relative
        MouseMove, 220, 520
        Sleep, 100
        Click
        Send, ^a
        Sleep, 100
        pasteTEXT(ans)
        ; Send, %ans%
        Sleep, 500
        Send, {Enter}

    Return

#If