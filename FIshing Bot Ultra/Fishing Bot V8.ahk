
WinGet, active_id, ID, Minecraft
WinGetClass, Active_Class, Minecraft
SetWorkingDir %A_ScriptDir%
#Include Gdip_All.ahk
#Include Gdip_ImageSearch.ahk
#MaxThreadsperHotkey 1
#SingleInstance force
CoordMode, Pixel, screen
;=========================================================================
count := 0

global XF1, YF1, BobberFound, active_id, Count, SplashObj, DrawObj, Active_Class,

IF !pToken := Gdip_Startup()
{
	    MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	    ExitApp
}
OnExit, Exit

Font = Arial

IF !Gdip_FontFamilyCreate(Font)
{
	MsgBox, 48, Font error!, The font you have specIFied does not exist on the system
	ExitApp
}
OnExit, Exit




Gui Splash: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow + OwnDialogs
Gui Splash: Show, NA
SplashObj := WinExist()

Gui Draw: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow + OwnDialogs
Gui Draw: Show, NA
DrawObj := WinExist()




Script:
while(!KeepGoing){
	UpdateSplash(Font,"Press Control+k to Start Fishing`nPress Control+p to Exit")
	
	If Getkeystate("F7"){
		Gui Draw: Show, NA
		UpdateDraw(0,0)
	} Else {
		Gui Draw: Hide	
	}
}

Search:
BobberSearch()

IF (!KeepGoing){
	goto, Script
}


IF (BobberFound = 0) {
	ToolboxSearch()
	goto, search
}

While (BobberFound = 1) {
	If Getkeystate("F7"){
		Gui Draw: Show, NA
	} Else {
		Gui Draw: Hide	
	}
	UpdateDraw(XF1,YF1)
	UpdateSplash(Font,"Tracking at x: " . XF1 . " y: " . YF1  )
	BobberSearch()
	
	IF (!KeepGoing) { 	
		goto, Script
	}
}	

if (BobberFound = 0) {
	UpdateSplash(Font,"Nibble?!")
	Sleep 100
	BobberSearch()
	If (BobberFound = 0 ) {
		UpdateSplash(Font,"***FISH ON***")
		ControlClick, x605 y635, ahk_class %Active_Class%, , Right, 1, NA
		Sleep 100
		loop, 12 {
			ControlClick, x605 y635, ahk_class %Active_Class%, , Right, 1, NA
			Sleep 60
		}
		send 5
		Sleep 100
		send 4
		Sleep 1500	
		goto search
	}
	
	goto search
}



 

BobberSearch()
{
	
	
	IF (BobberFound = 1){
		X := XF1-30
		Y := YF1-30
		X1 := XF1+30
		Y1 := YF1+30
		
	}Else{
		X := 0
		Y := 0
		X1 := 0
		Y1 := 0
		
	}
	
	bmpHaystack := Gdip_BitmapFromHWND(active_id)
	bmpNeedle := Gdip_CreateBitmapFromFile("bobber_3.png")
	Search := Gdip_ImageSearch(bmpHaystack,bmpNeedle,T,X,Y,X1,Y1,40,0xFFFFFF,1)
	Gdip_DisposeImage(bmpHaystack)
	Gdip_DisposeImage(bmpNeedle)
	
	Word_Array := StrSplit(T , ",", ",")
	
	YF1 :=  Word_Array[2]
	XF1 := Word_Array[1]
	
	IF (Search = 1){
		
		BobberFound = 1
	} Else {		
		
		BobberFound = 0
	} 
	
} Return


