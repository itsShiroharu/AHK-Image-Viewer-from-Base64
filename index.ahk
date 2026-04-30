;@Ahk2Exe-SetName           The name for the executable file (without extension)
;@Ahk2Exe-SetDescription    The description of the executable file
;@Ahk2Exe-SetVersion        1.0.0
;@Ahk2Exe-SetCompanyName    The company name
;@Ahk2Exe-SetCopyright      Copyright (C) 2026 The company name
;@Ahk2Exe-SetProductName    Image Viewer
;@Ahk2Exe-SetProductVersion 1.0.0
;@Ahk2Exe-SetFileVersion    1.0.0.0
;@Ahk2Exe-SetOrigFilename   index.exe

;Fill in the above metadata for your executable file. It will appears on the Properties for the Exe files.
;Change the data at will to fit your needs.

#NoEnv
#SingleInstance Force

FileInstall, index.txt, %A_Temp%\index.txt, 1
Gui, +AlwaysOnTop -Resize
Gui, Add, Picture, x0 y0 w540 h540 vDisplayPic
Gui, Show, w540 h540, %filename%
FileRead, b64Data, %A_Temp%\index.txt
Base64ToImage(b64Data, A_Temp "\index.jpg")
GuiControl,, DisplayPic, %A_Temp%\index.jpg
return

GuiClose:
    FileDelete, %A_Temp%\index.txt
    FileDelete, %A_Temp%\index.jpg
    ExitApp
return

Base64ToImage(ByRef b64, path) {
    DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &b64, "UInt", 0, "UInt", 1, "Ptr", 0, "UIntP", size, "Ptr", 0, "Ptr", 0)
    VarSetCapacity(buf, size, 0)
    DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &b64, "UInt", 0, "UInt", 1, "Ptr", &buf, "UIntP", size, "Ptr", 0, "Ptr", 0)
    file := FileOpen(path, "w")
    file.RawWrite(buf, size)
    file.Close()
}