ToolboxSearch()
{
	If Getkeystate("F7"){
		Gui Draw: Show, NA
	} Else {
		Gui Draw: Hide	
	}
	
	bmpHaystack := Gdip_BitmapFromHWND(active_id)
	bmpToolbox := Gdip_CreateBitmapFromFile("ToolBox_2.png")
	bmpReel := Gdip_CreateBitmapFromFile("FishingReel.png")
	bmpEnchanted := Gdip_CreateBitmapFromFile("FishingReelEnchanted.png")
	bmpBrokenRod := Gdip_CreateBitmapFromFile("Broken_Rod.png")		
	
	Toolbox := Gdip_ImageSearch(bmpHaystack,bmpToolbox,W, 0, 0, 0, 0,40,0xFFFFFF,1)
	Gdip_DisposeImage(bmpToolbox)	
	Word_Array := StrSplit(W , ",", ",")
	XTB1 :=  Word_Array[1]
	YTB1 := Word_Array[2]
	UpdateDraw(XTB1,YTB1)
	Reel := Gdip_ImageSearch(bmpHaystack,bmpReel,W,XTB1, YTB1, XTB1 + 40, YTB1 + 40,25,0xFFFFFF,1)
	Gdip_DisposeImage(bmpReel)
	
	
	Enchanted := Gdip_ImageSearch(bmpHaystack,bmpEnchanted,W,XTB1, YTB1, XTB1 + 40, YTB1 + 40,40,0xFFFFFF,1)
	Gdip_DisposeImage(bmpEnchanted)
	
	Broken := Gdip_ImageSearch(bmpHaystack,bmpBrokenRod,W,XTB1, YTB1, XTB1 + 40, YTB1 + 40,40,0xFFFFFF,1)
	Gdip_DisposeImage(bmpBrokenRod)
	
	
	Gdip_DisposeImage(bmpHaystack)
	
	
	IF (Toolbox = 1)
		
	{
		
		UpdateSplash(Font,"Action bar found")
		Sleep 300
	} IF (Broken = 1) 	{
		Count = 0
		UpdateSplash(Font,"Broken Rod Detected")
		ControlClick, x605 y635, ahk_class %Active_Class%, , WheelDown, 1, NA
		Sleep 300
	}  IF (Reel = 1 && Enchanted = 0 && Broken = 0)	 {
		Count = 0
		UpdateSplash(Font,"Using Normal Rod and Casting")
		ControlClick, x605 y635, ahk_class %Active_Class%, , Right, 1, NA
		Sleep 2500
	}  IF (Reel = 0 && Enchanted = 1 && Broken = 0)	{
		Count = 0
		UpdateSplash(Font,"Using Enchanted Rod and Casting")
		ControlClick, x605 y635, ahk_class %Active_Class%, , Right, 1, NA
		Sleep 2500
	}  IF ( Reel = 0 || Enchanted = 0 && Broken = 0 )	{
		UpdateSplash(Font,"Checking Slot attempt: " . count )
		Sleep 300
		IF (count = 5)
		{
			Count = 0
			UpdateSplash(Font,"Switching Action Bar Slot")
			ControlClick, x605 y635, ahk_class %Active_Class%, , WheelDown, 1, NA
		} 
		
		Count++
		
	} Else {
		UpdateSplash(Font,"Cannot Find Action Bar")
		Sleep 1000
		
	}
	
}

Return

UpdateDraw(X,Y) {
	
	IfWinNotActive,Minecraft
		Gui, Draw: Hide 
	else
		
	WinGetPos X1, Y1, W1, H1, Minecraft
	
	
	If (BobberFound = 1) {
		X := X - 15
		Y := Y - 15
	}
	
	W := 40
	H := 40
	;WinGetPos X, Y, W, H, Minecraft
	
	
	pPen := Gdip_CreatePen(0xFF00FF00,5)
	
	hbm := CreateDIBSection(A_ScreenWidth,A_ScreenHeight)
	hdc := CreateCompatibleDC()
	obm := SelectObject(hdc,hbm)
	G := Gdip_GraphicsFromHDC(hdc)
	
	Gdip_DrawRectangle(G,pPen,X,Y,W,H)
	UpdateLayeredWindow(DrawObj, hdc, X1, Y1, W1, H1)
	
	
	Gdip_DeletePen(pPen)
	
	SelectObject(hdc, obm)
	DeleteObject(hbm)
	DeleteDC(hdc)
	Gdip_DeleteGraphics(G)
}

UpdateSplash(Font,SplashTxt)
{
	IfWinActive,Minecraft
		Gui, Splash: Show, NA
	Else
		Gui, Splash: Hide 
	
	WinGetPos X, Y, W, H, Minecraft
	Font = Arial
	
	
	hbm := CreateDIBSection(A_ScreenWidth,A_ScreenHeight)
	hdc := CreateCompatibleDC()
	obm := SelectObject(hdc,hbm)
	G := Gdip_GraphicsFromHDC(hdc)
	
	SplashTxtPrev := SplashTxt
	O = X15 Y45 Near cFF00FF00 s20 Underline Italic r4
	Gdip_TextToGraphics(G, SplashTxt, O, Font,  W , H)
	UpdateLayeredWindow(SplashObj, hdc, X, Y, W, H)
	Gdip_GraphicsClear(G)
	SelectObject(hdc, obm)
	DeleteObject(hbm)
	DeleteDC(hdc)
	Gdip_DeleteGraphics(G)
	
}


^k::
KeepGoing := !KeepGoing
return 

^p:: ;QUIT
Exit:
Gdip_DeletePen(pPen)
SelectObject(hdc, obm)
DeleteObject(hbm)
DeleteDC(hdc)
Gdip_DeleteGraphics(G)
Gdip_DeleteGraphics(G1)
Gdip_DeleteGraphics(GPen)
Gdip_Shutdown(pToken)
ExitApp
return
Return
ExitApp

^!r::Reload